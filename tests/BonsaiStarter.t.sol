// Copyright 2023 RISC Zero, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.17;

import {BonsaiTest} from "bonsai/BonsaiTest.sol";
import {IBonsaiRelay} from "bonsai/IBonsaiRelay.sol";
import {BonsaiStarter} from "contracts/BonsaiStarter.sol";

contract BonsaiStarterTest is BonsaiTest {
    string MAINNET_RPC_URL = "https://eth.llamarpc.com";
    uint256 mainnetFork = vm.createFork(MAINNET_RPC_URL);

    function setUp() public withRelay {
        // vm.selectFork(mainnetFork);
    }

    function testMockCall() public {
        BonsaiStarter starter = new BonsaiStarter(
            IBonsaiRelay(bonsaiRelay),
            queryImageId('FIBONACCI'),
            0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e,
            0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2,
            0x54586bE62E3c3580375aE3723C145253060Ca0C2,
            0x91c0eA31b49B69Ea18607702c5d9aC360bf3dE7d
        );
        // Anticipate a callback request to the relay
        vm.expectCall(address(bonsaiRelay), abi.encodeWithSelector(IBonsaiRelay.requestCallback.selector));
        // Request the callback
        starter.calculateFibonacci(128);

        // Anticipate a callback invocation on the starter contract
        vm.expectCall(address(starter), abi.encodeWithSelector(BonsaiStarter.storeResult.selector));
        // Relay the solution as a callback
        runPendingCallbackRequest();

        // Validate the Fibonacci solution value
        uint256 result = starter.fibonacci(128);
        assertEq(result, uint256(407305795904080553832073954));
    }

    // function testCalcValueAtRisk() public {
    //     starter.calcValueAtRisk(0x4196c40De33062ce03070f058922BAA99B28157B, false);
    // }
}
