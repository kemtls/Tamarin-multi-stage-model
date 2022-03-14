from datetime import datetime
from math import log10
from ssl import CERT_REQUIRED
import subprocess
import re
from typing import Iterable, List, Optional, Tuple, Union
import os

#: Fetch lemmas from incomplete output
LEMMA_REGEX: re.Pattern = re.compile(r"^\s*(?P<lemma>[a-zA-Z0-9_]+) \((all-traces|exists-trace)\): analysis incomplete \(1 steps\)\s*$")

#: Parse out steps
STEPS_REGEX: str = r"^\s*{lemma} \((all-traces|exists-trace)\): verified \((?P<steps>\d+) steps\)\s*$"


def run_tamarin(model: str, prove: Union[str, None], defines: List[str]) -> str:
    cmd = ["tamarin-prover"]
    if 'TAMARIN_FLAGS' in os.environ:
        cmd.extend(os.environ['TAMARIN_FLAGS'].split(' '))
    cmd.extend(defines)
    cmd.append(model)
    if prove is not None:
        modelname = model.removesuffix(".spthy")
        cmd.append(f"--prove={prove}")
        cmd.append(f"--output=proofs/{modelname}_{prove}.spthy")
    result = subprocess.run(
        cmd,
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout


def get_lemmas(model: str, defines) -> Iterable[str]:
    """Parse out the lemmas from the output of Tamarin"""
    lines = run_tamarin(model, None, defines).splitlines()

    for line in lines:
        if m := LEMMA_REGEX.match(line):
            yield m.group("lemma")


def get_steps(tamarin_output: str, lemma) -> Optional[str]:
    pattern = STEPS_REGEX.format(lemma=lemma)
    if match := re.search(pattern, tamarin_output, re.MULTILINE):
        return match.group("steps")


def prove_lemmas(model, lemmas: Iterable[str], defines):
    lemmas = list(lemmas)
    max_lemma_length = max(len(lemma) for lemma in lemmas)
    for idx, lemma in enumerate(lemmas):
        start_time = datetime.now()
        stridx = str(idx+1).rjust(len(str(len(lemmas))))
        lemma_name = lemma.ljust(max_lemma_length)
        print(f"[{stridx}/{len(lemmas)}] Proving {lemma_name} at {start_time.time()}...", end="", flush=True)
        output = run_tamarin(model, lemma, defines)
        duration = datetime.now() - start_time
        steps = get_steps(output, lemma)
        if steps is None:
            print(output)
            print(f"Proof failed after {duration}!?")
            break
        print(f"\tCompleted in {steps: >4} steps in {duration}")


if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print(f"Usage: {sys.argv[0]} model.spthy [-Ddefine1 -Ddefine2 ..]")
        print("")
        print("Set environment variable TAMARIN_FLAGS to pass additional flags to Tamarin,")
        print("such as TAMARIN_FLAGS=\"+RTS -N16 -RTS\" to limit number of CPUs used to 16.")
        sys.exit(1)
    model = sys.argv[1]
    defines = sys.argv[2:]

    lemmas = get_lemmas(model, defines)
    start_time = datetime.now()
    prove_lemmas(model, lemmas, defines)
    duration = datetime.now() - start_time
    print(f"\n\nAll done in {duration}")
