// MyEpicNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";
import {Base64} from "./libraries/Base64.sol";

/**
〇コントラクトを変更する場合の注意点
- 再度コントラクトをデプロイする
--　npx hardhat run scripts/deploy.js --network goerli
- フロントエンド（App.js）のCONTRACT_ADDRESSを更新する
-ABIファイルを更新する
-- artifacts/contracts/GenerateNFT.sol/GenerateNFT.jsonの中身をfront/src/utils/Generate.jsonに貼り付ける

 */

contract GenerateNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    event NFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("LoveLetterNFT", "LL") {
        console.log("This is my NFT contract.");
    }

    function generateNFT() public {
        uint256 newItemId = _tokenIds.current();
        string
            memory baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
        string memory customWord = "konnnichiwa!";
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, customWord, "</text></svg>")
        );

        console.log("\n--------------------");
        console.log(finalSvg);
        console.log("--------------------\n");

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                    // NFTのタイトルを生成される言葉（例: GrandCuteBird）に設定します。
                    "Love Letter Generative NFT",
                    '", "description": "A Love Letter Collection using ChatGPT.", "image": "data:image/svg+xml;base64,',
                    //  data:image/svg+xml;base64 を追加し、SVG を base64 でエンコードした結果を追加します。
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n----- Token URI ----");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
        _tokenIds.increment();

        emit NFTMinted(msg.sender, newItemId);
    }
}


