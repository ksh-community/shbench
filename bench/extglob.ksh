function extglob { ## len
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
   typeset -i len=$1 line=80 slen linum loop=0
   typeset x y

   #adjust `len' to multiple of `line'
   ((len = len/line * line))
   ((len = len > line ? len:line))
   ((linum = len/line - 1))  
   ((slen = 2 * linum + 1))

   # note that jot and rs are unlikely to be present on linux
   x=$(jot -r -c $len a a | rs -g0 0 $line)
   while ((loop++ < 1000)); do
      y=${x//+(a)/A}
   done

   ((${#y} <= $slen)) && [[ $y == *A* && $y != *a* ]]
}
typeset -i para=3000
((penalty > 0)) || penalty=1
extglob $((para/penalty))
