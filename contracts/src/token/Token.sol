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
import 'contracts/interfaces/uniswap/IUniswapV2Router02.sol';
import 'contracts/interfaces/uniswap/IUniswapV2Factory.sol';

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

  IUniswapV2Factory private constant _uniswapV2Factory =
    IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
  IUniswapV2Router02 private constant _uniswapV2Router =
    IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
  bool public _uniV2Allowed = false;
  address public immutable _uniV2Pair;

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
     * Mint 9875 into teams wallet
     *
     *   1.) 500 tokens * 15 month = 7500 team rewards
     *   3.) 1375 token for development costs (audits / bug-bounty ...)
     *   4.) 1000 token for marketing (influencer / design ...)
     */
    _mint(_teamWallet, 11000 * 1e18);

    // Multi-sig teamwallet has initial admin rights, eg for adding minters
    _setupRole(DEFAULT_ADMIN_ROLE, _teamWallet);

    // Create the UniV2 liquidity pool
    address weth = _uniswapV2Router.WETH();
    _uniV2Pair = _uniswapV2Factory.createPair(address(this), weth);
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

  /**
   * @dev Allow UNIV2Router access for everyone
   *
   * @param allow True to allow UNIV2Router access, false otherwise
   */
  function allowUniswap(bool allow) external {
    require(hasRole(MINTER_ROLE, msg.sender));

    _uniV2Allowed = allow;
  }

  /**
   * @dev Transfer tokens
   *
   * @param sender The sender of the tokens
   * @param recipient The recipient of the tokens
   * @param amount The amount to transfer
   */
  function _transfer(
    address sender,
    address recipient,
    uint256 amount
  ) internal override {
    // Prevent transfer to uniswapv2 during pre-sale
    require(
      _uniV2Allowed || recipient != _uniV2Pair || hasRole(MINTER_ROLE, sender),
      'forbidden'
    );

    super._transfer(sender, recipient, amount);
  }
}
