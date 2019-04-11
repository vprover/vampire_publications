------------- CONTENTS ----------------
The .csv files containing the raw output of all experiments.
The experiments were run over two sets of benchmarks:
a) TPTP benchmarks
b) Sledgehammer benchmarks
The names of the .csv files link them directly to the experiments and benchmarks described in the paper.

---------- OBTAINING Solvers ----------
The Vampire binary used in experiment 1 can be obtained at:

http://www.cs.man.ac.uk/~regerg/files/vampire_ho_schedule.zip

The corresponding tag in the Git repository is: cade2019exp1

The Vampire binary used in experiments 2 and 3 can be obtained at:

http://www.cs.man.ac.uk/~regerg/files/Vampire_two-ho_schedules.zip

The corresponding tag in the Git repository is: cade2019exp2and3

The CASC-2018 versions of Leo-III and Satallax were utilised in experiments. These can be obtained
from the ATPSystems space of StarExec:

https://www.starexec.org/starexec/secure/explore/spaces.jsp?id=23834

If access is required, a request can be sent to Geoff Suttcliffe at geoff@cs.miami.edu

-------- OBTAINING BENCHMARKS ---------
1) TPTP benchmarks can be obtained from:

   http://www.tptp.org/

2) To obtain the Sledgehammer benchmarks, a request can be made to the Matryoshka team using contact details to be found: http://matryoshka.gforge.inria.fr/#Contact

---------- RUNNING SOLVERS ------------
For experiment 1:

./vampire_z3_rel_static_HOL_branch_4025 <path_to_problem> --forced_options cunif=off:proof=off --schedule thf_2019 --mode portfolio --time_limit 500

For experiment 2 and 3:

./vampire_z3_rel_static_HOL_branch_4026 <path_to_problem> --proof off --time_statistics on --schedule thf_2019 --mode portfolio --time_limit <value>

Note: if running on StarExec, the configuration scripts provided in the zip folders linked to above can be used.
Configuration for experiment 2: 1st_sched 
Configuration for experiment 3: 1st_sched_without_drop_inapprop

----------ALTERNATIVE------------------
Alternatively, the authors can provide access to their space on StarExec which contains the relevant solvers and benchmarks if requested.
