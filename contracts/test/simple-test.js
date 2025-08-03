const { expect } = require("chai");
const Sdk = require("@1inch/cross-chain-sdk");

describe("Simple SDK Test", function() {
    it("should support Sepolia and MonadTestnet chains", function() {
        // Test that the chains are supported
        expect(Sdk.isSupportedChain(11155111)).to.be.true; // Sepolia
        expect(Sdk.isSupportedChain(10143)).to.be.true; // MonadTestnet
        
        // Test that the chains are in the SupportedChains array
        expect(Sdk.SupportedChains).to.include(11155111); // Sepolia
        expect(Sdk.SupportedChains).to.include(10143); // MonadTestnet
        
        // Test that NetworkEnum has the new values
        expect(Sdk.NetworkEnum.SEPOLIA).to.equal(11155111);
        expect(Sdk.NetworkEnum.MONADTESTNET).to.equal(10143);
        
        console.log("✅ Sepolia and MonadTestnet support verified!");
        console.log("SupportedChains:", Sdk.SupportedChains);
        console.log("NetworkEnum.SEPOLIA:", Sdk.NetworkEnum.SEPOLIA);
        console.log("NetworkEnum.MONADTESTNET:", Sdk.NetworkEnum.MONADTESTNET);
    });
    
    it("should have TRUE_ERC20 entries for new chains", function() {
        // Test that TRUE_ERC20 has entries for the new chains
        expect(Sdk.TRUE_ERC20[Sdk.NetworkEnum.SEPOLIA]).to.exist;
        expect(Sdk.TRUE_ERC20[Sdk.NetworkEnum.MONADTESTNET]).to.exist;
        
        console.log("✅ TRUE_ERC20 entries verified for new chains!");
    });
    
    it("should have ESCROW_FACTORY entries for new chains", function() {
        // Test that ESCROW_FACTORY has entries for the new chains
        expect(Sdk.ESCROW_FACTORY[Sdk.NetworkEnum.SEPOLIA]).to.exist;
        expect(Sdk.ESCROW_FACTORY[Sdk.NetworkEnum.MONADTESTNET]).to.exist;
        
        console.log("✅ ESCROW_FACTORY entries verified for new chains!");
    });
}); 