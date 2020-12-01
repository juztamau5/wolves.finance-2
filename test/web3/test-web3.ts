/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * SPDX-License-Identifier: Apache-2.0
 * See the file LICENSES/README.md for more information.
 */

/* eslint @typescript-eslint/no-unused-expressions: "off" */

import chai from 'chai';

import { NETWORK_CONFIGS } from '../../src/web3/configs';
import {
  GANACHE_NETWORK_ID,
  KOVAN_NETWORK_ID,
  NULL_ADDRESS,
  RINKEBY_NETWORK_ID,
  ROPSTEN_NETWORK_ID,
} from '../../src/web3/constants';
import { MNEMONIC, RINKEBY_PRIVATE_KEY } from '../../src/web3/environment';
import { hardhat } from '../../src/web3/hardhat';
import { getNetworkName } from '../../src/web3/utils';

describe('web3', function () {
  it('should test config', async function () {
    const networkId = NETWORK_CONFIGS.networkId;

    chai.expect(networkId).to.be.a('number');
  });

  it('should test constants', async function () {
    chai.expect(NULL_ADDRESS).to.be.a('string');
    chai.expect(GANACHE_NETWORK_ID).to.be.a('number');
    chai.expect(KOVAN_NETWORK_ID).to.be.a('number');
    chai.expect(RINKEBY_NETWORK_ID).to.be.a('number');
    chai.expect(ROPSTEN_NETWORK_ID).to.be.a('number');
  });

  it('should test environment', async function () {
    chai.expect(MNEMONIC).to.be.a('string');
    chai.expect(RINKEBY_PRIVATE_KEY).to.be.a('string');
  });

  it('should test hardhat', async function () {
    this.timeout(4 * 2000);

    chai.expect(hardhat).to.not.be.undefined;
    chai.expect(hardhat.ethers).to.be.an('object');
  });

  it('should test utils', async function () {
    const networkId = NETWORK_CONFIGS.networkId;

    chai.expect(getNetworkName(networkId)).to.be.a('string');
  });
});
