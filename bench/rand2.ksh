# see also `rand.ksh'. the present function reduces granularity of
# the integer random numbers accessible via $RANDOM by using pairs of
# such positive short int values in the range [0, 2^15 -1] to
# construct a larger random integer in the range [0, 2^30].

function rand2 { ## n report
   typeset -i rnum rmin rmax random
   typeset -i i count minhit maxhit=0 n=$1 report=$2
   typeset -A buf
   for ((i = 1; i <= n; i++)); do
      ((random = RANDOM * 32768 + RANDOM))
      ((buf[$random]++))
   done
   minhit=$n
   if [[ -n $ZSH_NAME ]]; then
      set -o KSH_ARRAYS
      set -o SH_WORD_SPLIT
      typeset keys=${(k)buf[@]}
   else
      typeset keys=${!buf[@]}
   fi
   for rnum in $keys; do
      count=${buf[$rnum]}
      if ((count < minhit)); then
         minhit=$count
         rmin=$rnum
      fi
      if ((count > maxhit)); then
         maxhit=$count
         rmax=$rnum
      fi
   done
   ((report)) && echo "$n draws, ${#buf[@]} unique values, value $rmax drawn $maxhit times, value $rmin $minhit times" || return 0
}
rand2 100000
