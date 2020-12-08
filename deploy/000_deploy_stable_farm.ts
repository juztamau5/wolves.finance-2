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

  // Deploy lenders
  await diamond.deploy('DiamondAaveLender', {
    from: deployer,
    owner: deployer, // TODO: diamondAdmin
    log: true,
    deterministicDeployment: true,

    // TODO: hardhat-deploy doesn't support qualified names
    facets: ['AaveLender'],

    // Has to be a non-zero 32bytes string (in hex format)
    // TODO
    deterministicSalt:
      '0x0000000000000000000000000000000000000000000000000000000000000002',
  });

  await diamond.deploy('DiamondCompoundLender', {
    from: deployer,
    owner: deployer, // TODO: diamondAdmin
    log: true,
    deterministicDeployment: true,

    // TODO: hardhat-deploy doesn't support qualified names
    facets: ['CompoundLender'],

    // Has to be a non-zero 32bytes string (in hex format)
    // TODO
    deterministicSalt:
      '0x0000000000000000000000000000000000000000000000000000000000000003',
  });

  await diamond.deploy('DiamonddYdXLender', {
    from: deployer,
    owner: deployer, // TODO: diamondAdmin
    log: true,
    deterministicDeployment: true,

    // TODO: hardhat-deploy doesn't support qualified names
    facets: ['dYdXLender'],

    // Has to be a non-zero 32bytes string (in hex format)
    // TODO
    deterministicSalt:
      '0x0000000000000000000000000000000000000000000000000000000000000004',
  });

  await diamond.deploy('DiamondFulcrumLender', {
    from: deployer,
    owner: deployer, // TODO: diamondAdmin
    log: true,
    deterministicDeployment: true,

    // TODO: hardhat-deploy doesn't support qualified names
    facets: ['FulcrumLender'],

    // Has to be a non-zero 32bytes string (in hex format)
    // TODO
    deterministicSalt:
      '0x0000000000000000000000000000000000000000000000000000000000000005',
  });

  // Deploy Controller
  await diamond.deploy('DiamondController', {
    from: deployer,
    owner: deployer, // TODO: diamondAdmin
    log: true,
    deterministicDeployment: true,

    // TODO: hardhat-deploy doesn't support qualified names
    facets: ['Controller'],

    // Has to be a non-zero 32bytes string (in hex format)
    // TODO
    deterministicSalt:
      '0x0000000000000000000000000000000000000000000000000000000000000006',
  });

  // Deploy Stable Farm
  await diamond.deploy('DiamondStableFarm', {
    from: deployer,
    owner: deployer, // TODO: diamondAdmin
    log: true,
    deterministicDeployment: true,

    // TODO: hardhat-deploy doesn't support qualified names
    facets: ['StableCoinFarm'],

    // Has to be a non-zero 32bytes string (in hex format)
    // TODO
    deterministicSalt:
      '0x0000000000000000000000000000000000000000000000000000000000000007',
  });

  /*
  try {
    console.log('Initializing contract');
    await execute(
      'DiamondWolfToken',
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
  */
};

module.exports = func;
func.tags = ['StableFarm'];
