# tower of hanoi. this implementation *requires* ksh93: it uses
# namerefs to get the recursive calls with permuted argument lists
# right. it seems somewhat difficult to get this right for other
# shells and would require lots of swapping of the 3 global arrays
# between the recursive calls.
#
# for interactive use: source this file and than run, e.g.,
# `hanoi 3 1' to see the individual executed moves.
# ---------------------------------------------------------------------
function hanoi { ## n report
   function hanoi_report {
      typeset name peg pad
      integer i dif len flipflop
      typeset -a ruler=(" " ".")
      for name in from to aux; do
         peg='${'$name'[@]}'
         eval peg=$peg
         len=${#peg}
         ((dif = maxlen - len))
         ((dif == maxlen)) && flipflop=0 || flipflop=1
         pad=""
         for ((i = 0; i < dif; i++)); do
            ((flipflop = 1 - flipflop))
            pad+=${ruler[flipflop]}
         done
         printf "[$peg$pad] "
      done
      print
   }

   function hanoi_tower { ## n x y z report
      nameref n=$1
      ((n == 0)) && return

      nameref x=$2 y=$3 z=$4 report=$5
      integer n1 topdisk ny

      ((n1 = n - 1))

      hanoi_tower n1 x z y report

      # remove topdisk from x-peg
      topdisk=${x[-1]}
      unset x[-1]

      # add topdisk to y-peg
      ny=${#y[@]}
      y[ny]=$topdisk

      ((report)) && hanoi_report

      hanoi_tower n1 z y x report
   }
   # -------------------------------------------------------------------
   # give up if not a ksh (at least bash does not "fail correctly"...).
   [[ -z $KSH_VERSION ]] && exit 1 

   integer n=$1 report=$2 i
   typeset peg

   # fill "from" peg
   for ((i = 0; i < n; i++)); do ((from[i] = n - i)); done 

   # `maxlen' is needed by `hanoi_report'
   peg=${from[@]}
   maxlen=${#peg}

   ((report)) && hanoi_report
   hanoi_tower n from to aux report

   [[ ${to[@]} == "$peg" ]] && status=0 || status=1

   # tidy up global name space
   unset -f hanoi_report hanoi_tower
   unset from aux to para report maxlen 

   return $status
}
# -----------------------------------------------------------------------
integer para=13 report=0 maxlen
typeset -a from aux to
hanoi $para $report
