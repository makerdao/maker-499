pragma solidity ^0.4.8;

import "ds-auth/auth.sol";
import "ds-test/test.sol";
import "ds-token/token.t.sol";

import "./mkr-499.sol";


contract TestAuthority is DSAuthority {
    function canCall(address src, address dst, bytes4 sig) public view returns(bool) {
        return true;
    }
}

contract MKRUser is TokenUser {
    function MKRUser(DSToken t) TokenUser(t) public {}
}

contract Maker499Test is DSTest {
    uint initialBalance = 1000000 ether; // 10**6 * 10**18
    MakerUpdate499 update;
    MKRUser user1;
    DSAuthority authority;
    DSToken old_MKR;

    function setUp() public {
        user1 = new MKRUser(old_MKR);
        old_MKR = new DSToken("MKR");
        old_MKR.mint(initialBalance);
        old_MKR.push(user1, initialBalance);
        authority = new TestAuthority();
    }

    function test_basic_sanity() public {
        assert(true);
    }

    function testFail_basic_sanity() public {
        assert(false);
    }

    function test_deploy() public {
        uint deadline = now + 1 days;
        update = new MakerUpdate499(authority, old_MKR, deadline);
        assertEq(update.undo_deadline(), deadline);
        assertEq(address(update.old_MKR()), address(old_MKR));
        assertTrue(address(update.MKR()) != address(old_MKR));
        assertTrue(address(update.MKR()) != address(0x0));
    }

    function test_run() public {
    }
}
