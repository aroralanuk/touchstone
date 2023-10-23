// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.17;

library Position {
    struct PositionSnapshot {
        uint256 blockNumber;
        uint256 priceAtBlock;
        uint256 healthFactor; // 10^10
    }

    function encodeSnapshot(address borrower, PositionSnapshot memory snapshot) internal pure returns (bytes memory) {
        return abi.encode(borrower, snapshot);
    }
}
