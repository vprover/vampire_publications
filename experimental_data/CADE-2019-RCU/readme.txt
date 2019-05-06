------------- CONTENTS ----------------
The .csv files containing the raw output of all experiments.
The experiments were run over two sets of benchmarks:
a) TPTP benchmarks
b) Sledgehammer benchmarks
The names of the .csv files link them directly to the benchmarks described in the paper.

---------- OBTAINING Solvers ----------
The Vampire binary used in the experiment can be obtained at:



The CASC-2018 versions of Leo-III and Satallax were utilised in experiments. These can be obtained
from the ATPSystems space of StarExec:

https://www.starexec.org/starexec/secure/explore/spaces.jsp?id=23834

If access is required, a request can be sent to Geoff Suttcliffe at geoff@cs.miami.edu

-------- OBTAINING BENCHMARKS ---------
1) TPTP benchmarks can be obtained from:

   http://www.tptp.org/

2) To obtain the Sledgehammer benchmarks, a request can be made to the Matryoshka team using contact details to be found: http://matryoshka.gforge.inria.fr/#Contact

---------- RUNNING SOLVERS ------------

./vampire_z3_rel_static_HOL_branch_4028 <path_to_problem> --forced_options cunif=<val1>:combinator_elimination=<val2>:proof=off --schedule thf_2019 --mode portfolio --time_limit <value>

Note: if running on StarExec, the configuration scripts provided in the zip folders linked to above can be used.

----------ALTERNATIVE------------------
Alternatively, the authors can provide access to their space on StarExec which contains the relevant solvers and benchmarks if requested.
