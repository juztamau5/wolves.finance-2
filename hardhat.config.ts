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
require('@nomiclabs/hardhat-waffle');
require('hardhat-deploy');
require('hardhat-deploy-ethers');

// See file ".env.defaults" for parameters
dotenv.config();

// Enable solidity-coverage
require('solidity-coverage');

const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
const GOERLI_PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY;
const HARDHAT_NETWORK = process.env.HARDHAT_NETWORK || 'hardhat';
const INFURA_API_KEY = process.env.INFURA_API_KEY;
const KOVAN_PRIVATE_KEY = process.env.KOVAN_PRIVATE_KEY;
const MNEMONIC = process.env.MNEMONIC;
const RINKEBY_PRIVATE_KEY = process.env.RINKEBY_PRIVATE_KEY;
const ROPSTEN_PRIVATE_KEY = process.env.ROPSTEN_PRIVATE_KEY;

/**
 * You need to export an object to set up your config. Go to
 * https://hardhat.org/config/ to learn more.
 *
 * @type import('hardhat/config').HardhatUserConfig
 */
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
  defaultNetwork: HARDHAT_NETWORK,
  networks: {
    hardhat: {
      accounts: {
        mnemonic: MNEMONIC,
      },
      tags: ['test', 'local'],
    },
    localhost: {
      url: 'http://localhost:8545',
      accounts: {
        mnemonic: MNEMONIC,
        accountsBalance: 10000, // ETH
      },
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
    coverage: {
      url: 'http://127.0.0.1:8555', // Coverage launches its own ganache-cli client
      tags: ['local'],
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
};

module.exports = config;
