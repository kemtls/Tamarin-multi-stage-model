all: prove

preprocess:
	m4 corekt.spthy > generated_corekt.spthy

well-formed: preprocess
	tamarin-prover --quit-on-warning generated_corekt.spthy

prove: preprocess
	tamarin-prover $(if $(PROVE), --prove=$(PROVE), --prove) --output --Output=output generated_corekt.spthy

clean:
	$(RM) -f generated_* */generated_*
