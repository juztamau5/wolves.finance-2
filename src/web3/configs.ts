/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * This file is derived from the 0x Starter Project, available under
 * the Apache 2.0 license. https://github.com/0xProject/0x-starter-project
 *
 * SPDX-License-Identifier: Apache-2.0
 * See the file LICENSES/README.md for more information.
 */

import {
  GANACHE_NETWORK_ID,
  KOVAN_NETWORK_ID,
  RINKEBY_NETWORK_ID,
  ROPSTEN_NETWORK_ID,
} from './constants';
import { INFURA_API_KEY } from './environment';
import { NetworkSpecificConfigs } from './types';

export const TX_DEFAULTS = { gas: 800000, gasPrice: 1000000000 };
export const BASE_DERIVATION_PATH = `44'/60'/0'/0`;
export const GANACHE_CONFIGS: NetworkSpecificConfigs = {
  rpcUrl: 'http://127.0.0.1:8545',
  networkId: GANACHE_NETWORK_ID,
  chainId: 1337,
};
export const KOVAN_CONFIGS: NetworkSpecificConfigs = {
  rpcUrl: `https://kovan.infura.io/v3/${INFURA_API_KEY}`,
  networkId: KOVAN_NETWORK_ID,
  chainId: KOVAN_NETWORK_ID,
};
export const ROPSTEN_CONFIGS: NetworkSpecificConfigs = {
  rpcUrl: `https://ropsten.infura.io/v3/${INFURA_API_KEY}`,
  networkId: ROPSTEN_NETWORK_ID,
  chainId: ROPSTEN_NETWORK_ID,
};
export const RINKEBY_CONFIGS: NetworkSpecificConfigs = {
  rpcUrl: `https://rinkeby.infura.io/v3/${INFURA_API_KEY}`,
  networkId: RINKEBY_NETWORK_ID,
  chainId: RINKEBY_NETWORK_ID,
};
export const NETWORK_CONFIGS = ROPSTEN_CONFIGS; // TODO: Change to mainnet
