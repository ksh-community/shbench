# random permutation of the given sample using durstenfeld's
# implementation of fisher-yates shuffle.
function shuffle { ## num report  # if `report=1' the result is reported on stdout
   if [[ -n $BASH_VERSION ]]; then
      # temporary. reason for bash returning exit 0 despite failure not yet clarified.
      echo "! skipping shuffle in bash" 1>&2
      exit 1
   fi
   if [[ -n $ZSH_NAME ]]; then
      set -o SH_WORD_SPLIT
      set -o KSH_ARRAYS
   fi
   typeset entries=$(seq 1 $1)
   typeset -i index j report=$2
   typeset ara dum
   typeset -E runif
   set -A ara $entries
   typeset n=${#ara[@]}
   for ((i = n - 1; i >= 1; i--)); do
      runif=$((RANDOM/(32767. + 1.0e-15)))
      j=$(( (i + 1) * runif ))  # random integer in [0, i] (but see comment in `sample.ksh')
      dum=${ara[j]}
      ara[j]=${ara[i]}
      ara[i]=$dum
   done
   ((report)) && print -- "${ara[*]}"

   # assertion (responsible for about 10-20% (it becomes worse with
   # increasing size of `entries') of run time for ksh. I believe the
   # `<<<' here string is mostly responsible for this.
   typeset IFS=$'\n'
   typeset sa=$(sort -n <<< "${ara[*]}")
   # note to self: for sufficiently large strings [[ $sa == $entries
   # ]] segfaults in ksh93u+ this might be a principal problem with
   # the underlying glob matcher. we circumvent this problem as
   # follows:
   ( [[ $sa < $entries ]] || [[ $sa > $entries ]] ) && return 1 || return 0
}
typeset -i para=70000
((penalty > 0)) || penalty=1
[[ $refshell == zsh ]] && ((penalty /= 2))
shuffle $((para/penalty))
