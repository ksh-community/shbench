#!/bin/ksh
# split string into character array. this is essentially a test of
# string subsetting with ${x:a:b} (~95% of run time with ksh).

function charsplit { ## strlen report
   typeset -i strlen=$1 report=$2 i=-1
   typeset -a y
   typeset x

   x=$(jot -s "" -r -c $strlen a z)

   [[ -n $ZSH_NAME ]] && set -o KSH_ARRAYS    # required for zsh (obviously...)
   while ((++i < strlen)); do
      y[i]=${x: i:1}   #note: space in ${x: i:1} required for mksh
   done  
   (($report)) && echo ${y[*]}

   #assertion
   typeset IFS=''
   [[ "${y[*]}" == $x ]] && return 0 || return 1
}
typeset -i para=10000
charsplit $para
