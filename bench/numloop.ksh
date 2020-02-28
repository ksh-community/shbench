function numloop {
   typeset -i count=$1 i=0 buf=0
   while (( i < count)); do
      ((++i))
      ((++buf))
   done
   ((buf == i && buf == count))  # assertion
}
typeset -i para=1000000
((penalty > 0)) || penalty=1
numloop $((para/penalty))
