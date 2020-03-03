function pluseq { ## num > 1
   typeset -i i=0 num=$1
   typeset s si=1
   while ((i < num)); do
      ((++i))
      s+=$si
   done
   # assertion
   [[ $s == $si*$si && ${#s} == $num ]]
}
typeset -i para=200000
((penalty > 0)) || penalty=1
if [[ $refshell == "bash" ]];  then 
   ((penalty /= 4))
elif [[ $refshell == "zsh" ]];  then 
   ((penalty /= 4))
fi

pluseq $((para/penalty))
