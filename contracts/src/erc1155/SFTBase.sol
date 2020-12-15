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

import './SFTAccessControl.sol';

/**
 * @notice Base contract for SFTs
 *
 * Holds all common structs, events and base variables.
 *
 * See the SFTCore contract documentation to understand how the various contract
 * facets are arranged.
 */
contract SFTBase is SFTAccessControl {
  /*** EVENTS ***/

  /**
   * @dev The Mint event is fired whenever a new SFT comes into existence
   */
  event Mint(address owner, uint256 sftId);

  /**
   * @dev Transfer event is defined in ERC-1155
   *
   * Emitted every time an SFT ownership is assigned.
   */
  event Transfer(address from, address to, uint256 sftId);

  /*** DATA TYPES ***/

  /**
   * @dev The main SFT struct
   *
   * Every SFT is represented by a copy of this structure, so great care
   * was taken to ensure that it fits neatly into exactly two 256-bit words.
   * Note that the order of the members in this structure is
   * because of the byte-packing rules used by Ethereum.
   *
   * Ref: http://solidity.readthedocs.io/en/develop/miscellaneous.html
   */
  struct SFT {
    // The timestamp from the block when this SFT came into existence
    uint64 mintTime;

    // TODO: More properties
  }

  /*** CONSTANTS ***/

  // An approximation of currently how many seconds are in between blocks
  // TODO: Scrutinize this assumption
  uint256 public secondsPerBlock = 15;

  /*** STORAGE ***/

  /**
   * @dev An array containing the SFT struct for all SFTs in existence
   *
   * The ID of each SFT is actually an index into this array.
   *
   * TODO: Should this be private or public?
   */
  SFT[] private sfts;

  /**
   * @dev A mapping from SFT IDs to the address that owns them
   *
   * All SFT have some valid owner address.
   */
  mapping(uint256 => address) public sftIndexToOwner;

  /**
   * @dev A mapping from owner address to count of tokens that the address owns
   *
   * Used internally inside balanceOf() to resolve ownership count.
   *
   * TODO: Should this be private or public?
   */
  mapping(address => uint256) private ownershipTokenCount;

  /**
   * @dev A mapping from SFT IDs to an address that has been approved to call
   * transferFrom()
   *
   * Each SFT can only have one approved address for transfer at any time. A
   * zero value means no approval is outstanding.
   */
  mapping(uint256 => address) public sftIndexToApproved;

  /**
   * @dev The address of the ClockAuction contract that handles sales of SFTs
   *
   * This same contract handles both peer-to-peer sales as well as the minting
   * sales which are initiated periodically.
   */
  SaleClockAuction public saleAuction;

  /**
   * @dev Assigns ownership of a specific SFT to an address
   */
  function _transfer(
    address _from,
    address _to,
    uint256 _sftId
  ) internal {
    // Since the number of SFTs is capped to 2^32 we can't overflow this
    // TODO: Verify this constraint
    ownershipTokenCount[_to]++;

    // Transfer ownership
    sftIndexToOwner[_sftId] = _to;

    // When creating new SFTs _from is 0x0, but we can't account that
    // address
    if (_from != address(0)) {
      ownershipTokenCount[_from]--;

      // Clear any previously approved ownership exchange
      delete sftIndexToApproved[_sftId];
    }

    // Emit the transfer event
    Transfer(_from, _to, _sftId);
  }

  /**
   * @dev An internal method that creates a new SFT and stores it
   *
   * This method doesn't do any checking and should only be called when the
   * input data is known to be valid. Will generate both a Mint event and a
   * Transfer event.
   *
   * @param _owner The initial owner of this SFT
   */
  function _createSFT(address _owner) internal returns (uint256) {
    SFT memory _sft = SFT({ birthTime: uint64(now) });

    uint256 newSftId = sfts.push(_sft) - 1;

    // It's probably never going to happen, 4 billion SFTs is A LOT, but
    // let's just be 100% sure we never let this happen
    require(newSftId == uint256(uint32(newSftId)));

    // Emit the Mint event
    Mint(_owner, newSftId);

    // This will assign ownership, and also emit the Transfer event as per
    // ERC-1155
    _transfer(0, _owner, newSftId);

    return newSftId;
  }

  /**
   * @dev Any C-level can fix how many seconds per blocks are currently
   * observed
   */
  function setSecondsPerBlock(uint256 secs) external onlyCLevel {
    secondsPerBlock = secs;
  }
}
