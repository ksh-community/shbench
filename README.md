# README

# NAME

**shbench** - a shell benchmarking utility and benchmark suite.

# DESCRIPTION

**shbench** is a utility, written in KornShell, for benchmarking ksh and
other Bourne shell descendants. The collected absolute run times or run
time ratios are provided as tabular output. Typical output looks like

      ---------------------------------------------------
      name             /bin/ksh  kshcommunity  ksh2020nms
      ---------------------------------------------------
      braces.ksh       1.00      0.93          2.60
      charsplit.ksh    1.00      0.96          2.01
      extglob.ksh      1.00      0.84          1.55
      fibonacci.ksh    1.00      0.99          3.08
      gsub.ksh         1.00      0.99          0.62
      hanoi.ksh        1.00      0.97          1.59
      numfor.ksh       1.00      0.99          3.32
      numloop.ksh      1.00      1.01          2.12
      parens.ksh       1.00      0.88          0.75
      piln2.ksh        1.00      1.00          2.01
      plus-equals.ksh  1.00      0.98          1.27
      printf.ksh       1.00      0.92          1.18
      qsort.ksh        1.00      0.96          2.17
      rand.ksh         1.00      0.97          2.05
      rand2.ksh        1.00      0.97          2.03
      sample.ksh       1.00      0.98          2.04
      shuffle.ksh      1.00      0.97          2.17
      ---------------------------------------------------

This example shows run time ratios derived on an OSX machine (MacBook
Pro) relative to `/bin/ksh` (the ksh93u+ shipped with OSX).
`kshcommunity` is a binary compiled from the ksh-community maintained
[repository](https://github.com/ksh-community/ksh) and `ksh2020nms` is
compiled from
[this](https://github.com/att/ast/commit/43d1853550010c2badce7da704019f5e61f62cac)
checkin of the ksh2020 line of development that previously occurred in
the ATT/AST repository (see
[here](https://github.com/att/ast/issues/1466) for some background why
it was stopped).

The benchmark suite can easily be extended or replaced by user-defined
benchmarks. For further details, cd to the top-level directory of the
cloned or downloaded project and issue

      shbench --man


# NOTE

**shbench** is maintained using the [Fossil](https://fossil-scm.org)
distributed version control system. If you are reading this on Github
you are looking at a Git mirror of the corresponding Fossil repository
that is hosted [here](http://fossil.0branch.com/csb). Fossil allows to
automatically push all changes occurring in the Fossil repository **to**
the Git mirror but will not import changes **from** the mirror. Due to
this setup, pull requests on Github cannot be accepted. Instead, use
Github Issues or the ticketing system provided by Fossil in the [master
repo](http://fossil.0branch.com/csb/ticket).
