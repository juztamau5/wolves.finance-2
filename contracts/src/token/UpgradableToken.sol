/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * SPDX-License-Identifier: Apache-2.0
 * See the file LICENSES/README.md for more information.
 */

pragma solidity ^0.7.4;

import '@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol';
import '@openzeppelin/contracts-upgradeable/proxy/Initializable.sol';

/**
 * @dev A simple contract for a non-upgradable zero-sum ERC 20 token
 *
 * All tokens are minted in the constructor, and all subsequent transactions
 * are zero-sum.
 */
contract UpgradableToken is Initializable, ERC20Upgradeable {
  /**
   * @dev The ERC 20 token name used by wallets to identify the token
   */
  string private constant TOKEN_NAME = 'Token';

  /**
   * @dev The ERC 20 token symbol used as an abbreviation of the token, such
   * as BTC, ETH, AUG or SJCX.
   */
  string private constant TOKEN_SYMBOL = 'WOLF';

  /**
   * @dev The number of decimal places to which the token will be calculated.
   * The most common number of decimals to consider is 18.
   */
  uint8 private constant TOKEN_DECIMALS = 18;

  /**
   * @dev The number of tokens to initially mint
   */
  uint256 private constant INITIAL_SUPPLY = 200; // TODO

  /**
   * @dev Initialize a token instance
   *
   * @param initialOwner The owner to receive the initial minted tokens
   */
  function initialize(address initialOwner) public virtual initializer {
    // Initialize ERC20 base
    __ERC20_init(TOKEN_NAME, TOKEN_SYMBOL);
    _setupDecimals(TOKEN_DECIMALS);

    // Mint initial supply
    _mint(initialOwner, INITIAL_SUPPLY);
  }
}
