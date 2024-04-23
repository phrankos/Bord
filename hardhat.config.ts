import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

import "dotenv/config";

const ARBITRUM_SEPOLIA_URL: string = process.env.ARBITRUM_SEPOLIA_URL ?? "";
const PRIVATE_KEY: string = process.env.PRIVATE_KEY ?? "";

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    arbitrumSepolia: {
      url: ARBITRUM_SEPOLIA_URL,
      accounts: [PRIVATE_KEY],
      chainId: 421614,
    }
  },
  sourcify: {
    enabled: true,
  },
  etherscan: {
    apiKey: "Z5E5HRZPNZVSHGC7BRSISF36H858W539NN",
    customChains: [
      {
        network: "arbsep",
        chainId: 421614,
        urls: {
          apiURL: "https://api-sepolia.arbiscan.io/api",
          browserURL: "https://sepolia.arbiscan.io/",
        },
      },
    ],
  }
};

export default config;