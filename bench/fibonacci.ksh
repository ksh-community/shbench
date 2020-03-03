function fibslow { ## n
   # the well known (and inefficient) recursive approach for calculating
   # Fibonacci numbers.
   # ---------------------------------------------------------------------
   # NOTE TO SELF:
   # a a memory fault is triggered in ksh93u+ if `fibslow' is called
   # repeatedly with modestly large argument n. `fibslow 21' does already
   # fail at first try. the memory fault also happens quickly when calling
   # `fibslow 20' repeatedly. ksh93v- does not have this problem.
   # ---------------------------------------------------------------------
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
   typeset -i n=0 nmax=$1
   typeset res
   while ((n <= nmax)); do
      res+="$(fib $n) "
      ((++n))
   done
   unset -f fib
   echo $res
}

function fibfast { ## n
   typeset -i n=$1
   typeset -a fibnums
   fibnums[0]=0
   fibnums[1]=1
   if ((n < 2)); then
      echo ${fibnums[@]:0:n+1}
   else
      typeset -i i=1
      while ((++i <= n)); do
         ((fibnums[i] = fibnums[i-1] + fibnums[i-2]))
      done
      echo ${fibnums[@]}
   fi
}
# -------------------------------------------------------------------------
if [[ -n $ZSH_NAME ]]; then
   set -o SH_WORD_SPLIT
   set -o KSH_ARRAYS
fi
typeset r1 r2
typeset -i para=19
((penalty > 0)) || penalty=1
[[ $refshell == zsh ]] && ((penalty *= 3))
typeset -i num=$((para - penalty/3))
r1=$(fibslow $num)
r2=$(fibfast $num)
[[ $r1 == "$r2" ]] || exit 1
