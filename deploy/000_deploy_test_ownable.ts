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
  const { deploy } = deployments;

  const { deployer } = await getNamedAccounts();

  await deploy('contracts/test/TestOwnable.sol:TestOwnable', {
    from: deployer,
    args: [deployer],
    log: true,
    deterministicDeployment: true,
  });
};

module.exports = func;
func.tags = ['TestOwnable'];
