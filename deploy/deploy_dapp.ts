/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * SPDX-License-Identifier: Apache-2.0
 * See the file LICENSES/README.md for more information.
 */

/* eslint @typescript-eslint/no-var-requires: "off" */

const fs = require('fs');

require('hardhat-deploy');
require('hardhat-deploy-ethers');

// Path to generated addresses.json file
const GENERATED_ADDRESSES = 'src/dapp/config/addresses.json';

// TODO: Qualified names
//const ERC1155_CONTRACT = 'contracts/src/token/Token.sol:WolfToken';
const TOKEN_CONTRACT = 'WolfToken';

const func = async function (hardhat_re) {
  const { deployments, getNamedAccounts } = hardhat_re;

  const { deploy, execute } = deployments;
  const { deployer, teamWallet } = await getNamedAccounts();

  const token_receipt = await deploy(TOKEN_CONTRACT, {
    from: deployer,
    log: true,
    deterministicDeployment: true,

    owner: deployer,

    facets: [TOKEN_CONTRACT],

    // Has to be a non-zero 32bytes string (in hex format)
    // TODO
    deterministicSalt:
      '0x0000000000000000000000000000000000000000000000000000000000000001',

    execute: {
      methodName: 'postUpgrade',
      args: [teamWallet],
    },
  });

  const addresses = {
    token: token_receipt.address.toLowerCase(),
  };

  // Generate addresses.json file
  fs.writeFileSync(GENERATED_ADDRESSES, JSON.stringify(addresses));

  // TODO: Better initialization security
  // TODO: Reinitialization detection
  try {
    console.log('Initializing token contract');
    await execute(
      TOKEN_CONTRACT,
      {
        from: deployer,
        log: true,
      },
      'initialize',
      deployer
    );
  } catch (err) {
    // Verify transaction is reverted due to reinitialization
    if (
      err.message.search('Initializable: contract is already initialized') !==
      -1
    ) {
      console.log(`Reverted (already initialized)`);
    } else {
      throw err;
    }
  }
};

module.exports = func;
func.tags = ['token'];
