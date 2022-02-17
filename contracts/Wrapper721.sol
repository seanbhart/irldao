// SPDX-License-Identifier: MIT

pragma solidity >=0.7.6;


// import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @dev Modification of OpenZeppelin's ERC721.
 *
 * This implementation does not store token ownership locally,
 * and instead provides a new BaseURI and TokenURI to add additional
 * information to the wrapped ERC721 (NFTs).
 * 
 * The name and symbol of this wrapper contract should reflect the
 * unique event it signifies.
 */
contract Wrapper721 is Ownable {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping collection address and tokenIds to a wrapped indicator (1)
    mapping(address => mapping(uint256 => uint256)) private _wrappedTokens;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev MOD: Gets the balance of the owner in the specified collection and tokenId
     */
    function balanceOf(address collection, address owner) public view virtual returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        uint256 balance = IERC721(collection).balanceOf(owner);
        return balance;
    }

    /**
     * @dev MOD: Finds the owner of the tokenId from the wrapped contract.
     */
    function ownerOf(address collection, uint256 tokenId) public view virtual returns (address) {
        require(_wrappedTokens[collection][tokenId] == 1, "Wrapper721: This token is not wrapped");
        address owner = IERC721(collection).ownerOf(tokenId);
        require(owner != address(0), "Wrapper721: owner query for nonexistent token");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

     /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(address collection, uint256 tokenId) public view virtual returns (string memory) {
        require(_exists(collection, tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overriden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev MOD: Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(address collection, uint256 tokenId) internal view virtual returns (bool) {
        return _wrappedTokens[collection][tokenId] != 0;
    }

    /**
     * @dev Check if a token has been wrapped.
     */
    function wrappedToken(address collection, uint256 tokenId) public view returns (uint256) {
        require(_wrappedTokens[collection][tokenId] == 1, "Wrapper721: This token is not wrapped");
        return _wrappedTokens[collection][tokenId];
    }

    /**
     * @dev Adds this token to the list of wrapped tokens. Must be called by wrapper owner.
     */
    function wrapToken(address collection, uint256 tokenId) public onlyOwner returns (uint256) {
        _wrappedTokens[collection][tokenId] = 1;
        return 1;
    }
}