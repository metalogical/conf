# `conf`

Reproducible system configurations with Nix!
All software and most configuration should be tracked with Nix,
with some exceptions outlined below.

## NetworkManager

NetworkManager connections, passwords, etc. must be manually reconfigured.
I tried using a static configuration, but switched to a dynamic setup,
since the configurations tended to need tweaking for each machine
(so reproducibility is not as valuable).

### OpenVPN

OpenVPN can be configured using NetworkManager:

```
▶ sudo nmcli con import type openvpn file my-vpn.ovpn
▶ nmcli con up my-vpn
```

Note that using `sudo` ensured that any imported credentials are only accessible by `root`.
In particular, it may be convenient to import password-less private keys,
in which case it is crucial to prevent untrusted non-`root` programs from reading your keys.

Storing password-less private keys on an encrypted disk with a strong master password
is equivalent to using "keyring" or "keychain" software (i.e. a password manager).
