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

import './SFTOwnership.sol';

/**
 * @notice Handles creating auctions for sale of SFTs
 *
 * This wrapper of ReverseAuction exists only so that users can create auctions
 * with only one transaction.
 *
 * The auction contract variables are defined in SFTBase to allow us to refer
 * to them in SFTOwnership to prevent accidental transfers.
 *
 * `saleAuction` refers to the auction for minted and p2p sale of kitties.
 */
contract SFTAuction is SFTOwnership {
  /**
   * @dev Sets the reference to the sale auction
   *
   * @param _address Address of the sale contract
   */
  function setSaleAuctionAddress(address _address) external onlyCEO {
    SaleClockAuction candidateContract = SaleClockAuction(_address);

    // NOTE: Verify that a contract is what we expect
    // https://github.com/Lunyr/crowdsale-contracts/blob/cfadd15986c30521d8ba7d5b6f57b4fefcc7ac38/contracts/LunyrToken.sol#L117
    require(candidateContract.isSaleClockAuction(), 'Unexpected contract');

    // Set the new contract address
    saleAuction = candidateContract;
  }

  /**
   * @dev Put an SFT up for auction
   *
   * Does some ownership trickery to create auctions in one tx.
   */
  function createSaleAuction(
    uint256 _sftId,
    uint256 _startingPrice,
    uint256 _endingPrice,
    uint256 _duration
  ) external whenNotPaused {
    // Auction contract checks input sizes. If SFT is already on any
    // auction, this will throw because it will be owned by the auction
    // contract.
    require(_owns(msg.sender, _sftId), 'SFT owned by auction contract');

    _approve(_sftId, saleAuction);

    // Sale auction throws if inputs are invalid and clears transfer
    // approval after escrowing the SFT.
    saleAuction.createAuction(
      _sftId,
      _startingPrice,
      _endingPrice,
      _duration,
      msg.sender
    );
  }
}
