A few system updates in preparation for sai2:

The updates will be grouped roughly as follows. Remember, we cound down version numbers. Bigger jumps represent more substantial progress towards completion; in this case, this cluster is an upgrade from the last version, 957.

Maker 499: `MKR`, `WETH`, Redeemer
---

Redeployed MKR token:  although the original MKR token was designed to be
upgraded in-place, we have since transition to a "box"-oriented architecture where
componenets can be individually verified much more easily, allowing the system
as a whole to be analyzed in a manageable way.

The new version of the MKR token
will be a `DSToken` object which can be configured to enable protected operations (e.g. `burn`ing
MKR tokens) by future SAI and DAI iterations.
`DSToken` is an ERC20 implementation and extension which has just undergone a thorough code review by Trail of Bits. 

MKR holders will have to convert their tokens into the new form. Wallets, block explorers, and other
services need to be aware of this transition. There is no deadline to convert to the new MKR, but reversing
your conversion to get the old form back (for whatever reason) *does* have a deadline.


The wrapped ether token (WETH) will also be redeployed because there is demand to publish the source,
but restoring the source code for publication would be an exercise in archeology, and because we have since learned to write more ergonomic code anyway.


Maker 498: Chief and Vaults
---

`DSChief` is a basic governance box that enables a token to control root access to a contract
system ACL via [approval voting](https://en.wikipedia.org/wiki/Approval_voting). This is a very flexible governance tool that can be used for everything
from one-off system changes to complex rulesets that delegate permissions to other mechanisms (there will need
to be additional governance "layers" to implement the intended protections).

`DSVault` is a sort of "managed account" that integrates with the [Dappsys](http://dappsys.info) auth system. This makes it so
you don't have to transfer all your system's tokens each time you reconfigure which contracts control them.


Maker 497: More Feeds
---

`DSCache` and `Medianizer`


Maker 496: Sai Components
---

Maker 490: Enable Sai2 and transfer control
---
