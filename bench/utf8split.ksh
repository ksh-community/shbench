#!/bin/ksh
# split utf-8 string into character array. this is essentially a test of
# utf-8 string subsetting with ${x:a:b}.

function utf8split { ## strlen report
   typeset -i strlen=$1 report=$2 i=-1
   typeset -a y
   typeset x

   x=$'\xe2\x9c\x93'
   x+=$'\xe2\x9c\x97'
   x+=$'\xe2\x98\x85'
   x+=$'\xe2\x99\xa5'
   x+=$'\xe2\x9a\x99'
   x+=$'\xe2\x86\x92'
   x+=$'\xe2\x9a\xa0'
   x+=$'\xe2\x84\xb9'
   while ((${#x} <= strlen)); do x+=$x; done
   x=${x: 0: strlen}   #space before 'strlen' required for zsh (or 0:$strlen needed)

   [[ -n $ZSH_NAME ]] && set -o KSH_ARRAYS    # required for zsh (obviously...)
   while ((++i < strlen)); do
      y[i]=${x: i:1}   #space before 'i' required for zsh (or $i:1 needed) 
   done  
   typeset IFS=''
   (($report)) && echo ${y[*]}
   #assertion
   [[ "${y[*]}" == $x ]] && return 0 || return 1
}
typeset -i para=10000
utf8split $para
