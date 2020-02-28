#!/bin/ksh
# see `getopts' manpage in the code
# -------------------------------------------------------------------
function allgood {
   [[ $KSH_VERSION == Version\ A* ]] || {
     print -u2 "sorry, this script requires ksh93 to run."
     return 1
   }

   # ensure that the targeted shells are present
   typeset sh
   for sh in $shells; do
      $sh -c : || { print -u2 "please install this shell and retry (or exclude it from benchmarking)"; return 1; }
   done

   # also do a few tests for not necessarily available tools used here
   # and/or in the benchmark files.
   jot 1 >/dev/null            || { print -u2 please install it and retry; return 1; }
   print 1 | rs 1 > /dev/null  || { print -u2 please install it and retry; return 1; }
}

function printBanner { ## name
  typeset name=$1
  print -u$fd -- "*** $name ***"
}

function runit {  ## script
   compound res
   typeset -A cpu
   typeset str shop script="$@"

   for sh in $shells; do
     res.shell=$sh
     typeset str="# $sh"
     print -u$fd -n $str
     msg=$($sh -n "$script" 2>&1) || {  # this isn't a foolproof check!
       print -u$fd ": $msg[1G!"
       res.pass=**skip**
       res.time="real NA user NA sys NA"
       print $res " "
       continue
     }
     [[ $sh == k* ]] && shop=-e || shop=''
     function runShell { ## $sh,$shop,$script
        typeset -i i
        typeset sh=$1 shop=$2 script=$3
        for ((i = 1; i <= $loop; i++)); do
           $sh $shop "$script"
        done
     }
     str=$({ time runShell $sh $shop $script; } 2>&1)
     #str=$({ time $sh $shop "$script"; } 2>&1)
     if (($? != 0)); then
       print -u$fd "[1G! $sh: ${str%%$'\n'*}"   ## hopefully the error message but `time' output stripped
       res.pass=**fail**
       set -A cpu "real NA user NA sys NA"
     else
       print -u$fd ""
       res.pass=ok
       set -A cpu $str
     fi
     res.time=${cpu[*]}
     print $res " "
   done
}

function runScripts { ## $flist
   typeset -a times
   typeset -A bm
   typeset scripts=$* name dir script pass
   typeset add repline report i
   print -u2 "\nbenchmarking ${shells// /, } ..."
   for script in $scripts; do
     name=${script##*/}
     printBanner "$name"
     # explanation: the next line puts the set of compound variables
     # (each containing the results of this benchmark for one of the
     # considered shells) as an indexed array into one element of the
     # associative array `bm'. so `bm' is an (associative) array
     # of (indexed) arrays of compound variables.
     eval "bm[$name]=($(runit $script))"
   done
   typeset IFS=$'\n'
   for name in ${!bm[*]}; do
     unset IFS
     report+="${name// /$'\034'} "
     repline=''
     for i in "${!bm[$name][@]}"; do
       set -A times ${bm[$name][i].time}
       pass=${bm[$name][i].pass}
       [[ $pass == "ok" ]] && add=${times[1]} || add=$pass
       repline+="$add "
     done
     if ((useRatios == 1)); then
        typeset -a ratios
        set -A ratios $repline
        typeset refrat=${ratios[0]}
        typeset val
        for i in ${!ratios[@]}; do
           val=${ratios[i]}
           if [[ $val == *[[:alpha:]]* ]]; then
              continue
           elif [[ $refrat == *[[:alpha:]]* ]]; then
              ratios[i]=NA
           else
              ratios[i]=$(printf '%.2f' $((val/$refrat)))
           fi
        done
        repline=${ratios[@]}
     fi
     report+=$repline
     report+=$'\n'
   done
   print "$report"
}

function mkruler { ## table
   nameref table=$1
   typeset ruler lines
   typeset -i mxlen=0 slen=0 
   typeset IFS=$'\n'
   set -A lines $table
   for i in ${lines[*]}; do
      slen=${#i}
      ((mxlen = slen > mxlen ? slen : mxlen))
   done
   for ((i = 0; i < mxlen; i++)); do ruler+="-"; done
   unset IFS
   print $ruler
}

function mktable {  ## report
   typeset report="$*"
   typeset header
   set -A header name $shells
   typeset -i ncols=${#header[@]}
   typeset table=$(print "name $shells $report" | rs -z 0 $ncols | tr '\034' '\040')
   typeset ruler=$(mkruler table) lf=$'\n'
   table=${table/+([!$lf]$lf)/\1$ruler$lf}
   print "$lf$ruler"
   print "$table"
   print $ruler
}

function setPenalty { ## shell name
   typeset shell=$1
   typeset -A penalties
   penalties=(
      [ksh]=1
      [zsh]=8
      [mksh]=16
      [bash]=16
   )
   # working hypothesis: shells sharing the leading `*sh' glob in
   # their name have comparable performance. so we adjust penalty
   # depending on this identifier
   refshell=${shell/@(*sh)*(*)/\1} 
   penalty=${penalties[$refshell]}
   [[ -n $penalty ]] || penalty=${penalties[ksh]}
   export refshell penalty
}

function setup { ## $0 
   # some defaults
   fallback="ksh mksh"
   bdir=./bench
   TIMEFORMAT=$'\nreal\t%2R\nuser\t%2U\nsys\t%2S'
   loop=1

   opstring+="[+NAME?${1##*/}]"
   opstring+=$'[+DESCRIPTION?Benchmarking shells.]'
   opstring+=$'[+?Called without options and arguments, all benchmarks
      in the default location "'$bdir'" are run for the default shells
      ('${fallback// /, }').
   ]'
   opstring+=$'[+?Benchmarks can be selected via \a-b\a and have to be
      valid relative or absolute pathnames (remember to double quote the
      argument if multiple files are specified, e.g. when using
      wildcards). \a-d path\a is equivalent to \a-b "path/*.ksh"\a and
      is provided for convenience.

   ]'
   opstring+=$'[+?Absolute run times are reported in seconds using two
      decimal digits. Use \a-r\a to report relative run times when
      comparing different shells.
      
   ]'
   opstring+=$'[+?Results table: benchmarks which do not pass a syntax
      check for the considered shell are skipped and flagged as
      **skip**. Benchmarks failing to complete successfully are flagged
      as **fail**. If \a-r\a is used and the reference shell skips (or
      fails for) a benchmark so that a ratio cannot be computed for
      another (not failing) shell, the respective entry is set to "NA".

   ]'
   opstring+=$'[+?The \a-l\a option allows to set a repeat count for
      benchmark execution. This might help to increase timing
      reliability. So far only the cumulative time of all repeated runs
      is reported. No analysis of variability across runs is provided.

   ]'
   opstring+=$'[+TECHNICAL DETAILS?Actual run time of a given benchmark
      and a given shell is controlled by which shell is specified first
      as argument to the call: provisions are in place in the different
      benchmark files to use that shell as the "reference shell" for
      which the run times should be acceptable (order of
      1s/benchmark/run). For example, when calling the script with args
      "ksh mksh" run times are adjusted for ksh (which might lead to
      excessively long run times for mksh) while when calling it with
      args "mksh ksh" the run times are adjusted for mksh (which might
      lead to very short run times of ksh, thus making relative
      performance measurements unreliable).
   ]'
   opstring+=$'[+?The relevant information is stored in 2 exported
      variables "refshell" and "penalty" to which the subshells
      executing the benchmark do have access. The latter is the
      estimated average run time increase of the selected reference
      shell relative to ksh ("the penalty" incured when using anything
      else ;)) and hardcoded in the script. The former ("refshell") can
      be used to adjust individual benchmarks independently if the
      assumed "penalty" is unsuitable for the given reference shell.
      Benchmarks are of course not obliged to honour this information at
      all in which case the run time of the respective benchmark just
      remains independent of the order in which the shells appear in the
      call. Look at the existing benchmarks to get the idea when
      writing further benchmark files.

   ]'
   opstring+=$'[+?Regarding reliability of the timing information,
      the usual caveats apply. Ensure that the used machine is not too
      busy otherwise. Rerun several times to assess how reproducible
      the measurements are. Very short run times are inherently less
      reliable than longer ones (larger fractional uncertainty). This
      situation can be only partly improved by using \a-l\a with an
      increased loop count since a) the times are currently stored with
      only 10 ms accuracy and b) the startup time of the subshell is of
      about the same magnitude (which biases the measurement). Take
      home message: don\'t take run times below about 0.1-0.2 seconds
      per loop too serious.

   ]'
   opstring+="[b:bm?Select benchmarks to run.]:[flist]"
   opstring+="[d:dir?Location of the benchmark files.]:[bdir:=$bdir]"
   opstring+="[l:loop?Run each benchmark so many times.]#[loop:=$loop]"
   opstring+="[q:quite?Suppress progess report and associated error messages.]"
   opstring+="[r:ratio?Report timing as ratios relative to first specified shell.]"

   opstring+=$'\n\n [shell(s) ...]'
}
# ---------------------------------------------------------------------------
# note: we boldly assume adherence to a no-blanks-in-file-names
# policy at a few points... 

typeset fallback bdir opstring opt flist useRatios report quite fd=2
typeset -a shells

setup $0

while getopts "$opstring" opt; do
   case $opt in
      b) flist=$OPTARG;;
      d) bdir=$OPTARG;;
      l) loop=$OPTARG;;
      q) fd=3
         eval "redirect $fd> /dev/null"
      ;;
      r) useRatios=1;;
   esac
done
shift $((OPTIND - 1))

(($# == 0)) && set $fallback
flist=${flist:-$bdir/*.ksh}
shells=${*:-$fallback}
setPenalty $1

allgood || exit 1
report=$(runScripts $flist)
mktable "$report"
