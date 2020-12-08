// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.6.0 <0.8.0;

interface IController {
  function onDeposit(uint256 amount) external;

  function onWithdraw(uint256 amount) external;

  function calculateTokensEarned(
    uint256 amount,
    uint256 share,
    uint256 depositStartBlock
  ) external view returns (uint256); //1e18

  function lockEarnedTokens(uint256 tokenCount) external;
}
