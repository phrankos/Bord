import { ethers } from "hardhat";

async function main() {
    const BordToken = await ethers.getContractFactory("BordToken");
    const bordToken = await BordToken.deploy();

    console.log("Waiting for BordToken to be deployed...");
    await bordToken.waitForDeployment();
    console.log("BordToken deployed to:", bordToken.target);

    const Bord = await ethers.getContractFactory("Bord");
    const bord = await Bord.deploy(bordToken.getAddress());

    console.log("Waiting for Bord to be deployed...");
    await bord.waitForDeployment();
    console.log("Bord deployed to:", bord.target);


    // const Bord = await ethers.getContractFactory("Bord");
    // const bord = await Bord.deploy();

    // console.log("Waiting for Bord to be deployed...");
    // await bord.waitForDeployment();
    // console.log("Bord deployed to:", bord.target);
    
    // const BordToken = await ethers.getContractFactory("BordToken");
    // const bordToken = await BordToken.deploy(bord.getAddress());

    // console.log("Waiting for BordToken to be deployed...");
    // await bordToken.waitForDeployment();
    // console.log("BordToken deployed to:", bordToken.target);


    // require("hardhat-ethernal");
    // const hre = require("hardhat");
    // await hre.ethernal.push({
    //     name: "Bord",
    //     address: bord.target,
    //     workspace: "hardhat", // Optional, will override the workspace set in hardhat.config for this call only
    // });
    // await hre.ethernal.push({
    //     name: "BordToken",
    //     address: bordToken.target,
    //     workspace: "hardhat", // Optional, will override the workspace set in hardhat.config for this call only
    // });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});

// npx hardhat run scripts/deploy.ts --network arbitrumSepolia
// npx hardhat run scripts/deploy.ts --network localhost
