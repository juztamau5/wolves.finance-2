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

import './SFTMinting.sol';

/**
 * @notice SFT core contract
 *
 * This is the main contract for SFTs. In order to keep our code separated into
 * logical sections, we've broken it up in two ways. First, we have several
 * separately-instantiated sibling contracts that handle auctions. The auctions
 * are separate since their logic is somewhat complex and there's always a risk
 * of subtle bugs. By keeping them in their own contracts, we can upgrade them
 * without disrupting the main contract that tracks SFT ownership.
 *
 * Secondly, we break the core contract into multiple files using inheritance,
 * one for each major facet of functionality. This allows us to keep related
 * code bundled together while still avoiding a single giant file with
 * everything in it. The breakdown is as follows:
 *
 *     - SFTBase: This is where we define the most fundamental code shared
 *           throughout the core functionality. This includes our main data
 *           storage, constants and data types, plus internal functions for
 *           managing them.
 *
 *     - SFTAccessControl: This contract manages the various addresses and
 *           constraints for operations that can be executed only by specific
 *           roles. Namely CEO, CFO and COO.
 *
 *     - SFTOwnership: This provides the methods required for basic semi-
 *           fungible token transactions, following the ERC-1155 spec
 *           (https://github.com/ethereum/EIPs/issues/1155).
 *
 *     - SFTAuction: Here we have the public methods for auctioning or bidding
 *           on SFTs or services. The actual auction functionality is handled
 *           in a sibling contract for sales, while auction creation and bidding
 *           is mostly mediated through this facet of the core contract.
 *
 *     - SFTMinting: This final facet contains the functionality we use for
 *           creating new SFTs. SFTs are created and then immediately put up
 *           for auction via an algorithmically determined starting price.
 */
contract SFTCore is SFTMinting {
  /**
   * @dev Set in case the core contract is broken and an upgrade is required
   */
  address public newContractAddress;

  /**
   * @notice Creates the main SFT smart contract instance
   */
  function SFTCore() public {
    // Starts paused
    paused = true;

    // The creator of the contract is the initial CEO
    // TODO: msg.sender will be unavailable for Diamond/GSN usage
    ceoAddress = msg.sender;

    // The creator of the contract is also the initial COO
    // TODO: see msg.sender comment above
    cooAddress = msg.sender;

    // Start with the mythical SFT 0
    _createSFT(0, 0, 0, uint256(-1), address(0));
  }

  /**
   * @dev Used to mark the smart contract as upgraded
   *
   * This is in case there is a serious breaking bug. This method does nothing
   * but keep track of the new contract and emit a message indicating that the
   * new address is set. It's up to the clients of this contract to update to
   * the new contract address in that case. (This contract will be paused
   * indefinitely  if such an upgrade takes place.)
   */
  function setNewAddress(address _v2Address) external onlyCEO whenPaused {
    // See external documentation for upgrade plan
    newContractAddress = _v2Address;
    ContractUpgrade(_v2Address);
  }

  /**
   * @notice No tipping!
   *
   * Reject all Ether from being sent here, unless it's from the auction
   * contract. (Hopefully, we can prevent user accidents.)
   */
  /* TODO:
   * contracts/src/erc1155/SFTCore.sol:99:31: ParserError: Expected a state variable declaration. If you intended this as a fallback function or a function to handle plain ether transactions, use the "fallback" keyword or the "receive" keyword instead.
   * function() external payable {
   *                             ^
  function() external payable {
    // TODO: msg.sender issues
    require(msg.sender == address(saleAuction), 'Not from auction contract');
  }
  */
}
