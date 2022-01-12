all: prove

preprocess:
	m4 corekt.spthy > generated_corekt.spthy
	cd deniability && m4 kemtls_sauth.spthy > generated_kemtls_sauth.spthy
	cd deniability && m4 kemtls_mutual.spthy > generated_kemtls_mutual.spthy
	cd deniability && m4 kemtls_pdk_sauth.spthy > generated_kemtls_pdk_sauth.spthy
	cd deniability && m4 kemtls_pdk_mutual.spthy > generated_kemtls_pdk_mutual.spthy

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

deniability-sauth: preprocess
	tamarin-prover --quit-on-warning --diff --prove --output --Output=output deniability/generated_kemtls_sauth.spthy

deniability-mutual: preprocess
	tamarin-prover --quit-on-warning --diff --prove --output --Output=output deniability/generated_kemtls_mutual.spthy

deniability-pdk-sauth: preprocess
	tamarin-prover --quit-on-warning --diff --prove --output --Output=output deniability/generated_kemtls_pdk_sauth.spthy

deniability-pdk-mutual: preprocess
	tamarin-prover --quit-on-warning --diff --prove --output --Output=output deniability/generated_kemtls_pdk_mutual.spthy

deniability-all: deniability-sauth deniability-mutual deniability-pdk-sauth deniability-pdk-mutual

clean:
	$(RM) -f generated_* */generated_*
