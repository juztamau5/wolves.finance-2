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

/**
 * @notice A facet of SFTCore that manages special access priveleges
 *
 * This facet controls access control. The are three roles managed here:
 *
 *     - The CEO: The CEO can reassign other roles and change the addresses of
 *           our dependent smart contracts. It is also the only role that can
 *           unpause the smart contract. It is initially set to the address
 *           that created the smart contract in the SFTCore constructor.
 *
 *     - The CFO: The CFO can withdraw funds from SFTCore and its auction
 *           contracts.
 *
 *     - The COO: The COO can release minted SFTs to auction
 *
 * It should be noted that these roles are distinct without overlap in their
 * access abilities, the abilities listed for each role above are exhaustive.
 * In particular, while the CEO can assign any address to any role, the CEO
 * address itself doesn't have the ability to act in those roles. This
 * restriction is intentional so that we aren't tempted to use the CEO address
 * frequently out of convenience. The less we use an address, the less likely
 * it is that we somehow compromise the account.
 *
 * See the SFTCore contract documentation to understand how the various contract
 * facets are arranged.
 */
contract SFTAccessControl {
  /**
   * @dev Emitted when contract is upgraded
   */
  event ContractUpgrade(address newContract);

  // The addresses of the accounts (or contracts) that can execute actions
  // within each role
  address public ceoAddress;
  address public cfoAddress;
  address public cooAddress;

  /**
   * @dev Keeps track of whether the contract is paused
   *
   * When the contract is paused, most auctions are blocked.
   */
  bool public paused = false;

  /**
   * @dev Access modifier for CEO-only functionality
   */
  modifier onlyCEO() {
    require(msg.sender == ceoAddress, 'Not the CEO');
    _;
  }

  /**
   * @dev Access modifier for CFO-only functionality
   */
  modifier onlyCFO() {
    require(msg.sender == cfoAddress, 'Not the CFO');
    _;
  }

  /**
   * @dev Access modifier for COO-only functionality
   */
  modifier onlyCOO() {
    require(msg.sender == cooAddress, 'Not the COO');
    _;
  }

  /**
   * @dev Combination of the above three access roles
   */
  modifier onlyCLevel() {
    require(
      msg.sender == cooAddress ||
        msg.sender == ceoAddress ||
        msg.sender == cfoAddress,
      'Not a C-level'
    );
    _;
  }

  /**
   * @dev Assigns a new address to act as the CEO
   *
   * NOTE: This is only available to the current CEO.
   *
   * @param _newCEO The address of the new CEO
   */
  function setCEO(address _newCEO) external onlyCEO {
    require(_newCEO != address(0), 'CEO cannot be address 0');

    ceoAddress = _newCEO;
  }

  /**
   * @dev Assigns a new address to act as the CFO
   *
   * NOTE: This is only available to the current CEO.
   *
   * @param _newCFO The address of the new CFO
   */
  function setCFO(address _newCFO) external onlyCEO {
    require(_newCFO != address(0), 'CFO cannot be address 0');

    cfoAddress = _newCFO;
  }

  /**
   * @dev Assigns a new address to act as the COO
   *
   * NOTE: This is only available to the current CEO.
   *
   * @param _newCOO The address of the new COO
   */
  function setCOO(address _newCOO) external onlyCEO {
    require(_newCOO != address(0), 'COO cannot be address 0');

    cooAddress = _newCOO;
  }

  /*** Pausable functionality adapted from OpenZeppelin ***/

  /**
   * @dev Modifier to allow actions only when the contract IS NOT paused
   */
  modifier whenNotPaused() {
    require(!paused, 'Contract is paused');
    _;
  }

  /**
   * @dev Modifier to allow actions only when the contract IS paused
   */
  modifier whenPaused() {
    require(paused, 'Contract is not paused');
    _;
  }

  /**
   * @dev Pause the contract
   *
   * Called by any "C-level" role to pause the contract. Used only when a bug
   * or exploit is detected and we need to limit damage.
   */
  function pause() external onlyCLevel whenNotPaused {
    paused = true;
  }

  /**
   * @dev Unpauses the smart contract
   *
   * Can only be called by the CEO, since one reason we may pause the contract
   * is when CFO or COO accounts are compromised.
   *
   * @notice This is public rather than external so it can be called by derived
   * contracts
   */
  function unpause() public onlyCEO whenPaused {
    // Can't unpause if contract was upgraded
    paused = false;
  }
}
