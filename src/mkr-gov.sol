import 'ds-chief/chief.sol';
import 'ds-roles/roles.sol';

// `hat` address is unique root user (has every role) and the
// unique owner of role 0 (typically 'sys' or 'internal')
contract MakerAuth is DSChief, DSRoles {
    // override
    function getUserRoles(address who)
        constant
        returns (bytes32)
    {
        if( who == hat ) {
            return BITNOT(0);
        } else {
            return super.getUserRoles(who);
        }
    }
    function setUserRole(address who, uint8 role, bool enabled) {
        if( role == 0 ) {
            throw;
        } else {
            super.setUserRole(who, role, enabled);
        }
    }
    function setRootUser(address who, bool enabled) {
        throw;
    }
    function isUserRoot(address who)
        constant
        returns (bool)
    {
        if( who == hat ) {
            return true;
        } else  {
            return super.isUserRoot(who);
        }
    }
}


contract MakerTrueGenesis {
    function MakerGovInitialize(ERC20 old_mkr) {
        var MKR = new DSToken();
        
    }
}
