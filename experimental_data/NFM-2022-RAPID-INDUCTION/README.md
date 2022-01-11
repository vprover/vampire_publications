# Artifact Evaluation

This file explains how to build and run the various tools discussed in the NFM 2022 submission 
"Lemmaless Induction in Trace Logic". Following the instructions the experimental results 
attained by the Rapid framework are fully verifiable.

The benchmarks that we use along with their C equivalents can be found at:

https://github.com/vprover/rapid/tree/ahmed-induction-support/examples/arrays

We also include a number of benchmarks with false assertions to show the soundness of our 
implementation:

https://github.com/vprover/rapid/tree/ahmed-induction-support/examples/arrays_unsat

Build and run RAPID to convert the benchmarks from .spec files to first-order logic
theorem proving problems expressed in SMTLIB (.smt2) files. This step is optional
and if you wish to directly run Vampire, the SMTLIB benchmarks are located:

https://github.com/vprover/vampire_publications/tree/master/experimental_data/NFM-2022-RAPID-INDUCTION/rapid_array_benchmarks

## Build Rapid

* Checkout commit 285e54b7e from https://github.com/vprover/rapid/tree/ahmed-induction-support
* Follow the instructions https://github.com/vprover/rapid/tree/ahmed-induction-support to build
  Rapid

## Run Rapid

`./rapid -dir [output directory name] [.spec file name]`

## Build Vampire

* Checkout commit 4a0f319f from  https://github.com/vprover/vampire/tree/ahmed-rapid
* Follow the instructions https://github.com/vprover/vampire to build
  Vampire

## Run Vampire

`./vampire -dir [output directory name] [.spec file name]`
