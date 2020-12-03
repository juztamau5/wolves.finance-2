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

const func = async function (hardhat_re: any) {
  const { deployments, getNamedAccounts } = hardhat_re;

  const { diamond, execute } = deployments;
  const { deployer } = await getNamedAccounts();

  await diamond.deploy('DiamondToken', {
    from: deployer,
    owner: deployer, // TODO: diamondAdmin
    log: true,
    deterministicDeployment: true,

    facets: ['contracts/src/token/UpgradableToken.sol:UpgradableToken'],

    // Has to be a non-zero 32bytes string (in hex format)
    // TODO
    deterministicSalt:
      '0x0000000000000000000000000000000000000000000000000000000000000001',

    execute: {
      methodName: 'initialize',
      args: [deployer],
    },
  });

  try {
    console.log('Initializing contract');
    await execute(
      'DiamondToken',
      {
        from: deployer,
        log: true,
      },
      'initialize',
      deployer
    );
  } catch (err) {
    // TODO: Verify transaction is reverted with:
    // "Initializable: contract is already initialized"

    console.log('Reverted (already initialized)');
  }
};

module.exports = func;
func.tags = ['Token'];
