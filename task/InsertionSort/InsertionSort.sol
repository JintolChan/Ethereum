// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract InsertionSort {
    function insertionSort(uint[] memory arr) public pure returns (uint[] memory) {
        uint length = arr.length;
        for (uint i = 1; i < length; i++) {
            uint key = arr[i];
            uint j = i;
            while (j > 0 && arr[j - 1] > key) {
                arr[j] = arr[j - 1];
                j--;
            }
            arr[j] = key;
        }
        return arr;
    }
}
