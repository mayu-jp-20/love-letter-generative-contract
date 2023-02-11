// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import {Base64} from "./libraries/Base64.sol";


contract GenerateNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    event NFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("LoveLetterNFT", "LL") {
        console.log("This is my NFT contract.");
    }

    function generateNFT(string memory sentence) public {
        uint256 newItemId = _tokenIds.current();
        string
            memory baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><rect width='100%' height='100%' fill='white' /><text x='0' y='0' font-size='7px'><tspan x='0' dy='1.2em'>";
        string memory customWord = sentence;
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, customWord, "</tspan></text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                    "Love Letter Generative NFT",
                    '", "description": "A Love Letter Collection using ChatGPT.", "image": "data:image/svg+xml;base64,',
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        _tokenIds.increment();

        emit NFTMinted(msg.sender, newItemId);
    }
}


