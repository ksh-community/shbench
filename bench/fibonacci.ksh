# the well known (and inefficient) recursive approach for calculating
# Fibonacci numbers.
function fibs { ## n verbose
   function fib { ## n
      typeset -i n=$1
      if ((n < 2)); then
         echo $n 
      else
         typeset -i f1 f2
         f1=$(fib $((n - 1)))
         f2=$(fib $((n - 2)))
         echo $((f1 + f2))
      fi
   }
   # --------------------------------------
   typeset -i n=0 res nmax=$1 verbose=$2
   while ((n <= nmax)); do
      res=$(fib $n)
      ((verbose)) && echo $res
      ((++n))
   done
   unset -f fib
}

typeset -i para=19
((penalty > 0)) || penalty=1
[[ $refshell == zsh ]] && ((penalty *= 2))
fibs $((para - penalty/3))

# ---------------------------------------------------------------------
# NOTE TO SELF:
# a a memory fault is triggered in ksh93u+ if `fibs' is called
# repeatedly with modestly large argument n. `fibs 21' does already
# fail at first try. the memory fault also happens quickly when calling
# `fibs 20' repeatedly. ksh93v- does not have this problem.
# ---------------------------------------------------------------------
