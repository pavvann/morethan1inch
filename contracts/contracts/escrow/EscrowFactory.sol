// SPDX-License-Identifier: MIT
pragma solidity =0.8.23 ^0.8.0 ^0.8.20;

// contracts/lib/cross-chain-swap/lib/solidity-utils/contracts/libraries/AddressLib.sol

type Address is uint256;

/**
* @notice AddressLib
* @notice Library for working with addresses encoded as uint256 values, which can include flags in the highest bits.
*/
library AddressLib {
    uint256 private constant _LOW_160_BIT_MASK = (1 << 160) - 1;

    /**
    * @notice Returns the address representation of a uint256.
    * @param a The uint256 value to convert to an address.
    * @return The address representation of the provided uint256 value.
    */
    function get(Address a) internal pure returns (address) {
        return address(uint160(Address.unwrap(a) & _LOW_160_BIT_MASK));
    }

    /**
    * @notice Checks if a given flag is set for the provided address.
    * @param a The address to check for the flag.
    * @param flag The flag to check for in the provided address.
    * @return True if the provided flag is set in the address, false otherwise.
    */
    function getFlag(Address a, uint256 flag) internal pure returns (bool) {
        return (Address.unwrap(a) & flag) != 0;
    }

    /**
    * @notice Returns a uint32 value stored at a specific bit offset in the provided address.
    * @param a The address containing the uint32 value.
    * @param offset The bit offset at which the uint32 value is stored.
    * @return The uint32 value stored in the address at the specified bit offset.
    */
    function getUint32(Address a, uint256 offset) internal pure returns (uint32) {
        return uint32(Address.unwrap(a) >> offset);
    }

    /**
    * @notice Returns a uint64 value stored at a specific bit offset in the provided address.
    * @param a The address containing the uint64 value.
    * @param offset The bit offset at which the uint64 value is stored.
    * @return The uint64 value stored in the address at the specified bit offset.
    */
    function getUint64(Address a, uint256 offset) internal pure returns (uint64) {
        return uint64(Address.unwrap(a) >> offset);
    }
}

// contracts/lib/cross-chain-swap/lib/openzeppelin-contracts/contracts/utils/Context.sol

// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// contracts/lib/cross-chain-swap/lib/openzeppelin-contracts/contracts/utils/Errors.sol

/**
 * @dev Collection of common custom errors used in multiple contracts
 *
 * IMPORTANT: Backwards compatibility is not guaranteed in future versions of the library.
 * It is recommended to avoid relying on the error API for critical functionality.
 */
library Errors {
    /**
     * @dev The ETH balance of the account is not enough to perform the operation.
     */
    error InsufficientBalance(uint256 balance, uint256 needed);

    /**
     * @dev A call to an address target failed. The target may have reverted.
     */
    error FailedCall();

    /**
     * @dev The deployment failed.
     */
    error FailedDeployment();
}

// contracts/lib/cross-chain-swap/contracts/EscrowFactoryContext.sol

uint256 constant SRC_IMMUTABLES_LENGTH = 160;

// contracts/lib/cross-chain-swap/lib/limit-order-settlement/contracts/extensions/ExtensionLib.sol

/**
 * @title Extension Library
 * @notice Library to retrieve data from the bitmap.
 */
library ExtensionLib_0 {
    bytes1 private constant _RESOLVER_FEE_FLAG = 0x01;
    bytes1 private constant _INTEGRATOR_FEE_FLAG = 0x02;
    bytes1 private constant _CUSTOM_RECEIVER_FLAG = 0x04;
    uint256 private constant _WHITELIST_SHIFT = 3;

    /**
     * @notice Checks if the resolver fee is enabled
     * @param extraData Data to be processed in the extension
     * @return True if the resolver fee is enabled
     */
    function resolverFeeEnabled(bytes calldata extraData) internal pure returns (bool) {
        return extraData[extraData.length - 1] & _RESOLVER_FEE_FLAG == _RESOLVER_FEE_FLAG;
    }

    /**
     * @notice Checks if the integrator fee is enabled
     * @param extraData Data to be processed in the extension
     * @return True if the integrator fee is enabled
     */
    function integratorFeeEnabled(bytes calldata extraData) internal pure returns (bool) {
        return extraData[extraData.length - 1] & _INTEGRATOR_FEE_FLAG == _INTEGRATOR_FEE_FLAG;
    }

    /**
     * @notice Checks if the custom receiver is enabled
     * @param extraData Data to be processed in the extension
     * @return True if the custom receiver is specified
     */
    function hasCustomReceiver(bytes calldata extraData) internal pure returns (bool) {
        return extraData[extraData.length - 1] & _CUSTOM_RECEIVER_FLAG == _CUSTOM_RECEIVER_FLAG;
    }

    /**
     * @notice Gets the number of resolvers in the whitelist
     * @param extraData Data to be processed in the extension
     * @return The number of resolvers in the whitelist
     */
    function resolversCount(bytes calldata extraData) internal pure returns (uint256) {
        return uint8(extraData[extraData.length - 1]) >> _WHITELIST_SHIFT;
    }
}

// contracts/lib/cross-chain-swap/lib/openzeppelin-contracts/contracts/utils/cryptography/Hashes.sol

/**
 * @dev Library of standard hash functions.
 */
library Hashes {
    /**
     * @dev Commutative Keccak256 hash of a sorted pair of bytes32. Frequently used when working with merkle proofs.
     *
     * NOTE: Equivalent to the `standardNodeHash` in our https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
     */
    function commutativeKeccak256(bytes32 a, bytes32 b) internal pure returns (bytes32) {
        return a < b ? _efficientKeccak256(a, b) : _efficientKeccak256(b, a);
    }

    /**
     * @dev Implementation of keccak256(abi.encode(a, b)) that doesn't allocate or expand memory.
     */
    function _efficientKeccak256(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            value := keccak256(0x00, 0x40)
        }
    }
}

// contracts/lib/cross-chain-swap/lib/solidity-utils/contracts/interfaces/IDaiLikePermit.sol

/**
 * @title IDaiLikePermit
 * @dev Interface for Dai-like permit function allowing token spending via signatures.
 */
interface IDaiLikePermit {
    /**
     * @notice Approves spending of tokens via off-chain signatures.
     * @param holder Token holder's address.
     * @param spender Spender's address.
     * @param nonce Current nonce of the holder.
     * @param expiry Time when the permit expires.
     * @param allowed True to allow, false to disallow spending.
     * @param v, r, s Signature components.
     */
    function permit(
        address holder,
        address spender,
        uint256 nonce,
        uint256 expiry,
        bool allowed,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}

// contracts/lib/cross-chain-swap/lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/IERC20.sol)

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// contracts/lib/cross-chain-swap/lib/solidity-utils/contracts/interfaces/IERC20MetadataUppercase.sol

/**
 * @title IERC20MetadataUppercase
 * @dev Interface for ERC20 token metadata with uppercase naming convention.
 */
interface IERC20MetadataUppercase {
    /**
     * @notice Gets the token name.
     * @return Token name.
     */
    function NAME() external view returns (string memory); // solhint-disable-line func-name-mixedcase

    /**
     * @notice Gets the token symbol.
     * @return Token symbol.
     */
    function SYMBOL() external view returns (string memory); // solhint-disable-line func-name-mixedcase
}

// contracts/lib/cross-chain-swap/lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/extensions/IERC20Permit.sol)

/**
 * @dev Interface of the ERC-20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[ERC-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC-20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 *
 * ==== Security Considerations
 *
 * There are two important considerations concerning the use of `permit`. The first is that a valid permit signature
 * expresses an allowance, and it should not be assumed to convey additional meaning. In particular, it should not be
 * considered as an intention to spend the allowance in any specific way. The second is that because permits have
 * built-in replay protection and can be submitted by anyone, they can be frontrun. A protocol that uses permits should
 * take this into consideration and allow a `permit` call to fail. Combining these two aspects, a pattern that may be
 * generally recommended is:
 *
 * ```solidity
 * function doThingWithPermit(..., uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public {
 *     try token.permit(msg.sender, address(this), value, deadline, v, r, s) {} catch {}
 *     doThing(..., value);
 * }
 *
 * function doThing(..., uint256 value) public {
 *     token.safeTransferFrom(msg.sender, address(this), value);
 *     ...
 * }
 * ```
 *
 * Observe that: 1) `msg.sender` is used as the owner, leaving no ambiguity as to the signer intent, and 2) the use of
 * `try/catch` allows the permit to fail and makes the code tolerant to frontrunning. (See also
 * {SafeERC20-safeTransferFrom}).
 *
 * Additionally, note that smart contract wallets (such as Argent or Safe) are not able to produce permit signatures, so
 * contracts should have entry points that don't rely on permit.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     *
     * CAUTION: See Security Considerations above.
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// contracts/lib/cross-chain-swap/lib/solidity-utils/contracts/interfaces/IERC7597Permit.sol

/**
 * @title IERC7597Permit
 * @dev A new extension for ERC-2612 permit, which has already been added to USDC v2.2.
 */
interface IERC7597Permit {
    /**
     * @notice Update allowance with a signed permit.
     * @dev Signature bytes can be used for both EOA wallets and contract wallets.
     * @param owner Token owner's address (Authorizer).
     * @param spender Spender's address.
     * @param value Amount of allowance.
     * @param deadline The time at which the signature expires (unixtime).
     * @param signature Unstructured bytes signature signed by an EOA wallet or a contract wallet.
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        bytes memory signature
    ) external;
}

// contracts/lib/cross-chain-swap/lib/limit-order-settlement/contracts/interfaces/IFeeBank.sol

interface IFeeBank {
    /**
     * @notice Returns the available credit for a given account in the FeeBank contract.
     * @param account The address of the account for which the available credit is being queried.
     * @return availableCredit The available credit of the queried account.
     */
    function availableCredit(address account) external view returns (uint256 availableCredit);

    /**
     * @notice Increases the caller's available credit by the specified amount.
     * @param amount The amount of credit to be added to the caller's account.
     * @return totalAvailableCredit The updated available credit of the caller's account.
     */
    function deposit(uint256 amount) external returns (uint256 totalAvailableCredit);

    /**
     * @notice Increases the specified account's available credit by the specified amount.
     * @param account The address of the account for which the available credit is being increased.
     * @param amount The amount of credit to be added to the account.
     * @return totalAvailableCredit The updated available credit of the specified account.
     */
    function depositFor(address account, uint256 amount) external returns (uint256 totalAvailableCredit);

    /**
     * @notice Increases the caller's available credit by a specified amount with permit.
     * @param amount The amount of credit to be added to the caller's account.
     * @param permit The permit data authorizing the transaction.
     * @return totalAvailableCredit The updated available credit of the caller's account.
     */
    function depositWithPermit(uint256 amount, bytes calldata permit) external returns (uint256 totalAvailableCredit);

    /**
     * @notice Increases the specified account's available credit by a specified amount with permit.
     * @param account The address of the account for which the available credit is being increased.
     * @param amount The amount of credit to be added to the account.
     * @param permit The permit data authorizing the transaction.
     * @return totalAvailableCredit The updated available credit of the specified account.
     */
    function depositForWithPermit(address account, uint256 amount, bytes calldata permit) external returns (uint256 totalAvailableCredit);

    /**
     * @notice Withdraws a specified amount of credit from the caller's account.
     * @param amount The amount of credit to be withdrawn from the caller's account.
     * @return totalAvailableCredit The updated available credit of the caller's account.
     */
    function withdraw(uint256 amount) external returns (uint256 totalAvailableCredit);

    /**
     * @notice Withdraws a specified amount of credit to the specified account.
     * @param account The address of the account to which the credit is being withdrawn.
     * @param amount The amount of credit to be withdrawn.
     * @return totalAvailableCredit The updated available credit of the caller's account.
     */
    function withdrawTo(address account, uint256 amount) external returns (uint256 totalAvailableCredit);
}

// contracts/lib/cross-chain-swap/contracts/interfaces/IMerkleStorageInvalidator.sol

/**
 * @title Merkle Storage Invalidator interface
 * @notice Interface to invalidate hashed secrets from an order that supports multiple fills.
 * @custom:security-contact security@1inch.io
 */
interface IMerkleStorageInvalidator {
    struct ValidationData {
        uint256 index;
        bytes32 leaf;
    }

    struct TakerData {
        bytes32[] proof;
        uint256 idx;
        bytes32 secretHash;
    }

    error AccessDenied();
    error InvalidProof();

    /**
     * @notice Returns the index of the last validated hashed secret and the hashed secret itself.
     * @param key Hash of concatenated order hash and 30 bytes of root hash.
     * @return index Index of the last validated hashed secret.
     * @return secretHash Last validated hashed secret.
     */
    function lastValidated(bytes32 key) external view returns (uint256 index, bytes32 secretHash);
}

// contracts/lib/cross-chain-swap/lib/solidity-utils/contracts/interfaces/IPermit2.sol

/**
 * @title IPermit2
 * @dev Interface for a flexible permit system that extends ERC20 tokens to support permits in tokens lacking native permit functionality.
 */
interface IPermit2 {
    /**
     * @dev Struct for holding permit details.
     * @param token ERC20 token address for which the permit is issued.
     * @param amount The maximum amount allowed to spend.
     * @param expiration Timestamp until which the permit is valid.
     * @param nonce An incrementing value for each signature, unique per owner, token, and spender.
     */
    struct PermitDetails {
        address token;
        uint160 amount;
        uint48 expiration;
        uint48 nonce;
    }

    /**
     * @dev Struct for a single token allowance permit.
     * @param details Permit details including token, amount, expiration, and nonce.
     * @param spender Address authorized to spend the tokens.
     * @param sigDeadline Deadline for the permit signature, ensuring timeliness of the permit.
     */
    struct PermitSingle {
        PermitDetails details;
        address spender;
        uint256 sigDeadline;
    }

    /**
     * @dev Struct for packed allowance data to optimize storage.
     * @param amount Amount allowed.
     * @param expiration Permission expiry timestamp.
     * @param nonce Unique incrementing value for tracking allowances.
     */
    struct PackedAllowance {
        uint160 amount;
        uint48 expiration;
        uint48 nonce;
    }

    /**
     * @notice Executes a token transfer from one address to another.
     * @param user The token owner's address.
     * @param spender The address authorized to spend the tokens.
     * @param amount The amount of tokens to transfer.
     * @param token The address of the token being transferred.
     */
    function transferFrom(address user, address spender, uint160 amount, address token) external;

    /**
     * @notice Issues a permit for spending tokens via a signed authorization.
     * @param owner The token owner's address.
     * @param permitSingle Struct containing the permit details.
     * @param signature The signature proving the owner authorized the permit.
     */
    function permit(address owner, PermitSingle memory permitSingle, bytes calldata signature) external;

    /**
     * @notice Retrieves the allowance details between a token owner and spender.
     * @param user The token owner's address.
     * @param token The token address.
     * @param spender The spender's address.
     * @return The packed allowance details.
     */
    function allowance(address user, address token, address spender) external view returns (PackedAllowance memory);
}

// contracts/lib/cross-chain-swap/lib/limit-order-protocol/contracts/libraries/MakerTraitsLib.sol

type MakerTraits is uint256;

/**
 * @title MakerTraitsLib
 * @notice A library to manage and check MakerTraits, which are used to encode the maker's preferences for an order in a single uint256.
 * @dev
 * The MakerTraits type is a uint256 and different parts of the number are used to encode different traits.
 * High bits are used for flags
 * 255 bit `NO_PARTIAL_FILLS_FLAG`          - if set, the order does not allow partial fills
 * 254 bit `ALLOW_MULTIPLE_FILLS_FLAG`      - if set, the order permits multiple fills
 * 253 bit                                  - unused
 * 252 bit `PRE_INTERACTION_CALL_FLAG`      - if set, the order requires pre-interaction call
 * 251 bit `POST_INTERACTION_CALL_FLAG`     - if set, the order requires post-interaction call
 * 250 bit `NEED_CHECK_EPOCH_MANAGER_FLAG`  - if set, the order requires to check the epoch manager
 * 249 bit `HAS_EXTENSION_FLAG`             - if set, the order has extension(s)
 * 248 bit `USE_PERMIT2_FLAG`               - if set, the order uses permit2
 * 247 bit `UNWRAP_WETH_FLAG`               - if set, the order requires to unwrap WETH

 * Low 200 bits are used for allowed sender, expiration, nonceOrEpoch, and series
 * uint80 last 10 bytes of allowed sender address (0 if any)
 * uint40 expiration timestamp (0 if none)
 * uint40 nonce or epoch
 * uint40 series
 */
library MakerTraitsLib {
    // Low 200 bits are used for allowed sender, expiration, nonceOrEpoch, and series
    uint256 private constant _ALLOWED_SENDER_MASK = type(uint80).max;
    uint256 private constant _EXPIRATION_OFFSET = 80;
    uint256 private constant _EXPIRATION_MASK = type(uint40).max;
    uint256 private constant _NONCE_OR_EPOCH_OFFSET = 120;
    uint256 private constant _NONCE_OR_EPOCH_MASK = type(uint40).max;
    uint256 private constant _SERIES_OFFSET = 160;
    uint256 private constant _SERIES_MASK = type(uint40).max;

    uint256 private constant _NO_PARTIAL_FILLS_FLAG = 1 << 255;
    uint256 private constant _ALLOW_MULTIPLE_FILLS_FLAG = 1 << 254;
    uint256 private constant _PRE_INTERACTION_CALL_FLAG = 1 << 252;
    uint256 private constant _POST_INTERACTION_CALL_FLAG = 1 << 251;
    uint256 private constant _NEED_CHECK_EPOCH_MANAGER_FLAG = 1 << 250;
    uint256 private constant _HAS_EXTENSION_FLAG = 1 << 249;
    uint256 private constant _USE_PERMIT2_FLAG = 1 << 248;
    uint256 private constant _UNWRAP_WETH_FLAG = 1 << 247;

    /**
     * @notice Checks if the order has the extension flag set.
     * @dev If the `HAS_EXTENSION_FLAG` is set in the makerTraits, then the protocol expects that the order has extension(s).
     * @param makerTraits The traits of the maker.
     * @return result A boolean indicating whether the flag is set.
     */
    function hasExtension(MakerTraits makerTraits) internal pure returns (bool) {
        return (MakerTraits.unwrap(makerTraits) & _HAS_EXTENSION_FLAG) != 0;
    }

    /**
     * @notice Checks if the maker allows a specific taker to fill the order.
     * @param makerTraits The traits of the maker.
     * @param sender The address of the taker to be checked.
     * @return result A boolean indicating whether the taker is allowed.
     */
    function isAllowedSender(MakerTraits makerTraits, address sender) internal pure returns (bool) {
        uint160 allowedSender = uint160(MakerTraits.unwrap(makerTraits) & _ALLOWED_SENDER_MASK);
        return allowedSender == 0 || allowedSender == uint160(sender) & _ALLOWED_SENDER_MASK;
    }

    /**
     * @notice Checks if the order has expired.
     * @param makerTraits The traits of the maker.
     * @return result A boolean indicating whether the order has expired.
     */
    function isExpired(MakerTraits makerTraits) internal view returns (bool) {
        uint256 expiration = (MakerTraits.unwrap(makerTraits) >> _EXPIRATION_OFFSET) & _EXPIRATION_MASK;
        return expiration != 0 && expiration < block.timestamp;  // solhint-disable-line not-rely-on-time
    }

    /**
     * @notice Returns the nonce or epoch of the order.
     * @param makerTraits The traits of the maker.
     * @return result The nonce or epoch of the order.
     */
    function nonceOrEpoch(MakerTraits makerTraits) internal pure returns (uint256) {
        return (MakerTraits.unwrap(makerTraits) >> _NONCE_OR_EPOCH_OFFSET) & _NONCE_OR_EPOCH_MASK;
    }

    /**
     * @notice Returns the series of the order.
     * @param makerTraits The traits of the maker.
     * @return result The series of the order.
     */
    function series(MakerTraits makerTraits) internal pure returns (uint256) {
        return (MakerTraits.unwrap(makerTraits) >> _SERIES_OFFSET) & _SERIES_MASK;
    }

    /**
      * @notice Determines if the order allows partial fills.
      * @dev If the _NO_PARTIAL_FILLS_FLAG is not set in the makerTraits, then the order allows partial fills.
      * @param makerTraits The traits of the maker, determining their preferences for the order.
      * @return result A boolean indicating whether the maker allows partial fills.
      */
    function allowPartialFills(MakerTraits makerTraits) internal pure returns (bool) {
        return (MakerTraits.unwrap(makerTraits) & _NO_PARTIAL_FILLS_FLAG) == 0;
    }

    /**
     * @notice Checks if the maker needs pre-interaction call.
     * @param makerTraits The traits of the maker.
     * @return result A boolean indicating whether the maker needs a pre-interaction call.
     */
    function needPreInteractionCall(MakerTraits makerTraits) internal pure returns (bool) {
        return (MakerTraits.unwrap(makerTraits) & _PRE_INTERACTION_CALL_FLAG) != 0;
    }

    /**
     * @notice Checks if the maker needs post-interaction call.
     * @param makerTraits The traits of the maker.
     * @return result A boolean indicating whether the maker needs a post-interaction call.
     */
    function needPostInteractionCall(MakerTraits makerTraits) internal pure returns (bool) {
        return (MakerTraits.unwrap(makerTraits) & _POST_INTERACTION_CALL_FLAG) != 0;
    }

    /**
      * @notice Determines if the order allows multiple fills.
      * @dev If the _ALLOW_MULTIPLE_FILLS_FLAG is set in the makerTraits, then the maker allows multiple fills.
      * @param makerTraits The traits of the maker, determining their preferences for the order.
      * @return result A boolean indicating whether the maker allows multiple fills.
      */
    function allowMultipleFills(MakerTraits makerTraits) internal pure returns (bool) {
        return (MakerTraits.unwrap(makerTraits) & _ALLOW_MULTIPLE_FILLS_FLAG) != 0;
    }

    /**
      * @notice Determines if an order should use the bit invalidator or remaining amount validator.
      * @dev The bit invalidator can be used if the order does not allow partial or multiple fills.
      * @param makerTraits The traits of the maker, determining their preferences for the order.
      * @return result A boolean indicating whether the bit invalidator should be used.
      * True if the order requires the use of the bit invalidator.
      */
    function useBitInvalidator(MakerTraits makerTraits) internal pure returns (bool) {
        return !allowPartialFills(makerTraits) || !allowMultipleFills(makerTraits);
    }

    /**
     * @notice Checks if the maker needs to check the epoch.
     * @param makerTraits The traits of the maker.
     * @return result A boolean indicating whether the maker needs to check the epoch manager.
     */
    function needCheckEpochManager(MakerTraits makerTraits) internal pure returns (bool) {
        return (MakerTraits.unwrap(makerTraits) & _NEED_CHECK_EPOCH_MANAGER_FLAG) != 0;
    }

    /**
     * @notice Checks if the maker uses permit2.
     * @param makerTraits The traits of the maker.
     * @return result A boolean indicating whether the maker uses permit2.
     */
    function usePermit2(MakerTraits makerTraits) internal pure returns (bool) {
        return MakerTraits.unwrap(makerTraits) & _USE_PERMIT2_FLAG != 0;
    }

    /**
     * @notice Checks if the maker needs to unwraps WETH.
     * @param makerTraits The traits of the maker.
     * @return result A boolean indicating whether the maker needs to unwrap WETH.
     */
    function unwrapWeth(MakerTraits makerTraits) internal pure returns (bool) {
        return MakerTraits.unwrap(makerTraits) & _UNWRAP_WETH_FLAG != 0;
    }
}

// contracts/lib/cross-chain-swap/lib/limit-order-protocol/contracts/libraries/OffsetsLib.sol

type Offsets is uint256;

/// @title OffsetsLib
/// @dev A library for retrieving values by offsets from a concatenated calldata.
library OffsetsLib {

    /// @dev Error to be thrown when the offset is out of bounds.
    error OffsetOutOfBounds();

    /**
     * @notice Retrieves the field value calldata corresponding to the provided field index from the concatenated calldata.
     * @dev 
     * The function performs the following steps:
     * 1. Retrieve the start and end of the segment corresponding to the provided index from the offsets array.
     * 2. Get the value from segment using offset and length calculated based on the start and end of the segment.
     * 3. Throw `OffsetOutOfBounds` error if the length of the segment is greater than the length of the concatenated data.
     * @param offsets The offsets encoding the start and end of each segment within the concatenated calldata.
     * @param concat The concatenated calldata.
     * @param index The index of the segment to retrieve. The field index 0 corresponds to the lowest bytes of the offsets array.
     * @return result The calldata from a segment of the concatenated calldata corresponding to the provided index.
     */
    function get(Offsets offsets, bytes calldata concat, uint256 index) internal pure returns(bytes calldata result) {
        bytes4 exception = OffsetOutOfBounds.selector;
        assembly ("memory-safe") {  // solhint-disable-line no-inline-assembly
            let bitShift := shl(5, index)                                   // bitShift = index * 32
            let begin := and(0xffffffff, shr(bitShift, shl(32, offsets)))   // begin = offsets[ bitShift : bitShift + 32 ]
            let end := and(0xffffffff, shr(bitShift, offsets))              // end   = offsets[ bitShift + 32 : bitShift + 64 ]
            result.offset := add(concat.offset, begin)
            result.length := sub(end, begin)
            if gt(end, concat.length) {
                mstore(0, exception)
                revert(0, 4)
            }
        }
    }
}

// contracts/lib/cross-chain-swap/lib/openzeppelin-contracts/contracts/utils/Panic.sol

/**
 * @dev Helper library for emitting standardized panic codes.
 *
 * ```solidity
 * contract Example {
 *      using Panic for uint256;
 *
 *      // Use any of the declared internal constants
 *      function foo() { Panic.GENERIC.panic(); }
 *
 *      // Alternatively
 *      function foo() { Panic.panic(Panic.GENERIC); }
 * }
 * ```
 *
 * Follows the list from https://github.com/ethereum/solidity/blob/v0.8.24/libsolutil/ErrorCodes.h[libsolutil].
 */
// slither-disable-next-line unused-state
library Panic {
    /// @dev generic / unspecified error
    uint256 internal constant GENERIC = 0x00;
    /// @dev used by the assert() builtin
    uint256 internal constant ASSERT = 0x01;
    /// @dev arithmetic underflow or overflow
    uint256 internal constant UNDER_OVERFLOW = 0x11;
    /// @dev division or modulo by zero
    uint256 internal constant DIVISION_BY_ZERO = 0x12;
    /// @dev enum conversion error
    uint256 internal constant ENUM_CONVERSION_ERROR = 0x21;
    /// @dev invalid encoding in storage
    uint256 internal constant STORAGE_ENCODING_ERROR = 0x22;
    /// @dev empty array pop
    uint256 internal constant EMPTY_ARRAY_POP = 0x31;
    /// @dev array out of bounds access
    uint256 internal constant ARRAY_OUT_OF_BOUNDS = 0x32;
    /// @dev resource error (too large allocation or too large array)
    uint256 internal constant RESOURCE_ERROR = 0x41;
    /// @dev calling invalid internal function
    uint256 internal constant INVALID_INTERNAL_FUNCTION = 0x51;

    /// @dev Reverts with a panic code. Recommended to use with
    /// the internal constants with predefined codes.
    function panic(uint256 code) internal pure {
        /// @solidity memory-safe-assembly
        assembly {
            mstore(0x00, 0x4e487b71)
            mstore(0x20, code)
            revert(0x1c, 0x24)
        }
    }
}

// contracts/lib/cross-chain-swap/contracts/libraries/ProxyHashLib.sol

/**
 * @title Library to compute the hash of the proxy bytecode.
 * @custom:security-contact security@1inch.io
 */
library ProxyHashLib {
    /**
     * @notice Returns the hash of the proxy bytecode concatenated with the implementation address.
     * @param implementation The address of the contract to clone.
     * @return bytecodeHash The hash of the resulting bytecode.
     */
    function computeProxyBytecodeHash(address implementation) internal pure returns (bytes32 bytecodeHash) {
        assembly ("memory-safe") {
            // Stores the bytecode after address
            mstore(0x20, 0x5af43d82803e903d91602b57fd5bf3)
            // implementation address
            mstore(0x11, implementation)
            // Packs the first 3 bytes of the `implementation` address with the bytecode before the address.
            mstore(0x00, or(shr(0x88, implementation), 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000))
            bytecodeHash := keccak256(0x09, 0x37)
        }
    }
}

// contracts/lib/cross-chain-swap/lib/solidity-utils/contracts/libraries/RevertReasonForwarder.sol

/**
 * @title RevertReasonForwarder
 * @notice Provides utilities for forwarding and retrieving revert reasons from failed external calls.
 */
library RevertReasonForwarder {
    /**
     * @dev Forwards the revert reason from the latest external call.
     * This method allows propagating the revert reason of a failed external call to the caller.
     */
    function reRevert() internal pure {
        // bubble up revert reason from latest external call
        assembly ("memory-safe") { // solhint-disable-line no-inline-assembly
            let ptr := mload(0x40)
            returndatacopy(ptr, 0, returndatasize())
            revert(ptr, returndatasize())
        }
    }

    /**
     * @dev Retrieves the revert reason from the latest external call.
     * This method enables capturing the revert reason of a failed external call for inspection or processing.
     * @return reason The latest external call revert reason.
     */
    function reReason() internal pure returns (bytes memory reason) {
        assembly ("memory-safe") { // solhint-disable-line no-inline-assembly
            reason := mload(0x40)
            let length := returndatasize()
            mstore(reason, length)
            returndatacopy(add(reason, 0x20), 0, length)
            mstore(0x40, add(reason, add(0x20, length)))
        }
    }
}

// contracts/lib/cross-chain-swap/lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/math/SafeCast.sol)
// This file was procedurally generated from scripts/generate/templates/SafeCast.js.

/**
 * @dev Wrappers over Solidity's uintXX/intXX/bool casting operators with added overflow
 * checks.
 *
 * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
 * easily result in undesired exploitation or bugs, since developers usually
 * assume that overflows raise errors. `SafeCast` restores this intuition by
 * reverting the transaction when such an operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeCast {
    /**
     * @dev Value doesn't fit in an uint of `bits` size.
     */
    error SafeCastOverflowedUintDowncast(uint8 bits, uint256 value);

    /**
     * @dev An int value doesn't fit in an uint of `bits` size.
     */
    error SafeCastOverflowedIntToUint(int256 value);

    /**
     * @dev Value doesn't fit in an int of `bits` size.
     */
    error SafeCastOverflowedIntDowncast(uint8 bits, int256 value);

    /**
     * @dev An uint value doesn't fit in an int of `bits` size.
     */
    error SafeCastOverflowedUintToInt(uint256 value);

    /**
     * @dev Returns the downcasted uint248 from uint256, reverting on
     * overflow (when the input is greater than largest uint248).
     *
     * Counterpart to Solidity's `uint248` operator.
     *
     * Requirements:
     *
     * - input must fit into 248 bits
     */
    function toUint248(uint256 value) internal pure returns (uint248) {
        if (value > type(uint248).max) {
            revert SafeCastOverflowedUintDowncast(248, value);
        }
        return uint248(value);
    }

    /**
     * @dev Returns the downcasted uint240 from uint256, reverting on
     * overflow (when the input is greater than largest uint240).
     *
     * Counterpart to Solidity's `uint240` operator.
     *
     * Requirements:
     *
     * - input must fit into 240 bits
     */
    function toUint240(uint256 value) internal pure returns (uint240) {
        if (value > type(uint240).max) {
            revert SafeCastOverflowedUintDowncast(240, value);
        }
        return uint240(value);
    }

    /**
     * @dev Returns the downcasted uint232 from uint256, reverting on
     * overflow (when the input is greater than largest uint232).
     *
     * Counterpart to Solidity's `uint232` operator.
     *
     * Requirements:
     *
     * - input must fit into 232 bits
     */
    function toUint232(uint256 value) internal pure returns (uint232) {
        if (value > type(uint232).max) {
            revert SafeCastOverflowedUintDowncast(232, value);
        }
        return uint232(value);
    }

    /**
     * @dev Returns the downcasted uint224 from uint256, reverting on
     * overflow (when the input is greater than largest uint224).
     *
     * Counterpart to Solidity's `uint224` operator.
     *
     * Requirements:
     *
     * - input must fit into 224 bits
     */
    function toUint224(uint256 value) internal pure returns (uint224) {
        if (value > type(uint224).max) {
            revert SafeCastOverflowedUintDowncast(224, value);
        }
        return uint224(value);
    }

    /**
     * @dev Returns the downcasted uint216 from uint256, reverting on
     * overflow (when the input is greater than largest uint216).
     *
     * Counterpart to Solidity's `uint216` operator.
     *
     * Requirements:
     *
     * - input must fit into 216 bits
     */
    function toUint216(uint256 value) internal pure returns (uint216) {
        if (value > type(uint216).max) {
            revert SafeCastOverflowedUintDowncast(216, value);
        }
        return uint216(value);
    }

    /**
     * @dev Returns the downcasted uint208 from uint256, reverting on
     * overflow (when the input is greater than largest uint208).
     *
     * Counterpart to Solidity's `uint208` operator.
     *
     * Requirements:
     *
     * - input must fit into 208 bits
     */
    function toUint208(uint256 value) internal pure returns (uint208) {
        if (value > type(uint208).max) {
            revert SafeCastOverflowedUintDowncast(208, value);
        }
        return uint208(value);
    }

    /**
     * @dev Returns the downcasted uint200 from uint256, reverting on
     * overflow (when the input is greater than largest uint200).
     *
     * Counterpart to Solidity's `uint200` operator.
     *
     * Requirements:
     *
     * - input must fit into 200 bits
     */
    function toUint200(uint256 value) internal pure returns (uint200) {
        if (value > type(uint200).max) {
            revert SafeCastOverflowedUintDowncast(200, value);
        }
        return uint200(value);
    }

    /**
     * @dev Returns the downcasted uint192 from uint256, reverting on
     * overflow (when the input is greater than largest uint192).
     *
     * Counterpart to Solidity's `uint192` operator.
     *
     * Requirements:
     *
     * - input must fit into 192 bits
     */
    function toUint192(uint256 value) internal pure returns (uint192) {
        if (value > type(uint192).max) {
            revert SafeCastOverflowedUintDowncast(192, value);
        }
        return uint192(value);
    }

    /**
     * @dev Returns the downcasted uint184 from uint256, reverting on
     * overflow (when the input is greater than largest uint184).
     *
     * Counterpart to Solidity's `uint184` operator.
     *
     * Requirements:
     *
     * - input must fit into 184 bits
     */
    function toUint184(uint256 value) internal pure returns (uint184) {
        if (value > type(uint184).max) {
            revert SafeCastOverflowedUintDowncast(184, value);
        }
        return uint184(value);
    }

    /**
     * @dev Returns the downcasted uint176 from uint256, reverting on
     * overflow (when the input is greater than largest uint176).
     *
     * Counterpart to Solidity's `uint176` operator.
     *
     * Requirements:
     *
     * - input must fit into 176 bits
     */
    function toUint176(uint256 value) internal pure returns (uint176) {
        if (value > type(uint176).max) {
            revert SafeCastOverflowedUintDowncast(176, value);
        }
        return uint176(value);
    }

    /**
     * @dev Returns the downcasted uint168 from uint256, reverting on
     * overflow (when the input is greater than largest uint168).
     *
     * Counterpart to Solidity's `uint168` operator.
     *
     * Requirements:
     *
     * - input must fit into 168 bits
     */
    function toUint168(uint256 value) internal pure returns (uint168) {
        if (value > type(uint168).max) {
            revert SafeCastOverflowedUintDowncast(168, value);
        }
        return uint168(value);
    }

    /**
     * @dev Returns the downcasted uint160 from uint256, reverting on
     * overflow (when the input is greater than largest uint160).
     *
     * Counterpart to Solidity's `uint160` operator.
     *
     * Requirements:
     *
     * - input must fit into 160 bits
     */
    function toUint160(uint256 value) internal pure returns (uint160) {
        if (value > type(uint160).max) {
            revert SafeCastOverflowedUintDowncast(160, value);
        }
        return uint160(value);
    }

    /**
     * @dev Returns the downcasted uint152 from uint256, reverting on
     * overflow (when the input is greater than largest uint152).
     *
     * Counterpart to Solidity's `uint152` operator.
     *
     * Requirements:
     *
     * - input must fit into 152 bits
     */
    function toUint152(uint256 value) internal pure returns (uint152) {
        if (value > type(uint152).max) {
            revert SafeCastOverflowedUintDowncast(152, value);
        }
        return uint152(value);
    }

    /**
     * @dev Returns the downcasted uint144 from uint256, reverting on
     * overflow (when the input is greater than largest uint144).
     *
     * Counterpart to Solidity's `uint144` operator.
     *
     * Requirements:
     *
     * - input must fit into 144 bits
     */
    function toUint144(uint256 value) internal pure returns (uint144) {
        if (value > type(uint144).max) {
            revert SafeCastOverflowedUintDowncast(144, value);
        }
        return uint144(value);
    }

    /**
     * @dev Returns the downcasted uint136 from uint256, reverting on
     * overflow (when the input is greater than largest uint136).
     *
     * Counterpart to Solidity's `uint136` operator.
     *
     * Requirements:
     *
     * - input must fit into 136 bits
     */
    function toUint136(uint256 value) internal pure returns (uint136) {
        if (value > type(uint136).max) {
            revert SafeCastOverflowedUintDowncast(136, value);
        }
        return uint136(value);
    }

    /**
     * @dev Returns the downcasted uint128 from uint256, reverting on
     * overflow (when the input is greater than largest uint128).
     *
     * Counterpart to Solidity's `uint128` operator.
     *
     * Requirements:
     *
     * - input must fit into 128 bits
     */
    function toUint128(uint256 value) internal pure returns (uint128) {
        if (value > type(uint128).max) {
            revert SafeCastOverflowedUintDowncast(128, value);
        }
        return uint128(value);
    }

    /**
     * @dev Returns the downcasted uint120 from uint256, reverting on
     * overflow (when the input is greater than largest uint120).
     *
     * Counterpart to Solidity's `uint120` operator.
     *
     * Requirements:
     *
     * - input must fit into 120 bits
     */
    function toUint120(uint256 value) internal pure returns (uint120) {
        if (value > type(uint120).max) {
            revert SafeCastOverflowedUintDowncast(120, value);
        }
        return uint120(value);
    }

    /**
     * @dev Returns the downcasted uint112 from uint256, reverting on
     * overflow (when the input is greater than largest uint112).
     *
     * Counterpart to Solidity's `uint112` operator.
     *
     * Requirements:
     *
     * - input must fit into 112 bits
     */
    function toUint112(uint256 value) internal pure returns (uint112) {
        if (value > type(uint112).max) {
            revert SafeCastOverflowedUintDowncast(112, value);
        }
        return uint112(value);
    }

    /**
     * @dev Returns the downcasted uint104 from uint256, reverting on
     * overflow (when the input is greater than largest uint104).
     *
     * Counterpart to Solidity's `uint104` operator.
     *
     * Requirements:
     *
     * - input must fit into 104 bits
     */
    function toUint104(uint256 value) internal pure returns (uint104) {
        if (value > type(uint104).max) {
            revert SafeCastOverflowedUintDowncast(104, value);
        }
        return uint104(value);
    }

    /**
     * @dev Returns the downcasted uint96 from uint256, reverting on
     * overflow (when the input is greater than largest uint96).
     *
     * Counterpart to Solidity's `uint96` operator.
     *
     * Requirements:
     *
     * - input must fit into 96 bits
     */
    function toUint96(uint256 value) internal pure returns (uint96) {
        if (value > type(uint96).max) {
            revert SafeCastOverflowedUintDowncast(96, value);
        }
        return uint96(value);
    }

    /**
     * @dev Returns the downcasted uint88 from uint256, reverting on
     * overflow (when the input is greater than largest uint88).
     *
     * Counterpart to Solidity's `uint88` operator.
     *
     * Requirements:
     *
     * - input must fit into 88 bits
     */
    function toUint88(uint256 value) internal pure returns (uint88) {
        if (value > type(uint88).max) {
            revert SafeCastOverflowedUintDowncast(88, value);
        }
        return uint88(value);
    }

    /**
     * @dev Returns the downcasted uint80 from uint256, reverting on
     * overflow (when the input is greater than largest uint80).
     *
     * Counterpart to Solidity's `uint80` operator.
     *
     * Requirements:
     *
     * - input must fit into 80 bits
     */
    function toUint80(uint256 value) internal pure returns (uint80) {
        if (value > type(uint80).max) {
            revert SafeCastOverflowedUintDowncast(80, value);
        }
        return uint80(value);
    }

    /**
     * @dev Returns the downcasted uint72 from uint256, reverting on
     * overflow (when the input is greater than largest uint72).
     *
     * Counterpart to Solidity's `uint72` operator.
     *
     * Requirements:
     *
     * - input must fit into 72 bits
     */
    function toUint72(uint256 value) internal pure returns (uint72) {
        if (value > type(uint72).max) {
            revert SafeCastOverflowedUintDowncast(72, value);
        }
        return uint72(value);
    }

    /**
     * @dev Returns the downcasted uint64 from uint256, reverting on
     * overflow (when the input is greater than largest uint64).
     *
     * Counterpart to Solidity's `uint64` operator.
     *
     * Requirements:
     *
     * - input must fit into 64 bits
     */
    function toUint64(uint256 value) internal pure returns (uint64) {
        if (value > type(uint64).max) {
            revert SafeCastOverflowedUintDowncast(64, value);
        }
        return uint64(value);
    }

    /**
     * @dev Returns the downcasted uint56 from uint256, reverting on
     * overflow (when the input is greater than largest uint56).
     *
     * Counterpart to Solidity's `uint56` operator.
     *
     * Requirements:
     *
     * - input must fit into 56 bits
     */
    function toUint56(uint256 value) internal pure returns (uint56) {
        if (value > type(uint56).max) {
            revert SafeCastOverflowedUintDowncast(56, value);
        }
        return uint56(value);
    }

    /**
     * @dev Returns the downcasted uint48 from uint256, reverting on
     * overflow (when the input is greater than largest uint48).
     *
     * Counterpart to Solidity's `uint48` operator.
     *
     * Requirements:
     *
     * - input must fit into 48 bits
     */
    function toUint48(uint256 value) internal pure returns (uint48) {
        if (value > type(uint48).max) {
            revert SafeCastOverflowedUintDowncast(48, value);
        }
        return uint48(value);
    }

    /**
     * @dev Returns the downcasted uint40 from uint256, reverting on
     * overflow (when the input is greater than largest uint40).
     *
     * Counterpart to Solidity's `uint40` operator.
     *
     * Requirements:
     *
     * - input must fit into 40 bits
     */
    function toUint40(uint256 value) internal pure returns (uint40) {
        if (value > type(uint40).max) {
            revert SafeCastOverflowedUintDowncast(40, value);
        }
        return uint40(value);
    }

    /**
     * @dev Returns the downcasted uint32 from uint256, reverting on
     * overflow (when the input is greater than largest uint32).
     *
     * Counterpart to Solidity's `uint32` operator.
     *
     * Requirements:
     *
     * - input must fit into 32 bits
     */
    function toUint32(uint256 value) internal pure returns (uint32) {
        if (value > type(uint32).max) {
            revert SafeCastOverflowedUintDowncast(32, value);
        }
        return uint32(value);
    }

    /**
     * @dev Returns the downcasted uint24 from uint256, reverting on
     * overflow (when the input is greater than largest uint24).
     *
     * Counterpart to Solidity's `uint24` operator.
     *
     * Requirements:
     *
     * - input must fit into 24 bits
     */
    function toUint24(uint256 value) internal pure returns (uint24) {
        if (value > type(uint24).max) {
            revert SafeCastOverflowedUintDowncast(24, value);
        }
        return uint24(value);
    }

    /**
     * @dev Returns the downcasted uint16 from uint256, reverting on
     * overflow (when the input is greater than largest uint16).
     *
     * Counterpart to Solidity's `uint16` operator.
     *
     * Requirements:
     *
     * - input must fit into 16 bits
     */
    function toUint16(uint256 value) internal pure returns (uint16) {
        if (value > type(uint16).max) {
            revert SafeCastOverflowedUintDowncast(16, value);
        }
        return uint16(value);
    }

    /**
     * @dev Returns the downcasted uint8 from uint256, reverting on
     * overflow (when the input is greater than largest uint8).
     *
     * Counterpart to Solidity's `uint8` operator.
     *
     * Requirements:
     *
     * - input must fit into 8 bits
     */
    function toUint8(uint256 value) internal pure returns (uint8) {
        if (value > type(uint8).max) {
            revert SafeCastOverflowedUintDowncast(8, value);
        }
        return uint8(value);
    }

    /**
     * @dev Converts a signed int256 into an unsigned uint256.
     *
     * Requirements:
     *
     * - input must be greater than or equal to 0.
     */
    function toUint256(int256 value) internal pure returns (uint256) {
        if (value < 0) {
            revert SafeCastOverflowedIntToUint(value);
        }
        return uint256(value);
    }

    /**
     * @dev Returns the downcasted int248 from int256, reverting on
     * overflow (when the input is less than smallest int248 or
     * greater than largest int248).
     *
     * Counterpart to Solidity's `int248` operator.
     *
     * Requirements:
     *
     * - input must fit into 248 bits
     */
    function toInt248(int256 value) internal pure returns (int248 downcasted) {
        downcasted = int248(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(248, value);
        }
    }

    /**
     * @dev Returns the downcasted int240 from int256, reverting on
     * overflow (when the input is less than smallest int240 or
     * greater than largest int240).
     *
     * Counterpart to Solidity's `int240` operator.
     *
     * Requirements:
     *
     * - input must fit into 240 bits
     */
    function toInt240(int256 value) internal pure returns (int240 downcasted) {
        downcasted = int240(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(240, value);
        }
    }

    /**
     * @dev Returns the downcasted int232 from int256, reverting on
     * overflow (when the input is less than smallest int232 or
     * greater than largest int232).
     *
     * Counterpart to Solidity's `int232` operator.
     *
     * Requirements:
     *
     * - input must fit into 232 bits
     */
    function toInt232(int256 value) internal pure returns (int232 downcasted) {
        downcasted = int232(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(232, value);
        }
    }

    /**
     * @dev Returns the downcasted int224 from int256, reverting on
     * overflow (when the input is less than smallest int224 or
     * greater than largest int224).
     *
     * Counterpart to Solidity's `int224` operator.
     *
     * Requirements:
     *
     * - input must fit into 224 bits
     */
    function toInt224(int256 value) internal pure returns (int224 downcasted) {
        downcasted = int224(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(224, value);
        }
    }

    /**
     * @dev Returns the downcasted int216 from int256, reverting on
     * overflow (when the input is less than smallest int216 or
     * greater than largest int216).
     *
     * Counterpart to Solidity's `int216` operator.
     *
     * Requirements:
     *
     * - input must fit into 216 bits
     */
    function toInt216(int256 value) internal pure returns (int216 downcasted) {
        downcasted = int216(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(216, value);
        }
    }

    /**
     * @dev Returns the downcasted int208 from int256, reverting on
     * overflow (when the input is less than smallest int208 or
     * greater than largest int208).
     *
     * Counterpart to Solidity's `int208` operator.
     *
     * Requirements:
     *
     * - input must fit into 208 bits
     */
    function toInt208(int256 value) internal pure returns (int208 downcasted) {
        downcasted = int208(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(208, value);
        }
    }

    /**
     * @dev Returns the downcasted int200 from int256, reverting on
     * overflow (when the input is less than smallest int200 or
     * greater than largest int200).
     *
     * Counterpart to Solidity's `int200` operator.
     *
     * Requirements:
     *
     * - input must fit into 200 bits
     */
    function toInt200(int256 value) internal pure returns (int200 downcasted) {
        downcasted = int200(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(200, value);
        }
    }

    /**
     * @dev Returns the downcasted int192 from int256, reverting on
     * overflow (when the input is less than smallest int192 or
     * greater than largest int192).
     *
     * Counterpart to Solidity's `int192` operator.
     *
     * Requirements:
     *
     * - input must fit into 192 bits
     */
    function toInt192(int256 value) internal pure returns (int192 downcasted) {
        downcasted = int192(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(192, value);
        }
    }

    /**
     * @dev Returns the downcasted int184 from int256, reverting on
     * overflow (when the input is less than smallest int184 or
     * greater than largest int184).
     *
     * Counterpart to Solidity's `int184` operator.
     *
     * Requirements:
     *
     * - input must fit into 184 bits
     */
    function toInt184(int256 value) internal pure returns (int184 downcasted) {
        downcasted = int184(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(184, value);
        }
    }

    /**
     * @dev Returns the downcasted int176 from int256, reverting on
     * overflow (when the input is less than smallest int176 or
     * greater than largest int176).
     *
     * Counterpart to Solidity's `int176` operator.
     *
     * Requirements:
     *
     * - input must fit into 176 bits
     */
    function toInt176(int256 value) internal pure returns (int176 downcasted) {
        downcasted = int176(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(176, value);
        }
    }

    /**
     * @dev Returns the downcasted int168 from int256, reverting on
     * overflow (when the input is less than smallest int168 or
     * greater than largest int168).
     *
     * Counterpart to Solidity's `int168` operator.
     *
     * Requirements:
     *
     * - input must fit into 168 bits
     */
    function toInt168(int256 value) internal pure returns (int168 downcasted) {
        downcasted = int168(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(168, value);
        }
    }

    /**
     * @dev Returns the downcasted int160 from int256, reverting on
     * overflow (when the input is less than smallest int160 or
     * greater than largest int160).
     *
     * Counterpart to Solidity's `int160` operator.
     *
     * Requirements:
     *
     * - input must fit into 160 bits
     */
    function toInt160(int256 value) internal pure returns (int160 downcasted) {
        downcasted = int160(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(160, value);
        }
    }

    /**
     * @dev Returns the downcasted int152 from int256, reverting on
     * overflow (when the input is less than smallest int152 or
     * greater than largest int152).
     *
     * Counterpart to Solidity's `int152` operator.
     *
     * Requirements:
     *
     * - input must fit into 152 bits
     */
    function toInt152(int256 value) internal pure returns (int152 downcasted) {
        downcasted = int152(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(152, value);
        }
    }

    /**
     * @dev Returns the downcasted int144 from int256, reverting on
     * overflow (when the input is less than smallest int144 or
     * greater than largest int144).
     *
     * Counterpart to Solidity's `int144` operator.
     *
     * Requirements:
     *
     * - input must fit into 144 bits
     */
    function toInt144(int256 value) internal pure returns (int144 downcasted) {
        downcasted = int144(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(144, value);
        }
    }

    /**
     * @dev Returns the downcasted int136 from int256, reverting on
     * overflow (when the input is less than smallest int136 or
     * greater than largest int136).
     *
     * Counterpart to Solidity's `int136` operator.
     *
     * Requirements:
     *
     * - input must fit into 136 bits
     */
    function toInt136(int256 value) internal pure returns (int136 downcasted) {
        downcasted = int136(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(136, value);
        }
    }

    /**
     * @dev Returns the downcasted int128 from int256, reverting on
     * overflow (when the input is less than smallest int128 or
     * greater than largest int128).
     *
     * Counterpart to Solidity's `int128` operator.
     *
     * Requirements:
     *
     * - input must fit into 128 bits
     */
    function toInt128(int256 value) internal pure returns (int128 downcasted) {
        downcasted = int128(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(128, value);
        }
    }

    /**
     * @dev Returns the downcasted int120 from int256, reverting on
     * overflow (when the input is less than smallest int120 or
     * greater than largest int120).
     *
     * Counterpart to Solidity's `int120` operator.
     *
     * Requirements:
     *
     * - input must fit into 120 bits
     */
    function toInt120(int256 value) internal pure returns (int120 downcasted) {
        downcasted = int120(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(120, value);
        }
    }

    /**
     * @dev Returns the downcasted int112 from int256, reverting on
     * overflow (when the input is less than smallest int112 or
     * greater than largest int112).
     *
     * Counterpart to Solidity's `int112` operator.
     *
     * Requirements:
     *
     * - input must fit into 112 bits
     */
    function toInt112(int256 value) internal pure returns (int112 downcasted) {
        downcasted = int112(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(112, value);
        }
    }

    /**
     * @dev Returns the downcasted int104 from int256, reverting on
     * overflow (when the input is less than smallest int104 or
     * greater than largest int104).
     *
     * Counterpart to Solidity's `int104` operator.
     *
     * Requirements:
     *
     * - input must fit into 104 bits
     */
    function toInt104(int256 value) internal pure returns (int104 downcasted) {
        downcasted = int104(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(104, value);
        }
    }

    /**
     * @dev Returns the downcasted int96 from int256, reverting on
     * overflow (when the input is less than smallest int96 or
     * greater than largest int96).
     *
     * Counterpart to Solidity's `int96` operator.
     *
     * Requirements:
     *
     * - input must fit into 96 bits
     */
    function toInt96(int256 value) internal pure returns (int96 downcasted) {
        downcasted = int96(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(96, value);
        }
    }

    /**
     * @dev Returns the downcasted int88 from int256, reverting on
     * overflow (when the input is less than smallest int88 or
     * greater than largest int88).
     *
     * Counterpart to Solidity's `int88` operator.
     *
     * Requirements:
     *
     * - input must fit into 88 bits
     */
    function toInt88(int256 value) internal pure returns (int88 downcasted) {
        downcasted = int88(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(88, value);
        }
    }

    /**
     * @dev Returns the downcasted int80 from int256, reverting on
     * overflow (when the input is less than smallest int80 or
     * greater than largest int80).
     *
     * Counterpart to Solidity's `int80` operator.
     *
     * Requirements:
     *
     * - input must fit into 80 bits
     */
    function toInt80(int256 value) internal pure returns (int80 downcasted) {
        downcasted = int80(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(80, value);
        }
    }

    /**
     * @dev Returns the downcasted int72 from int256, reverting on
     * overflow (when the input is less than smallest int72 or
     * greater than largest int72).
     *
     * Counterpart to Solidity's `int72` operator.
     *
     * Requirements:
     *
     * - input must fit into 72 bits
     */
    function toInt72(int256 value) internal pure returns (int72 downcasted) {
        downcasted = int72(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(72, value);
        }
    }

    /**
     * @dev Returns the downcasted int64 from int256, reverting on
     * overflow (when the input is less than smallest int64 or
     * greater than largest int64).
     *
     * Counterpart to Solidity's `int64` operator.
     *
     * Requirements:
     *
     * - input must fit into 64 bits
     */
    function toInt64(int256 value) internal pure returns (int64 downcasted) {
        downcasted = int64(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(64, value);
        }
    }

    /**
     * @dev Returns the downcasted int56 from int256, reverting on
     * overflow (when the input is less than smallest int56 or
     * greater than largest int56).
     *
     * Counterpart to Solidity's `int56` operator.
     *
     * Requirements:
     *
     * - input must fit into 56 bits
     */
    function toInt56(int256 value) internal pure returns (int56 downcasted) {
        downcasted = int56(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(56, value);
        }
    }

    /**
     * @dev Returns the downcasted int48 from int256, reverting on
     * overflow (when the input is less than smallest int48 or
     * greater than largest int48).
     *
     * Counterpart to Solidity's `int48` operator.
     *
     * Requirements:
     *
     * - input must fit into 48 bits
     */
    function toInt48(int256 value) internal pure returns (int48 downcasted) {
        downcasted = int48(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(48, value);
        }
    }

    /**
     * @dev Returns the downcasted int40 from int256, reverting on
     * overflow (when the input is less than smallest int40 or
     * greater than largest int40).
     *
     * Counterpart to Solidity's `int40` operator.
     *
     * Requirements:
     *
     * - input must fit into 40 bits
     */
    function toInt40(int256 value) internal pure returns (int40 downcasted) {
        downcasted = int40(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(40, value);
        }
    }

    /**
     * @dev Returns the downcasted int32 from int256, reverting on
     * overflow (when the input is less than smallest int32 or
     * greater than largest int32).
     *
     * Counterpart to Solidity's `int32` operator.
     *
     * Requirements:
     *
     * - input must fit into 32 bits
     */
    function toInt32(int256 value) internal pure returns (int32 downcasted) {
        downcasted = int32(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(32, value);
        }
    }

    /**
     * @dev Returns the downcasted int24 from int256, reverting on
     * overflow (when the input is less than smallest int24 or
     * greater than largest int24).
     *
     * Counterpart to Solidity's `int24` operator.
     *
     * Requirements:
     *
     * - input must fit into 24 bits
     */
    function toInt24(int256 value) internal pure returns (int24 downcasted) {
        downcasted = int24(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(24, value);
        }
    }

    /**
     * @dev Returns the downcasted int16 from int256, reverting on
     * overflow (when the input is less than smallest int16 or
     * greater than largest int16).
     *
     * Counterpart to Solidity's `int16` operator.
     *
     * Requirements:
     *
     * - input must fit into 16 bits
     */
    function toInt16(int256 value) internal pure returns (int16 downcasted) {
        downcasted = int16(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(16, value);
        }
    }

    /**
     * @dev Returns the downcasted int8 from int256, reverting on
     * overflow (when the input is less than smallest int8 or
     * greater than largest int8).
     *
     * Counterpart to Solidity's `int8` operator.
     *
     * Requirements:
     *
     * - input must fit into 8 bits
     */
    function toInt8(int256 value) internal pure returns (int8 downcasted) {
        downcasted = int8(value);
        if (downcasted != value) {
            revert SafeCastOverflowedIntDowncast(8, value);
        }
    }

    /**
     * @dev Converts an unsigned uint256 into a signed int256.
     *
     * Requirements:
     *
     * - input must be less than or equal to maxInt256.
     */
    function toInt256(uint256 value) internal pure returns (int256) {
        // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
        if (value > uint256(type(int256).max)) {
            revert SafeCastOverflowedUintToInt(value);
        }
        return int256(value);
    }

    /**
     * @dev Cast a boolean (false or true) to a uint256 (0 or 1) with no jump.
     */
    function toUint(bool b) internal pure returns (uint256 u) {
        /// @solidity memory-safe-assembly
        assembly {
            u := iszero(iszero(b))
        }
    }
}

// contracts/lib/cross-chain-swap/lib/solidity-utils/contracts/libraries/StringUtil.sol

/**
 * @title StringUtil
 * @dev Library with gas-efficient string operations.
 */
library StringUtil {
    /**
     * @notice Converts a uint256 value to its hexadecimal string representation.
     * @param value The uint256 value to convert.
     * @return The hexadecimal string representation of the input value.
     */
    function toHex(uint256 value) internal pure returns (string memory) {
        return toHex(abi.encodePacked(value));
    }

    /**
     * @notice Converts an address to its hexadecimal string representation.
     * @param value The address to convert.
     * @return The hexadecimal string representation of the input address.
     */
    function toHex(address value) internal pure returns (string memory) {
        return toHex(abi.encodePacked(value));
    }

    /**
     * @dev Converts arbitrary bytes to their hexadecimal string representation.
     * This is an assembly adaptation of highly optimized toHex16 code by Mikhail Vladimirov.
     * Reference: https://stackoverflow.com/a/69266989
     * @param data The bytes to be converted to hexadecimal string.
     * @return result The hexadecimal string representation of the input bytes.
     */
    function toHex(bytes memory data) internal pure returns (string memory result) {
        assembly ("memory-safe") { // solhint-disable-line no-inline-assembly
            function _toHex16(input) -> output {
                output := or(
                    and(input, 0xFFFFFFFFFFFFFFFF000000000000000000000000000000000000000000000000),
                    shr(64, and(input, 0x0000000000000000FFFFFFFFFFFFFFFF00000000000000000000000000000000))
                )
                output := or(
                    and(output, 0xFFFFFFFF000000000000000000000000FFFFFFFF000000000000000000000000),
                    shr(32, and(output, 0x00000000FFFFFFFF000000000000000000000000FFFFFFFF0000000000000000))
                )
                output := or(
                    and(output, 0xFFFF000000000000FFFF000000000000FFFF000000000000FFFF000000000000),
                    shr(16, and(output, 0x0000FFFF000000000000FFFF000000000000FFFF000000000000FFFF00000000))
                )
                output := or(
                    and(output, 0xFF000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000),
                    shr(8, and(output, 0x00FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF0000))
                )
                output := or(
                    shr(4, and(output, 0xF000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000)),
                    shr(8, and(output, 0x0F000F000F000F000F000F000F000F000F000F000F000F000F000F000F000F00))
                )
                output := add(
                    add(0x3030303030303030303030303030303030303030303030303030303030303030, output),
                    mul(
                        and(
                            shr(4, add(output, 0x0606060606060606060606060606060606060606060606060606060606060606)),
                            0x0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F0F
                        ),
                        7 // Change 7 to 39 for lower case output
                    )
                )
            }

            result := mload(0x40)
            let length := mload(data)
            let resultLength := shl(1, length)
            let toPtr := add(result, 0x22) // 32 bytes for length + 2 bytes for '0x'
            mstore(0x40, add(toPtr, resultLength)) // move free memory pointer
            mstore(add(result, 2), 0x3078) // 0x3078 is right aligned so we write to `result + 2`
            // to store the last 2 bytes in the beginning of the string
            mstore(result, add(resultLength, 2)) // extra 2 bytes for '0x'

            for {
                let fromPtr := add(data, 0x20)
                let endPtr := add(fromPtr, length)
            } lt(fromPtr, endPtr) {
                fromPtr := add(fromPtr, 0x20)
            } {
                let rawData := mload(fromPtr)
                let hexData := _toHex16(rawData)
                mstore(toPtr, hexData)
                toPtr := add(toPtr, 0x20)
                hexData := _toHex16(shl(128, rawData))
                mstore(toPtr, hexData)
                toPtr := add(toPtr, 0x20)
            }
        }
    }
}

// contracts/lib/cross-chain-swap/lib/limit-order-protocol/contracts/libraries/TakerTraitsLib.sol

type TakerTraits is uint256;

/**
 * @title TakerTraitsLib
 * @notice This library to manage and check TakerTraits, which are used to encode the taker's preferences for an order in a single uint256.
 * @dev The TakerTraits are structured as follows:
 * High bits are used for flags
 * 255 bit `_MAKER_AMOUNT_FLAG`           - If set, the taking amount is calculated based on making amount, otherwise making amount is calculated based on taking amount.
 * 254 bit `_UNWRAP_WETH_FLAG`            - If set, the WETH will be unwrapped into ETH before sending to taker.
 * 253 bit `_SKIP_ORDER_PERMIT_FLAG`      - If set, the order skips maker's permit execution.
 * 252 bit `_USE_PERMIT2_FLAG`            - If set, the order uses the permit2 function for authorization.
 * 251 bit `_ARGS_HAS_TARGET`             - If set, then first 20 bytes of args are treated as target address for maker’s funds transfer.
 * 224-247 bits `ARGS_EXTENSION_LENGTH`   - The length of the extension calldata in the args.
 * 200-223 bits `ARGS_INTERACTION_LENGTH` - The length of the interaction calldata in the args.
 * 0-184 bits                             - The threshold amount (the maximum amount a taker agrees to give in exchange for a making amount).
 */
library TakerTraitsLib {
    uint256 private constant _MAKER_AMOUNT_FLAG = 1 << 255;
    uint256 private constant _UNWRAP_WETH_FLAG = 1 << 254;
    uint256 private constant _SKIP_ORDER_PERMIT_FLAG = 1 << 253;
    uint256 private constant _USE_PERMIT2_FLAG = 1 << 252;
    uint256 private constant _ARGS_HAS_TARGET = 1 << 251;

    uint256 private constant _ARGS_EXTENSION_LENGTH_OFFSET = 224;
    uint256 private constant _ARGS_EXTENSION_LENGTH_MASK = 0xffffff;
    uint256 private constant _ARGS_INTERACTION_LENGTH_OFFSET = 200;
    uint256 private constant _ARGS_INTERACTION_LENGTH_MASK = 0xffffff;

    uint256 private constant _AMOUNT_MASK = 0x000000000000000000ffffffffffffffffffffffffffffffffffffffffffffff;

    /**
     * @notice Checks if the args should contain target address.
     * @param takerTraits The traits of the taker.
     * @return result A boolean indicating whether the args should contain target address.
     */
    function argsHasTarget(TakerTraits takerTraits) internal pure returns (bool) {
        return (TakerTraits.unwrap(takerTraits) & _ARGS_HAS_TARGET) != 0;
    }

    /**
     * @notice Retrieves the length of the extension calldata from the takerTraits.
     * @param takerTraits The traits of the taker.
     * @return result The length of the extension calldata encoded in the takerTraits.
     */
    function argsExtensionLength(TakerTraits takerTraits) internal pure returns (uint256) {
        return (TakerTraits.unwrap(takerTraits) >> _ARGS_EXTENSION_LENGTH_OFFSET) & _ARGS_EXTENSION_LENGTH_MASK;
    }

    /**
     * @notice Retrieves the length of the interaction calldata from the takerTraits.
     * @param takerTraits The traits of the taker.
     * @return result The length of the interaction calldata encoded in the takerTraits.
     */
    function argsInteractionLength(TakerTraits takerTraits) internal pure returns (uint256) {
        return (TakerTraits.unwrap(takerTraits) >> _ARGS_INTERACTION_LENGTH_OFFSET) & _ARGS_INTERACTION_LENGTH_MASK;
    }

    /**
     * @notice Checks if the taking amount should be calculated based on making amount.
     * @param takerTraits The traits of the taker.
     * @return result A boolean indicating whether the taking amount should be calculated based on making amount.
     */
    function isMakingAmount(TakerTraits takerTraits) internal pure returns (bool) {
        return (TakerTraits.unwrap(takerTraits) & _MAKER_AMOUNT_FLAG) != 0;
    }

    /**
     * @notice Checks if the order should unwrap WETH and send ETH to taker.
     * @param takerTraits The traits of the taker.
     * @return result A boolean indicating whether the order should unwrap WETH.
     */
    function unwrapWeth(TakerTraits takerTraits) internal pure returns (bool) {
        return (TakerTraits.unwrap(takerTraits) & _UNWRAP_WETH_FLAG) != 0;
    }

    /**
     * @notice Checks if the order should skip maker's permit execution.
     * @param takerTraits The traits of the taker.
     * @return result A boolean indicating whether the order don't apply permit.
     */
    function skipMakerPermit(TakerTraits takerTraits) internal pure returns (bool) {
        return (TakerTraits.unwrap(takerTraits) & _SKIP_ORDER_PERMIT_FLAG) != 0;
    }

    /**
     * @notice Checks if the order uses the permit2 instead of permit.
     * @param takerTraits The traits of the taker.
     * @return result A boolean indicating whether the order uses the permit2.
     */
    function usePermit2(TakerTraits takerTraits) internal pure returns (bool) {
        return (TakerTraits.unwrap(takerTraits) & _USE_PERMIT2_FLAG) != 0;
    }

    /**
     * @notice Retrieves the threshold amount from the takerTraits.
     * The maximum amount a taker agrees to give in exchange for a making amount.
     * @param takerTraits The traits of the taker.
     * @return result The threshold amount encoded in the takerTraits.
     */
    function threshold(TakerTraits takerTraits) internal pure returns (uint256) {
        return TakerTraits.unwrap(takerTraits) & _AMOUNT_MASK;
    }
}

// contracts/lib/cross-chain-swap/contracts/libraries/TimelocksLib.sol

/**
 * @dev Timelocks for the source and the destination chains plus the deployment timestamp.
 * Timelocks store the number of seconds from the time the contract is deployed to the start of a specific period.
 * For illustrative purposes, it is possible to describe timelocks by two structures:
 * struct SrcTimelocks {
 *     uint256 withdrawal;
 *     uint256 publicWithdrawal;
 *     uint256 cancellation;
 *     uint256 publicCancellation;
 * }
 *
 * struct DstTimelocks {
 *     uint256 withdrawal;
 *     uint256 publicWithdrawal;
 *     uint256 cancellation;
 * }
 *
 * withdrawal: Period when only the taker with a secret can withdraw tokens for taker (source chain) or maker (destination chain).
 * publicWithdrawal: Period when anyone with a secret can withdraw tokens for taker (source chain) or maker (destination chain).
 * cancellation: Period when escrow can only be cancelled by the taker.
 * publicCancellation: Period when escrow can be cancelled by anyone.
 *
 * @custom:security-contact security@1inch.io
 */
type Timelocks is uint256;

/**
 * @title Timelocks library for compact storage of timelocks in a uint256.
 */
library TimelocksLib {
    enum Stage {
        SrcWithdrawal,
        SrcPublicWithdrawal,
        SrcCancellation,
        SrcPublicCancellation,
        DstWithdrawal,
        DstPublicWithdrawal,
        DstCancellation
    }

    uint256 private constant _DEPLOYED_AT_MASK = 0xffffffff00000000000000000000000000000000000000000000000000000000;
    uint256 private constant _DEPLOYED_AT_OFFSET = 224;

    /**
     * @notice Sets the Escrow deployment timestamp.
     * @param timelocks The timelocks to set the deployment timestamp to.
     * @param value The new Escrow deployment timestamp.
     * @return The timelocks with the deployment timestamp set.
     */
    function setDeployedAt(Timelocks timelocks, uint256 value) internal pure returns (Timelocks) {
        return Timelocks.wrap((Timelocks.unwrap(timelocks) & ~uint256(_DEPLOYED_AT_MASK)) | value << _DEPLOYED_AT_OFFSET);
    }

    /**
     * @notice Returns the start of the rescue period.
     * @param timelocks The timelocks to get the rescue delay from.
     * @return The start of the rescue period.
     */
    function rescueStart(Timelocks timelocks, uint256 rescueDelay) internal pure returns (uint256) {
        unchecked {
            return rescueDelay + (Timelocks.unwrap(timelocks) >> _DEPLOYED_AT_OFFSET);
        }
    }

    /**
     * @notice Returns the timelock value for the given stage.
     * @param timelocks The timelocks to get the value from.
     * @param stage The stage to get the value for.
     * @return The timelock value for the given stage.
     */
    function get(Timelocks timelocks, Stage stage) internal pure returns (uint256) {
        uint256 data = Timelocks.unwrap(timelocks);
        uint256 bitShift = uint256(stage) * 32;
        // The maximum uint32 value will be reached in 2106.
        return (data >> _DEPLOYED_AT_OFFSET) + uint32(data >> bitShift);
    }
}

// contracts/lib/cross-chain-swap/lib/openzeppelin-contracts/contracts/proxy/Clones.sol

// OpenZeppelin Contracts (last updated v5.0.0) (proxy/Clones.sol)

/**
 * @dev https://eips.ethereum.org/EIPS/eip-1167[ERC-1167] is a standard for
 * deploying minimal proxy contracts, also known as "clones".
 *
 * > To simply and cheaply clone contract functionality in an immutable way, this standard specifies
 * > a minimal bytecode implementation that delegates all calls to a known, fixed address.
 *
 * The library includes functions to deploy a proxy using either `create` (traditional deployment) or `create2`
 * (salted deterministic deployment). It also includes functions to predict the addresses of clones deployed using the
 * deterministic method.
 */
library Clones {
    /**
     * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
     *
     * This function uses the create opcode, which should never revert.
     */
    function clone(address implementation) internal returns (address instance) {
        return clone(implementation, 0);
    }

    /**
     * @dev Same as {xref-Clones-clone-address-}[clone], but with a `value` parameter to send native currency
     * to the new contract.
     *
     * NOTE: Using a non-zero value at creation will require the contract using this function (e.g. a factory)
     * to always have enough balance for new deployments. Consider exposing this function under a payable method.
     */
    function clone(address implementation, uint256 value) internal returns (address instance) {
        if (address(this).balance < value) {
            revert Errors.InsufficientBalance(address(this).balance, value);
        }
        /// @solidity memory-safe-assembly
        assembly {
            // Stores the bytecode after address
            mstore(0x20, 0x5af43d82803e903d91602b57fd5bf3)
            // implementation address
            mstore(0x11, implementation)
            // Packs the first 3 bytes of the `implementation` address with the bytecode before the address.
            mstore(0x00, or(shr(0x88, implementation), 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000))
            instance := create(value, 0x09, 0x37)
        }
        if (instance == address(0)) {
            revert Errors.FailedDeployment();
        }
    }

    /**
     * @dev Deploys and returns the address of a clone that mimics the behaviour of `implementation`.
     *
     * This function uses the create2 opcode and a `salt` to deterministically deploy
     * the clone. Using the same `implementation` and `salt` multiple time will revert, since
     * the clones cannot be deployed twice at the same address.
     */
    function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
        return cloneDeterministic(implementation, salt, 0);
    }

    /**
     * @dev Same as {xref-Clones-cloneDeterministic-address-bytes32-}[cloneDeterministic], but with
     * a `value` parameter to send native currency to the new contract.
     *
     * NOTE: Using a non-zero value at creation will require the contract using this function (e.g. a factory)
     * to always have enough balance for new deployments. Consider exposing this function under a payable method.
     */
    function cloneDeterministic(
        address implementation,
        bytes32 salt,
        uint256 value
    ) internal returns (address instance) {
        if (address(this).balance < value) {
            revert Errors.InsufficientBalance(address(this).balance, value);
        }
        /// @solidity memory-safe-assembly
        assembly {
            // Stores the bytecode after address
            mstore(0x20, 0x5af43d82803e903d91602b57fd5bf3)
            // implementation address
            mstore(0x11, implementation)
            // Packs the first 3 bytes of the `implementation` address with the bytecode before the address.
            mstore(0x00, or(shr(0x88, implementation), 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000))
            instance := create2(value, 0x09, 0x37, salt)
        }
        if (instance == address(0)) {
            revert Errors.FailedDeployment();
        }
    }

    /**
     * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
     */
    function predictDeterministicAddress(
        address implementation,
        bytes32 salt,
        address deployer
    ) internal pure returns (address predicted) {
        /// @solidity memory-safe-assembly
        assembly {
            let ptr := mload(0x40)
            mstore(add(ptr, 0x38), deployer)
            mstore(add(ptr, 0x24), 0x5af43d82803e903d91602b57fd5bf3ff)
            mstore(add(ptr, 0x14), implementation)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73)
            mstore(add(ptr, 0x58), salt)
            mstore(add(ptr, 0x78), keccak256(add(ptr, 0x0c), 0x37))
            predicted := and(keccak256(add(ptr, 0x43), 0x55), 0xffffffffffffffffffffffffffffffffffffffff)
        }
    }

    /**
     * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
     */
    function predictDeterministicAddress(
        address implementation,
        bytes32 salt
    ) internal view returns (address predicted) {
        return predictDeterministicAddress(implementation, salt, address(this));
    }
}

// contracts/lib/cross-chain-swap/lib/openzeppelin-contracts/contracts/utils/Create2.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/Create2.sol)

/**
 * @dev Helper to make usage of the `CREATE2` EVM opcode easier and safer.
 * `CREATE2` can be used to compute in advance the address where a smart
 * contract will be deployed, which allows for interesting new mechanisms known
 * as 'counterfactual interactions'.
 *
 * See the https://eips.ethereum.org/EIPS/eip-1014#motivation[EIP] for more
 * information.
 */
library Create2 {
    /**
     * @dev There's no code to deploy.
     */
    error Create2EmptyBytecode();

    /**
     * @dev Deploys a contract using `CREATE2`. The address where the contract
     * will be deployed can be known in advance via {computeAddress}.
     *
     * The bytecode for a contract can be obtained from Solidity with
     * `type(contractName).creationCode`.
     *
     * Requirements:
     *
     * - `bytecode` must not be empty.
     * - `salt` must have not been used for `bytecode` already.
     * - the factory must have a balance of at least `amount`.
     * - if `amount` is non-zero, `bytecode` must have a `payable` constructor.
     */
    function deploy(uint256 amount, bytes32 salt, bytes memory bytecode) internal returns (address addr) {
        if (address(this).balance < amount) {
            revert Errors.InsufficientBalance(address(this).balance, amount);
        }
        if (bytecode.length == 0) {
            revert Create2EmptyBytecode();
        }
        /// @solidity memory-safe-assembly
        assembly {
            addr := create2(amount, add(bytecode, 0x20), mload(bytecode), salt)
        }
        if (addr == address(0)) {
            revert Errors.FailedDeployment();
        }
    }

    /**
     * @dev Returns the address where a contract will be stored if deployed via {deploy}. Any change in the
     * `bytecodeHash` or `salt` will result in a new destination address.
     */
    function computeAddress(bytes32 salt, bytes32 bytecodeHash) internal view returns (address) {
        return computeAddress(salt, bytecodeHash, address(this));
    }

    /**
     * @dev Returns the address where a contract will be stored if deployed via {deploy} from a contract located at
     * `deployer`. If `deployer` is this contract's address, returns the same value as {computeAddress}.
     */
    function computeAddress(bytes32 salt, bytes32 bytecodeHash, address deployer) internal pure returns (address addr) {
        /// @solidity memory-safe-assembly
        assembly {
            let ptr := mload(0x40) // Get free memory pointer

            // |                   | ↓ ptr ...  ↓ ptr + 0x0B (start) ...  ↓ ptr + 0x20 ...  ↓ ptr + 0x40 ...   |
            // |-------------------|---------------------------------------------------------------------------|
            // | bytecodeHash      |                                                        CCCCCCCCCCCCC...CC |
            // | salt              |                                      BBBBBBBBBBBBB...BB                   |
            // | deployer          | 000000...0000AAAAAAAAAAAAAAAAAAA...AA                                     |
            // | 0xFF              |            FF                                                             |
            // |-------------------|---------------------------------------------------------------------------|
            // | memory            | 000000...00FFAAAAAAAAAAAAAAAAAAA...AABBBBBBBBBBBBB...BBCCCCCCCCCCCCC...CC |
            // | keccak(start, 85) |            ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ |

            mstore(add(ptr, 0x40), bytecodeHash)
            mstore(add(ptr, 0x20), salt)
            mstore(ptr, deployer) // Right-aligned with 12 preceding garbage bytes
            let start := add(ptr, 0x0b) // The hashed data starts at the final garbage byte which we will set to 0xff
            mstore8(start, 0xff)
            addr := and(keccak256(start, 85), 0xffffffffffffffffffffffffffffffffffffffff)
        }
    }
}

// contracts/lib/cross-chain-swap/lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol

// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/extensions/IERC20Metadata.sol)

/**
 * @dev Interface for the optional metadata functions from the ERC-20 standard.
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// contracts/lib/cross-chain-swap/lib/limit-order-settlement/contracts/interfaces/IFeeBankCharger.sol

interface IFeeBankCharger {
    /**
     * @notice Returns the instance of the FeeBank contract.
     * @return The instance of the FeeBank contract.
     */
    function FEE_BANK() external view returns (IFeeBank); // solhint-disable-line func-name-mixedcase

    /**
     * @notice Returns the available credit for a given account.
     * @param account The address of the account for which the available credit is being queried.
     * @return The available credit of the queried account.
     */
    function availableCredit(address account) external view returns (uint256);

    /**
     * @notice Increases the available credit of a given account by a specified amount.
     * @param account The address of the account for which the available credit is being increased.
     * @param amount The amount by which the available credit will be increased.
     * @return allowance The updated available credit of the specified account.
     */
    function increaseAvailableCredit(address account, uint256 amount) external returns (uint256 allowance);

    /**
     * @notice Decreases the available credit of a given account by a specified amount.
     * @param account The address of the account for which the available credit is being decreased.
     * @param amount The amount by which the available credit will be decreased.
     * @return allowance The updated available credit of the specified account.
     */
    function decreaseAvailableCredit(address account, uint256 amount) external returns (uint256 allowance);
}

// contracts/lib/cross-chain-swap/lib/solidity-utils/contracts/interfaces/IWETH.sol

/**
 * @title IWETH
 * @dev Interface for wrapper as WETH-like token.
 */
interface IWETH is IERC20 {
    /**
     * @notice Emitted when Ether is deposited to get wrapper tokens.
     */
    event Deposit(address indexed dst, uint256 wad);

    /**
     * @notice Emitted when wrapper tokens is withdrawn as Ether.
     */
    event Withdrawal(address indexed src, uint256 wad);

    /**
     * @notice Deposit Ether to get wrapper tokens.
     */
    function deposit() external payable;

    /**
     * @notice Withdraw wrapped tokens as Ether.
     * @param amount Amount of wrapped tokens to withdraw.
     */
    function withdraw(uint256 amount) external;
}

// contracts/lib/cross-chain-swap/lib/openzeppelin-contracts/contracts/utils/cryptography/MerkleProof.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/cryptography/MerkleProof.sol)

/**
 * @dev These functions deal with verification of Merkle Tree proofs.
 *
 * The tree and the proofs can be generated using our
 * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
 * You will find a quickstart guide in the readme.
 *
 * WARNING: You should avoid using leaf values that are 64 bytes long prior to
 * hashing, or use a hash function other than keccak256 for hashing leaves.
 * This is because the concatenation of a sorted pair of internal nodes in
 * the Merkle tree could be reinterpreted as a leaf value.
 * OpenZeppelin's JavaScript library generates Merkle trees that are safe
 * against this attack out of the box.
 */
library MerkleProof {
    /**
     *@dev The multiproof provided is not valid.
     */
    error MerkleProofInvalidMultiproof();

    /**
     * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
     * defined by `root`. For this, a `proof` must be provided, containing
     * sibling hashes on the branch from the leaf to the root of the tree. Each
     * pair of leaves and each pair of pre-images are assumed to be sorted.
     */
    function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        return processProof(proof, leaf) == root;
    }

    /**
     * @dev Calldata version of {verify}
     */
    function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
        return processProofCalldata(proof, leaf) == root;
    }

    /**
     * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
     * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
     * hash matches the root of the tree. When processing the proof, the pairs
     * of leafs & pre-images are assumed to be sorted.
     */
    function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = Hashes.commutativeKeccak256(computedHash, proof[i]);
        }
        return computedHash;
    }

    /**
     * @dev Calldata version of {processProof}
     */
    function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            computedHash = Hashes.commutativeKeccak256(computedHash, proof[i]);
        }
        return computedHash;
    }

    /**
     * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a Merkle tree defined by
     * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
     *
     * CAUTION: Not all Merkle trees admit multiproofs. See {processMultiProof} for details.
     */
    function multiProofVerify(
        bytes32[] memory proof,
        bool[] memory proofFlags,
        bytes32 root,
        bytes32[] memory leaves
    ) internal pure returns (bool) {
        return processMultiProof(proof, proofFlags, leaves) == root;
    }

    /**
     * @dev Calldata version of {multiProofVerify}
     *
     * CAUTION: Not all Merkle trees admit multiproofs. See {processMultiProof} for details.
     */
    function multiProofVerifyCalldata(
        bytes32[] calldata proof,
        bool[] calldata proofFlags,
        bytes32 root,
        bytes32[] memory leaves
    ) internal pure returns (bool) {
        return processMultiProofCalldata(proof, proofFlags, leaves) == root;
    }

    /**
     * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
     * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
     * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
     * respectively.
     *
     * CAUTION: Not all Merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
     * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
     * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
     */
    function processMultiProof(
        bytes32[] memory proof,
        bool[] memory proofFlags,
        bytes32[] memory leaves
    ) internal pure returns (bytes32 merkleRoot) {
        // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
        // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
        // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
        // the Merkle tree.
        uint256 leavesLen = leaves.length;
        uint256 proofLen = proof.length;
        uint256 totalHashes = proofFlags.length;

        // Check proof validity.
        if (leavesLen + proofLen != totalHashes + 1) {
            revert MerkleProofInvalidMultiproof();
        }

        // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
        // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
        bytes32[] memory hashes = new bytes32[](totalHashes);
        uint256 leafPos = 0;
        uint256 hashPos = 0;
        uint256 proofPos = 0;
        // At each step, we compute the next hash using two values:
        // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
        //   get the next hash.
        // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
        //   `proof` array.
        for (uint256 i = 0; i < totalHashes; i++) {
            bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
            bytes32 b = proofFlags[i]
                ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
                : proof[proofPos++];
            hashes[i] = Hashes.commutativeKeccak256(a, b);
        }

        if (totalHashes > 0) {
            if (proofPos != proofLen) {
                revert MerkleProofInvalidMultiproof();
            }
            unchecked {
                return hashes[totalHashes - 1];
            }
        } else if (leavesLen > 0) {
            return leaves[0];
        } else {
            return proof[0];
        }
    }

    /**
     * @dev Calldata version of {processMultiProof}.
     *
     * CAUTION: Not all Merkle trees admit multiproofs. See {processMultiProof} for details.
     */
    function processMultiProofCalldata(
        bytes32[] calldata proof,
        bool[] calldata proofFlags,
        bytes32[] memory leaves
    ) internal pure returns (bytes32 merkleRoot) {
        // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
        // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
        // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
        // the Merkle tree.
        uint256 leavesLen = leaves.length;
        uint256 proofLen = proof.length;
        uint256 totalHashes = proofFlags.length;

        // Check proof validity.
        if (leavesLen + proofLen != totalHashes + 1) {
            revert MerkleProofInvalidMultiproof();
        }

        // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
        // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
        bytes32[] memory hashes = new bytes32[](totalHashes);
        uint256 leafPos = 0;
        uint256 hashPos = 0;
        uint256 proofPos = 0;
        // At each step, we compute the next hash using two values:
        // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
        //   get the next hash.
        // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
        //   `proof` array.
        for (uint256 i = 0; i < totalHashes; i++) {
            bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
            bytes32 b = proofFlags[i]
                ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
                : proof[proofPos++];
            hashes[i] = Hashes.commutativeKeccak256(a, b);
        }

        if (totalHashes > 0) {
            if (proofPos != proofLen) {
                revert MerkleProofInvalidMultiproof();
            }
            unchecked {
                return hashes[totalHashes - 1];
            }
        } else if (leavesLen > 0) {
            return leaves[0];
        } else {
            return proof[0];
        }
    }
}

// contracts/lib/cross-chain-swap/lib/openzeppelin-contracts/contracts/access/Ownable.sol

// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// contracts/lib/cross-chain-swap/contracts/interfaces/IBaseEscrow.sol

/**
 * @title Base Escrow interface for cross-chain atomic swap.
 * @notice Interface implies locking funds initially and then unlocking them with verification of the secret presented.
 * @custom:security-contact security@1inch.io
 */
interface IBaseEscrow {
    struct Immutables {
        bytes32 orderHash;
        bytes32 hashlock;  // Hash of the secret.
        Address maker;
        Address taker;
        Address token;
        uint256 amount;
        uint256 safetyDeposit;
        Timelocks timelocks;
    }

    /**
     * @notice Emitted on escrow cancellation.
     */
    event EscrowCancelled();

    /**
     * @notice Emitted when funds are rescued.
     * @param token The address of the token rescued. Zero address for native token.
     * @param amount The amount of tokens rescued.
     */
    event FundsRescued(address token, uint256 amount);

    /**
     * @notice Emitted on successful withdrawal.
     * @param secret The secret that unlocks the escrow.
     */
    event Withdrawal(bytes32 secret);

    error InvalidCaller();
    error InvalidImmutables();
    error InvalidSecret();
    error InvalidTime();
    error NativeTokenSendingFailure();

    /* solhint-disable func-name-mixedcase */
    /// @notice Returns the delay for rescuing funds from the escrow.
    function RESCUE_DELAY() external view returns (uint256);
    /// @notice Returns the address of the factory that created the escrow.
    function FACTORY() external view returns (address);
    /* solhint-enable func-name-mixedcase */

    /**
     * @notice Withdraws funds to a predetermined recipient.
     * @dev Withdrawal can only be made during the withdrawal period and with secret with hash matches the hashlock.
     * The safety deposit is sent to the caller.
     * @param secret The secret that unlocks the escrow.
     * @param immutables The immutables of the escrow contract.
     */
    function withdraw(bytes32 secret, Immutables calldata immutables) external;

    /**
     * @notice Cancels the escrow and returns tokens to a predetermined recipient.
     * @dev The escrow can only be cancelled during the cancellation period.
     * The safety deposit is sent to the caller.
     * @param immutables The immutables of the escrow contract.
     */
    function cancel(Immutables calldata immutables) external;

    /**
     * @notice Rescues funds from the escrow.
     * @dev Funds can only be rescued by the taker after the rescue delay.
     * @param token The address of the token to rescue. Zero address for native token.
     * @param amount The amount of tokens to rescue.
     * @param immutables The immutables of the escrow contract.
     */
    function rescueFunds(address token, uint256 amount, Immutables calldata immutables) external;
}

// contracts/lib/cross-chain-swap/lib/openzeppelin-contracts/contracts/utils/math/Math.sol

// OpenZeppelin Contracts (last updated v5.0.0) (utils/math/Math.sol)

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    enum Rounding {
        Floor, // Toward negative infinity
        Ceil, // Toward positive infinity
        Trunc, // Toward zero
        Expand // Away from zero
    }

    /**
     * @dev Returns the addition of two unsigned integers, with an success flag (no overflow).
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool success, uint256 result) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an success flag (no overflow).
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool success, uint256 result) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an success flag (no overflow).
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool success, uint256 result) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a success flag (no division by zero).
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool success, uint256 result) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a success flag (no division by zero).
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool success, uint256 result) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds towards infinity instead
     * of rounding towards zero.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        if (b == 0) {
            // Guarantee the same behavior as in a regular Solidity division.
            Panic.panic(Panic.DIVISION_BY_ZERO);
        }

        // The following calculation ensures accurate ceiling division without overflow.
        // Since a is non-zero, (a - 1) / b will not overflow.
        // The largest possible result occurs when (a - 1) / b is type(uint256).max,
        // but the largest value we can obtain is type(uint256).max - 1, which happens
        // when a = type(uint256).max and b = 1.
        unchecked {
            return a == 0 ? 0 : (a - 1) / b + 1;
        }
    }

    /**
     * @dev Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or
     * denominator == 0.
     *
     * Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv) with further edits by
     * Uniswap Labs also under MIT license.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
        unchecked {
            // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2²⁵⁶ and mod 2²⁵⁶ - 1, then use
            // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
            // variables such that product = prod1 * 2²⁵⁶ + prod0.
            uint256 prod0 = x * y; // Least significant 256 bits of the product
            uint256 prod1; // Most significant 256 bits of the product
            assembly {
                let mm := mulmod(x, y, not(0))
                prod1 := sub(sub(mm, prod0), lt(mm, prod0))
            }

            // Handle non-overflow cases, 256 by 256 division.
            if (prod1 == 0) {
                // Solidity will revert if denominator == 0, unlike the div opcode on its own.
                // The surrounding unchecked block does not change this fact.
                // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
                return prod0 / denominator;
            }

            // Make sure the result is less than 2²⁵⁶. Also prevents denominator == 0.
            if (denominator <= prod1) {
                Panic.panic(denominator == 0 ? Panic.DIVISION_BY_ZERO : Panic.UNDER_OVERFLOW);
            }

            ///////////////////////////////////////////////
            // 512 by 256 division.
            ///////////////////////////////////////////////

            // Make division exact by subtracting the remainder from [prod1 prod0].
            uint256 remainder;
            assembly {
                // Compute remainder using mulmod.
                remainder := mulmod(x, y, denominator)

                // Subtract 256 bit number from 512 bit number.
                prod1 := sub(prod1, gt(remainder, prod0))
                prod0 := sub(prod0, remainder)
            }

            // Factor powers of two out of denominator and compute largest power of two divisor of denominator.
            // Always >= 1. See https://cs.stackexchange.com/q/138556/92363.

            uint256 twos = denominator & (0 - denominator);
            assembly {
                // Divide denominator by twos.
                denominator := div(denominator, twos)

                // Divide [prod1 prod0] by twos.
                prod0 := div(prod0, twos)

                // Flip twos such that it is 2²⁵⁶ / twos. If twos is zero, then it becomes one.
                twos := add(div(sub(0, twos), twos), 1)
            }

            // Shift in bits from prod1 into prod0.
            prod0 |= prod1 * twos;

            // Invert denominator mod 2²⁵⁶. Now that denominator is an odd number, it has an inverse modulo 2²⁵⁶ such
            // that denominator * inv ≡ 1 mod 2²⁵⁶. Compute the inverse by starting with a seed that is correct for
            // four bits. That is, denominator * inv ≡ 1 mod 2⁴.
            uint256 inverse = (3 * denominator) ^ 2;

            // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also
            // works in modular arithmetic, doubling the correct bits in each step.
            inverse *= 2 - denominator * inverse; // inverse mod 2⁸
            inverse *= 2 - denominator * inverse; // inverse mod 2¹⁶
            inverse *= 2 - denominator * inverse; // inverse mod 2³²
            inverse *= 2 - denominator * inverse; // inverse mod 2⁶⁴
            inverse *= 2 - denominator * inverse; // inverse mod 2¹²⁸
            inverse *= 2 - denominator * inverse; // inverse mod 2²⁵⁶

            // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
            // This will give us the correct result modulo 2²⁵⁶. Since the preconditions guarantee that the outcome is
            // less than 2²⁵⁶, this is the final result. We don't need to compute the high bits of the result and prod1
            // is no longer required.
            result = prod0 * inverse;
            return result;
        }
    }

    /**
     * @dev Calculates x * y / denominator with full precision, following the selected rounding direction.
     */
    function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
        return mulDiv(x, y, denominator) + SafeCast.toUint(unsignedRoundsUp(rounding) && mulmod(x, y, denominator) > 0);
    }

    /**
     * @dev Calculate the modular multiplicative inverse of a number in Z/nZ.
     *
     * If n is a prime, then Z/nZ is a field. In that case all elements are inversible, expect 0.
     * If n is not a prime, then Z/nZ is not a field, and some elements might not be inversible.
     *
     * If the input value is not inversible, 0 is returned.
     *
     * NOTE: If you know for sure that n is (big) a prime, it may be cheaper to use Ferma's little theorem and get the
     * inverse using `Math.modExp(a, n - 2, n)`.
     */
    function invMod(uint256 a, uint256 n) internal pure returns (uint256) {
        unchecked {
            if (n == 0) return 0;

            // The inverse modulo is calculated using the Extended Euclidean Algorithm (iterative version)
            // Used to compute integers x and y such that: ax + ny = gcd(a, n).
            // When the gcd is 1, then the inverse of a modulo n exists and it's x.
            // ax + ny = 1
            // ax = 1 + (-y)n
            // ax ≡ 1 (mod n) # x is the inverse of a modulo n

            // If the remainder is 0 the gcd is n right away.
            uint256 remainder = a % n;
            uint256 gcd = n;

            // Therefore the initial coefficients are:
            // ax + ny = gcd(a, n) = n
            // 0a + 1n = n
            int256 x = 0;
            int256 y = 1;

            while (remainder != 0) {
                uint256 quotient = gcd / remainder;

                (gcd, remainder) = (
                    // The old remainder is the next gcd to try.
                    remainder,
                    // Compute the next remainder.
                    // Can't overflow given that (a % gcd) * (gcd // (a % gcd)) <= gcd
                    // where gcd is at most n (capped to type(uint256).max)
                    gcd - remainder * quotient
                );

                (x, y) = (
                    // Increment the coefficient of a.
                    y,
                    // Decrement the coefficient of n.
                    // Can overflow, but the result is casted to uint256 so that the
                    // next value of y is "wrapped around" to a value between 0 and n - 1.
                    x - y * int256(quotient)
                );
            }

            if (gcd != 1) return 0; // No inverse exists.
            return x < 0 ? (n - uint256(-x)) : uint256(x); // Wrap the result if it's negative.
        }
    }

    /**
     * @dev Returns the modular exponentiation of the specified base, exponent and modulus (b ** e % m)
     *
     * Requirements:
     * - modulus can't be zero
     * - underlying staticcall to precompile must succeed
     *
     * IMPORTANT: The result is only valid if the underlying call succeeds. When using this function, make
     * sure the chain you're using it on supports the precompiled contract for modular exponentiation
     * at address 0x05 as specified in https://eips.ethereum.org/EIPS/eip-198[EIP-198]. Otherwise,
     * the underlying function will succeed given the lack of a revert, but the result may be incorrectly
     * interpreted as 0.
     */
    function modExp(uint256 b, uint256 e, uint256 m) internal view returns (uint256) {
        (bool success, uint256 result) = tryModExp(b, e, m);
        if (!success) {
            Panic.panic(Panic.DIVISION_BY_ZERO);
        }
        return result;
    }

    /**
     * @dev Returns the modular exponentiation of the specified base, exponent and modulus (b ** e % m).
     * It includes a success flag indicating if the operation succeeded. Operation will be marked has failed if trying
     * to operate modulo 0 or if the underlying precompile reverted.
     *
     * IMPORTANT: The result is only valid if the success flag is true. When using this function, make sure the chain
     * you're using it on supports the precompiled contract for modular exponentiation at address 0x05 as specified in
     * https://eips.ethereum.org/EIPS/eip-198[EIP-198]. Otherwise, the underlying function will succeed given the lack
     * of a revert, but the result may be incorrectly interpreted as 0.
     */
    function tryModExp(uint256 b, uint256 e, uint256 m) internal view returns (bool success, uint256 result) {
        if (m == 0) return (false, 0);
        /// @solidity memory-safe-assembly
        assembly {
            let ptr := mload(0x40)
            // | Offset    | Content    | Content (Hex)                                                      |
            // |-----------|------------|--------------------------------------------------------------------|
            // | 0x00:0x1f | size of b  | 0x0000000000000000000000000000000000000000000000000000000000000020 |
            // | 0x20:0x3f | size of e  | 0x0000000000000000000000000000000000000000000000000000000000000020 |
            // | 0x40:0x5f | size of m  | 0x0000000000000000000000000000000000000000000000000000000000000020 |
            // | 0x60:0x7f | value of b | 0x<.............................................................b> |
            // | 0x80:0x9f | value of e | 0x<.............................................................e> |
            // | 0xa0:0xbf | value of m | 0x<.............................................................m> |
            mstore(ptr, 0x20)
            mstore(add(ptr, 0x20), 0x20)
            mstore(add(ptr, 0x40), 0x20)
            mstore(add(ptr, 0x60), b)
            mstore(add(ptr, 0x80), e)
            mstore(add(ptr, 0xa0), m)

            // Given the result < m, it's guaranteed to fit in 32 bytes,
            // so we can use the memory scratch space located at offset 0.
            success := staticcall(gas(), 0x05, ptr, 0xc0, 0x00, 0x20)
            result := mload(0x00)
        }
    }

    /**
     * @dev Variant of {modExp} that supports inputs of arbitrary length.
     */
    function modExp(bytes memory b, bytes memory e, bytes memory m) internal view returns (bytes memory) {
        (bool success, bytes memory result) = tryModExp(b, e, m);
        if (!success) {
            Panic.panic(Panic.DIVISION_BY_ZERO);
        }
        return result;
    }

    /**
     * @dev Variant of {tryModExp} that supports inputs of arbitrary length.
     */
    function tryModExp(
        bytes memory b,
        bytes memory e,
        bytes memory m
    ) internal view returns (bool success, bytes memory result) {
        if (_zeroBytes(m)) return (false, new bytes(0));

        uint256 mLen = m.length;

        // Encode call args in result and move the free memory pointer
        result = abi.encodePacked(b.length, e.length, mLen, b, e, m);

        /// @solidity memory-safe-assembly
        assembly {
            let dataPtr := add(result, 0x20)
            // Write result on top of args to avoid allocating extra memory.
            success := staticcall(gas(), 0x05, dataPtr, mload(result), dataPtr, mLen)
            // Overwrite the length.
            // result.length > returndatasize() is guaranteed because returndatasize() == m.length
            mstore(result, mLen)
            // Set the memory pointer after the returned data.
            mstore(0x40, add(dataPtr, mLen))
        }
    }

    /**
     * @dev Returns whether the provided byte array is zero.
     */
    function _zeroBytes(bytes memory byteArray) private pure returns (bool) {
        for (uint256 i = 0; i < byteArray.length; ++i) {
            if (byteArray[i] != 0) {
                return false;
            }
        }
        return true;
    }

    /**
     * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded
     * towards zero.
     *
     * This method is based on Newton's method for computing square roots; the algorithm is restricted to only
     * using integer operations.
     */
    function sqrt(uint256 a) internal pure returns (uint256) {
        unchecked {
            // Take care of easy edge cases when a == 0 or a == 1
            if (a <= 1) {
                return a;
            }

            // In this function, we use Newton's method to get a root of `f(x) := x² - a`. It involves building a
            // sequence x_n that converges toward sqrt(a). For each iteration x_n, we also define the error between
            // the current value as `ε_n = | x_n - sqrt(a) |`.
            //
            // For our first estimation, we consider `e` the smallest power of 2 which is bigger than the square root
            // of the target. (i.e. `2**(e-1) ≤ sqrt(a) < 2**e`). We know that `e ≤ 128` because `(2¹²⁸)² = 2²⁵⁶` is
            // bigger than any uint256.
            //
            // By noticing that
            // `2**(e-1) ≤ sqrt(a) < 2**e → (2**(e-1))² ≤ a < (2**e)² → 2**(2*e-2) ≤ a < 2**(2*e)`
            // we can deduce that `e - 1` is `log2(a) / 2`. We can thus compute `x_n = 2**(e-1)` using a method similar
            // to the msb function.
            uint256 aa = a;
            uint256 xn = 1;

            if (aa >= (1 << 128)) {
                aa >>= 128;
                xn <<= 64;
            }
            if (aa >= (1 << 64)) {
                aa >>= 64;
                xn <<= 32;
            }
            if (aa >= (1 << 32)) {
                aa >>= 32;
                xn <<= 16;
            }
            if (aa >= (1 << 16)) {
                aa >>= 16;
                xn <<= 8;
            }
            if (aa >= (1 << 8)) {
                aa >>= 8;
                xn <<= 4;
            }
            if (aa >= (1 << 4)) {
                aa >>= 4;
                xn <<= 2;
            }
            if (aa >= (1 << 2)) {
                xn <<= 1;
            }

            // We now have x_n such that `x_n = 2**(e-1) ≤ sqrt(a) < 2**e = 2 * x_n`. This implies ε_n ≤ 2**(e-1).
            //
            // We can refine our estimation by noticing that the middle of that interval minimizes the error.
            // If we move x_n to equal 2**(e-1) + 2**(e-2), then we reduce the error to ε_n ≤ 2**(e-2).
            // This is going to be our x_0 (and ε_0)
            xn = (3 * xn) >> 1; // ε_0 := | x_0 - sqrt(a) | ≤ 2**(e-2)

            // From here, Newton's method give us:
            // x_{n+1} = (x_n + a / x_n) / 2
            //
            // One should note that:
            // x_{n+1}² - a = ((x_n + a / x_n) / 2)² - a
            //              = ((x_n² + a) / (2 * x_n))² - a
            //              = (x_n⁴ + 2 * a * x_n² + a²) / (4 * x_n²) - a
            //              = (x_n⁴ + 2 * a * x_n² + a² - 4 * a * x_n²) / (4 * x_n²)
            //              = (x_n⁴ - 2 * a * x_n² + a²) / (4 * x_n²)
            //              = (x_n² - a)² / (2 * x_n)²
            //              = ((x_n² - a) / (2 * x_n))²
            //              ≥ 0
            // Which proves that for all n ≥ 1, sqrt(a) ≤ x_n
            //
            // This gives us the proof of quadratic convergence of the sequence:
            // ε_{n+1} = | x_{n+1} - sqrt(a) |
            //         = | (x_n + a / x_n) / 2 - sqrt(a) |
            //         = | (x_n² + a - 2*x_n*sqrt(a)) / (2 * x_n) |
            //         = | (x_n - sqrt(a))² / (2 * x_n) |
            //         = | ε_n² / (2 * x_n) |
            //         = ε_n² / | (2 * x_n) |
            //
            // For the first iteration, we have a special case where x_0 is known:
            // ε_1 = ε_0² / | (2 * x_0) |
            //     ≤ (2**(e-2))² / (2 * (2**(e-1) + 2**(e-2)))
            //     ≤ 2**(2*e-4) / (3 * 2**(e-1))
            //     ≤ 2**(e-3) / 3
            //     ≤ 2**(e-3-log2(3))
            //     ≤ 2**(e-4.5)
            //
            // For the following iterations, we use the fact that, 2**(e-1) ≤ sqrt(a) ≤ x_n:
            // ε_{n+1} = ε_n² / | (2 * x_n) |
            //         ≤ (2**(e-k))² / (2 * 2**(e-1))
            //         ≤ 2**(2*e-2*k) / 2**e
            //         ≤ 2**(e-2*k)
            xn = (xn + a / xn) >> 1; // ε_1 := | x_1 - sqrt(a) | ≤ 2**(e-4.5)  -- special case, see above
            xn = (xn + a / xn) >> 1; // ε_2 := | x_2 - sqrt(a) | ≤ 2**(e-9)    -- general case with k = 4.5
            xn = (xn + a / xn) >> 1; // ε_3 := | x_3 - sqrt(a) | ≤ 2**(e-18)   -- general case with k = 9
            xn = (xn + a / xn) >> 1; // ε_4 := | x_4 - sqrt(a) | ≤ 2**(e-36)   -- general case with k = 18
            xn = (xn + a / xn) >> 1; // ε_5 := | x_5 - sqrt(a) | ≤ 2**(e-72)   -- general case with k = 36
            xn = (xn + a / xn) >> 1; // ε_6 := | x_6 - sqrt(a) | ≤ 2**(e-144)  -- general case with k = 72

            // Because e ≤ 128 (as discussed during the first estimation phase), we know have reached a precision
            // ε_6 ≤ 2**(e-144) < 1. Given we're operating on integers, then we can ensure that xn is now either
            // sqrt(a) or sqrt(a) + 1.
            return xn - SafeCast.toUint(xn > a / xn);
        }
    }

    /**
     * @dev Calculates sqrt(a), following the selected rounding direction.
     */
    function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = sqrt(a);
            return result + SafeCast.toUint(unsignedRoundsUp(rounding) && result * result < a);
        }
    }

    /**
     * @dev Return the log in base 2 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
    function log2(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        uint256 exp;
        unchecked {
            exp = 128 * SafeCast.toUint(value > (1 << 128) - 1);
            value >>= exp;
            result += exp;

            exp = 64 * SafeCast.toUint(value > (1 << 64) - 1);
            value >>= exp;
            result += exp;

            exp = 32 * SafeCast.toUint(value > (1 << 32) - 1);
            value >>= exp;
            result += exp;

            exp = 16 * SafeCast.toUint(value > (1 << 16) - 1);
            value >>= exp;
            result += exp;

            exp = 8 * SafeCast.toUint(value > (1 << 8) - 1);
            value >>= exp;
            result += exp;

            exp = 4 * SafeCast.toUint(value > (1 << 4) - 1);
            value >>= exp;
            result += exp;

            exp = 2 * SafeCast.toUint(value > (1 << 2) - 1);
            value >>= exp;
            result += exp;

            result += SafeCast.toUint(value > 1);
        }
        return result;
    }

    /**
     * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log2(value);
            return result + SafeCast.toUint(unsignedRoundsUp(rounding) && 1 << result < value);
        }
    }

    /**
     * @dev Return the log in base 10 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     */
    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
    }

    /**
     * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log10(value);
            return result + SafeCast.toUint(unsignedRoundsUp(rounding) && 10 ** result < value);
        }
    }

    /**
     * @dev Return the log in base 256 of a positive value rounded towards zero.
     * Returns 0 if given 0.
     *
     * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
     */
    function log256(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        uint256 isGt;
        unchecked {
            isGt = SafeCast.toUint(value > (1 << 128) - 1);
            value >>= isGt * 128;
            result += isGt * 16;

            isGt = SafeCast.toUint(value > (1 << 64) - 1);
            value >>= isGt * 64;
            result += isGt * 8;

            isGt = SafeCast.toUint(value > (1 << 32) - 1);
            value >>= isGt * 32;
            result += isGt * 4;

            isGt = SafeCast.toUint(value > (1 << 16) - 1);
            value >>= isGt * 16;
            result += isGt * 2;

            result += SafeCast.toUint(value > (1 << 8) - 1);
        }
        return result;
    }

    /**
     * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
     * Returns 0 if given 0.
     */
    function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
        unchecked {
            uint256 result = log256(value);
            return result + SafeCast.toUint(unsignedRoundsUp(rounding) && 1 << (result << 3) < value);
        }
    }

    /**
     * @dev Returns whether a provided rounding mode is considered rounding up for unsigned integers.
     */
    function unsignedRoundsUp(Rounding rounding) internal pure returns (bool) {
        return uint8(rounding) % 2 == 1;
    }
}

// contracts/lib/cross-chain-swap/contracts/interfaces/IEscrow.sol

/**
 * @title Escrow interface for cross-chain atomic swap.
 * @notice Interface implies locking funds initially and then unlocking them with verification of the secret presented.
 * @custom:security-contact security@1inch.io
 */
interface IEscrow is IBaseEscrow {
    /// @notice Returns the bytecode hash of the proxy contract.
    function PROXY_BYTECODE_HASH() external view returns (bytes32); // solhint-disable-line func-name-mixedcase
}

// contracts/lib/cross-chain-swap/contracts/interfaces/IEscrowFactory.sol

/**
 * @title Escrow Factory interface for cross-chain atomic swap.
 * @notice Interface to deploy escrow contracts for the destination chain and to get the deterministic address of escrow on both chains.
 * @custom:security-contact security@1inch.io
 */
interface IEscrowFactory {
    struct ExtraDataArgs {
        bytes32 hashlockInfo; // Hash of the secret or the Merkle tree root if multiple fills are allowed
        uint256 dstChainId;
        Address dstToken;
        uint256 deposits;
        Timelocks timelocks;
    }

    struct DstImmutablesComplement {
        Address maker;
        uint256 amount;
        Address token;
        uint256 safetyDeposit;
        uint256 chainId;
    }

    error InsufficientEscrowBalance();
    error InvalidCreationTime();
    error InvalidPartialFill();
    error InvalidSecretsAmount();

    /**
     * @notice Emitted on EscrowSrc deployment to recreate EscrowSrc and EscrowDst immutables off-chain.
     * @param srcImmutables The immutables of the escrow contract that are used in deployment on the source chain.
     * @param dstImmutablesComplement Additional immutables related to the escrow contract on the destination chain.
     */
    event SrcEscrowCreated(IBaseEscrow.Immutables srcImmutables, DstImmutablesComplement dstImmutablesComplement);
    /**
     * @notice Emitted on EscrowDst deployment.
     * @param escrow The address of the created escrow.
     * @param hashlock The hash of the secret.
     * @param taker The address of the taker.
     */
    event DstEscrowCreated(address escrow, bytes32 hashlock, Address taker);

    /* solhint-disable func-name-mixedcase */
    /// @notice Returns the address of implementation on the source chain.
    function ESCROW_SRC_IMPLEMENTATION() external view returns (address);
    /// @notice Returns the address of implementation on the destination chain.
    function ESCROW_DST_IMPLEMENTATION() external view returns (address);
    /* solhint-enable func-name-mixedcase */

    /**
     * @notice Creates a new escrow contract for taker on the destination chain.
     * @dev The caller must send the safety deposit in the native token along with the function call
     * and approve the destination token to be transferred to the created escrow.
     * @param dstImmutables The immutables of the escrow contract that are used in deployment.
     * @param srcCancellationTimestamp The start of the cancellation period for the source chain.
     */
    function createDstEscrow(IBaseEscrow.Immutables calldata dstImmutables, uint256 srcCancellationTimestamp) external payable;

    /**
     * @notice Returns the deterministic address of the source escrow based on the salt.
     * @param immutables The immutable arguments used to compute salt for escrow deployment.
     * @return The computed address of the escrow.
     */
    function addressOfEscrowSrc(IBaseEscrow.Immutables calldata immutables) external view returns (address);

    /**
     * @notice Returns the deterministic address of the destination escrow based on the salt.
     * @param immutables The immutable arguments used to compute salt for escrow deployment.
     * @return The computed address of the escrow.
     */
    function addressOfEscrowDst(IBaseEscrow.Immutables calldata immutables) external view returns (address);
}

// contracts/lib/cross-chain-swap/lib/limit-order-protocol/contracts/interfaces/IOrderMixin.sol

interface IOrderMixin {
    struct Order {
        uint256 salt;
        Address maker;
        Address receiver;
        Address makerAsset;
        Address takerAsset;
        uint256 makingAmount;
        uint256 takingAmount;
        MakerTraits makerTraits;
    }

    error InvalidatedOrder();
    error TakingAmountExceeded();
    error PrivateOrder();
    error BadSignature();
    error OrderExpired();
    error WrongSeriesNonce();
    error SwapWithZeroAmount();
    error PartialFillNotAllowed();
    error OrderIsNotSuitableForMassInvalidation();
    error EpochManagerAndBitInvalidatorsAreIncompatible();
    error ReentrancyDetected();
    error PredicateIsNotTrue();
    error TakingAmountTooHigh();
    error MakingAmountTooLow();
    error TransferFromMakerToTakerFailed();
    error TransferFromTakerToMakerFailed();
    error MismatchArraysLengths();
    error InvalidPermit2Transfer();
    error SimulationResults(bool success, bytes res);

    /**
     * @notice Emitted when order gets filled
     * @param orderHash Hash of the order
     * @param remainingAmount Amount of the maker asset that remains to be filled
     */
    event OrderFilled(
        bytes32 orderHash,
        uint256 remainingAmount
    );

    /**
     * @notice Emitted when order without `useBitInvalidator` gets cancelled
     * @param orderHash Hash of the order
     */
    event OrderCancelled(
        bytes32 orderHash
    );

    /**
     * @notice Emitted when order with `useBitInvalidator` gets cancelled
     * @param maker Maker address
     * @param slotIndex Slot index that was updated
     * @param slotValue New slot value
     */
    event BitInvalidatorUpdated(
        address indexed maker,
        uint256 slotIndex,
        uint256 slotValue
    );

    /**
     * @notice Returns bitmask for double-spend invalidators based on lowest byte of order.info and filled quotes
     * @param maker Maker address
     * @param slot Slot number to return bitmask for
     * @return result Each bit represents whether corresponding was already invalidated
     */
    function bitInvalidatorForOrder(address maker, uint256 slot) external view returns(uint256 result);

    /**
     * @notice Returns bitmask for double-spend invalidators based on lowest byte of order.info and filled quotes
     * @param orderHash Hash of the order
     * @return remaining Remaining amount of the order
     */
    function remainingInvalidatorForOrder(address maker, bytes32 orderHash) external view returns(uint256 remaining);

    /**
     * @notice Returns bitmask for double-spend invalidators based on lowest byte of order.info and filled quotes
     * @param orderHash Hash of the order
     * @return remainingRaw Inverse of the remaining amount of the order if order was filled at least once, otherwise 0
     */
    function rawRemainingInvalidatorForOrder(address maker, bytes32 orderHash) external view returns(uint256 remainingRaw);

    /**
     * @notice Cancels order's quote
     * @param makerTraits Order makerTraits
     * @param orderHash Hash of the order to cancel
     */
    function cancelOrder(MakerTraits makerTraits, bytes32 orderHash) external;

    /**
     * @notice Cancels orders' quotes
     * @param makerTraits Orders makerTraits
     * @param orderHashes Hashes of the orders to cancel
     */
    function cancelOrders(MakerTraits[] calldata makerTraits, bytes32[] calldata orderHashes) external;

    /**
     * @notice Cancels all quotes of the maker (works for bit-invalidating orders only)
     * @param makerTraits Order makerTraits
     * @param additionalMask Additional bitmask to invalidate orders
     */
    function bitsInvalidateForOrder(MakerTraits makerTraits, uint256 additionalMask) external;

    /**
     * @notice Returns order hash, hashed with limit order protocol contract EIP712
     * @param order Order
     * @return orderHash Hash of the order
     */
    function hashOrder(IOrderMixin.Order calldata order) external view returns(bytes32 orderHash);

    /**
     * @notice Delegates execution to custom implementation. Could be used to validate if `transferFrom` works properly
     * @dev The function always reverts and returns the simulation results in revert data.
     * @param target Addresses that will be delegated
     * @param data Data that will be passed to delegatee
     */
    function simulate(address target, bytes calldata data) external;

    /**
     * @notice Fills order's quote, fully or partially (whichever is possible).
     * @param order Order quote to fill
     * @param r R component of signature
     * @param vs VS component of signature
     * @param amount Taker amount to fill
     * @param takerTraits Specifies threshold as maximum allowed takingAmount when takingAmount is zero, otherwise specifies
     * minimum allowed makingAmount. The 2nd (0 based index) highest bit specifies whether taker wants to skip maker's permit.
     * @return makingAmount Actual amount transferred from maker to taker
     * @return takingAmount Actual amount transferred from taker to maker
     * @return orderHash Hash of the filled order
     */
    function fillOrder(
        Order calldata order,
        bytes32 r,
        bytes32 vs,
        uint256 amount,
        TakerTraits takerTraits
    ) external payable returns(uint256 makingAmount, uint256 takingAmount, bytes32 orderHash);

    /**
     * @notice Same as `fillOrder` but allows to specify arguments that are used by the taker.
     * @param order Order quote to fill
     * @param r R component of signature
     * @param vs VS component of signature
     * @param amount Taker amount to fill
     * @param takerTraits Specifies threshold as maximum allowed takingAmount when takingAmount is zero, otherwise specifies
     * minimum allowed makingAmount. The 2nd (0 based index) highest bit specifies whether taker wants to skip maker's permit.
     * @param args Arguments that are used by the taker (target, extension, interaction, permit)
     * @return makingAmount Actual amount transferred from maker to taker
     * @return takingAmount Actual amount transferred from taker to maker
     * @return orderHash Hash of the filled order
     */
    function fillOrderArgs(
        IOrderMixin.Order calldata order,
        bytes32 r,
        bytes32 vs,
        uint256 amount,
        TakerTraits takerTraits,
        bytes calldata args
    ) external payable returns(uint256 makingAmount, uint256 takingAmount, bytes32 orderHash);

    /**
     * @notice Same as `fillOrder` but uses contract-based signatures.
     * @param order Order quote to fill
     * @param signature Signature to confirm quote ownership
     * @param amount Taker amount to fill
     * @param takerTraits Specifies threshold as maximum allowed takingAmount when takingAmount is zero, otherwise specifies
     * minimum allowed makingAmount. The 2nd (0 based index) highest bit specifies whether taker wants to skip maker's permit.
     * @return makingAmount Actual amount transferred from maker to taker
     * @return takingAmount Actual amount transferred from taker to maker
     * @return orderHash Hash of the filled order
     * @dev See tests for examples
     */
    function fillContractOrder(
        Order calldata order,
        bytes calldata signature,
        uint256 amount,
        TakerTraits takerTraits
    ) external returns(uint256 makingAmount, uint256 takingAmount, bytes32 orderHash);

    /**
     * @notice Same as `fillContractOrder` but allows to specify arguments that are used by the taker.
     * @param order Order quote to fill
     * @param signature Signature to confirm quote ownership
     * @param amount Taker amount to fill
     * @param takerTraits Specifies threshold as maximum allowed takingAmount when takingAmount is zero, otherwise specifies
     * minimum allowed makingAmount. The 2nd (0 based index) highest bit specifies whether taker wants to skip maker's permit.
     * @param args Arguments that are used by the taker (target, extension, interaction, permit)
     * @return makingAmount Actual amount transferred from maker to taker
     * @return takingAmount Actual amount transferred from taker to maker
     * @return orderHash Hash of the filled order
     * @dev See tests for examples
     */
    function fillContractOrderArgs(
        Order calldata order,
        bytes calldata signature,
        uint256 amount,
        TakerTraits takerTraits,
        bytes calldata args
    ) external returns(uint256 makingAmount, uint256 takingAmount, bytes32 orderHash);
}

// contracts/lib/cross-chain-swap/contracts/libraries/ImmutablesLib.sol

/**
 * @title Library for escrow immutables.
 * @custom:security-contact security@1inch.io
 */
library ImmutablesLib {
    uint256 internal constant ESCROW_IMMUTABLES_SIZE = 0x100;

    /**
     * @notice Returns the hash of the immutables.
     * @param immutables The immutables to hash.
     * @return ret The computed hash.
     */
    function hash(IBaseEscrow.Immutables calldata immutables) internal pure returns(bytes32 ret) {
        assembly ("memory-safe") {
            let ptr := mload(0x40)
            calldatacopy(ptr, immutables, ESCROW_IMMUTABLES_SIZE)
            ret := keccak256(ptr, ESCROW_IMMUTABLES_SIZE)
        }
    }

    /**
     * @notice Returns the hash of the immutables.
     * @param immutables The immutables to hash.
     * @return ret The computed hash.
     */
    function hashMem(IBaseEscrow.Immutables memory immutables) internal pure returns(bytes32 ret) {
        assembly ("memory-safe") {
            ret := keccak256(immutables, ESCROW_IMMUTABLES_SIZE)
        }
    }
}

// contracts/lib/cross-chain-swap/lib/limit-order-protocol/contracts/interfaces/IAmountGetter.sol

interface IAmountGetter {
    /**
     * @notice View method that gets called to determine the actual making amount
     * @param order Order being processed
     * @param extension Order extension data
     * @param orderHash Hash of the order being processed
     * @param taker Taker address
     * @param takingAmount Actual taking amount
     * @param remainingMakingAmount Order remaining making amount
     * @param extraData Extra data
     */
    function getMakingAmount(
        IOrderMixin.Order calldata order,
        bytes calldata extension,
        bytes32 orderHash,
        address taker,
        uint256 takingAmount,
        uint256 remainingMakingAmount,
        bytes calldata extraData
    ) external view returns (uint256);

    /**
     * @notice View method that gets called to determine the actual making amount
     * @param order Order being processed
     * @param extension Order extension data
     * @param orderHash Hash of the order being processed
     * @param taker Taker address
     * @param makingAmount Actual taking amount
     * @param remainingMakingAmount Order remaining making amount
     * @param extraData Extra data
     */
    function getTakingAmount(
        IOrderMixin.Order calldata order,
        bytes calldata extension,
        bytes32 orderHash,
        address taker,
        uint256 makingAmount,
        uint256 remainingMakingAmount,
        bytes calldata extraData
    ) external view returns (uint256);
}

// contracts/lib/cross-chain-swap/contracts/interfaces/IEscrowDst.sol

/**
 * @title Destination Escrow interface for cross-chain atomic swap.
 * @notice Interface implies withdrawing funds initially and then unlocking them with verification of the secret presented.
 * @custom:security-contact security@1inch.io
 */
interface IEscrowDst is IEscrow {
    /**
     * @notice Withdraws funds to maker
     * @dev Withdrawal can only be made during the withdrawal period and with secret with hash matches the hashlock.
     * @param secret The secret that unlocks the escrow.
     * @param immutables The immutables of the escrow contract.
     */
    function publicWithdraw(bytes32 secret, IBaseEscrow.Immutables calldata immutables) external;
}

// contracts/lib/cross-chain-swap/contracts/interfaces/IEscrowSrc.sol

/**
 * @title Source Escrow interface for cross-chain atomic swap.
 * @notice Interface implies locking funds initially and then unlocking them with verification of the secret presented.
 * @custom:security-contact security@1inch.io
 */
interface IEscrowSrc is IEscrow {
    /**
     * @notice Withdraws funds to a specified target.
     * @dev Withdrawal can only be made during the withdrawal period and with secret with hash matches the hashlock.
     * The safety deposit is sent to the caller.
     * @param secret The secret that unlocks the escrow.
     * @param target The address to withdraw the funds to.
     * @param immutables The immutables of the escrow contract.
     */
    function withdrawTo(bytes32 secret, address target, IBaseEscrow.Immutables calldata immutables) external;

    /**
     * @notice Withdraws funds to the taker.
     * @dev Withdrawal can only be made during the public withdrawal period and with secret with hash matches the hashlock.
     * @param secret The secret that unlocks the escrow.
     * @param immutables The immutables of the escrow contract.
     */
    function publicWithdraw(bytes32 secret, Immutables calldata immutables) external;

    /**
     * @notice Cancels the escrow and returns tokens to the maker.
     * @dev The escrow can only be cancelled during the public cancellation period.
     * The safety deposit is sent to the caller.
     * @param immutables The immutables of the escrow contract.
     */
    function publicCancel(IBaseEscrow.Immutables calldata immutables) external;
}

// contracts/lib/cross-chain-swap/lib/limit-order-protocol/contracts/interfaces/IPostInteraction.sol

interface IPostInteraction {
    /**
     * @notice Callback method that gets called after all fund transfers
     * @param order Order being processed
     * @param extension Order extension data
     * @param orderHash Hash of the order being processed
     * @param taker Taker address
     * @param makingAmount Actual making amount
     * @param takingAmount Actual taking amount
     * @param remainingMakingAmount Order remaining making amount
     * @param extraData Extra data
     */
    function postInteraction(
        IOrderMixin.Order calldata order,
        bytes calldata extension,
        bytes32 orderHash,
        address taker,
        uint256 makingAmount,
        uint256 takingAmount,
        uint256 remainingMakingAmount,
        bytes calldata extraData
    ) external;
}

// contracts/lib/cross-chain-swap/lib/limit-order-protocol/contracts/interfaces/IPreInteraction.sol

interface IPreInteraction {
    /**
     * @notice Callback method that gets called before any funds transfers
     * @param order Order being processed
     * @param extension Order extension data
     * @param orderHash Hash of the order being processed
     * @param taker Taker address
     * @param makingAmount Actual making amount
     * @param takingAmount Actual taking amount
     * @param remainingMakingAmount Order remaining making amount
     * @param extraData Extra data
     */
    function preInteraction(
        IOrderMixin.Order calldata order,
        bytes calldata extension,
        bytes32 orderHash,
        address taker,
        uint256 makingAmount,
        uint256 takingAmount,
        uint256 remainingMakingAmount,
        bytes calldata extraData
    ) external;
}

// contracts/lib/cross-chain-swap/lib/limit-order-protocol/contracts/interfaces/ITakerInteraction.sol

/**
 * @title Interface for interactor which acts after `maker -> taker` transfer but before `taker -> maker` transfer.
 * @notice The order filling steps are `preInteraction` =>` Transfer "maker -> taker"` => **`Interaction`** => `Transfer "taker -> maker"` => `postInteraction`
 */
interface ITakerInteraction {
    /**
     * @dev This callback allows to interactively handle maker aseets to produce takers assets, doesn't supports ETH as taker assets
     * @notice Callback method that gets called after maker fund transfer but before taker fund transfer
     * @param order Order being processed
     * @param extension Order extension data
     * @param orderHash Hash of the order being processed
     * @param taker Taker address
     * @param makingAmount Actual making amount
     * @param takingAmount Actual taking amount
     * @param remainingMakingAmount Order remaining making amount
     * @param extraData Extra data
     */
    function takerInteraction(
        IOrderMixin.Order calldata order,
        bytes calldata extension,
        bytes32 orderHash,
        address taker,
        uint256 makingAmount,
        uint256 takingAmount,
        uint256 remainingMakingAmount,
        bytes calldata extraData
    ) external;
}

// contracts/lib/cross-chain-swap/lib/limit-order-protocol/contracts/libraries/ExtensionLib.sol

/**
 * @title ExtensionLib
 * @notice Library for retrieving extensions information for the IOrderMixin Interface.
 */
library ExtensionLib_1 {
    using AddressLib for Address;
    using OffsetsLib for Offsets;

    enum DynamicField {
        MakerAssetSuffix,
        TakerAssetSuffix,
        MakingAmountData,
        TakingAmountData,
        Predicate,
        MakerPermit,
        PreInteractionData,
        PostInteractionData,
        CustomData
    }

    /**
     * @notice Returns the MakerAssetSuffix from the provided extension calldata.
     * @param extension The calldata from which the MakerAssetSuffix is to be retrieved.
     * @return calldata Bytes representing the MakerAssetSuffix.
     */
    function makerAssetSuffix(bytes calldata extension) internal pure returns(bytes calldata) {
        return _get(extension, DynamicField.MakerAssetSuffix);
    }

    /**
     * @notice Returns the TakerAssetSuffix from the provided extension calldata.
     * @param extension The calldata from which the TakerAssetSuffix is to be retrieved.
     * @return calldata Bytes representing the TakerAssetSuffix.
     */
    function takerAssetSuffix(bytes calldata extension) internal pure returns(bytes calldata) {
        return _get(extension, DynamicField.TakerAssetSuffix);
    }

    /**
     * @notice Returns the MakingAmountData from the provided extension calldata.
     * @param extension The calldata from which the MakingAmountData is to be retrieved.
     * @return calldata Bytes representing the MakingAmountData.
     */
    function makingAmountData(bytes calldata extension) internal pure returns(bytes calldata) {
        return _get(extension, DynamicField.MakingAmountData);
    }

    /**
     * @notice Returns the TakingAmountData from the provided extension calldata.
     * @param extension The calldata from which the TakingAmountData is to be retrieved.
     * @return calldata Bytes representing the TakingAmountData.
     */
    function takingAmountData(bytes calldata extension) internal pure returns(bytes calldata) {
        return _get(extension, DynamicField.TakingAmountData);
    }

    /**
     * @notice Returns the order's predicate from the provided extension calldata.
     * @param extension The calldata from which the predicate is to be retrieved.
     * @return calldata Bytes representing the predicate.
     */
    function predicate(bytes calldata extension) internal pure returns(bytes calldata) {
        return _get(extension, DynamicField.Predicate);
    }

    /**
     * @notice Returns the maker's permit from the provided extension calldata.
     * @param extension The calldata from which the maker's permit is to be retrieved.
     * @return calldata Bytes representing the maker's permit.
     */
    function makerPermit(bytes calldata extension) internal pure returns(bytes calldata) {
        return _get(extension, DynamicField.MakerPermit);
    }

    /**
     * @notice Returns the pre-interaction from the provided extension calldata.
     * @param extension The calldata from which the pre-interaction is to be retrieved.
     * @return calldata Bytes representing the pre-interaction.
     */
    function preInteractionTargetAndData(bytes calldata extension) internal pure returns(bytes calldata) {
        return _get(extension, DynamicField.PreInteractionData);
    }

    /**
     * @notice Returns the post-interaction from the provided extension calldata.
     * @param extension The calldata from which the post-interaction is to be retrieved.
     * @return calldata Bytes representing the post-interaction.
     */
    function postInteractionTargetAndData(bytes calldata extension) internal pure returns(bytes calldata) {
        return _get(extension, DynamicField.PostInteractionData);
    }

    /**
     * @notice Returns extra suffix data from the provided extension calldata.
     * @param extension The calldata from which the extra suffix data is to be retrieved.
     * @return calldata Bytes representing the extra suffix data.
     */
    function customData(bytes calldata extension) internal pure returns(bytes calldata) {
        if (extension.length < 0x20) return msg.data[:0];
        uint256 offsets = uint256(bytes32(extension));
        unchecked {
            return extension[0x20 + (offsets >> 224):];
        }
    }

    /**
     * @notice Retrieves a specific field from the provided extension calldata.
     * @dev The first 32 bytes of an extension calldata contain offsets to the end of each field within the calldata.
     * @param extension The calldata from which the field is to be retrieved.
     * @param field The specific dynamic field to retrieve from the extension.
     * @return calldata Bytes representing the requested field.
     */
    function _get(bytes calldata extension, DynamicField field) private pure returns(bytes calldata) {
        if (extension.length < 0x20) return msg.data[:0];

        Offsets offsets;
        bytes calldata concat;
        assembly ("memory-safe") {  // solhint-disable-line no-inline-assembly
            offsets := calldataload(extension.offset)
            concat.offset := add(extension.offset, 0x20)
            concat.length := sub(extension.length, 0x20)
        }

        return offsets.get(concat, uint256(field));
    }
}

// contracts/lib/cross-chain-swap/lib/solidity-utils/contracts/libraries/SafeERC20.sol

/**
 * @title Implements efficient safe methods for ERC20 interface.
 * @notice Compared to the standard ERC20, this implementation offers several enhancements:
 * 1. more gas-efficient, providing significant savings in transaction costs.
 * 2. support for different permit implementations
 * 3. forceApprove functionality
 * 4. support for WETH deposit and withdraw
 */
library SafeERC20 {
    error SafeTransferFailed();
    error SafeTransferFromFailed();
    error ForceApproveFailed();
    error SafeIncreaseAllowanceFailed();
    error SafeDecreaseAllowanceFailed();
    error SafePermitBadLength();
    error Permit2TransferAmountTooHigh();

    // Uniswap Permit2 address
    address private constant _PERMIT2 = 0x000000000022D473030F116dDEE9F6B43aC78BA3;
    bytes4 private constant _PERMIT_LENGTH_ERROR = 0x68275857;  // SafePermitBadLength.selector
    uint256 private constant _RAW_CALL_GAS_LIMIT = 5000;

    /**
     * @notice Fetches the balance of a specific ERC20 token held by an account.
     * Consumes less gas then regular `ERC20.balanceOf`.
     * @dev Note that the implementation does not perform dirty bits cleaning, so it is the
     * responsibility of the caller to make sure that the higher 96 bits of the `account` parameter are clean.
     * @param token The IERC20 token contract for which the balance will be fetched.
     * @param account The address of the account whose token balance will be fetched.
     * @return tokenBalance The balance of the specified ERC20 token held by the account.
     */
    function safeBalanceOf(
        IERC20 token,
        address account
    ) internal view returns(uint256 tokenBalance) {
        bytes4 selector = IERC20.balanceOf.selector;
        assembly ("memory-safe") { // solhint-disable-line no-inline-assembly
            mstore(0x00, selector)
            mstore(0x04, account)
            let success := staticcall(gas(), token, 0x00, 0x24, 0x00, 0x20)
            tokenBalance := mload(0)

            if or(iszero(success), lt(returndatasize(), 0x20)) {
                let ptr := mload(0x40)
                returndatacopy(ptr, 0, returndatasize())
                revert(ptr, returndatasize())
            }
        }
    }

    /**
     * @notice Attempts to safely transfer tokens from one address to another.
     * @dev If permit2 is true, uses the Permit2 standard; otherwise uses the standard ERC20 transferFrom.
     * Either requires `true` in return data, or requires target to be smart-contract and empty return data.
     * Note that the implementation does not perform dirty bits cleaning, so it is the responsibility of
     * the caller to make sure that the higher 96 bits of the `from` and `to` parameters are clean.
     * @param token The IERC20 token contract from which the tokens will be transferred.
     * @param from The address from which the tokens will be transferred.
     * @param to The address to which the tokens will be transferred.
     * @param amount The amount of tokens to transfer.
     * @param permit2 If true, uses the Permit2 standard for the transfer; otherwise uses the standard ERC20 transferFrom.
     */
    function safeTransferFromUniversal(
        IERC20 token,
        address from,
        address to,
        uint256 amount,
        bool permit2
    ) internal {
        if (permit2) {
            safeTransferFromPermit2(token, from, to, amount);
        } else {
            safeTransferFrom(token, from, to, amount);
        }
    }

    /**
     * @notice Attempts to safely transfer tokens from one address to another using the ERC20 standard.
     * @dev Either requires `true` in return data, or requires target to be smart-contract and empty return data.
     * Note that the implementation does not perform dirty bits cleaning, so it is the responsibility of
     * the caller to make sure that the higher 96 bits of the `from` and `to` parameters are clean.
     * @param token The IERC20 token contract from which the tokens will be transferred.
     * @param from The address from which the tokens will be transferred.
     * @param to The address to which the tokens will be transferred.
     * @param amount The amount of tokens to transfer.
     */
    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 amount
    ) internal {
        bytes4 selector = token.transferFrom.selector;
        bool success;
        assembly ("memory-safe") { // solhint-disable-line no-inline-assembly
            let data := mload(0x40)

            mstore(data, selector)
            mstore(add(data, 0x04), from)
            mstore(add(data, 0x24), to)
            mstore(add(data, 0x44), amount)
            success := call(gas(), token, 0, data, 100, 0x0, 0x20)
            if success {
                switch returndatasize()
                case 0 {
                    success := gt(extcodesize(token), 0)
                }
                default {
                    success := and(gt(returndatasize(), 31), eq(mload(0), 1))
                }
            }
        }
        if (!success) revert SafeTransferFromFailed();
    }

    /**
     * @notice Attempts to safely transfer tokens from one address to another using the Permit2 standard.
     * @dev Either requires `true` in return data, or requires target to be smart-contract and empty return data.
     * Note that the implementation does not perform dirty bits cleaning, so it is the responsibility of
     * the caller to make sure that the higher 96 bits of the `from` and `to` parameters are clean.
     * @param token The IERC20 token contract from which the tokens will be transferred.
     * @param from The address from which the tokens will be transferred.
     * @param to The address to which the tokens will be transferred.
     * @param amount The amount of tokens to transfer.
     */
    function safeTransferFromPermit2(
        IERC20 token,
        address from,
        address to,
        uint256 amount
    ) internal {
        if (amount > type(uint160).max) revert Permit2TransferAmountTooHigh();
        bytes4 selector = IPermit2.transferFrom.selector;
        bool success;
        assembly ("memory-safe") { // solhint-disable-line no-inline-assembly
            let data := mload(0x40)

            mstore(data, selector)
            mstore(add(data, 0x04), from)
            mstore(add(data, 0x24), to)
            mstore(add(data, 0x44), amount)
            mstore(add(data, 0x64), token)
            success := call(gas(), _PERMIT2, 0, data, 0x84, 0x0, 0x0)
            if success {
                success := gt(extcodesize(_PERMIT2), 0)
            }
        }
        if (!success) revert SafeTransferFromFailed();
    }

    /**
     * @notice Attempts to safely transfer tokens to another address.
     * @dev Either requires `true` in return data, or requires target to be smart-contract and empty return data.
     * Note that the implementation does not perform dirty bits cleaning, so it is the responsibility of
     * the caller to make sure that the higher 96 bits of the `to` parameter are clean.
     * @param token The IERC20 token contract from which the tokens will be transferred.
     * @param to The address to which the tokens will be transferred.
     * @param value The amount of tokens to transfer.
     */
    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        if (!_makeCall(token, token.transfer.selector, to, value)) {
            revert SafeTransferFailed();
        }
    }

    /**
     * @notice Attempts to approve a spender to spend a certain amount of tokens.
     * @dev If `approve(from, to, amount)` fails, it tries to set the allowance to zero, and retries the `approve` call.
     * Note that the implementation does not perform dirty bits cleaning, so it is the responsibility of
     * the caller to make sure that the higher 96 bits of the `spender` parameter are clean.
     * @param token The IERC20 token contract on which the call will be made.
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to be spent.
     */
    function forceApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        if (!_makeCall(token, token.approve.selector, spender, value)) {
            if (
                !_makeCall(token, token.approve.selector, spender, 0) ||
                !_makeCall(token, token.approve.selector, spender, value)
            ) {
                revert ForceApproveFailed();
            }
        }
    }

    /**
     * @notice Safely increases the allowance of a spender.
     * @dev Increases with safe math check. Checks if the increased allowance will overflow, if yes, then it reverts the transaction.
     * Then uses `forceApprove` to increase the allowance.
     * Note that the implementation does not perform dirty bits cleaning, so it is the responsibility of
     * the caller to make sure that the higher 96 bits of the `spender` parameter are clean.
     * @param token The IERC20 token contract on which the call will be made.
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to increase the allowance by.
     */
    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 allowance = token.allowance(address(this), spender);
        if (value > type(uint256).max - allowance) revert SafeIncreaseAllowanceFailed();
        forceApprove(token, spender, allowance + value);
    }

    /**
     * @notice Safely decreases the allowance of a spender.
     * @dev Decreases with safe math check. Checks if the decreased allowance will underflow, if yes, then it reverts the transaction.
     * Then uses `forceApprove` to increase the allowance.
     * Note that the implementation does not perform dirty bits cleaning, so it is the responsibility of
     * the caller to make sure that the higher 96 bits of the `spender` parameter are clean.
     * @param token The IERC20 token contract on which the call will be made.
     * @param spender The address which will spend the funds.
     * @param value The amount of tokens to decrease the allowance by.
     */
    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 allowance = token.allowance(address(this), spender);
        if (value > allowance) revert SafeDecreaseAllowanceFailed();
        forceApprove(token, spender, allowance - value);
    }

    /**
     * @notice Attempts to execute the `permit` function on the provided token with the sender and contract as parameters.
     * Permit type is determined automatically based on permit calldata (IERC20Permit, IDaiLikePermit, and IPermit2).
     * @dev Wraps `tryPermit` function and forwards revert reason if permit fails.
     * @param token The IERC20 token to execute the permit function on.
     * @param permit The permit data to be used in the function call.
     */
    function safePermit(IERC20 token, bytes calldata permit) internal {
        if (!tryPermit(token, msg.sender, address(this), permit)) RevertReasonForwarder.reRevert();
    }

    /**
     * @notice Attempts to execute the `permit` function on the provided token with custom owner and spender parameters.
     * Permit type is determined automatically based on permit calldata (IERC20Permit, IDaiLikePermit, and IPermit2).
     * @dev Wraps `tryPermit` function and forwards revert reason if permit fails.
     * Note that the implementation does not perform dirty bits cleaning, so it is the responsibility of
     * the caller to make sure that the higher 96 bits of the `owner` and `spender` parameters are clean.
     * @param token The IERC20 token to execute the permit function on.
     * @param owner The owner of the tokens for which the permit is made.
     * @param spender The spender allowed to spend the tokens by the permit.
     * @param permit The permit data to be used in the function call.
     */
    function safePermit(IERC20 token, address owner, address spender, bytes calldata permit) internal {
        if (!tryPermit(token, owner, spender, permit)) RevertReasonForwarder.reRevert();
    }

    /**
     * @notice Attempts to execute the `permit` function on the provided token with the sender and contract as parameters.
     * @dev Invokes `tryPermit` with sender as owner and contract as spender.
     * @param token The IERC20 token to execute the permit function on.
     * @param permit The permit data to be used in the function call.
     * @return success Returns true if the permit function was successfully executed, false otherwise.
     */
    function tryPermit(IERC20 token, bytes calldata permit) internal returns(bool success) {
        return tryPermit(token, msg.sender, address(this), permit);
    }

    /**
     * @notice The function attempts to call the permit function on a given ERC20 token.
     * @dev The function is designed to support a variety of permit functions, namely: IERC20Permit, IDaiLikePermit, IERC7597Permit and IPermit2.
     * It accommodates both Compact and Full formats of these permit types.
     * Please note, it is expected that the `expiration` parameter for the compact Permit2 and the `deadline` parameter
     * for the compact Permit are to be incremented by one before invoking this function. This approach is motivated by
     * gas efficiency considerations; as the unlimited expiration period is likely to be the most common scenario, and
     * zeros are cheaper to pass in terms of gas cost. Thus, callers should increment the expiration or deadline by one
     * before invocation for optimized performance.
     * Note that the implementation does not perform dirty bits cleaning, so it is the responsibility of
     * the caller to make sure that the higher 96 bits of the `owner` and `spender` parameters are clean.
     * @param token The address of the ERC20 token on which to call the permit function.
     * @param owner The owner of the tokens. This address should have signed the off-chain permit.
     * @param spender The address which will be approved for transfer of tokens.
     * @param permit The off-chain permit data, containing different fields depending on the type of permit function.
     * @return success A boolean indicating whether the permit call was successful.
     */
    function tryPermit(IERC20 token, address owner, address spender, bytes calldata permit) internal returns(bool success) {
        // load function selectors for different permit standards
        bytes4 permitSelector = IERC20Permit.permit.selector;
        bytes4 daiPermitSelector = IDaiLikePermit.permit.selector;
        bytes4 permit2Selector = IPermit2.permit.selector;
        bytes4 erc7597PermitSelector = IERC7597Permit.permit.selector;
        assembly ("memory-safe") { // solhint-disable-line no-inline-assembly
            let ptr := mload(0x40)

            // Switch case for different permit lengths, indicating different permit standards
            switch permit.length
            // Compact IERC20Permit
            case 100 {
                mstore(ptr, permitSelector)     // store selector
                mstore(add(ptr, 0x04), owner)   // store owner
                mstore(add(ptr, 0x24), spender) // store spender

                // Compact IERC20Permit.permit(uint256 value, uint32 deadline, uint256 r, uint256 vs)
                {  // stack too deep
                    let deadline := shr(224, calldataload(add(permit.offset, 0x20))) // loads permit.offset 0x20..0x23
                    let vs := calldataload(add(permit.offset, 0x44))                 // loads permit.offset 0x44..0x63

                    calldatacopy(add(ptr, 0x44), permit.offset, 0x20)            // store value     = copy permit.offset 0x00..0x19
                    mstore(add(ptr, 0x64), sub(deadline, 1))                     // store deadline  = deadline - 1
                    mstore(add(ptr, 0x84), add(27, shr(255, vs)))                // store v         = most significant bit of vs + 27 (27 or 28)
                    calldatacopy(add(ptr, 0xa4), add(permit.offset, 0x24), 0x20) // store r         = copy permit.offset 0x24..0x43
                    mstore(add(ptr, 0xc4), shr(1, shl(1, vs)))                   // store s         = vs without most significant bit
                }
                // IERC20Permit.permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
                success := call(gas(), token, 0, ptr, 0xe4, 0, 0)
            }
            // Compact IDaiLikePermit
            case 72 {
                mstore(ptr, daiPermitSelector)  // store selector
                mstore(add(ptr, 0x04), owner)   // store owner
                mstore(add(ptr, 0x24), spender) // store spender

                // Compact IDaiLikePermit.permit(uint32 nonce, uint32 expiry, uint256 r, uint256 vs)
                {  // stack too deep
                    let expiry := shr(224, calldataload(add(permit.offset, 0x04))) // loads permit.offset 0x04..0x07
                    let vs := calldataload(add(permit.offset, 0x28))               // loads permit.offset 0x28..0x47

                    mstore(add(ptr, 0x44), shr(224, calldataload(permit.offset))) // store nonce   = copy permit.offset 0x00..0x03
                    mstore(add(ptr, 0x64), sub(expiry, 1))                        // store expiry  = expiry - 1
                    mstore(add(ptr, 0x84), true)                                  // store allowed = true
                    mstore(add(ptr, 0xa4), add(27, shr(255, vs)))                 // store v       = most significant bit of vs + 27 (27 or 28)
                    calldatacopy(add(ptr, 0xc4), add(permit.offset, 0x08), 0x20)  // store r       = copy permit.offset 0x08..0x27
                    mstore(add(ptr, 0xe4), shr(1, shl(1, vs)))                    // store s       = vs without most significant bit
                }
                // IDaiLikePermit.permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s)
                success := call(gas(), token, 0, ptr, 0x104, 0, 0)
            }
            // IERC20Permit
            case 224 {
                mstore(ptr, permitSelector)
                calldatacopy(add(ptr, 0x04), permit.offset, permit.length) // copy permit calldata
                // IERC20Permit.permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s)
                success := call(gas(), token, 0, ptr, 0xe4, 0, 0)
            }
            // IDaiLikePermit
            case 256 {
                mstore(ptr, daiPermitSelector)
                calldatacopy(add(ptr, 0x04), permit.offset, permit.length) // copy permit calldata
                // IDaiLikePermit.permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s)
                success := call(gas(), token, 0, ptr, 0x104, 0, 0)
            }
            // Compact IPermit2
            case 96 {
                // Compact IPermit2.permit(uint160 amount, uint32 expiration, uint32 nonce, uint32 sigDeadline, uint256 r, uint256 vs)
                mstore(ptr, permit2Selector)  // store selector
                mstore(add(ptr, 0x04), owner) // store owner
                mstore(add(ptr, 0x24), token) // store token

                calldatacopy(add(ptr, 0x50), permit.offset, 0x14)             // store amount = copy permit.offset 0x00..0x13
                // and(0xffffffffffff, ...) - conversion to uint48
                mstore(add(ptr, 0x64), and(0xffffffffffff, sub(shr(224, calldataload(add(permit.offset, 0x14))), 1))) // store expiration = ((permit.offset 0x14..0x17 - 1) & 0xffffffffffff)
                mstore(add(ptr, 0x84), shr(224, calldataload(add(permit.offset, 0x18)))) // store nonce = copy permit.offset 0x18..0x1b
                mstore(add(ptr, 0xa4), spender)                               // store spender
                // and(0xffffffffffff, ...) - conversion to uint48
                mstore(add(ptr, 0xc4), and(0xffffffffffff, sub(shr(224, calldataload(add(permit.offset, 0x1c))), 1))) // store sigDeadline = ((permit.offset 0x1c..0x1f - 1) & 0xffffffffffff)
                mstore(add(ptr, 0xe4), 0x100)                                 // store offset = 256
                mstore(add(ptr, 0x104), 0x40)                                 // store length = 64
                calldatacopy(add(ptr, 0x124), add(permit.offset, 0x20), 0x20) // store r      = copy permit.offset 0x20..0x3f
                calldatacopy(add(ptr, 0x144), add(permit.offset, 0x40), 0x20) // store vs     = copy permit.offset 0x40..0x5f
                // IPermit2.permit(address owner, PermitSingle calldata permitSingle, bytes calldata signature)
                success := call(gas(), _PERMIT2, 0, ptr, 0x164, 0, 0)
            }
            // IPermit2
            case 352 {
                mstore(ptr, permit2Selector)
                calldatacopy(add(ptr, 0x04), permit.offset, permit.length) // copy permit calldata
                // IPermit2.permit(address owner, PermitSingle calldata permitSingle, bytes calldata signature)
                success := call(gas(), _PERMIT2, 0, ptr, 0x164, 0, 0)
            }
            // Dynamic length
            default {
                mstore(ptr, erc7597PermitSelector)
                calldatacopy(add(ptr, 0x04), permit.offset, permit.length) // copy permit calldata
                // IERC7597Permit.permit(address owner, address spender, uint256 value, uint256 deadline, bytes memory signature)
                success := call(gas(), token, 0, ptr, add(permit.length, 4), 0, 0)
            }
        }
    }

    /**
     * @dev Executes a low level call to a token contract, making it resistant to reversion and erroneous boolean returns.
     * @param token The IERC20 token contract on which the call will be made.
     * @param selector The function signature that is to be called on the token contract.
     * @param to The address to which the token amount will be transferred.
     * @param amount The token amount to be transferred.
     * @return success A boolean indicating if the call was successful. Returns 'true' on success and 'false' on failure.
     * In case of success but no returned data, validates that the contract code exists.
     * In case of returned data, ensures that it's a boolean `true`.
     */
    function _makeCall(
        IERC20 token,
        bytes4 selector,
        address to,
        uint256 amount
    ) private returns (bool success) {
        assembly ("memory-safe") { // solhint-disable-line no-inline-assembly
            let data := mload(0x40)

            mstore(data, selector)
            mstore(add(data, 0x04), to)
            mstore(add(data, 0x24), amount)
            success := call(gas(), token, 0, data, 0x44, 0x0, 0x20)
            if success {
                switch returndatasize()
                case 0 {
                    success := gt(extcodesize(token), 0)
                }
                default {
                    success := and(gt(returndatasize(), 31), eq(mload(0), 1))
                }
            }
        }
    }

    /**
     * @notice Safely deposits a specified amount of Ether into the IWETH contract. Consumes less gas then regular `IWETH.deposit`.
     * @param weth The IWETH token contract.
     * @param amount The amount of Ether to deposit into the IWETH contract.
     */
    function safeDeposit(IWETH weth, uint256 amount) internal {
        if (amount > 0) {
            bytes4 selector = IWETH.deposit.selector;
            assembly ("memory-safe") { // solhint-disable-line no-inline-assembly
                mstore(0, selector)
                if iszero(call(gas(), weth, amount, 0, 4, 0, 0)) {
                    let ptr := mload(0x40)
                    returndatacopy(ptr, 0, returndatasize())
                    revert(ptr, returndatasize())
                }
            }
        }
    }

    /**
     * @notice Safely withdraws a specified amount of wrapped Ether from the IWETH contract. Consumes less gas then regular `IWETH.withdraw`.
     * @dev Uses inline assembly to interact with the IWETH contract.
     * @param weth The IWETH token contract.
     * @param amount The amount of wrapped Ether to withdraw from the IWETH contract.
     */
    function safeWithdraw(IWETH weth, uint256 amount) internal {
        bytes4 selector = IWETH.withdraw.selector;
        assembly ("memory-safe") {  // solhint-disable-line no-inline-assembly
            mstore(0, selector)
            mstore(4, amount)
            if iszero(call(gas(), weth, 0, 0, 0x24, 0, 0)) {
                let ptr := mload(0x40)
                returndatacopy(ptr, 0, returndatasize())
                revert(ptr, returndatasize())
            }
        }
    }

    /**
     * @notice Safely withdraws a specified amount of wrapped Ether from the IWETH contract to a specified recipient.
     * Consumes less gas then regular `IWETH.withdraw`.
     * @param weth The IWETH token contract.
     * @param amount The amount of wrapped Ether to withdraw from the IWETH contract.
     * @param to The recipient of the withdrawn Ether.
     */
    function safeWithdrawTo(IWETH weth, uint256 amount, address to) internal {
        safeWithdraw(weth, amount);
        if (to != address(this)) {
            assembly ("memory-safe") {  // solhint-disable-line no-inline-assembly
                if iszero(call(_RAW_CALL_GAS_LIMIT, to, amount, 0, 0, 0, 0)) {
                    let ptr := mload(0x40)
                    returndatacopy(ptr, 0, returndatasize())
                    revert(ptr, returndatasize())
                }
            }
        }
    }
}

// contracts/lib/cross-chain-swap/lib/limit-order-settlement/contracts/extensions/BaseExtension.sol

/**
 * @title Base Extension contract
 * @notice Contract to define the basic functionality for the limit orders settlement.
 */
contract BaseExtension is IPreInteraction, IPostInteraction, IAmountGetter {
    error OnlyLimitOrderProtocol();

    uint256 private constant _BASE_POINTS = 10_000_000; // 100%
    uint256 private constant _GAS_PRICE_BASE = 1_000_000; // 1000 means 1 Gwei

    address private immutable _LIMIT_ORDER_PROTOCOL;

    /// @dev Modifier to check if the caller is the limit order protocol contract.
    modifier onlyLimitOrderProtocol {
        if (msg.sender != _LIMIT_ORDER_PROTOCOL) revert OnlyLimitOrderProtocol();
        _;
    }

    /**
     * @notice Initializes the contract.
     * @param limitOrderProtocol The limit order protocol contract.
     */
    constructor(address limitOrderProtocol) {
        _LIMIT_ORDER_PROTOCOL = limitOrderProtocol;
    }

    /**
     * See {IAmountGetter-getMakingAmount}
     */
    function getMakingAmount(
        IOrderMixin.Order calldata order,
        bytes calldata /* extension */,
        bytes32 /* orderHash */,
        address /* taker */,
        uint256 takingAmount,
        uint256 /* remainingMakingAmount */,
        bytes calldata extraData
    ) external view returns (uint256) {
        uint256 rateBump = _getRateBump(extraData);
        return Math.mulDiv(order.makingAmount, takingAmount * _BASE_POINTS, order.takingAmount * (_BASE_POINTS + rateBump));
    }

    /**
     * See {IAmountGetter-getTakingAmount}
     */
    function getTakingAmount(
        IOrderMixin.Order calldata order,
        bytes calldata /* extension */,
        bytes32 /* orderHash */,
        address /* taker */,
        uint256 makingAmount,
        uint256 /* remainingMakingAmount */,
        bytes calldata extraData
    ) external view returns (uint256) {
        uint256 rateBump = _getRateBump(extraData);
        return Math.mulDiv(order.takingAmount, makingAmount * (_BASE_POINTS + rateBump), order.makingAmount * _BASE_POINTS, Math.Rounding.Ceil);
    }

    /**
     * See {IPreInteraction-preInteraction}
     */
    function preInteraction(
        IOrderMixin.Order calldata order,
        bytes calldata extension,
        bytes32 orderHash,
        address taker,
        uint256 makingAmount,
        uint256 takingAmount,
        uint256 remainingMakingAmount,
        bytes calldata extraData
    ) external onlyLimitOrderProtocol {
        _preInteraction(order, extension, orderHash, taker, makingAmount, takingAmount, remainingMakingAmount, extraData);
    }

    /**
     * See {IPostInteraction-postInteraction}
     */
    function postInteraction(
        IOrderMixin.Order calldata order,
        bytes calldata extension,
        bytes32 orderHash,
        address taker,
        uint256 makingAmount,
        uint256 takingAmount,
        uint256 remainingMakingAmount,
        bytes calldata extraData
    ) external onlyLimitOrderProtocol {
        _postInteraction(order, extension, orderHash, taker, makingAmount, takingAmount, remainingMakingAmount, extraData);
    }

    function _preInteraction(
        IOrderMixin.Order calldata order,
        bytes calldata extension,
        bytes32 orderHash,
        address taker,
        uint256 makingAmount,
        uint256 takingAmount,
        uint256 remainingMakingAmount,
        bytes calldata extraData
    ) internal virtual {}

    function _postInteraction(
        IOrderMixin.Order calldata order,
        bytes calldata extension,
        bytes32 orderHash,
        address taker,
        uint256 makingAmount,
        uint256 takingAmount,
        uint256 remainingMakingAmount,
        bytes calldata extraData
    ) internal virtual {
        // Allows to add custom postInteractions
        if (extraData.length > 20) {
            IPostInteraction(address(bytes20(extraData))).postInteraction(order, extension, orderHash, taker, makingAmount, takingAmount, remainingMakingAmount, extraData[20 : extraData.length - 1]);
        }
    }

    /**
     * @dev Parses auction rate bump data from the `auctionDetails` field.
     * `gasBumpEstimate` and `gasPriceEstimate` are used to estimate the transaction costs
     * which are then offset from the auction rate bump.
     * @param auctionDetails AuctionDetails is a tightly packed struct of the following format:
     * ```
     * struct AuctionDetails {
     *     bytes3 gasBumpEstimate;
     *     bytes4 gasPriceEstimate;
     *     bytes4 auctionStartTime;
     *     bytes3 auctionDuration;
     *     bytes3 initialRateBump;
     *     (bytes3,bytes2)[N] pointsAndTimeDeltas;
     * }
     * ```
     * @return rateBump The rate bump.
     */
    function _getRateBump(bytes calldata auctionDetails) private view returns (uint256) {
        unchecked {
            uint256 gasBumpEstimate = uint24(bytes3(auctionDetails[0:3]));
            uint256 gasPriceEstimate = uint32(bytes4(auctionDetails[3:7]));
            uint256 gasBump = gasBumpEstimate == 0 || gasPriceEstimate == 0 ? 0 : gasBumpEstimate * block.basefee / gasPriceEstimate / _GAS_PRICE_BASE;
            uint256 auctionStartTime = uint32(bytes4(auctionDetails[7:11]));
            uint256 auctionFinishTime = auctionStartTime + uint24(bytes3(auctionDetails[11:14]));
            uint256 initialRateBump = uint24(bytes3(auctionDetails[14:17]));
            uint256 auctionBump = _getAuctionBump(auctionStartTime, auctionFinishTime, initialRateBump, auctionDetails[17:]);
            return auctionBump > gasBump ? auctionBump - gasBump : 0;
        }
    }

    /**
     * @dev Calculates auction price bump. Auction is represented as a piecewise linear function with `N` points.
     * Each point is represented as a pair of `(rateBump, timeDelta)`, where `rateBump` is the
     * rate bump in basis points and `timeDelta` is the time delta in seconds.
     * The rate bump is interpolated linearly between the points.
     * The last point is assumed to be `(0, auctionDuration)`.
     * @param auctionStartTime The time when the auction starts.
     * @param auctionFinishTime The time when the auction finishes.
     * @param initialRateBump The initial rate bump.
     * @param pointsAndTimeDeltas The points and time deltas structure.
     * @return The rate bump at the current time.
     */
    function _getAuctionBump(uint256 auctionStartTime, uint256 auctionFinishTime, uint256 initialRateBump, bytes calldata pointsAndTimeDeltas) private view returns (uint256) {
        unchecked {
            if (block.timestamp <= auctionStartTime) {
                return initialRateBump;
            } else if (block.timestamp >= auctionFinishTime) {
                return 0;
            }

            uint256 currentPointTime = auctionStartTime;
            uint256 currentRateBump = initialRateBump;

            while (pointsAndTimeDeltas.length > 0) {
                uint256 nextRateBump = uint24(bytes3(pointsAndTimeDeltas[:3]));
                uint256 nextPointTime = currentPointTime + uint16(bytes2(pointsAndTimeDeltas[3:5]));
                if (block.timestamp <= nextPointTime) {
                    return ((block.timestamp - currentPointTime) * nextRateBump + (nextPointTime - block.timestamp) * currentRateBump) / (nextPointTime - currentPointTime);
                }
                currentRateBump = nextRateBump;
                currentPointTime = nextPointTime;
                pointsAndTimeDeltas = pointsAndTimeDeltas[5:];
            }
            return (auctionFinishTime - block.timestamp) * currentRateBump / (auctionFinishTime - currentPointTime);
        }
    }
}

// contracts/lib/cross-chain-swap/lib/solidity-utils/contracts/libraries/UniERC20.sol

/**
 * @title UniERC20
 * @dev Library to abstract the handling of ETH and ERC20 tokens, enabling unified interaction with both. It allows usage of ETH as ERC20.
 * Utilizes SafeERC20 for ERC20 interactions and provides additional utility functions.
 */
library UniERC20 {
    using SafeERC20 for IERC20;

    error InsufficientBalance();
    error ApproveCalledOnETH();
    error NotEnoughValue();
    error FromIsNotSender();
    error ToIsNotThis();
    error ETHTransferFailed();

    uint256 private constant _RAW_CALL_GAS_LIMIT = 5000;
    IERC20 private constant _ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
    IERC20 private constant _ZERO_ADDRESS = IERC20(address(0));

    /**
     * @dev Determines if the specified token is ETH.
     * @param token The token to check.
     * @return bool True if the token is ETH, false otherwise.
     */
    function isETH(IERC20 token) internal pure returns (bool) {
        return (token == _ZERO_ADDRESS || token == _ETH_ADDRESS);
    }

    /**
     * @dev Retrieves the balance of the specified token for an account.
     * @param token The token to query the balance of.
     * @param account The address of the account.
     * @return uint256 The balance of the token for the specified account.
     */
    function uniBalanceOf(IERC20 token, address account) internal view returns (uint256) {
        if (isETH(token)) {
            return account.balance;
        } else {
            return token.balanceOf(account);
        }
    }

    /**
     * @dev Transfers a specified amount of the token to a given address.
     * Note: Does nothing if the amount is zero.
     * @param token The token to transfer.
     * @param to The address to transfer the token to.
     * @param amount The amount of the token to transfer.
     */
    function uniTransfer(
        IERC20 token,
        address payable to,
        uint256 amount
    ) internal {
        if (amount > 0) {
            if (isETH(token)) {
                if (address(this).balance < amount) revert InsufficientBalance();
                // solhint-disable-next-line avoid-low-level-calls
                (bool success, ) = to.call{value: amount, gas: _RAW_CALL_GAS_LIMIT}("");
                if (!success) revert ETHTransferFailed();
            } else {
                token.safeTransfer(to, amount);
            }
        }
    }

    /**
     * @dev Transfers a specified amount of the token from one address to another.
     * Note: Does nothing if the amount is zero.
     * @param token The token to transfer.
     * @param from The address to transfer the token from.
     * @param to The address to transfer the token to.
     * @param amount The amount of the token to transfer.
     */
    function uniTransferFrom(
        IERC20 token,
        address payable from,
        address to,
        uint256 amount
    ) internal {
        if (amount > 0) {
            if (isETH(token)) {
                if (msg.value < amount) revert NotEnoughValue();
                if (from != msg.sender) revert FromIsNotSender();
                if (to != address(this)) revert ToIsNotThis();
                if (msg.value > amount) {
                    // Return remainder if exist
                    unchecked {
                        // solhint-disable-next-line avoid-low-level-calls
                        (bool success, ) = from.call{value: msg.value - amount, gas: _RAW_CALL_GAS_LIMIT}("");
                        if (!success) revert ETHTransferFailed();
                    }
                }
            } else {
                token.safeTransferFrom(from, to, amount);
            }
        }
    }

    /**
     * @dev Retrieves the symbol from ERC20 metadata of the specified token.
     * @param token The token to retrieve the symbol of.
     * @return string The symbol of the token.
     */
    function uniSymbol(IERC20 token) internal view returns (string memory) {
        return _uniDecode(token, IERC20Metadata.symbol.selector, IERC20MetadataUppercase.SYMBOL.selector);
    }

    /**
     * @dev Retrieves the name from ERC20 metadata of the specified token.
     * @param token The token to retrieve the name of.
     * @return string The name of the token.
     */
    function uniName(IERC20 token) internal view returns (string memory) {
        return _uniDecode(token, IERC20Metadata.name.selector, IERC20MetadataUppercase.NAME.selector);
    }

    /**
     * @dev forceApprove the specified amount of the token to a given address.
     * Reverts if the token is ETH.
     * @param token The token to approve.
     * @param to The address to approve the token to.
     * @param amount The amount of the token to approve.
     */
    function uniApprove(
        IERC20 token,
        address to,
        uint256 amount
    ) internal {
        if (isETH(token)) revert ApproveCalledOnETH();

        token.forceApprove(to, amount);
    }

    /**
     * @dev Internal function to decode token metadata (name or symbol).
     * 20K gas is provided to account for possible implementations of name/symbol
     * (token implementation might be behind proxy or store the value in storage)
     * @param token The token to decode metadata for.
     * @param lowerCaseSelector The selector for the lowercase metadata function.
     * @param upperCaseSelector The selector for the uppercase metadata function.
     * @return result The decoded metadata value.
     */
    function _uniDecode(
        IERC20 token,
        bytes4 lowerCaseSelector,
        bytes4 upperCaseSelector
    ) private view returns (string memory result) {
        if (isETH(token)) {
            return "ETH";
        }

        (bool success, bytes memory data) = address(token).staticcall{gas: 20000}(
            abi.encodeWithSelector(lowerCaseSelector)
        );
        if (!success) {
            (success, data) = address(token).staticcall{gas: 20000}(abi.encodeWithSelector(upperCaseSelector));
        }

        if (success && data.length >= 0x40) {
            (uint256 offset, uint256 len) = abi.decode(data, (uint256, uint256));
            /*
                return data is padded up to 32 bytes with ABI encoder also sometimes
                there is extra 32 bytes of zeros padded in the end:
                https://github.com/ethereum/solidity/issues/10170
                because of that we can't check for equality and instead check
                that overall data length is greater or equal than string length + extra 64 bytes
            */
            if (offset == 0x20 && data.length >= 0x40 + len) {
                assembly ("memory-safe") { // solhint-disable-line no-inline-assembly
                    result := add(data, 0x40)
                }
                return result;
            }
        }
        if (success && data.length == 32) {
            uint256 len = 0;
            while (len < data.length && data[len] >= 0x20 && data[len] <= 0x7E) {
                unchecked {
                    len++;
                }
            }

            if (len > 0) {
                assembly ("memory-safe") { // solhint-disable-line no-inline-assembly
                    mstore(data, len)
                }
                return string(data);
            }
        }

        return StringUtil.toHex(address(token));
    }
}

// contracts/lib/cross-chain-swap/contracts/BaseEscrow.sol

/**
 * @title Base abstract Escrow contract for cross-chain atomic swap.
 * @dev {IBaseEscrow-withdraw}, {IBaseEscrow-cancel} and _validateImmutables functions must be implemented in the derived contracts.
 * @custom:security-contact security@1inch.io
 */
abstract contract BaseEscrow is IBaseEscrow {
    using AddressLib for Address;
    using SafeERC20 for IERC20;
    using TimelocksLib for Timelocks;
    using ImmutablesLib for Immutables;

    /// @notice See {IBaseEscrow-RESCUE_DELAY}.
    uint256 public immutable RESCUE_DELAY;
    /// @notice See {IBaseEscrow-FACTORY}.
    address public immutable FACTORY = msg.sender;

    constructor(uint32 rescueDelay) {
        RESCUE_DELAY = rescueDelay;
    }

    modifier onlyTaker(Immutables calldata immutables) {
        if (msg.sender != immutables.taker.get()) revert InvalidCaller();
        _;
    }

    modifier onlyValidImmutables(Immutables calldata immutables) virtual {
        _validateImmutables(immutables);
        _;
    }

    modifier onlyValidSecret(bytes32 secret, Immutables calldata immutables) {
        if (_keccakBytes32(secret) != immutables.hashlock) revert InvalidSecret();
        _;
    }

    modifier onlyAfter(uint256 start) {
        if (block.timestamp < start) revert InvalidTime();
        _;
    }

    modifier onlyBefore(uint256 stop) {
        if (block.timestamp >= stop) revert InvalidTime();
        _;
    }

    /**
     * @notice See {IBaseEscrow-rescueFunds}.
     */
    function rescueFunds(address token, uint256 amount, Immutables calldata immutables)
        external
        onlyTaker(immutables)
        onlyValidImmutables(immutables)
        onlyAfter(immutables.timelocks.rescueStart(RESCUE_DELAY))
    {
        _uniTransfer(token, msg.sender, amount);
        emit FundsRescued(token, amount);
    }

    /**
     * @dev Transfers ERC20 or native tokens to the recipient.
     */
    function _uniTransfer(address token, address to, uint256 amount) internal {
        if (token == address(0)) {
            _ethTransfer(to, amount);
        } else {
            IERC20(token).safeTransfer(to, amount);
        }
    }

    /**
     * @dev Transfers native tokens to the recipient.
     */
    function _ethTransfer(address to, uint256 amount) internal {
        (bool success,) = to.call{ value: amount }("");
        if (!success) revert NativeTokenSendingFailure();
    }

    /**
     * @dev Should verify that the computed escrow address matches the address of this contract.
     */
    function _validateImmutables(Immutables calldata immutables) internal view virtual;

    /**
     * @dev Computes the Keccak-256 hash of the secret.
     * @param secret The secret that unlocks the escrow.
     * @return ret The computed hash.
     */
    function _keccakBytes32(bytes32 secret) private pure returns (bytes32 ret) {
        assembly ("memory-safe") {
            mstore(0, secret)
            ret := keccak256(0, 0x20)
        }
    }
}

// contracts/lib/cross-chain-swap/contracts/MerkleStorageInvalidator.sol

 // solhint-disable-line no-unused-import

/**
 * @title Merkle Storage Invalidator contract
 * @notice Contract to invalidate hashed secrets from an order that supports multiple fills.
 * @custom:security-contact security@1inch.io
 */
contract MerkleStorageInvalidator is IMerkleStorageInvalidator, ITakerInteraction {
    using MerkleProof for bytes32[];
    using ExtensionLib_1 for bytes;

    address private immutable _LIMIT_ORDER_PROTOCOL;

    /// @notice See {IMerkleStorageInvalidator-lastValidated}.
    mapping(bytes32 key => ValidationData) public lastValidated;

    /// @notice Only limit order protocol can call this contract.
    modifier onlyLOP() {
        if (msg.sender != _LIMIT_ORDER_PROTOCOL) {
            revert AccessDenied();
        }
        _;
    }

    constructor(address limitOrderProtocol) {
        _LIMIT_ORDER_PROTOCOL = limitOrderProtocol;
    }

    /**
     * @notice See {ITakerInteraction-takerInteraction}.
     * @dev Verifies the proof and stores the last validated index and hashed secret.
     * Only Limit Order Protocol can call this function.
     */
    function takerInteraction(
        IOrderMixin.Order calldata /* order */,
        bytes calldata extension,
        bytes32 orderHash,
        address /* taker */,
        uint256 /* makingAmount */,
        uint256 /* takingAmount */,
        uint256 /* remainingMakingAmount */,
        bytes calldata extraData
    ) external onlyLOP {
        bytes calldata postInteraction = extension.postInteractionTargetAndData();
        IEscrowFactory.ExtraDataArgs calldata extraDataArgs;
        TakerData calldata takerData;
        assembly ("memory-safe") {
            extraDataArgs := add(postInteraction.offset, sub(postInteraction.length, SRC_IMMUTABLES_LENGTH))
            takerData := extraData.offset
        }
        uint240 rootShortened = uint240(uint256(extraDataArgs.hashlockInfo));
        bytes32 key = keccak256(abi.encodePacked(orderHash, rootShortened));
        bytes32 rootCalculated = takerData.proof.processProofCalldata(
            keccak256(abi.encodePacked(uint64(takerData.idx), takerData.secretHash))
        );
        if (uint240(uint256(rootCalculated)) != rootShortened) revert InvalidProof();
        lastValidated[key] = ValidationData(takerData.idx + 1, takerData.secretHash);
    }
}

// contracts/lib/cross-chain-swap/lib/limit-order-settlement/contracts/FeeBank.sol

/**
 * @title FeeBank
 * @notice FeeBank contract introduces a credit system for paying fees.
 * A user can deposit tokens to the FeeBank contract, obtain credits and then use them to pay fees.
 * @dev FeeBank is coupled with FeeBankCharger to actually charge fees.
 */
contract FeeBank is IFeeBank, Ownable {
    using SafeERC20 for IERC20;
    using UniERC20 for IERC20;

    error ZeroAddress();

    IERC20 private immutable _FEE_TOKEN;
    IFeeBankCharger private immutable _CHARGER;

    mapping(address account => uint256 availableCredit) private _accountDeposits;

    constructor(IFeeBankCharger charger, IERC20 feeToken, address owner) Ownable(owner) {
        if (address(feeToken) == address(0)) revert ZeroAddress();
        _CHARGER = charger;
        _FEE_TOKEN = feeToken;
    }

    /**
     * @notice See {IFeeBank-availableCredit}.
     */
    function availableCredit(address account) external view returns (uint256) {
        return _CHARGER.availableCredit(account);
    }

    /**
     * @notice See {IFeeBank-deposit}.
     */
    function deposit(uint256 amount) external returns (uint256) {
        return _depositFor(msg.sender, amount);
    }

    /**
     * @notice See {IFeeBank-depositFor}.
     */
    function depositFor(address account, uint256 amount) external returns (uint256) {
        return _depositFor(account, amount);
    }

    /**
     * @notice See {IFeeBank-depositWithPermit}.
     */
    function depositWithPermit(uint256 amount, bytes calldata permit) external returns (uint256) {
        return depositForWithPermit(msg.sender, amount, permit);
    }

    /**
     * @notice See {IFeeBank-depositForWithPermit}.
     */
    function depositForWithPermit(
        address account,
        uint256 amount,
        bytes calldata permit
    ) public returns (uint256) {
        _FEE_TOKEN.safePermit(permit);
        return _depositFor(account, amount);
    }

    /**
     * @notice See {IFeeBank-withdraw}.
     */
    function withdraw(uint256 amount) external returns (uint256) {
        return _withdrawTo(msg.sender, amount);
    }

    /**
     * @notice See {IFeeBank-withdrawTo}.
     */
    function withdrawTo(address account, uint256 amount) external returns (uint256) {
        return _withdrawTo(account, amount);
    }

    /**
     * @notice Admin method returns commissions spent by users.
     * @param accounts Accounts whose commissions are being withdrawn.
     * @return totalAccountFees The total amount of accounts commissions.
     */
    function gatherFees(address[] calldata accounts) external onlyOwner returns (uint256 totalAccountFees) {
        uint256 accountsLength = accounts.length;
        unchecked {
            for (uint256 i = 0; i < accountsLength; ++i) {
                address account = accounts[i];
                uint256 accountDeposit = _accountDeposits[account];
                uint256 availableCredit_ = _CHARGER.availableCredit(account);
                _accountDeposits[account] = availableCredit_;
                totalAccountFees += accountDeposit - availableCredit_;  // overflow is impossible due to checks in FeeBankCharger
            }
        }
        _FEE_TOKEN.safeTransfer(msg.sender, totalAccountFees);
    }

    function _depositFor(address account, uint256 amount) internal returns (uint256 totalAvailableCredit) {
        if (account == address(0)) revert ZeroAddress();
        _FEE_TOKEN.safeTransferFrom(msg.sender, address(this), amount);
        unchecked {
            _accountDeposits[account] += amount;  // overflow is impossible due to limited _FEE_TOKEN supply
        }
        totalAvailableCredit = _CHARGER.increaseAvailableCredit(account, amount);
    }

    function _withdrawTo(address account, uint256 amount) internal returns (uint256 totalAvailableCredit) {
        totalAvailableCredit = _CHARGER.decreaseAvailableCredit(msg.sender, amount);
        unchecked {
            _accountDeposits[msg.sender] -= amount;  // underflow is impossible due to checks in FeeBankCharger
        }
        _FEE_TOKEN.safeTransfer(account, amount);
    }

    /**
     * @notice Retrieves funds accidently sent directly to the contract address
     * @param token ERC20 token to retrieve
     * @param amount amount to retrieve
     */
    function rescueFunds(IERC20 token, uint256 amount) external onlyOwner {
        token.uniTransfer(payable(msg.sender), amount);
    }
}

// contracts/lib/cross-chain-swap/contracts/Escrow.sol

/**
 * @title Abstract Escrow contract for cross-chain atomic swap.
 * @dev {IBaseEscrow-withdraw} and {IBaseEscrow-cancel} functions must be implemented in the derived contracts.
 * @custom:security-contact security@1inch.io
 */
abstract contract Escrow is BaseEscrow, IEscrow {
    using ImmutablesLib for Immutables;

    /// @notice See {IEscrow-PROXY_BYTECODE_HASH}.
    bytes32 public immutable PROXY_BYTECODE_HASH = ProxyHashLib.computeProxyBytecodeHash(address(this));

    /**
     * @dev Verifies that the computed escrow address matches the address of this contract.
     */
    function _validateImmutables(Immutables calldata immutables) internal view virtual override {
        bytes32 salt = immutables.hash();
        if (Create2.computeAddress(salt, PROXY_BYTECODE_HASH, FACTORY) != address(this)) {
            revert InvalidImmutables();
        }
    }
}

// contracts/lib/cross-chain-swap/lib/limit-order-settlement/contracts/FeeBankCharger.sol

/**
 * @title FeeBankCharger
 * @notice FeeBankCharger contract implements logic to increase or decrease users' credits in FeeBank.
 */
contract FeeBankCharger is IFeeBankCharger {
    error OnlyFeeBankAccess();
    error NotEnoughCredit();

    /**
     * @notice See {IFeeBankCharger-feeBank}.
     */
    IFeeBank public immutable FEE_BANK;
    mapping(address => uint256) private _creditAllowance;

    /**
     * @dev Modifier to check if the sender is a FEE_BANK contract.
     */
    modifier onlyFeeBank() {
        if (msg.sender != address(FEE_BANK)) revert OnlyFeeBankAccess();
        _;
    }

    constructor(IERC20 feeToken, address owner) {
        FEE_BANK = new FeeBank(this, feeToken, owner);
    }

    /**
     * @notice See {IFeeBankCharger-availableCredit}.
     */
    function availableCredit(address account) external view returns (uint256) {
        return _creditAllowance[account];
    }

    /**
     * @notice See {IFeeBankCharger-increaseAvailableCredit}.
     */
    function increaseAvailableCredit(address account, uint256 amount) external onlyFeeBank returns (uint256 allowance) {
        allowance = _creditAllowance[account];
        unchecked {
            allowance += amount;  // overflow is impossible due to limited _token supply
        }
        _creditAllowance[account] = allowance;
    }

    /**
     * @notice See {IFeeBankCharger-decreaseAvailableCredit}.
     */
    function decreaseAvailableCredit(address account, uint256 amount) external onlyFeeBank returns (uint256 allowance) {
        return _creditAllowance[account] -= amount;  // checked math is needed to prevent underflow
    }

    /**
     * @notice Internal function that charges a specified fee from a given account's credit allowance.
     * @dev Reverts with 'NotEnoughCredit' if the account's credit allowance is insufficient to cover the fee.
     * @param account The address of the account from which the fee is being charged.
     * @param fee The amount of fee to be charged from the account.
     */
    function _chargeFee(address account, uint256 fee) internal virtual {
        if (fee > 0) {
            uint256 currentAllowance = _creditAllowance[account];
            if (currentAllowance < fee) revert NotEnoughCredit();
            unchecked {
                _creditAllowance[account] = currentAllowance - fee;
            }
        }
    }
}

// contracts/lib/cross-chain-swap/contracts/EscrowDst.sol

/**
 * @title Destination Escrow contract for cross-chain atomic swap.
 * @notice Contract to initially lock funds and then unlock them with verification of the secret presented.
 * @dev Funds are locked in at the time of contract deployment. For this taker calls the `EscrowFactory.createDstEscrow` function.
 * To perform any action, the caller must provide the same Immutables values used to deploy the clone contract.
 * @custom:security-contact security@1inch.io
 */
contract EscrowDst is Escrow, IEscrowDst {
    using SafeERC20 for IERC20;
    using AddressLib for Address;
    using TimelocksLib for Timelocks;

    constructor(uint32 rescueDelay) BaseEscrow(rescueDelay) {}

    /**
     * @notice See {IBaseEscrow-withdraw}.
     * @dev The function works on the time intervals highlighted with capital letters:
     * ---- contract deployed --/-- finality --/-- PRIVATE WITHDRAWAL --/-- PUBLIC WITHDRAWAL --/-- private cancellation ----
     */
    function withdraw(bytes32 secret, Immutables calldata immutables)
        external
        onlyTaker(immutables)
        onlyAfter(immutables.timelocks.get(TimelocksLib.Stage.DstWithdrawal))
        onlyBefore(immutables.timelocks.get(TimelocksLib.Stage.DstCancellation))
    {
        _withdraw(secret, immutables);
    }

    /**
     * @notice See {IBaseEscrow-publicWithdraw}.
     * @dev The function works on the time intervals highlighted with capital letters:
     * ---- contract deployed --/-- finality --/-- private withdrawal --/-- PUBLIC WITHDRAWAL --/-- private cancellation ----
     */
    function publicWithdraw(bytes32 secret, Immutables calldata immutables)
        external
        onlyAfter(immutables.timelocks.get(TimelocksLib.Stage.DstPublicWithdrawal))
        onlyBefore(immutables.timelocks.get(TimelocksLib.Stage.DstCancellation))
    {
        _withdraw(secret, immutables);
    }

    /**
     * @notice See {IBaseEscrow-cancel}.
     * @dev The function works on the time interval highlighted with capital letters:
     * ---- contract deployed --/-- finality --/-- private withdrawal --/-- public withdrawal --/-- PRIVATE CANCELLATION ----
     */
    function cancel(Immutables calldata immutables)
        external
        onlyTaker(immutables)
        onlyValidImmutables(immutables)
        onlyAfter(immutables.timelocks.get(TimelocksLib.Stage.DstCancellation))
    {
        _uniTransfer(immutables.token.get(), immutables.taker.get(), immutables.amount);
        _ethTransfer(msg.sender, immutables.safetyDeposit);
        emit EscrowCancelled();
    }

    /**
     * @dev Transfers ERC20 (or native) tokens to the maker and native tokens to the caller.
     * @param immutables The immutable values used to deploy the clone contract.
     */
    function _withdraw(bytes32 secret, Immutables calldata immutables)
        internal
        onlyValidImmutables(immutables)
        onlyValidSecret(secret, immutables)
    {
        address token = immutables.token.get();
        address to = immutables.maker.get();
        if (token == address(0)) {
            /**
             * @dev The result of the call is not checked intentionally. This is done to ensure that
             * even in case of malicious receiver the withdrawal flow can not be blocked and takers
             * will be able to get their safety deposit back.
             **/
            to.call{ value: immutables.amount }("");
        } else {
            IERC20(token).safeTransfer(to, immutables.amount);
        }
        _ethTransfer(msg.sender, immutables.safetyDeposit);
        emit Withdrawal(secret);
    }
}

// contracts/lib/cross-chain-swap/contracts/EscrowSrc.sol

/**
 * @title Source Escrow contract for cross-chain atomic swap.
 * @notice Contract to initially lock funds and then unlock them with verification of the secret presented.
 * @dev Funds are locked in at the time of contract deployment. For this Limit Order Protocol
 * calls the `EscrowFactory.postInteraction` function.
 * To perform any action, the caller must provide the same Immutables values used to deploy the clone contract.
 * @custom:security-contact security@1inch.io
 */
contract EscrowSrc is Escrow, IEscrowSrc {
    using AddressLib for Address;
    using ImmutablesLib for Immutables;
    using SafeERC20 for IERC20;
    using TimelocksLib for Timelocks;

    constructor(uint32 rescueDelay) BaseEscrow(rescueDelay) {}

    /**
     * @notice See {IBaseEscrow-withdraw}.
     * @dev The function works on the time interval highlighted with capital letters:
     * ---- contract deployed --/-- finality --/-- PRIVATE WITHDRAWAL --/-- PUBLIC WITHDRAWAL --/--
     * --/-- private cancellation --/-- public cancellation ----
     */
    function withdraw(bytes32 secret, Immutables calldata immutables)
        external
        onlyTaker(immutables)
        onlyAfter(immutables.timelocks.get(TimelocksLib.Stage.SrcWithdrawal))
        onlyBefore(immutables.timelocks.get(TimelocksLib.Stage.SrcCancellation))
    {
        _withdrawTo(secret, msg.sender, immutables);
    }

    /**
     * @notice See {IEscrowSrc-withdrawTo}.
     * @dev The function works on the time interval highlighted with capital letters:
     * ---- contract deployed --/-- finality --/-- PRIVATE WITHDRAWAL --/-- PUBLIC WITHDRAWAL --/--
     * --/-- private cancellation --/-- public cancellation ----
     */
    function withdrawTo(bytes32 secret, address target, Immutables calldata immutables)
        external
        onlyTaker(immutables)
        onlyAfter(immutables.timelocks.get(TimelocksLib.Stage.SrcWithdrawal))
        onlyBefore(immutables.timelocks.get(TimelocksLib.Stage.SrcCancellation))
    {
        _withdrawTo(secret, target, immutables);
    }

    /**
     * @notice See {IEscrowSrc-publicWithdraw}.
     * @dev The function works on the time interval highlighted with capital letters:
     * ---- contract deployed --/-- finality --/-- private withdrawal --/-- PUBLIC WITHDRAWAL --/--
     * --/-- private cancellation --/-- public cancellation ----
     */
    function publicWithdraw(bytes32 secret, Immutables calldata immutables)
        external
        onlyAfter(immutables.timelocks.get(TimelocksLib.Stage.SrcPublicWithdrawal))
        onlyBefore(immutables.timelocks.get(TimelocksLib.Stage.SrcCancellation))
    {
        _withdrawTo(secret, immutables.taker.get(), immutables);
    }

    /**
     * @notice See {IBaseEscrow-cancel}.
     * @dev The function works on the time intervals highlighted with capital letters:
     * ---- contract deployed --/-- finality --/-- private withdrawal --/-- public withdrawal --/--
     * --/-- PRIVATE CANCELLATION --/-- PUBLIC CANCELLATION ----
     */
    function cancel(Immutables calldata immutables)
        external
        onlyTaker(immutables)
        onlyAfter(immutables.timelocks.get(TimelocksLib.Stage.SrcCancellation))
    {
        _cancel(immutables);
    }

    /**
     * @notice See {IEscrowSrc-publicCancel}.
     * @dev The function works on the time intervals highlighted with capital letters:
     * ---- contract deployed --/-- finality --/-- private withdrawal --/-- public withdrawal --/--
     * --/-- private cancellation --/-- PUBLIC CANCELLATION ----
     */
    function publicCancel(Immutables calldata immutables)
        external
        onlyAfter(immutables.timelocks.get(TimelocksLib.Stage.SrcPublicCancellation))
    {
        _cancel(immutables);
    }

    /**
     * @dev Transfers ERC20 tokens to the target and native tokens to the caller.
     * @param secret The secret that unlocks the escrow.
     * @param target The address to transfer ERC20 tokens to.
     * @param immutables The immutable values used to deploy the clone contract.
     */
    function _withdrawTo(bytes32 secret, address target, Immutables calldata immutables)
        internal
        onlyValidImmutables(immutables)
        onlyValidSecret(secret, immutables)
    {
        IERC20(immutables.token.get()).safeTransfer(target, immutables.amount);
        _ethTransfer(msg.sender, immutables.safetyDeposit);
        emit Withdrawal(secret);
    }

    /**
     * @dev Transfers ERC20 tokens to the maker and native tokens to the caller.
     * @param immutables The immutable values used to deploy the clone contract.
     */
    function _cancel(Immutables calldata immutables) internal onlyValidImmutables(immutables) {
        IERC20(immutables.token.get()).safeTransfer(immutables.maker.get(), immutables.amount);
        _ethTransfer(msg.sender, immutables.safetyDeposit);
        emit EscrowCancelled();
    }
}

// contracts/lib/cross-chain-swap/lib/limit-order-settlement/contracts/extensions/ResolverValidationExtension.sol

/**
 * @title Resolver Validation Extension
 * @notice This abstract contract combines functionalities to enhance security and compliance in the order execution process.
 * Ensures that only transactions from whitelisted resolvers or resolvers who own specific accessToken are processed within the post-interaction phase of order execution.
 * Additionally, it allows charging a fee to resolvers in the `postInteraction` method, providing a mechanism for resolver fee management.
 */
abstract contract ResolverValidationExtension is BaseExtension, FeeBankCharger {
    using ExtensionLib_0 for bytes;

    error ResolverCanNotFillOrder();

    uint256 private constant _ORDER_FEE_BASE_POINTS = 1e15;
    /// @notice Contract address whose tokens allow filling limit orders with a fee for resolvers that are outside the whitelist
    IERC20 private immutable _ACCESS_TOKEN;

    constructor(IERC20 feeToken, IERC20 accessToken, address owner) FeeBankCharger(feeToken, owner) {
        _ACCESS_TOKEN = accessToken;
    }

    /**
     * @dev Validates whether the resolver is whitelisted.
     * @param allowedTime The time after which interaction with the order is allowed.
     * @param whitelist Whitelist is tightly packed struct of the following format:
     * ```
     * (bytes10,bytes2)[N] resolversAddressesAndTimeDeltas;
     * ```
     * Resolvers in the list are sorted in ascending order by the time when they are allowed to interact with the order.
     * Time deltas represent the time in seconds between the adjacent resolvers.
     * Only 10 lowest bytes of the resolver address are used for comparison.
     * @param whitelistSize The amount of resolvers in the whitelist.
     * @param resolver The resolver to check.
     * @return Whether the resolver is whitelisted.
     */
    function _isWhitelisted(uint256 allowedTime, bytes calldata whitelist, uint256 whitelistSize, address resolver) internal view virtual returns (bool) {
        unchecked {
            uint80 maskedResolverAddress = uint80(uint160(resolver));
            for (uint256 i = 0; i < whitelistSize; i++) {
                uint80 whitelistedAddress = uint80(bytes10(whitelist[:10]));
                allowedTime += uint16(bytes2(whitelist[10:12])); // add next time delta
                if (maskedResolverAddress == whitelistedAddress) {
                    return allowedTime <= block.timestamp;
                } else if (allowedTime > block.timestamp) {
                    return false;
                }
                whitelist = whitelist[12:];
            }
            return false;
        }
    }

    /**
     * @dev Calculates the resolver fee.
     * @param fee Scaled resolver fee.
     * @param orderMakingAmount Making amount from the order.
     * @param actualMakingAmount Making amount that was actually filled.
     * @return resolverFee Calculated resolver fee.
     */
    function _getResolverFee(
        uint256 fee,
        uint256 orderMakingAmount,
        uint256 actualMakingAmount
    ) internal pure virtual returns(uint256) {
        return fee * _ORDER_FEE_BASE_POINTS * actualMakingAmount / orderMakingAmount;
    }

    /**
     * @param extraData Structured data of length n bytes, segmented as follows:
     * [0:4] - Resolver fee information.
     * [4:8] - The time after which interaction with the order is allowed.
     * [8:k] - Data as defined by the `whitelist` parameter for the `_isWhitelisted` method,
     *         where k depends on the amount of resolvers in the whitelist, as indicated by the bitmap in the last byte.
     * [k:n] - ExtraData for other extensions, not utilized by this validation extension.
     * [n] - Bitmap indicating various usage flags and values.
     *       The bitmask xxxx xxx1 signifies resolver fee usage.
     *       The bitmask VVVV Vxxx represents the number of resolvers in the whitelist, where the V bits denote the count of resolvers.
     *       The remaining bits in this bitmap are not used by this extension.
     */
    function _postInteraction(
        IOrderMixin.Order calldata order,
        bytes calldata extension,
        bytes32 orderHash,
        address taker,
        uint256 makingAmount,
        uint256 takingAmount,
        uint256 remainingMakingAmount,
        bytes calldata extraData
    ) internal virtual override {
        bool feeEnabled = extraData.resolverFeeEnabled();
        uint256 resolversCount = extraData.resolversCount();
        unchecked {
            uint256 resolverFee;
            if (feeEnabled) {
                resolverFee = _getResolverFee(uint256(uint32(bytes4(extraData[:4]))), order.makingAmount, makingAmount);
                extraData = extraData[4:];
            }

            uint256 allowedTime = uint32(bytes4(extraData[0:4]));
            extraData = extraData[4:];
            uint256 whitelistSize = resolversCount * 12;
            if (!_isWhitelisted(allowedTime, extraData[:whitelistSize], resolversCount, taker)) { // resolversCount always > 0 on prod
                if (allowedTime > block.timestamp || _ACCESS_TOKEN.balanceOf(taker) == 0) revert ResolverCanNotFillOrder();
                if (feeEnabled) {
                    _chargeFee(taker, resolverFee);
                }
            }
            super._postInteraction(order, extension, orderHash, taker, makingAmount, takingAmount, remainingMakingAmount, extraData[whitelistSize:]);
        }
    }
}

// contracts/lib/cross-chain-swap/contracts/BaseEscrowFactory.sol

/**
 * @title Abstract contract for escrow factory
 * @notice Contract to create escrow contracts for cross-chain atomic swap.
 * @dev Immutable variables must be set in the constructor of the derived contracts.
 * @custom:security-contact security@1inch.io
 */
abstract contract BaseEscrowFactory is IEscrowFactory, ResolverValidationExtension, MerkleStorageInvalidator {
    using AddressLib for Address;
    using Clones for address;
    using ImmutablesLib for IBaseEscrow.Immutables;
    using SafeERC20 for IERC20;
    using TimelocksLib for Timelocks;

    /// @notice See {IEscrowFactory-ESCROW_SRC_IMPLEMENTATION}.
    address public immutable ESCROW_SRC_IMPLEMENTATION;
    /// @notice See {IEscrowFactory-ESCROW_DST_IMPLEMENTATION}.
    address public immutable ESCROW_DST_IMPLEMENTATION;
    bytes32 internal immutable _PROXY_SRC_BYTECODE_HASH;
    bytes32 internal immutable _PROXY_DST_BYTECODE_HASH;

    /**
     * @notice Creates a new escrow contract for maker on the source chain.
     * @dev The caller must be whitelisted and pre-send the safety deposit in a native token
     * to a pre-computed deterministic address of the created escrow.
     * The external postInteraction function call will be made from the Limit Order Protocol
     * after all funds have been transferred. See {IPostInteraction-postInteraction}.
     * `extraData` consists of:
     *   - ExtraDataArgs struct
     *   - whitelist
     *   - 0 / 4 bytes for the fee
     *   - 1 byte for the bitmap
     */
    function _postInteraction(
        IOrderMixin.Order calldata order,
        bytes calldata extension,
        bytes32 orderHash,
        address taker,
        uint256 makingAmount,
        uint256 takingAmount,
        uint256 remainingMakingAmount,
        bytes calldata extraData
    ) internal override(ResolverValidationExtension) {
        uint256 superArgsLength = extraData.length - SRC_IMMUTABLES_LENGTH;
        super._postInteraction(
            order, extension, orderHash, taker, makingAmount, takingAmount, remainingMakingAmount, extraData[:superArgsLength]
        );

        ExtraDataArgs calldata extraDataArgs;
        assembly ("memory-safe") {
            extraDataArgs := add(extraData.offset, superArgsLength)
        }

        bytes32 hashlock;

        if (MakerTraitsLib.allowMultipleFills(order.makerTraits)) {
            uint256 partsAmount = uint256(extraDataArgs.hashlockInfo) >> 240;
            if (partsAmount < 2) revert InvalidSecretsAmount();
            bytes32 key = keccak256(abi.encodePacked(orderHash, uint240(uint256(extraDataArgs.hashlockInfo))));
            ValidationData memory validated = lastValidated[key];
            hashlock = validated.leaf;
            if (!_isValidPartialFill(makingAmount, remainingMakingAmount, order.makingAmount, partsAmount, validated.index)) {
                revert InvalidPartialFill();
            }
        } else {
            hashlock = extraDataArgs.hashlockInfo;
        }

        IBaseEscrow.Immutables memory immutables = IBaseEscrow.Immutables({
            orderHash: orderHash,
            hashlock: hashlock,
            maker: order.maker,
            taker: Address.wrap(uint160(taker)),
            token: order.makerAsset,
            amount: makingAmount,
            safetyDeposit: extraDataArgs.deposits >> 128,
            timelocks: extraDataArgs.timelocks.setDeployedAt(block.timestamp)
        });

        DstImmutablesComplement memory immutablesComplement = DstImmutablesComplement({
            maker: order.receiver.get() == address(0) ? order.maker : order.receiver,
            amount: takingAmount,
            token: extraDataArgs.dstToken,
            safetyDeposit: extraDataArgs.deposits & type(uint128).max,
            chainId: extraDataArgs.dstChainId
        });

        emit SrcEscrowCreated(immutables, immutablesComplement);

        bytes32 salt = immutables.hashMem();
        address escrow = _deployEscrow(salt, 0, ESCROW_SRC_IMPLEMENTATION);
        if (escrow.balance < immutables.safetyDeposit || IERC20(order.makerAsset.get()).safeBalanceOf(escrow) < makingAmount) {
            revert InsufficientEscrowBalance();
        }
    }

    /**
     * @notice See {IEscrowFactory-createDstEscrow}.
     */
    function createDstEscrow(IBaseEscrow.Immutables calldata dstImmutables, uint256 srcCancellationTimestamp) external payable {
        address token = dstImmutables.token.get();
        uint256 nativeAmount = dstImmutables.safetyDeposit;
        if (token == address(0)) {
            nativeAmount += dstImmutables.amount;
        }
        if (msg.value != nativeAmount) revert InsufficientEscrowBalance();

        IBaseEscrow.Immutables memory immutables = dstImmutables;
        immutables.timelocks = immutables.timelocks.setDeployedAt(block.timestamp);
        // Check that the escrow cancellation will start not later than the cancellation time on the source chain.
        if (immutables.timelocks.get(TimelocksLib.Stage.DstCancellation) > srcCancellationTimestamp) revert InvalidCreationTime();

        bytes32 salt = immutables.hashMem();
        address escrow = _deployEscrow(salt, msg.value, ESCROW_DST_IMPLEMENTATION);
        if (token != address(0)) {
            IERC20(token).safeTransferFrom(msg.sender, escrow, immutables.amount);
        }

        emit DstEscrowCreated(escrow, dstImmutables.hashlock, dstImmutables.taker);
    }

    /**
     * @notice See {IEscrowFactory-addressOfEscrowSrc}.
     */
    function addressOfEscrowSrc(IBaseEscrow.Immutables calldata immutables) external view virtual returns (address) {
        return Create2.computeAddress(immutables.hash(), _PROXY_SRC_BYTECODE_HASH);
    }

    /**
     * @notice See {IEscrowFactory-addressOfEscrowDst}.
     */
    function addressOfEscrowDst(IBaseEscrow.Immutables calldata immutables) external view virtual returns (address) {
        return Create2.computeAddress(immutables.hash(), _PROXY_DST_BYTECODE_HASH);
    }

    /**
     * @notice Deploys a new escrow contract.
     * @param salt The salt for the deterministic address computation.
     * @param value The value to be sent to the escrow contract.
     * @param implementation Address of the implementation.
     * @return escrow The address of the deployed escrow contract.
     */
    function _deployEscrow(bytes32 salt, uint256 value, address implementation) internal virtual returns (address escrow) {
        escrow = implementation.cloneDeterministic(salt, value);
    }

    function _isValidPartialFill(
        uint256 makingAmount,
        uint256 remainingMakingAmount,
        uint256 orderMakingAmount,
        uint256 partsAmount,
        uint256 validatedIndex
    ) internal pure returns (bool) {
        uint256 calculatedIndex = (orderMakingAmount - remainingMakingAmount + makingAmount - 1) * partsAmount / orderMakingAmount;

        if (remainingMakingAmount == makingAmount) {
            // The last secret must be used for the last fill.
            return (calculatedIndex + 2 == validatedIndex);
        } else if (orderMakingAmount != remainingMakingAmount) {
            // Calculate the previous fill index only if this is not the first fill.
            uint256 prevCalculatedIndex = (orderMakingAmount - remainingMakingAmount - 1) * partsAmount / orderMakingAmount;
            if (calculatedIndex == prevCalculatedIndex) return false;
        }

        return calculatedIndex + 1 == validatedIndex;
    }
}

// contracts/lib/cross-chain-swap/contracts/EscrowFactory.sol

/**
 * @title Escrow Factory contract
 * @notice Contract to create escrow contracts for cross-chain atomic swap.
 * @custom:security-contact security@1inch.io
 */
contract EscrowFactory is BaseEscrowFactory {
    constructor(
        address limitOrderProtocol,
        IERC20 feeToken,
        IERC20 accessToken,
        address owner,
        uint32 rescueDelaySrc,
        uint32 rescueDelayDst
    )
    BaseExtension(limitOrderProtocol)
    ResolverValidationExtension(feeToken, accessToken, owner)
    MerkleStorageInvalidator(limitOrderProtocol) {
        ESCROW_SRC_IMPLEMENTATION = address(new EscrowSrc(rescueDelaySrc));
        ESCROW_DST_IMPLEMENTATION = address(new EscrowDst(rescueDelayDst));
        _PROXY_SRC_BYTECODE_HASH = ProxyHashLib.computeProxyBytecodeHash(ESCROW_SRC_IMPLEMENTATION);
        _PROXY_DST_BYTECODE_HASH = ProxyHashLib.computeProxyBytecodeHash(ESCROW_DST_IMPLEMENTATION);
    }
}

