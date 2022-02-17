// SPDX-License-Identifier: MIT

pragma solidity >=0.7.6;


import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @dev Modification of standard ERC721.
 *
 * This implementation does not store token ownership locally,
 * and instead provides a new BaseURI and TokenURI to add additional
 * information to the wrapped ERC721 (NFTs).
 */
contract Wrapper721 is ERC721, Ownable {

    // ERC721 contract to wrap
    address private _wrapped;

    // Mapping wrapped token to 1
    mapping(uint256 => uint256) private _wrappedTokens;

    constructor(string memory name_, string memory symbol_, address wrapped_) ERC721(name_, symbol_) {
        _wrapped = wrapped_;
        // name_ = ERC721(_wrapped).name();
        // symbol_ = ERC721(_wrapped).symbol();
    }

    /**
     * @dev Returns the wrapped nft contract address.
     */
    function wrappedContract() public view virtual returns (address) {
        return _wrapped;
    }

    /**
     * @dev Finds the owner of the tokenId from the wrapped contract.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        require(_wrappedTokens[tokenId] == 1, "Wrapper721: This token is not wrapped");
        // address owner = _owners[tokenId];
        address owner = IERC721(_wrapped).ownerOf(tokenId);
        require(owner != address(0), "Wrapper721: owner query for nonexistent token");
        return owner;
    }

    /**
     * @dev Check if a token has been wrapped.
     */
    function wrappedToken(uint256 tokenId) public view returns (uint256) {
        return _wrappedTokens[tokenId];
    }

    /**
     * @dev Adds this token to the list of wrapped tokens. Must be called by wrapper owner.
     */
    function wrapToken(uint256 tokenId) public onlyOwner returns (uint256) {
        _wrappedTokens[tokenId] = 1;
        return 1;
    }
}