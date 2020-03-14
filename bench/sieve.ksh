# find primes using the sieve of eratosthenes
function sieve { ## n>=2 report(0/1)
   typeset -i n=$1 report=$2 i j k
   typeset keys
   typeset -a buf primes firstprimes
   firstprimes=(
      2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83
      89 97 101 103 107 109 113 127 131 137 139 149 151 157 163 167 173
      179 181 191 193 197 199 211 223 227 229 233 239 241 251 257 263 269
      271 277 281 283 293 307 311 313 317 331 337 347 349 353 359 367 373
      379 383 389 397 401 409 419 421 431 433 439 443 449 457 461 463 467
      479 487 491 499 503 509 521 523 541 547 557 563 569 571 577 587 593
      599 601 607 613 617 619 631 641 643 647 653 659 661 673 677 683 691
      701 709 719 727 733 739 743 751 757 761 769 773 787 797 809 811 821
      823 827 829 839 853 857 859 863 877 881 883 887 907 911 919 929 937
      941 947 953 967 971 977 983 991 997
   )
   j=1
   while ((j++ < n)); do
      buf[j]=1
   done
   if [[ -n $ZSH_NAME ]]; then
      set -o KSH_ARRAYS
      set -o SH_WORD_SPLIT
      keys=$(seq 2 $n)
   else
      # FIXME: how can zsh achieve this for _indexed_ arrays?  not at
      # all, it seems, since zsh arrays are not sparse and thus all
      # indices are "used" even if the stored value is just the empty
      # string. and there seems to be no syntax for "which elements
      # of the indexed array are not-empty?"
      keys=${!buf[@]}
   fi
   for i in $keys; do
      ((i * i > n)) && break
      if ((buf[i] == 1)); then
         ((j = i * i - i))
         while ((j += i)); do
            ((j <= n)) && buf[j]=0 || break
         done
      fi
   done
   j=0
   for i in $keys; do
      ((buf[i] == 1)) && ((primes[j++] = i))
   done
   if ((report)); then
      echo "${primes[@]} ($j primes)"
   fi

   # (partial) assertion. since mksh seemingly cannot do array
   # subsetting with ranges, we convert everything to strings first.
   # zsh does not allow a variable in `${x:0:k}' subsetting but
   # insists on `${x:0:$k}'. we comply. :)
   firstprimes=${firstprimes[@]}
   primes=${primes[@]}
   ((k = ${#firstprimes}))
   ((j = ${#primes}))
   ((k = j < k ? j:k))
   [[ ${primes:0:$k} == "${firstprimes:0:$k}" ]] && return 0 || return 1
}
# -----------------------------------------------------------------------
typeset -i para=150000
((penalty > 0)) || penalty=1
sieve $((para/penalty))
