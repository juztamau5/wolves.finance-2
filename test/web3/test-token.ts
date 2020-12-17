/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * SPDX-License-Identifier: Apache-2.0
 * See LICENSE.txt for more information.
 */

/* eslint @typescript-eslint/no-explicit-any: "off" */
/* eslint @typescript-eslint/no-unused-vars: "off" */

import type { SignerWithAddress } from '@nomiclabs/hardhat-ethers/dist/src/signer-with-address';
import chai from 'chai';
import { solidity } from 'ethereum-waffle';

import { hardhat } from '../../src/web3/hardhat';

chai.use(solidity);

// TODO: Qualified names
//const ERC1155_CONTRACT = 'contracts/src/token/Token.sol:WolfToken';
const TOKEN_CONTRACT = 'WolfToken';

// Supress type errors for properties injected by hardhat plugins
const deployEthers: any = hardhat.ethers;

describe('Token contract', function () {
  let owner: SignerWithAddress;
  let teamWalletAddress: string;

  before(async function () {
    this.timeout(10 * 1000);

    // Get the Signers
    [owner] = await hardhat.ethers.getSigners();

    // Get the team wallet
    const { teamWallet } = await hardhat.getNamedAccounts();
    teamWalletAddress = teamWallet;
  });

  beforeEach(async function () {
    this.timeout(15 * 1000);

    await hardhat.deployments.fixture();
  });

  after(async function () {
    this.timeout(15 * 1000);

    await hardhat.deployments.fixture();
  });

  it('should assign the total supply of tokens to the team', async function () {
    const contract = await deployEthers.getContract(TOKEN_CONTRACT);

    const balance = await contract.balanceOf(teamWalletAddress);
    console.log(`Team wallet ${owner.address} has ${balance} tokens`);
    chai.expect(balance).to.not.equal(0);
  });
});
