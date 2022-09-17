const hre = require("hardhat");
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
const { ethers } = hre;

import {
  InstaFlashResolverArbitrum,
  InstaFlashResolverArbitrum__factory,
} from "../../typechain";

describe("Resolver", function () {
  let Resolver, resolver: InstaFlashResolverArbitrum;
  let signer: SignerWithAddress;

  const USDC = "0xff970a61a04b1ca14834a43f5de4533ebddb5cc8";
  const USDT = "0xfd086bc7cd5c481dcc9c85ebe478a1c0b69fcbb9";

  const Usdc = ethers.utils.parseUnits("5000", 6);
  const Usdt = ethers.utils.parseUnits("5000", 6);

  beforeEach(async function () {
    [signer] = await ethers.getSigners();

    Resolver = new InstaFlashResolverArbitrum__factory(signer);
    resolver = await Resolver.deploy();
    await resolver.deployed();
  });

  it("Should be able to return routes info", async function () {
    console.log((await resolver.getRoutes()).toString());
  });

  it("Should be able to return the best route for flashloan", async function () {
    console.log(
      (await resolver.getBestRoutes([USDC, USDT], [Usdc, Usdt])).toString()
    );
  });

  it("Should be able to return all the data for flashloan", async function () {
    console.log(
      (await resolver.getData([USDC, USDT], [Usdc, Usdt])).toString()
    );
  });
});
