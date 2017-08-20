pragma solidity ^0.4.15;

import 'ds-chief/chief.sol';
import 'ds-token/token.sol';
import 'ds-vault/vault.sol';

contract MakerUpdate499 {
    DSToken MKR;
    DSChief MKRChief;
    DSVault MakerFiniteVault;

    function run() {
        MKR = new DSToken();
        MKRChief = new DSChief();
        MakerFiniteVault = new DSVault(MKR);
        // mkr token
        // mkr chief
        // mkr redeemer
        // mkr burner
        // weth token
        // "makerdao" vault
    }
}
