## Primitives

*Defined in protocol/primitives.spthy.*

#### `KEM_e`: KEM for ephemeral key exchange

- `KEM_e_PK(sk) -> pk`
- `KEM_e_Encaps_ct(pk, coins) -> ct`
- `KEM_e_Encaps_ss(pk, coins) -> ss`
- `KEM_e_Decaps(ct, sk) -> ss`

Accompanied by equational theory on correctness of decapsulation.

#### `KEM_s`: KEM for server authentication

- `KEM_s_PK(sk) -> pk`
- `KEM_s_Encaps_ct(pk, coins) -> ct`
- `KEM_s_Encaps_ss(pk, coins) -> ss`
- `KEM_s_Decaps(ct, sk) -> ss`

Accompanied by equational theory on correctness of decapsulation.

#### `KEM_c`: KEM for client authentication

- `KEM_c_PK(sk) -> pk`
- `KEM_c_Encaps_ct(pk, coins) -> ct`
- `KEM_c_Encaps_ss(pk, coins) -> ss`
- `KEM_c_Decaps(ct, sk) -> ss`

Accompanied by equational theory on correctness of decapsulation.

#### HKDF

- `HKDFExtract(ikm, salt) -> output`
- `HKDFExpand(key, label, transcript) -> output`

#### HMAC

- `HMAC(key, msg) -> tag`

## Protocol actions

All variants of KEMTLS can use:

- `KEMTLS_KEM_s_KeyGen`:
	- generates a new `KEM_s` key pair `(pk, sk)`
	- binds a public key `pk` to a new party name `$P`
	- outputs the public key

- `KEMTLS_KEM_c_KeyGen`:
	- generates a new `KEM_c` key pair `(pk, sk)`
	- binds a public key `pk` to a new party name `$P`
	- outputs the public key

### `KEMTLS_SAUTH`: KEMTLS in server-only authentication mode

- `KEMTLS_SAUTH_OR_MUTUAL_ClientAction1`:
	- outputs `<CLIENT_HELLO>`
- `KEMTLS_SAUTH_ServerAction1`:
	- accepts stage 1 and 2 keys
	- outputs `<SERVER_HELLO, SERVER_CERTIFICATE>`
- `KEMTLS_SAUTH_ClientAction2`:
	- accepts stage 1-5 keys
	- outputs `<CLIENT_KEM_CIPHERTEXT, CLIENT_FINISHED>`
- `KEMTLS_SAUTH_ServerAction2Part1`:
	- inputs `<CLIENT_KEM_CIPHERTEXT>`
	- accepts stage 3 and 4 keys
- `KEMTLS_SAUTH_ServerAction2Part2`:
	- part 1 and part 2 are separated so that the stage 3 and 4 keys can be accepted even if the MAC check fails
	- inputs `<CLIENT_FINISHED>`
	- accepts stage 5 and 6 keys
	- outputs `<SERVER_FINISHED>`
- `KEMTLS_SAUTH_ClientAction3`: 
	- accepts stage 6 key

### `KEMTLS_MUTUAL`: KEMTLS in mutual authentication mode

- `KEMTLS_SAUTH_OR_MUTUAL_ClientAction1`:
	- outputs `<CLIENT_HELLO>`
- `KEMTLS_MUTUAL_ServerAction1`:
	- accepts stage 1 and 2 keys
	- outputs `<SERVER_HELLO, CERTIFICATE_REQUEST, SERVER_CERTIFICATE>`
- `KEMTLS_MUTUAL_ClientAction2`:
	- accepts stage 1-4 keys
	- outputs `<CLIENT_KEM_CIPHERTEXT, CLIENT_CERTIFICATE>`
- `KEMTLS_MUTUAL_ServerAction2`:
	- accepts stage 3 and 4 keys
	- outputs `<SERVER_KEM_CIPHERTEXT>`
- `KEMTLS_MUTUAL_ClientAction3`:
	- accepts stage 5 key
	- outputs `<CLIENT_FINISHED>`
- `KEMTLS_MUTUAL_ServerAction3`:
	- accepts stage 5 and 6 keys
	- outputs `<SERVER_FINISHED>`
- `KEMTLS_MUTUAL_ClientAction3`: 
	- accepts stage 6 key

## Action facts

For KEMTLS, `stage` can be `'1'`, `'2'`, ..., `'6'`.

- `Registered(P, pk, type)`: Records that a public key `pk` of type `type` (either `KEM_c` or `KEM_s`) was registered for party `P`.
- `Owner(tid, P)` or `Owner(tid, 'anonymous')`: Records that the owner of thread `tid` is party `P` or is anonymous.
- `Role(tid, 'client')` or `Role(tid, 'server')`: Records that the role of the party in thread `tid` is a client or a server.
- `CID(tid, stage, cid)`: Records that the contributive identifier of stage `stage` for thread `tid` is `cid`.
- `SID(tid, stage, sid)`: Records that the session identifier of stage `stage` for thread `tid` is `sid`.
- `Peer(tid, P)`: Records that the alleged peer for thread `tid` is `P`.
- `Accept(tid, stage)`: Records that thread `tid` has accepted a key in stage `stage`.
- `SK(tid, stage, key)`: Records that thread `tid` has accepted key `key` in stage `stage`.
- `FS(tid, stage, fslevel)`: Records that thread `tid` has accepted a key in stage `stage` as having forward secrecy level `fslevel` (in `wfs1`, `wfs2`, `fs`).
- `Auth(tid, stage)`: Records that thread `tid` has accepted the stage `stage` key as authenticated.
- `RevealedSessionKey(tid, stage)`: Records that the stage `stage` key in thread `tid` was revealed to the adversary.
- `CorruptedLTK(P)`: Records that party `P`'s long-term secret key was revealed to the adversary.
- `ProtocolMode(tid, mode)`: Records that thread `tid` is running in protocol mode `mode` (one of: `KEMTLS_SAUTH`, `KEMTLS_MUTUAL`).

## State facts

- `!Ltk(P, pk, sk, type)`: Records that party `P`'s long-term public key of type `type` is `pk` and the corresponding secret key is `sk`.
- `!Pk(P, pk, type)`: Records that party `P`'s long-term public key of type `type` is `pk`.
- `!SessionKey(tid, stage, key)`: Records that the stage `stage` session key for thread `tid` is `key`.
- `State(tid, mode, action, vars, transcript)`: Records state for thread `tid` to be consumed by subsequent protocol actions. 
	- `mode` is the protocol mode the state is intended for.
	- `action` is the name of the protocol action that output this state (e.g., `ClientAction1`, `ClientAction2`, etc.)
	- `vars` is a tuple of variables (`<var1, var2, etc>`).
	- `transcript` is a tuple of protocol messages.

## Oracles

- `ORevealSessionKey`: Reveals a session key recorded with `!SessionKey(tid, stage, key)`. Records this using a `RevealedSessionKey` action fact.
- `OCorruptLTK`: Reveals the long-term secret key recorded with `!Ltk(P, pk, sk, type)`. Records this using a `Corrupted` action fact.
