/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * SPDX-License-Identifier: Apache-2.0
 * See the file LICENSES/README.md for more information.
 */

/* eslint @typescript-eslint/no-explicit-any: "off" */

require('hardhat-deploy');
require('hardhat-deploy-ethers');

// TODO: Qualified names
//const ERC1155_CONTRACT = 'contracts/src/token/ERC1155Token.sol:ERC1155Token';
const ERC1155_CONTRACT = 'ERC1155Token';

const DAIMOND_ERC1155_CONTRACT = 'DiamondERC1155Token';

const func = async function (hardhat_re) {
  const { deployments, getNamedAccounts } = hardhat_re;

  const { diamond, execute } = deployments;
  const { deployer, teamWallet } = await getNamedAccounts();

  await diamond.deploy(DAIMOND_ERC1155_CONTRACT, {
    from: deployer,
    owner: deployer,
    log: true,
    deterministicDeployment: true,

    facets: [ERC1155_CONTRACT],

    // Has to be a non-zero 32bytes string (in hex format)
    // TODO
    deterministicSalt:
      '0x0000000000000000000000000000000000000000000000000000000000000001',

    execute: {
      methodName: 'postUpgrade',
      args: [],
    },
  });

  try {
    console.log('Initializing contract');
    await execute(
      DAIMOND_ERC1155_CONTRACT,
      {
        from: deployer,
        log: true,
      },
      'initialize',
      teamWallet
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
func.tags = ['erc1155'];
