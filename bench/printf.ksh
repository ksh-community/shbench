# this mostly tests whether printf is a (fast) builtin or requires
# (slow) calls of an external program.
function prntf { ## count
   typeset -i wid i=0 count=$1
   wid=${#count}
   while ((i++ < count)); do
      printf "%0${wid}d\n" $i >/dev/null
   done
}
typeset -i para=30000
[[ $refshell == "mksh" ]] && ((penalty *= 4)) || penalty=1
prntf $((para/penalty))
