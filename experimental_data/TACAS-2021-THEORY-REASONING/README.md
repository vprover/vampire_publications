# General

The file `non_trivial.txt` conains the problem set B, mentioned in the paper, on which the two experiments were conducted.

# Experiment 1
In the directory `experiment1`, there is a file `<config>.solved.txt`` listing the solved problems, for each of the configurations of vampire, considered in the paper. The file `ids.txt` lists which options were enabled/disabled for which configurations. The file `greedy-ranking` contains the full ranking of configurations, of which the top 10 are listed in the paper.

# Experiment 2
The directory `experiment2` contains a file `<config>.porfolio.solved.txt` listing the solved problems, for each of the configurations used in experiment 2. The configuration id to options mapping is the same one as in `experiment1` (except that portfolio mode is enabled). Further the directory contains a file `z3.solved.txt`, and `cvc4.solved.txt` for the problems solved by z3, and cvc4 respectively.
