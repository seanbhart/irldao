import { ContractFactory, Contract, ContractReceipt, ContractTransaction, Event } from "@ethersproject/contracts";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { BigNumber, Bytes } from "ethers";
import { ethers } from "hardhat";

import TESTERC721 from "../artifacts/contracts/TESTERC721.sol/TESTERC721.json";

describe("Fund setup", function () {
  let owner: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let addrs: SignerWithAddress[];

  let collectionFactory: ContractFactory;
  let collection: Contract;

  let wrapperFactory: ContractFactory;
  let wrapper: Contract;

  var account2 = ethers.Wallet.createRandom();
  console.log("Fund contracts test");

  before(async function () {
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    console.log("owner address: ", owner.address);

    // Deploy the test ERC721 contract and mint some NFTs
    collectionFactory = await ethers.getContractFactory("TESTERC721");
    collection = await collectionFactory.deploy();
    console.log("collection Address: ", collection.address);

    // Deploy the wrapper ERC721
    wrapperFactory = await ethers.getContractFactory("Wrapper721");
    wrapper = await wrapperFactory.deploy("tmp", "tmp", collection.address);
    console.log("wrapper Address: ", wrapper.address);
  });

  describe("Mint some NFTs", function () {
    it("Should have minted 3 NFTs", async function () {
      await collection.createCollectible();
      const newToken = await collection.tokenURI(0);
      console.log("newCollection ID: ", newToken);

      const counter = await collection.tokenCounter();
      console.log("counter: ", BigNumber.from(counter).toString());
      expect(counter).to.equal(1);
    });

    it("Should wrap token", async function () {
      await wrapper.wrapToken(0);
      const wrapped = await wrapper.wrappedToken(0);
      console.log("wrapped: ", wrapped);

      expect(wrapped).to.equal(1);
    });

    // it("Should show original name in wrapper", async function () {
    //   const wrapperName = await wrapper.name();
    //   const origName = await collection.name();
    //   console.log("wrapper name: ", wrapperName);

    //   expect(wrapperName).to.equal(origName);
    // });
    // it("Should show original symbol in wrapper", async function () {
    //   const wrapperSymbol = await wrapper.symbol();
    //   const origSymbol = await collection.symbol();
    //   console.log("wrapper symbol: ", wrapperSymbol);

    //   expect(wrapperSymbol).to.equal(origSymbol);
    // });

    it("Should show original owner through wrapper", async function () {
      const ownerCheck = await wrapper.ownerOf(0);
      console.log("ownerCheck 0: ", ownerCheck);

      expect(ownerCheck).to.equal(owner.address);
    });
  });

  console.log("test end");
});
