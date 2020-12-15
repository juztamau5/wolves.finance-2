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

import '@openzeppelin/contracts/token/ERC1155/ERC1155.sol';

import './SFTBase.sol';

/**
 * @notice The core contract that manages ownership, ERC-1155 compliant
 *
 * @dev Ref: https://github.com/ethereum/EIPs/issues/1155
 *
 * See the SFTCore contract documentation to understand how the various contract
 * facets are arranged.
 */
contract SFTOwnership is SFTBase, ERC1155 {
  /**
   * @dev ERC 1155 metadata URI
   */
  string private constant METADATA_URI =
    'https://ipfs.io/ipfs/Qmeh5GHqPXaEww5cBYfBpeVsTwdZ7pMNdzboJ18DpR8Dtg/metadata/{id}.json';

  // TODO: ERC-1155 functionality
}
