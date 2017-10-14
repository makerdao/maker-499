// (c) Dai Foundation, 2017

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
    ERC20   public old_MKR;
    DSToken public MKR;
    Redeemer public redeemer;
    uint    public undo_deadline;

    function MakerUpdate499(ERC20 old_MKR_, uint undo_deadline_) {
        old_MKR = old_MKR_;
        undo_deadline = undo_deadline_;
    }

    function run() public {
        MKR = new DSToken('MKR');
        MKR.mint(1000000 ether); // 10**6 * 10**18
        redeemer = new Redeemer(old_MKR, MKR, undo_deadline); // TODO now
        MKR.push(redeemer, 1000000 ether);
    }
}

contract MakerUpdate498 is DSThing {
    function run() {
/*
        var IOU = new DSToken('IOU');
        MKRChief = new DSChief(MKR, IOU, 3);
        DevFund = new DSVault();
        MKR.setAuthority(MKRChief);
        IOU.setAuthority(MKRChief);
        MKR.setOwner(address(0));
        IOU.setOwner(address(0));
*/
    }
}
