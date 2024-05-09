import { ethers } from "hardhat";

async function main() {
  const Bord = await ethers.getContractFactory("Bord");
  const bord = await Bord.deploy();
  // const bord = await ethers.deployContract("Bord", [tokenAddress]);
  await bord.waitForDeployment();
  console.log(
    ` deployed Bord to ${bord.target}`
  );

  require('hardhat-ethernal');
  const hre = require("hardhat");
  await hre.ethernal.push({
    name: 'Bord',
    address: bord.target,
    workspace: 'hardhat' // Optional, will override the workspace set in hardhat.config for this call only
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

// npx hardhat run scripts/deploy.ts --network arbitrumSepolia