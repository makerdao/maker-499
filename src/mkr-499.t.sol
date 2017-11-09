pragma solidity ^0.4.8;

import "ds-auth/auth.sol";
import "ds-test/test.sol";
import "ds-token/token.t.sol";

import "./mkr-499.sol";


contract TestAuthority is DSAuthority {
    function canCall(address src, address dst, bytes4 sig) public view returns(bool) {
        src; dst; sig;
        return true;
    }
}

contract MKRUser is TokenUser {
    function MKRUser(DSToken t) TokenUser(t) public {}

    function doRedeem(Redeemer r) public {
        r.redeem();
    }

    function doUndo(Redeemer r) public {
        r.undo();
    }
    
    function doReclaim(Redeemer r) public {
        r.reclaim();
    }

    function doApprove(DSToken token, address recipient, uint amount)
            public
            returns (bool)
    {
        return token.approve(recipient, amount);
    }
}

contract Maker499Test is DSTest {
    uint initialBalance = 1000000 ether; // 10**6 * 10**18
    MakerUpdate499 update;
    MKRUser user;
    DSAuthority authority;
    DSToken old_MKR;

    function setUp() public {
        old_MKR = new DSToken("MKR");
        old_MKR.mint(initialBalance);

        user = new MKRUser(old_MKR);
        old_MKR.push(user, initialBalance);
        authority = new TestAuthority();
    }

    function test_deploy() public {
        uint deadline = now + 1 days;
        update = new MakerUpdate499(authority, old_MKR, deadline);
        assertEq(update.undo_deadline(), deadline);
        assertEq(address(update.old_MKR()), address(old_MKR));
    }

    function test_owner_and_authority() public {
        uint deadline = now + 1 days;
        address owner = 0x123;
        update = new MakerUpdate499(owner, old_MKR, deadline);
        update.run();
        assertEq(address(update.owner()), owner);
        assertEq(address(update.MKR().owner()), owner);
        assertEq(address(update.authority()), 0x0);
        assertEq(address(update.MKR().authority()), 0x0);
        assertEq(address(update.redeemer().authority()), owner);
    }

    function test_run() public {
        uint deadline = now + 1 days;
        update = new MakerUpdate499(authority, old_MKR, deadline);
        update.run();
        assertTrue(address(update.MKR()) != address(old_MKR));
        assertTrue(address(update.MKR()) != address(0x0));
    }

    function test_redeem() public {
        uint deadline = now + 1 days;
        update = new MakerUpdate499(authority, old_MKR, deadline);
        update.run();

        assertEq(old_MKR.balanceOf(user), initialBalance);
        user.doApprove(old_MKR, update.redeemer(), initialBalance);
        user.doRedeem(update.redeemer());
        assertEq(old_MKR.balanceOf(user), 0);
        assertEq(update.MKR().balanceOf(user), initialBalance);
    }

    function test_undo() public {
        uint deadline = now + 1 days;
        update = new MakerUpdate499(authority, old_MKR, deadline);
        update.run();

        assertEq(old_MKR.balanceOf(user), initialBalance);
        user.doApprove(old_MKR, update.redeemer(), initialBalance);
        user.doApprove(update.MKR(), update.redeemer(), initialBalance);
        user.doRedeem(update.redeemer());
        user.doUndo(update.redeemer());
        assertEq(update.MKR().balanceOf(user), 0);
        assertEq(old_MKR.balanceOf(user), initialBalance);
    }

    function test_reclaim() public {
        uint deadline = now + 1 days;
        update = new MakerUpdate499(authority, old_MKR, deadline);
        update.run();

        assertEq(update.MKR().balanceOf(update.redeemer()), initialBalance);
        assertEq(update.MKR().balanceOf(authority), 0);

        // user.doReclaim(update.redeemer());

        // assertEq(old_MKR.balanceOf(user), initialBalance);
        // user.doApprove(old_MKR, update.redeemer(), initialBalance);
        // user.doApprove(update.MKR(), update.redeemer(), initialBalance);
        // user.doRedeem(update.redeemer());
        // user.doUndo(update.redeemer());
        // assertEq(update.MKR().balanceOf(user), 0);
        // assertEq(old_MKR.balanceOf(user), initialBalance);
    }

    function testFail_undo() public {
        uint deadline = 0;
        update = new MakerUpdate499(authority, old_MKR, deadline);
        update.run();

        assertEq(old_MKR.balanceOf(user), initialBalance);
        user.doApprove(old_MKR, update.redeemer(), initialBalance);
        user.doApprove(update.MKR(), update.redeemer(), initialBalance);
        user.doRedeem(update.redeemer());
        user.doUndo(update.redeemer());
    }

    function testFail_reclaim() public {
        uint deadline = now + 1 days;
        update = new MakerUpdate499(authority, old_MKR, deadline);
        update.run();

        assertEq(update.MKR().balanceOf(update.redeemer()), initialBalance);
        assertEq(update.MKR().balanceOf(authority), 0);

        user.doReclaim(update.redeemer());
    }
}
