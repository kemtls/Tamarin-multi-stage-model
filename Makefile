all: prove

preprocess:
	m4 corekt.spthy > generated_corekt.spthy
	m4 corekt_deniability.spthy > generated_corekt_deniability.spthy

prove-sauth: preprocess
	tamarin-prover -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_SAUTH --quit-on-warning generated_corekt.spthy
	tamarin-prover -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_SAUTH $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

prove-mutual: preprocess
	tamarin-prover -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_MUTUAL --quit-on-warning generated_corekt.spthy
	tamarin-prover -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_MUTUAL $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

prove-sauth-mutual: preprocess
	tamarin-prover -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_SAUTH -DINCLUDE_KEMTLS_MUTUAL --quit-on-warning generated_corekt.spthy
	tamarin-prover -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_SAUTH -DINCLUDE_KEMTLS_MUTUAL $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

prove-pdk-sauth: preprocess
	tamarin-prover -DINCLUDE_KEMTLS_PDK_SAUTH --quit-on-warning generated_corekt.spthy
	tamarin-prover -DINCLUDE_KEMTLS_PDK_SAUTH $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

prove-pdk-mutual: preprocess
	tamarin-prover -DINCLUDE_KEMTLS_PDK_MUTUAL --quit-on-warning generated_corekt.spthy
	tamarin-prover -DINCLUDE_KEMTLS_PDK_MUTUAL $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

prove-pdk-sauth-mutual: preprocess
	tamarin-prover -DINCLUDE_KEMTLS_PDK_SAUTH -DINCLUDE_KEMTLS_PDK_MUTUAL --quit-on-warning generated_corekt.spthy
	tamarin-prover -DINCLUDE_KEMTLS_PDK_SAUTH -DINCLUDE_KEMTLS_PDK_MUTUAL $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

prove-all: preprocess
	tamarin-prover -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_SAUTH -DINCLUDE_KEMTLS_MUTUAL -DINCLUDE_KEMTLS_PDK_SAUTH -DINCLUDE_KEMTLS_PDK_SAUTH -DINCLUDE_KEMTLS_PDK_MUTUAL --quit-on-warning generated_corekt.spthy
	tamarin-prover -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_SAUTH -DINCLUDE_KEMTLS_MUTUAL -DINCLUDE_KEMTLS_PDK_SAUTH -DINCLUDE_KEMTLS_PDK_SAUTH -DINCLUDE_KEMTLS_PDK_MUTUAL $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

deniability: preprocess
	tamarin-prover --quit-on-warning --diff $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt_deniability.spthy

clean:
	$(RM) -f generated_* */generated_*
