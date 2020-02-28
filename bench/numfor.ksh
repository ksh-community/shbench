function numfor {
   typeset -i count=$1 i=0 buf=0
   for ((i = 0; i < count; i++)); do
      ((buf++))
      :
   done
   ((buf == i && buf == count))  # assertion
}
typeset -i para=1000000
((penalty > 0)) || penalty=1
numfor $((para/penalty))
