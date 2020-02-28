function braces { ## num
   function bracefun {
     echo "hello from bracefun"
   }
   typeset -i i=0 num=$1
   typeset out
   while ((i < num)); do
     out=${ bracefun; }
     ((++i))
   done
   unset -f bracefun
   # assertion
   ((i == num))
}
typeset -i para=100000
((penalty > 0)) || penalty=1
braces $((para/penalty))
