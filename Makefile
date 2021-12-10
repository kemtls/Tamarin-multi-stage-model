all: prove

preprocess:
	m4 corekt.spthy > generated_corekt.spthy

preprocess-pdk:
	m4 corekt_pdk.spthy > generated_corekt_pdk.spthy

well-formed: preprocess
	tamarin-prover --quit-on-warning generated_corekt.spthy

well-formed-pdk: preprocess-pdk
	tamarin-prover --quit-on-warning generated_corekt_pdk.spthy

prove: preprocess
	tamarin-prover $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

prove-pdk: preprocess-pdk
	tamarin-prover $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt_pdk.spthy

clean:
	$(RM) -f generated_* */generated_*
