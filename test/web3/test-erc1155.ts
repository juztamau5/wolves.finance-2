/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * SPDX-License-Identifier: Apache-2.0
 * See LICENSE.txt for more information.
 */

import chai from 'chai';
import { solidity } from 'ethereum-waffle';

import { hardhat } from '../../src/web3/hardhat';

/* eslint @typescript-eslint/no-explicit-any: "off" */

chai.use(solidity);

// TODO: Qualified names
//const ERC1155_CONTRACT = 'contracts/src/token/ERC1155Token.sol:ERC1155Token';
const ERC1155_CONTRACT = 'DiamondERC1155Token';

// Supress type errors for properties injected by hardhat plugins
const deployEthers: any = hardhat.ethers;

describe('ERC 1155 token contract', function () {
  beforeEach(async function () {
    this.timeout(15 * 1000);

    await hardhat.deployments.fixture();
  });

  after(async function () {
    this.timeout(15 * 1000);

    await hardhat.deployments.fixture();
  });

  it('should deploy the contract', async function () {
    await deployEthers.getContract(ERC1155_CONTRACT);
  });
});
