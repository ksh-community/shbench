# two (slowly) converging infinite series approximating well-known numbers.
#
function piln2 {  # loopcount report
   if [[ -n $BASH_VERSION ]]; then
      # patch, since bash fails only with large delay otherwise
      # despite floating point arithmetic involved (to be clarified
      # what causes the delay)
      exit 1
   fi
   typeset -lE x=0.0 y=0.0 z=0.0 pisq ln2
   typeset -i i loopcount=$1 report=$2
   for ((i = 1; i <= loopcount; i ++)); do
      ((x += 1.0/(i * i)))     # -> pi^2/6, see https://en.wikipedia.org/wiki/Basel_problem
      ((z += -1.0**i/i))       # -> -ln(2)
   done
   pisq=$(printf "%.6f\n" $((6 * x)))
   ln2=$(printf "%.6f\n" $((-z)))
   if ((report)); then
      print $pisq
      print $ln2
   fi
   ((1 - pisq/9.869604 < 1e-6 && 1 - ln2/0.693147 < 1e-6)) || return 1
}
typeset -i para=1000000
piln2 $para

# NOTE TO SELF: this benchmark cannot just honour `penalty' since the
# assertion relies on sufficient accuracy of the computation. no real
# problem since it works anyway only for ksh and zsh so far and zsh
# speed is okayish...

