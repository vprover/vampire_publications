------------- CONTENTS ----------------
The .csv files containing the raw output of all experiments.
The experiments were run over two sets of benchmarks:
a) TPTP benchmarks
b) Sledgehammer benchmarks
The names of the .csv files link them directly to the experiments and benchmarks described in the paper.

---------- OBTAINING Solvers ----------
The Vampire binary used in experiment 1 can be obtained at:

http://www.cs.man.ac.uk/~regerg/files/vampire_ho_schedule.zip

The Vampire binary used in experiments 2 and 3 can be obtained at:

http://www.cs.man.ac.uk/~regerg/files/Vampire_two-ho_schedules.zip


-------- OBTAINING BENCHMARKS ---------
1) TPTP benchmarks can be obtained from:

   http://www.tptp.org/

2) To obtain the Sledgehammer benchmarks, a request can be made to the Matryoshka team using contact details to be found: http://matryoshka.gforge.inria.fr/#Contact

---------- RUNNING SOLVERS ------------
For experiment 1:

./vampire_z3_rel_static_HOL_branch_4025 <path_to_problem> --forced_options cunif=off:proof=off --schedule thf_2019 --mode portfolio --time_limit 500

For experiment 2 and 3:

./vampire_z3_rel_static_HOL_branch_4026 <path_to_problem> --proof off --time_statistics on --schedule thf_2019 --mode portfolio --time_limit <value>

----------ALTERNATIVE------------------
Alternatively, the authors can provide access to the solvers and TPTP benchmarks on StarExec system if requested.

To obtain access to the SH-\lambda benchmarks on StarExec, a request can be made to the Matryoshka team using the details given above.