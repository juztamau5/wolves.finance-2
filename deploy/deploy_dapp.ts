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

const func = async function (hardhat_re) {
  const addresses = {};

  // Generate addresses.json file
  fs.writeFileSync(GENERATED_ADDRESSES, JSON.stringify(addresses));
};

module.exports = func;
func.tags = ['token'];
