/*
 * Copyright (C) 2020 wolves.finance developers
 * This file is part of wolves.finance - https://github.com/peak3d/wolves.finance
 *
 * SPDX-License-Identifier: Apache-2.0
 * See LICENSE.txt for more information.
 */

pragma solidity >=0.7.0 <0.8.0;

import '@openzeppelin/contracts-upgradeable/proxy/Initializable.sol';
import '@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol';

// Library for using console.log
import 'hardhat/console.sol';

import '../../test/StringUtils.sol'; // TODO: Remove me

/**
 * @dev ERC 1155 token contract
 */
contract ERC1155Token is Initializable, ERC1155Upgradeable {
  /**
   * @dev ERC 1155 metadata URI
   */
  string private constant METADATA_URI =
    'https://ipfs.io/ipfs/Qmeh5GHqPXaEww5cBYfBpeVsTwdZ7pMNdzboJ18DpR8Dtg/metadata/{id}.json';

  // Start token IDs

  uint256 public constant DOG_1 = 0;
  uint256 public constant DOG_2 = 1;
  uint256 public constant DOG_3 = 2;
  uint256 public constant DOG_4 = 3;

  uint256 public constant WOLF_1 = 4;
  uint256 public constant WOLF_2 = 5;
  uint256 public constant WOLF_3 = 6;
  uint256 public constant WOLF_4 = 7;

  // End token IDs

  /**
   * @dev Initialize the contract
   */
  function initialize(address initialOwner) public virtual initializer {
    console.log(
      'ERC1155Token.initialize(owner=0x%s)',
      StringUtils.toAsciiString(initialOwner)
    );

    __ERC1155_init(METADATA_URI);

    _mint(initialOwner, DOG_1, 1, '');
    _mint(initialOwner, DOG_2, 1, '');
    _mint(initialOwner, DOG_3, 1, '');
    _mint(initialOwner, DOG_4, 1, '');
    _mint(initialOwner, WOLF_1, 1, '');
    _mint(initialOwner, WOLF_2, 1, '');
    _mint(initialOwner, WOLF_3, 1, '');
    _mint(initialOwner, WOLF_4, 1, '');
  }

  function postUpgrade() public {
    console.log('ERC1155Token.postUpgrade()');

    _setURI(METADATA_URI);
  }
}
