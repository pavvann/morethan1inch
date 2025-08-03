const { expect } = require("chai");
const { ethers } = require("hardhat");

// normalize SDK import for ESM/CJS
const SdkRaw = require('@1inch/cross-chain-sdk');
const Sdk = SdkRaw.default ?? SdkRaw;

const {
  CrossChainOrder,
  HashLock,
  TimeLocks,
  AuctionDetails,
  randBigInt,
  AmountMode,
  TakerTraits,
  Address,
  UINT_40_MAX: SDK_UINT_40_MAX // if needed from SDK; else use byte-utils
} = Sdk;

const { uint8ArrayToHex, UINT_40_MAX } = require("@1inch/byte-utils");

// Your deployed contract addresses
const CONFIG = {
  sepolia: {
    chainId: 11155111,
    rpcUrl: "https://ethereum-sepolia-rpc.publicnode.com",
    contracts: {
      limitOrderProtocol: '0x7DE54E9C823f9e9F86EB5731f0F8FDA8fA359E56',
      escrowFactory: '0xaDD462E871B6E7C4c7d2fC6688981928d99d781f',
      resolver: '0xb293f137d22F016634f5a9bcf4f9f77DEB705BFE',
      usdc: '0x7118135fCD0bD585F1EE2a523e775004781afe19'
    }
  },
  monad: {
    chainId: 10143, 
    rpcUrl: "https://testnet-rpc.monad.xyz",
    contracts: {
      limitOrderProtocol: '0x7DE54E9C823f9e9F86EB5731f0F8FDA8fA359E56',
      escrowFactory: '0xaDD462E871B6E7C4c7d2fC6688981928d99d781f',
      resolver: '0xb293f137d22F016634f5a9bcf4f9f77DEB705BFE',
      usdc: '0x7118135fCD0bD585F1EE2a523e775004781afe19'
    }
  }
};

// Test wallet private keys (for testing only!)
const USER_PRIVATE_KEY = process.env.DEPLOYER_PK || "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";
const RESOLVER_PRIVATE_KEY = process.env.RESOLVER_PK || "0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a";

// Wrapper classes
class WalletWrapper {
  constructor(privateKey, provider) {
    this.provider = provider;
    this.signer = new ethers.Wallet(privateKey, provider);
  }

  async getAddress() {
    return this.signer.getAddress();
  }

  async send(param) {
    const res = await this.signer.sendTransaction({
      ...param,
      gasLimit: 10_000_000,
      from: await this.getAddress()
    });

    const receipt = await res.wait(1);
    if (receipt && receipt.status) {
      return {
        txHash: res.hash,
        blockTimestamp: BigInt(receipt.timestamp),
        blockHash: receipt.blockHash
      };
    }
    throw new Error('Transaction failed');
  }

  async signOrder(chainId, order) {
    const typedData = order.getTypedData(chainId);
    return this.signer._signTypedData(
      typedData.domain,
      typedData.types,
      typedData.message
    );
  }
}

// Simplified resolver wrapper (placeholder, needs real ABI for production)
class ResolverWrapper {
  constructor(srcAddress, dstAddress) {
    this.srcAddress = srcAddress;
    this.dstAddress = dstAddress;
    this.iface = {
      encodeFunctionData: (functionName, args) => {
        // stub: replace with real ABI encoding (ethers.Interface)
        return '0x' + functionName + args.map(a => a.toString()).join('');
      }
    };
  }

  deploySrc(chainId, order, signature, takerTraits, amount, hashLock) {
    // NOTE: you need actual SDK Signature helper to extract r/v/s or adapt
    // Fallback: naive split using ethers.Signature if needed
    const sig = ethers.Signature.from(signature); // ethers v6
    const r = sig.r;
    const s = sig.s;
    const v = sig.v;
    // The SDK reference used yParityAndS (vs); adapt if you have helper to produce that

    const { args, trait } = takerTraits.encode();
    const immutables = order.toSrcImmutables(chainId, new Address(this.srcAddress), amount, hashLock);

    return {
      to: this.srcAddress,
      data: this.iface.encodeFunctionData('deploySrc', [
        immutables.build(),
        order.build(),
        r,
        /* depending on expected format */ `${v}${s.slice(2)}`, // placeholder for vs
        amount,
        trait,
        args
      ]),
      value: order.escrowExtension.srcSafetyDeposit
    };
  }

  deployDst(immutables) {
    return {
      to: this.dstAddress,
      data: this.iface.encodeFunctionData('deployDst', [
        immutables.build(),
        immutables.timeLocks.toSrcTimeLocks().privateCancellation
      ]),
      value: immutables.safetyDeposit
    };
  }

  withdraw(side, escrow, secret, immutables) {
    return {
      to: side === 'src' ? this.srcAddress : this.dstAddress,
      data: this.iface.encodeFunctionData('withdraw', [
        escrow.toString(),
        secret,
        immutables.build()
      ])
    };
  }
}

describe("Single Fill Test - Deployed Contracts", function () {
  let sepoliaProvider, monadProvider;
  let sepoliaUser, monadUser, sepoliaResolver, monadResolver;
  let resolverContract;

  before(async function () {
    console.log("Setting up test environment...");

    sepoliaProvider = new ethers.JsonRpcProvider(CONFIG.sepolia.rpcUrl);
    monadProvider = new ethers.JsonRpcProvider(CONFIG.monad.rpcUrl);

    sepoliaUser = new WalletWrapper(USER_PRIVATE_KEY, sepoliaProvider);
    monadUser = new WalletWrapper(USER_PRIVATE_KEY, monadProvider);
    sepoliaResolver = new WalletWrapper(RESOLVER_PRIVATE_KEY, sepoliaProvider);
    monadResolver = new WalletWrapper(RESOLVER_PRIVATE_KEY, monadProvider);

    resolverContract = new ResolverWrapper(
      CONFIG.sepolia.contracts.resolver,
      CONFIG.monad.contracts.resolver
    );

    console.log('Sepolia User:', await sepoliaUser.getAddress());
    console.log('Monad User:', await monadUser.getAddress());
    console.log('Sepolia Resolver:', await sepoliaResolver.getAddress());
    console.log('Monad Resolver:', await monadResolver.getAddress());
  });

  it("should swap Sepolia USDC -> Monad USDC. Single fill only", async function () {
    // timestamp
    const sepoliaBlock = await sepoliaProvider.getBlock('latest');
    const sepoliaTimestamp = BigInt(sepoliaBlock.timestamp);
    console.log('block timestamp:', sepoliaTimestamp.toString());

    // secret
    const secret = uint8ArrayToHex(ethers.randomBytes(32));
    console.log('Generated secret:', secret);

    // build order
    const order = CrossChainOrder.new(
      new Address(CONFIG.sepolia.contracts.escrowFactory),
      {
        salt: randBigInt(1000n),
        maker: new Address(await sepoliaUser.getAddress()),
        makingAmount: ethers.parseUnits('10', 6),
        takingAmount: ethers.parseUnits('10', 6),
        makerAsset: new Address(CONFIG.sepolia.contracts.usdc),
        takerAsset: new Address(CONFIG.monad.contracts.usdc)
      },
      {
        hashLock: HashLock.forSingleFill(secret),
        timeLocks: TimeLocks.new({
          srcWithdrawal: 10n,
          srcPublicWithdrawal: 120n,
          srcCancellation: 121n,
          srcPublicCancellation: 122n,
          dstWithdrawal: 10n,
          dstPublicWithdrawal: 100n,
          dstCancellation: 101n
        }),
        srcChainId: BigInt(CONFIG.sepolia.chainId),
        dstChainId: BigInt(CONFIG.monad.chainId),
        srcSafetyDeposit: ethers.parseEther('0.001'),
        dstSafetyDeposit: ethers.parseEther('0.001')
      },
      {
        auction: new AuctionDetails({
          initialRateBump: 0,
          points: [],
          duration: 120n,
          startTime: sepoliaTimestamp
        }),
        whitelist: [
          {
            address: new Address(CONFIG.sepolia.contracts.resolver),
            allowFrom: 0n
          }
        ],
        resolvingStartTime: 0n
      },
      {
        nonce: randBigInt(UINT_40_MAX),
        allowPartialFills: false,
        allowMultipleFills: false
      }
    );

    console.log('Order hash:', order.getOrderHash(CONFIG.sepolia.chainId));

    // sign order
    const signature = await sepoliaUser.signOrder(CONFIG.sepolia.chainId, order);
    console.log('Signature:', signature);

    // fill (deploySrc)
    const fillAmount = order.makingAmount;
    try {
      const tx = resolverContract.deploySrc(
        CONFIG.sepolia.chainId,
        order,
        signature,
        TakerTraits.default()
          .setExtension(order.extension)
          .setAmountMode(AmountMode.maker)
          .setAmountThreshold(order.takingAmount),
        fillAmount,
        HashLock.forSingleFill(secret)
      );
      const { txHash, blockHash } = await sepoliaResolver.send(tx);
      console.log(`Source escrow deployed in tx: ${txHash}`);
      console.log(`Block hash: ${blockHash}`);

      // NOTE: rest of flow (dst deploy, withdrawals) needs full implementation
    } catch (err) {
      console.error('Fill failed:', err);
      throw err;
    }
  });
});
