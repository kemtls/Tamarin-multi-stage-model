## Protocol modelling limitations

- No handshake encryption of protocol messages or adversary-supplied data
- No application-layer encryption
- No TLS data structures
- No PSK mode
- No modelling of KEMTLS-PDK (yet?)

## Interesting questions

- What if KEM_e = KEM_c = KEM_s?
- Is there any satisfactory way we can connect the conclusions from this simplified model to the conclusions of the full TLS13-Tamarin model?
