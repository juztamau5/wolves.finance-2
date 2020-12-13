/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * SPDX-License-Identifier: Apache-2.0
 * See the file LICENSES/README.md for more information.
 */

pragma solidity >=0.7.0 <0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20Capped.sol';
import '@openzeppelin/contracts/access/AccessControl.sol';

contract WolfToken is ERC20Capped, AccessControl {
  /**
   * @dev The ERC 20 token name used by wallets to identify the token
   */
  string private constant TOKEN_NAME = 'Wolf Token';

  /**
   * @dev The ERC 20 token symbol used as an abbreviation of the token, such
   * as BTC, ETH, AUG or SJCX.
   */
  string private constant TOKEN_SYMBOL = 'WOW';

  /**
   * @dev The number of decimal places to which the token will be calculated.
   * The most common number of decimals to consider is 18.
   */
  uint8 private constant TOKEN_DECIMALS = 18;

  /**
   * @dev 60.000 tokens maximal supply
   */
  uint256 private constant MAX_SUPPLY = 60000 * 1e18;

  /**
   * @dev Role to allow minting of new tokens
   */
  bytes32 public constant MINTER_ROLE = 'minter_role';

  /**
   * @dev Construct a token instance
   *
   * @param _teamWallet The team wallet to receive initial supply
   */
  constructor(address _teamWallet)
    ERC20Capped(MAX_SUPPLY)
    ERC20(TOKEN_NAME, TOKEN_SYMBOL)
  {
    // Initialize ERC20 base
    _setupDecimals(TOKEN_DECIMALS);

    /*
     * Mint 11000 into teams wallet
     *
     *   1.) 500 tokens * 15 month = 7500 team rewards
     *   2.) 1125 token for building up Uniswap v2 ETH / Token pool
     *   3.) 1375 token for development costs (audits / bug-bounty ...)
     *   4.) 1000 token for marketing (influencer / design ...)
     */
    _mint(_teamWallet, 11000 * 1e18);

    // Multi-sig teamwallet has initial admin rights, eg for adding minters
    _setupRole(DEFAULT_ADMIN_ROLE, _teamWallet);
  }

  /**
   * @dev Mint tokens
   *
   * @param account The account to receive the tokens
   * @param amount The amount to mint
   *
   * @return True if successful, reverts on failure
   */
  function mint(address account, uint256 amount) external returns (bool) {
    // Mint is only allowed by addresses with minter role
    require(hasRole(MINTER_ROLE, msg.sender), 'Only minters allowed');

    _mint(account, amount);

    return true;
  }
}
