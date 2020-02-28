function parens { ## num
   function parfunw {
     echo "hello from parfunw"
   }
   typeset -i i=0 num=$1
   typeset out
   while ((i < num)); do
     out=$(parfunw)
     ((++i))
   done
   unset -f parfunw
   # assertion
   ((i == num))
}
typeset -i para=40000
((penalty > 0)) || penalty=1
parens $((para/penalty))
