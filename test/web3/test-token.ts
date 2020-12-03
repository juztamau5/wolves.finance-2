/*
 * Copyright (C) 2020 Marquise Stein
 * This file is part of 8bitbot - https://github.com/botocracy/8bitbot
 *
 * SPDX-License-Identifier: Apache-2.0
 * See LICENSE.txt for more information.
 */

import type { SignerWithAddress } from '@nomiclabs/hardhat-ethers/dist/src/signer-with-address';
import chai from 'chai';
import { solidity } from 'ethereum-waffle';

import { hardhat } from '../../src/web3/hardhat';

/* eslint @typescript-eslint/no-explicit-any: "off" */

chai.use(solidity);

// Supress type errors for properties injected by hardhat plugins
const deployEthers: any = hardhat.ethers;

describe('Token contract', function () {
  let owner: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;

  before(async function () {
    this.timeout(10 * 1000);

    // Get the Signers
    [owner, addr1, addr2] = await hardhat.ethers.getSigners();
  });

  beforeEach(async function () {
    this.timeout(10 * 1000);

    await hardhat.deployments.fixture();
  });

  after(async function () {
    this.timeout(10 * 1000);

    await hardhat.deployments.fixture();
  });

  describe('Deployment', function () {
    it('should assign the total supply of tokens to the owner', async function () {
      const contract = await deployEthers.getContract('DiamondToken');

      const ownerBalance = await contract.balanceOf(owner.address);
      console.log(`Owner ${owner.address} has ${ownerBalance} tokens`);
      chai.expect(ownerBalance).to.not.equal(0);

      const totalSupply = await contract.totalSupply();
      console.log(`Total supply is ${totalSupply} tokens`);
      chai.expect(totalSupply).to.equal(ownerBalance);
    });
  });

  describe('Transactions', function () {
    it('should transfer tokens between accounts', async function () {
      const contract = await deployEthers.getContract('DiamondToken');

      // Transfer 50 tokens from owner to addr1
      await contract.transfer(addr1.address, 50);
      const addr1Balance = await contract.balanceOf(addr1.address);
      chai.expect(addr1Balance).to.equal(50);

      // Transfer 50 tokens from addr1 to addr2. Use .connect(signer) to send
      // a transaction from another account
      await contract.connect(addr1).transfer(addr2.address, 50);
      const addr2Balance = await contract.balanceOf(addr2.address);
      chai.expect(addr2Balance).to.equal(50);
    });

    it('should fail if sender doesn’t have enough tokens', async function () {
      const contract = await deployEthers.getContract('DiamondToken');

      const initialOwnerBalance = await contract.balanceOf(owner.address);

      // Try to send 1 token from addr1 (0 tokens) to owner (1000 tokens).
      // `require` will evaluate false and revert the transaction.
      await chai
        .expect(contract.connect(addr1).transfer(owner.address, 1))
        .to.be.revertedWith('ERC20: transfer amount exceeds balance');

      // Owner balance shouldn't have changed
      chai
        .expect(await contract.balanceOf(owner.address))
        .to.equal(initialOwnerBalance);
    });

    it('should update balances after transfers', async function () {
      const contract = await deployEthers.getContract('DiamondToken');

      const initialOwnerBalance = await contract.balanceOf(owner.address);

      // Transfer 100 tokens from owner to addr1
      await contract.transfer(addr1.address, 100);

      // Transfer another 50 tokens from owner to addr2
      await contract.transfer(addr2.address, 50);

      // Check balances
      const finalOwnerBalance = await contract.balanceOf(owner.address);
      chai.expect(finalOwnerBalance).to.equal(initialOwnerBalance - 150);

      const addr1Balance = await contract.balanceOf(addr1.address);
      chai.expect(addr1Balance).to.equal(100);

      const addr2Balance = await contract.balanceOf(addr2.address);
      chai.expect(addr2Balance).to.equal(50);
    });
  });
});
