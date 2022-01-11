TAMARIN_FLAGS=
# TAMARIN_FLAGS=+RTS -N16 -RTS # limit number of CPUs used
# TAMARIN_FLAGS=+RTS -s -M1000000000 -RTS # limit amount of memory used

all: prove

preprocess:
	m4 corekt.spthy > generated_corekt.spthy
	sed -I .backup -e 's/KEM_e/KEM_u/g' generated_corekt.spthy
	sed -I .backup -e 's/KEM_c/KEM_u/g' generated_corekt.spthy
	sed -I .backup -e 's/KEM_s/KEM_u/g' generated_corekt.spthy
	cd deniability && m4 kemtls_sauth.spthy > generated_kemtls_sauth.spthy
	cd deniability && m4 kemtls_mutual.spthy > generated_kemtls_mutual.spthy
	cd deniability && m4 kemtls_pdk_sauth.spthy > generated_kemtls_pdk_sauth.spthy
	cd deniability && m4 kemtls_pdk_mutual.spthy > generated_kemtls_pdk_mutual.spthy
	cd deniability && m4 --define=FULL kemtls_sauth.spthy > generated_kemtls_sauth_full.spthy
	cd deniability && m4 --define=FULL kemtls_mutual.spthy > generated_kemtls_mutual_full.spthy
	cd deniability && m4 --define=FULL kemtls_pdk_sauth.spthy > generated_kemtls_pdk_sauth_full.spthy
	cd deniability && m4 --define=FULL kemtls_pdk_mutual.spthy > generated_kemtls_pdk_mutual_full.spthy

prove-sauth: preprocess
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_SAUTH --quit-on-warning generated_corekt.spthy
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_SAUTH $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

prove-mutual: preprocess
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_MUTUAL --quit-on-warning generated_corekt.spthy
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_MUTUAL $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

prove-sauth-mutual: preprocess
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_SAUTH -DINCLUDE_KEMTLS_MUTUAL --quit-on-warning generated_corekt.spthy
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_SAUTH -DINCLUDE_KEMTLS_MUTUAL $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

prove-pdk-sauth: preprocess
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_PDK_SAUTH --quit-on-warning generated_corekt.spthy
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_PDK_SAUTH $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

prove-pdk-mutual: preprocess
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_PDK_MUTUAL --quit-on-warning generated_corekt.spthy
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_PDK_MUTUAL $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

prove-pdk-sauth-mutual: preprocess
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_PDK_SAUTH -DINCLUDE_KEMTLS_PDK_MUTUAL --quit-on-warning generated_corekt.spthy
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_PDK_SAUTH -DINCLUDE_KEMTLS_PDK_MUTUAL $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

prove-all: preprocess
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_SAUTH -DINCLUDE_KEMTLS_MUTUAL -DINCLUDE_KEMTLS_PDK_SAUTH -DINCLUDE_KEMTLS_PDK_SAUTH -DINCLUDE_KEMTLS_PDK_MUTUAL --quit-on-warning generated_corekt.spthy
	tamarin-prover ${TAMARIN_FLAGS} -DINCLUDE_KEMTLS_SAUTH_OR_MUTUAL -DINCLUDE_KEMTLS_SAUTH -DINCLUDE_KEMTLS_MUTUAL -DINCLUDE_KEMTLS_PDK_SAUTH -DINCLUDE_KEMTLS_PDK_SAUTH -DINCLUDE_KEMTLS_PDK_MUTUAL $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

deniability-sauth: preprocess
	tamarin-prover ${TAMARIN_FLAGS} --quit-on-warning --diff --prove --output --Output=output deniability/generated_kemtls_sauth.spthy

deniability-sauth-full: preprocess
	tamarin-prover ${TAMARIN_FLAGS} --quit-on-warning --diff --prove --output --Output=output deniability/generated_kemtls_sauth_full.spthy

deniability-mutual: preprocess
	tamarin-prover ${TAMARIN_FLAGS} --quit-on-warning --diff --prove --output --Output=output deniability/generated_kemtls_mutual.spthy

deniability-mutual-full: preprocess
	tamarin-prover ${TAMARIN_FLAGS} --quit-on-warning --diff --prove --output --Output=output deniability/generated_kemtls_mutual_full.spthy

deniability-pdk-sauth: preprocess
	tamarin-prover ${TAMARIN_FLAGS} --quit-on-warning --diff --prove --output --Output=output deniability/generated_kemtls_pdk_sauth.spthy

deniability-pdk-sauth-full: preprocess
	tamarin-prover ${TAMARIN_FLAGS} --quit-on-warning --diff --prove --output --Output=output deniability/generated_kemtls_pdk_sauth_full.spthy

deniability-pdk-mutual: preprocess
	tamarin-prover ${TAMARIN_FLAGS} --quit-on-warning --diff --prove --output --Output=output deniability/generated_kemtls_pdk_mutual.spthy

deniability-pdk-mutual-full: preprocess
	tamarin-prover ${TAMARIN_FLAGS} --quit-on-warning --diff --prove --output --Output=output deniability/generated_kemtls_pdk_mutual_full.spthy

deniability-all: deniability-sauth deniability-mutual deniability-pdk-sauth deniability-pdk-mutual

deniability-full-all: deniability-sauth-full deniability-mutual-full deniability-pdk-sauth-full deniability-pdk-mutual-full

clean:
	$(RM) -f generated_* */generated_*
