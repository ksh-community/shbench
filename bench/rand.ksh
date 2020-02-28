# random number generation using the RANDOM shell variable. since
# RANDOM is a positive short int, it is not suitable when
# fine-grained random numbers are required. formally, this is
# essentially a hash-collision problem: there is a (rather small)
# finite number of possible values and drawing too many single samples
# (with replacement...) from this set will find the same value(s)
# repeatedly.

# this function counts the number of occurrences of the different
# random numbers and gives an idea how rapidly with increasing `n'
# collisons appear (an example of the birthday problem).
function rand { ## n report
   typeset -i rnum rmin rmax
   typeset -i i count minhit maxhit=0 n=$1 report=$2
   typeset -A buf
   for ((i = 1; i <= n; i++)); do
      ((buf[$RANDOM]++))
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
rand 300000
