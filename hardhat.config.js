/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * SPDX-License-Identifier: Apache-2.0
 * See the file LICENSES/README.md for more information.
 */

// Inject Hardhat plugins
require('@nomiclabs/hardhat-ethers');
require('hardhat-abi-exporter');
require('hardhat-deploy');
require('hardhat-deploy-ethers');

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
