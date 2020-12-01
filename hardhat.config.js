/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * SPDX-License-Identifier: Apache-2.0
 * See the file LICENSES/README.md for more information.
 */

/* eslint @typescript-eslint/no-var-requires: "off" */

const dotenv = require('dotenv-defaults');

// Inject Hardhat plugins
require('@nomiclabs/hardhat-ethers');
require('@nomiclabs/hardhat-etherscan');
require('hardhat-abi-exporter');
require('hardhat-deploy');
require('hardhat-deploy-ethers');

// See file ".env.defaults" for parameters
dotenv.config();

// Gnosis safe address. Receives initial token supplies.
const TEAM_WALLET_ADDRESS = '0x7Df8c0E18c6103B1f5037032ca02A960cd4F67E4';

// Environment secrets
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
const GOERLI_PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY;
const INFURA_API_KEY = process.env.INFURA_API_KEY;
const KOVAN_PRIVATE_KEY = process.env.KOVAN_PRIVATE_KEY;
const RINKEBY_PRIVATE_KEY = process.env.RINKEBY_PRIVATE_KEY;
const ROPSTEN_PRIVATE_KEY = process.env.ROPSTEN_PRIVATE_KEY;

const config = {
  namedAccounts: {
    deployer: {
      // By default take the first account as deployer
      default: 0,

      // Similarly on mainnet, take the first account as deployer. Note though
      // that depending on how hardhat network are configured, the account 0 on
      // one network can be different than on another.
      1: 0,
    },
    teamWallet: {
      // By default take the second account as team wallet
      default: 1,

      // Specify account on testnets
      goerli: TEAM_WALLET_ADDRESS,
      kovan: TEAM_WALLET_ADDRESS,
      rinkeby: TEAM_WALLET_ADDRESS,
      ropsten: TEAM_WALLET_ADDRESS,
    },
  },
  solidity: {
    compilers: [
      {
        version: '0.7.4',
        settings: {
          evmVersion: 'berlin',
          optimizer: {
            enabled: true,
            runs: 1000000,
            details: {
              yul: true,
              deduplicate: true,
              cse: true,
              constantOptimizer: true,
            },
          },
        },
      },
      {
        version: '0.6.5',
        settings: {
          evmVersion: 'berlin',
          optimizer: {
            enabled: true,
            runs: 1000000,
            details: {
              yul: true,
              deduplicate: true,
              cse: true,
              constantOptimizer: true,
            },
          },
        },
      },
    ],
  },
  loggingEnabled: true,
  defaultNetwork: 'hardhat',
  networks: {
    hardhat: {
      tags: ['test', 'local'],
    },
    localhost: {
      url: 'http://localhost:8545',
      tags: ['local'],
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY],
      tags: ['staging'],
    },
    kovan: {
      url: `https://kovan.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [KOVAN_PRIVATE_KEY],
      tags: ['staging'],
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [RINKEBY_PRIVATE_KEY],
      tags: ['staging'],
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${INFURA_API_KEY}`,
      accounts: [ROPSTEN_PRIVATE_KEY],
      tags: ['staging'],
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
  },
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts',

    // Contains the deploy script that are executed upon invocation of
    // `hardhat deploy` or `hardhat node`
    deploy: './deploy',

    // Contains the resulting deployments (contract addresses along their ABI,
    // bytecode, metadata...)
    deployments: './deployments',

    // Contains artifacts that were pre-compiled. Useful if you want to upgrade
    // to a new solidity version but want to keep using previously compiled
    // contracts.
    imports: 'imports',
  },
  abiExporter: {
    // Path to ABI export directory (relative to Hardhat root)
    path: './src/abi',

    // Whether to delete old files in path
    clear: true,
  },
};

module.exports = config;
