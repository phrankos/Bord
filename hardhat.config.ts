import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-abi-exporter";

import "dotenv/config";

const ARBITRUM_SEPOLIA_URL: string = process.env.ARBITRUM_SEPOLIA_URL ?? "";
const PRIVATE_KEY: string = process.env.PRIVATE_KEY ?? "";

require('hardhat-ethernal');

const config: HardhatUserConfig = {
    solidity: "0.8.24",
    networks: {
        // localhost: {
        //   url: "http://172.26.116.168:8545/",
        //   accounts: {
        //     mnemonic: process.env.SEED_PHRASE,
        //   },
        //   chainId: 1337,
        // },
        hardhat: {
            accounts: {
                mnemonic: process.env.SEED_PHRASE,
            },
            chainId: 1337,
            gas: "auto",
            mining: {
                mempool: {
                    order: "fifo",
                },
            },
        },
        arbitrumSepolia: {
            url: ARBITRUM_SEPOLIA_URL,
            accounts: [PRIVATE_KEY],
            chainId: 421614,
        },
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
    },
    abiExporter: {
        path: "./app/src",
        runOnCompile: true,
        clear: true,
    },
};

export default config;
