pragma solidity ^0.4.15;

import 'ds-chief/chief.sol';
import 'ds-token/token.sol';
import 'ds-vault/multivault.sol';

import 'ds-thing/thing.sol';

contract Redeemer is DSThing {
    ERC20 from;
    DSToken to;
    uint undo_deadline;
    function Redeemer(ERC20 from, DSToken to, uint undo_deadline);
    function redeem(uint128 wad) {
        require( from.transferFrom(msg.sender, this, wad) ) );
        to.push(msg.sender, wad);
    }
    function undo(uint128 wad) {
        require( now < undo_deadline );
        require( to.transfer(msg.sender, wad) );
        to.pull(msg.sender, wad);
    }
}

contract MakerUpdate499 is DSThing {
    DSToken MKR;
    DSChief MKRChief;
    DSVault DevFund;

    function run() {
        MKR = new DSToken();
        MKR.mint(cast(1000000 ether));
        MKRChief = new DSChief(MKR);
        MKR.setAuthority(MKRChief);
        MKR.setOwner(address(0));
        DevFund = new DSMultiVault(MKR);
        // mkr burner
        // weth token
    }
}
