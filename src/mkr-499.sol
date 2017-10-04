pragma solidity ^0.4.15;

import 'ds-chief/chief.sol';
import 'ds-token/token.sol';
import 'ds-vault/vault.sol';

import 'ds-thing/thing.sol';

contract Redeemer is DSThing {
    ERC20 from;
    DSToken to;
    uint undo_deadline;
    function Redeemer(ERC20 from_, DSToken to_, uint undo_deadline_) public {
        from = from_;
        to = to_;
        undo_deadline = undo_deadline_;
    }
    function redeem(uint128 wad) public {
        require(from.transferFrom(msg.sender, this, wad));
        to.push(msg.sender, wad);
    }
    function undo(uint128 wad) public {
        require(now < undo_deadline);
        require(to.transfer(msg.sender, wad));
        to.pull(msg.sender, wad);
    }
}

contract MakerUpdate499 is DSThing {
    DSToken MKR;
    DSChief MKRChief;
    DSVault DevFund;

    function run() public {
        MKR = new DSToken('MKR');
        MKR.mint(1000000 ether);
        var IOU = new DSToken('IOU');
        MKRChief = new DSChief(MKR, IOU, 3);
        MKR.setAuthority(MKRChief);
        IOU.setAuthority(MKRChief);
        MKR.setOwner(address(0));
        IOU.setOwner(address(0));
        // DevFund = new DSVault();
        // DevFund.swap(MKR);
        // mkr burner
        // weth token
    }
}
