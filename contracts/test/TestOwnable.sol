/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * SPDX-License-Identifier: Apache-2.0
 * See the file LICENSES/README.md for more information.
 */

pragma solidity ^0.7.4;

import '@openzeppelin/contracts/access/Ownable.sol';

// Library for using console.log
import 'hardhat/console.sol';

/**
 * @dev A class to test the Ownable access mechanism
 *
 * This class is entirely for testing purposes and should not be considered
 * secure.
 */
contract TestOwnable is Ownable {
  /**
   * @dev Construct a TestOwnable class
   *
   * A constructor parameter is provided to handle deterministic deployment.
   * In this case, contracts are deployed by a proxy, so the owner might not
   * be the deployer.
   *
   * @param initialOwner The initial owner of the contract
   */
  constructor(address initialOwner) Ownable() {
    super.transferOwnership(initialOwner);
  }

  /**
   * @dev A function that only the owner can call
   *
   * @return True if the caller is the owner, reverts otherwise
   */
  function externalOnlyOwner() external view onlyOwner returns (bool) {
    return true;
  }

  /**
   * @dev Test the transfer of ownership to a new owner
   *
   * @param newOwner The new owner to receive ownership
   */
  function testTransferOwnership(address newOwner) external {
    console.log(
      'Transferring ownership from %s to %s',
      toAsciiString(owner()),
      toAsciiString(newOwner)
    );

    super.transferOwnership(newOwner);
  }

  /**
   * @dev Convert an address to an ASCII string
   *
   * Credit to Stack Overflow:
   *
   *   https://ethereum.stackexchange.com/questions/8346/convert-address-to-string
   *
   * @param x The address
   *
   * @return The ASCII string representing the address
   */
  function toAsciiString(address x) internal pure returns (string memory) {
    bytes memory s = new bytes(40);
    for (uint256 i = 0; i < 20; i++) {
      bytes1 b = bytes1(uint8(uint256(x) / (2**(8 * (19 - i)))));
      bytes1 hi = bytes1(uint8(b) / 16);
      bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
      s[2 * i] = char(hi);
      s[2 * i + 1] = char(lo);
    }
    return string(s);
  }

  /**
   * @dev Helper function for address-to-string converter
   *
   * @param b The address byte
   *
   * @return c The ASCII character
   */
  function char(bytes1 b) internal pure returns (bytes1 c) {
    if (uint8(b) < 10) {
      return bytes1(uint8(b) + 0x30);
    } else {
      return bytes1(uint8(b) + 0x57);
    }
  }
}
