/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * SPDX-License-Identifier: Apache-2.0
 * See the file LICENSES/README.md for more information.
 */

/* eslint @typescript-eslint/no-var-requires: "off" */

require('hardhat-deploy');
require('hardhat-deploy-ethers');

// TODO: Qualified names
//const ERC1155_CONTRACT = 'contracts/src/token/Token.sol:WolfToken';
const TOKEN_CONTRACT = 'WolfToken';

const func = async function (hardhat_re) {
  const { deployments, getNamedAccounts } = hardhat_re;

  const { deploy } = deployments;
  const { deployer, teamWallet } = await getNamedAccounts();

  await deploy(TOKEN_CONTRACT, {
    from: deployer,
    args: [teamWallet],
    log: true,
    deterministicDeployment: true,

    /* TODO: Diamond upgradeability support
    owner: deployer,

    facets: [TOKEN_CONTRACT],

    // Has to be a non-zero 32bytes string (in hex format)
    // TODO
    deterministicSalt:
      '0x0000000000000000000000000000000000000000000000000000000000000001',

    execute: {
      methodName: 'postUpgrade',
      args: [],
    },
    */
  });
};

module.exports = func;
func.tags = ['token'];
