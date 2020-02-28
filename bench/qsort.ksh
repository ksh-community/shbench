# quicksort. the stumbling stone is (was...) to keep `ara' in sync
# with `vals': the issue is that in order to keep everything local to
# the functions (rather than defining the array `ara' globally) we
# need the string `vals' to pass args to/from function calls while
# needing the array `ara' internally to do the 'quicksorting'.
function qsort { ## n m report
   if [[ -n $ZSH_NAME ]]; then
      set -o SH_WORD_SPLIT
      set -o KSH_ARRAYS
   fi
   function qs { ## vals lo hi
      typeset vals=$1 dum
      typeset -i lo=$2 hi=$3 i j pivot 
      typeset -a ara
      i=$lo
      j=$hi
      while ((i < hi)); do
         ara=($vals)
         pivot=${ara[$(((lo + hi)/2))]}
         while ((i <= j)); do 
            while ((ara[i] < pivot)); do ((i++)); done
            while ((ara[j] > pivot)); do ((j--)); done
            if ((i <= j)); then
               dum=${ara[i]}
               ara[i]=${ara[j]}
               ara[j]=$dum
               ((i++))
               ((j--))
            fi
         done
         vals=${ara[@]}
         if ((lo < j)); then
            vals=$(qs "$vals" $lo $j)
         fi
         lo=$i
         j=$hi
      done
      echo $vals
   }
   # ------------------------------------------------------
   # sort n random integers sampled from the range [1, m]
   typeset -i n=$1 m=$2 report=$3
   typeset res
   ((m > 0)) || m=$n
   typeset vals=$(jot -r $n 1 $m)
   res=$(qs "$vals" 0 $((n-1)))
   unset -f qs
   ((report)) && echo $res || return 0
}
typeset -i para=1500 bag=10000
((penalty > 0)) && ((penalty /= 4)) || penalty=1
qsort $(($para/penalty)) $bag
