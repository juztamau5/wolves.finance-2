/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * This file is derived from CryptoKitties, available under the Creative
 * Commons Zero v1.0 Universal license.
 *
 * SPDX-License-Identifier: Apache-2.0 AND CC0-1.0
 * See LICENSE.txt for more information.
 */

pragma solidity >=0.7.0 <0.8.0;

import './SFTAuction.sol';

/**
 * @notice All functions related to creating SFTs
 */
contract SFTMinting is SFTAction {
  // Constants for initial SFT auctions
  uint256 public constant SFT_STARTING_PRICE = 1e16; // 10 finney
  uint256 public constant SFT_AUCTION_DURATION = 1 days;

  /**
   * @dev Counts the number of SFTs the contract owner has created
   */
  uint256 public sftCreatedCount;

  /**
   * @dev Creates a new SFT and creates an auction for it
   */
  function createSFTAuction() external onlyCOO {
    uint256 sftId = _createSFT(0, 0, 0, address(this));
    _approve(sftId, saleAuction);

    saleAuction.createAuction(
      sftId,
      _computeNextSFTPrice(),
      0,
      SFT_AUCTION_DURATION,
      address(this)
    );

    sftCreatedCount++;
  }

  /**
   * @dev Computes the next SFT auction starting price, given the average
   * price of the past 5 prices + 50%
   */
  function _computeNextSFTPrice() internal view returns (uint256) {
    uint256 avgPrice = saleAuction.averageSFTSalePrice();

    // Sanity check to ensure we don't overflow arithmetic
    require(avgPrice == uint256(uint128(avgPrice)), 'Arithmetic overflow');

    uint256 nextPrice = avgPrice + (avgPrice / 2);

    // We never auction for less than starting price
    if (nextPrice < SFT_STARTING_PRICE) {
      nextPrice = SFT_STARTING_PRICE;
    }

    return nextPrice;
  }
}
