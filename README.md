# Tamarain model for Core KEMTLS ("CoreKT")

This repository contains a Tamarin model for the "core cryptographic version" of the KEMTLS protocol.  Roughly speaking, this means the version of KEMTLS as specified in Figures 3 and 7 of https://eprint.iacr.org/2020/534.pdf, without any additional the framing from the TLS protocol, such as extra TLS message fields, pre-shared key / resumption, or handshake / application layer encryption.

The goal of this modelling exercise is to very closely follow the pen-and-paper security model and properties as specified in the multi-stage key exchange security model of the original paper (https://eprint.iacr.org/2020/534.pdf).

## Organization of the code base

- `glossary.md` summarizes the primitives, state facts, and action facts used throughout the protocol, model, and lemmas.

- The `protocol` folder contains the formulation of the KEMTLS protocol in Tamarin.  In fact it includes two KEMTLS protocol modes: server-only authentication and mutual authentication.

- The `model` folder contains oracles that are accessible to the adversary for compromising secret keys.

- The `lemmas` folder contains lemmas modelling correctness and security properties.

	- `lemmas/reachable.spthy` contains lemmas that model correctness of the protocol. In particular, we want to check that it is possible to generate sessions and stages that achieve each of the intended states.
	- `lemmas/attacker_works.spthy` contains a few basic lemmas that check that it's possible for the attacker to trigger its various corruption queries.
	- `lemmas/match_security.spthy` contains lemmas that model "match security". This means the sound behaviour of session matching: that, for honest sessions, the session identifier matches the partnered session. This is a codification of Section B.4 and Definition B.1 of https://eprint.iacr.org/2020/534.pdf. Please see Section B.4 of the paper for references on the origin of modelling match security as a separate property for authenticated key exchange protocols.
	- `lemmas/sk_security.spthy` contains lemmas that model session key security. There are separate lemmas checking keys that are intended to have "weak forward secrecy 1", "weak forward secrecy 2", or "(full) forward secrecy".  This is a codification of the freshness conditions in Definition B.3 of https://eprint.iacr.org/2020/534.pdf.
	- `lemmas/malicious_acceptance.spthy` contains a lemma authentication security of KEMTLS: for session stages that believe they have authenticated their peer, there really is a matching session. This is a codification of Definition B.4 in https://eprint.iacr.org/2020/534.pdf.

- `corekt.spthy` uses m4 macros to pull all the above Tamarin source code into a single file.  Run the command `make preprocess` to generate the resulting file `generated_corekt.spthy`, which is the file you should actually have Tamarin run.

- The `output` folder contains output from having run the model.

## Getting started

1. You'll need to have a working version of [Tamarin prover](https://tamarin-prover.github.io) installed.
2. Run `make preprocess` to generate a single Tamarin file `generated_corekt.spthy` from all the above sources.
3. Run `make prove` to have Tamarin try to prove all the above lemmas.  The output will be shown on the screen and stored in the `output` directory.  On a 16-core machine with lots of RAM, it takes about 7 minutes of wall clock time to prove all the lemmas.
	- You can prove a specific lemma with `make prove PROVE=sk_securty_wfs1`
	- You can also use the Tamarin web UI: `tamarin-prover interactive .`

