function gsub { ## len
   if [[ -n $BASH_VERSION ]]; then
      if [[ ${BASH_VERSINFO[0]} < 4 ]]; then
         echo "! skipping pathologically slow benchmark in bash $BASH_VERSION" 1>&2
         exit 1
      else
         shopt -s extglob
      fi
   elif [[ -n $ZSH_NAME ]]; then
      set -o KSH_GLOB
   fi

   typeset -i len=$1 line=80 slen linum
   typeset x y

   #adjust `len' to multiple of `line'
   ((len = len/line * line))
   ((len = len > line ? len:line))
   ((linum = len/line - 1))  
   ((slen = 2 * linum + 1))

   # note that jot and rs are unlikely to be present on linux
   x=$(jot -r -c $len a a | rs -g0 0 $line)
   y=${x//+(a)/A}

   ((${#y} <= $slen)) && [[ $y == *A* && $y != *a* ]]
}
typeset -i para=700000
((penalty > 0)) || penalty=1
if [[ $refshell == mksh || $refshell == bash ]]; then
   ((penalty *= 50))
elif [[ $refshell == "zsh" ]];  then 
   ((penalty /= 2))
fi
gsub $((para/penalty))
