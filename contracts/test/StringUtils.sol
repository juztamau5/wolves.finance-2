/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * SPDX-License-Identifier: Apache-2.0
 * See LICENSE.txt for more information.
 */

pragma solidity >=0.7.0 <0.8.0;

/**
 * @dev String-related utility functions
 */
library StringUtils {
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
   * @return The ASCII character
   */
  function char(bytes1 b) internal pure returns (bytes1) {
    if (uint8(b) < 10) {
      return bytes1(uint8(b) + 0x30);
    } else {
      return bytes1(uint8(b) + 0x57);
    }
  }
}
