# use robert floyd's algorithm for getting a random sample of size m
# from population of size n (m <= n). the sample is random regarding
# the selected members of the population but not regarding its
# ordering, i.e. the sample is *not* randomly permuted. this might
# or might not be what one wants...
function sample { ## m n report
   if [[ -n $ZSH_NAME ]]; then
      set -o SH_WORD_SPLIT
   fi
   typeset -i m=$1 n=$2 report=$3 i num rnum hit i
   float runif
   typeset nums=""
   for ((i = n - m + 1; i <= n; i++)); do
      # note: `runif' is a random number in [0, 1). remember that
      # there are only 32767 distinct `runif' values, though, since
      # $RANDOM provides just a positive short int. consequently,
      # there are also only 32767 possible `rnum' values for each
      # given value of `i' so that rnum will only be a random int in
      # [1, i] if i (hence n) is not too large. to make this a truely
      # random sample for large n as well, one would need a generator
      # for really uniform random numbers in [0, 1).

      # we use the semi-open interval [0, 1) in order to avoid
      # spurious hits of exactly one that would somewhat mess up the
      # conversion to integer random numbers using integer truncation.
      # then convert to random integer in [low hig] by computing
      # $((low + (hig - low + 1) * runif)):

      runif=$((RANDOM/(32767. + 1.0e-15)))
      rnum=$(( 1 + i * runif ))  # random int in [1, i]
      # check whether `rnum' has already been drawn:
      hit=0
      for num in $nums; do
         ((rnum == num)) && { hit=1; break; }
      done
      ((hit == 1)) && nums+=$i || nums+=$rnum
      nums+=" "
   done
   ((report)) && print -- $nums || return 0
}
typeset -i para=2500 bag=10000
((penalty > 0)) || penalty=1
[[ $refshell == zsh ]] && ((penalty /= 4))
sample $((para/penalty)) $bag
