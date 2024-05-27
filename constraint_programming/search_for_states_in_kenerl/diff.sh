#!/bin/bash

function max2 {
   while [ `jobs | wc -l` -ge 30 ]
   do
      sleep 1
   done
}
set -e
nr=3
sboxnum=$2
mkdir -p ./$1/diff
mkdir -p ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox
mkdir -p ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/results
num=0
take=0
while read p; do

	if [[ "$p" == *"-"* ]]; then
		echo ${p}
		echo $num
		cp ./$1/diff.mzn ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
		take=1
		continue

	fi
	if [[ ${take} -eq 1 ]]; then # this is the 1 line
		for ((i=0;i<=${#p};i++)); do
			if [[ ${p:$i:1} == 1 ]]; then
				echo "constraint stateend[0,0,${i}] = 1;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
			if [[ ${p:$i:1} == 0 ]]; then
				echo "constraint stateend[0,0,${i}] = 0;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
		done
		take=2
		continue
	fi

	if [[ ${take} -eq 2 ]]; then # this is the 2 line
		for ((i=0;i<=${#p};i++)); do
			if [[ ${p:$i:1} == 1 ]]; then
				echo "constraint stateend[0,1,${i}] = 1;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
			if [[ ${p:$i:1} == 0 ]]; then
				echo "constraint stateend[0,1,${i}] = 0;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
		done
		take=3
		continue
	fi

	if [[ ${take} -eq 3 ]]; then # this is the 3 line
		for ((i=0;i<=${#p};i++)); do
			if [[ ${p:$i:1} == 1 ]]; then
				echo "constraint stateend[0,2,${i}] = 1;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
			if [[ ${p:$i:1} == 0 ]]; then
				echo "constraint stateend[0,2,${i}] = 0;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi

		done
		take=4
		continue
	fi


	if [[ ${take} -eq 4 ]]; then # this is the 4 line
		for ((i=0;i<=${#p};i++)); do
			if [[ ${p:$i:1} == 1 ]]; then
				echo "constraint stateend[0,3,${i}] = 1;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
			if [[ ${p:$i:1} == 0 ]]; then
				echo "constraint stateend[0,3,${i}] = 0;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
		done
		take=5
		continue
	fi

	if [[ ${take} -eq 5 ]]; then # this is the 5 line
		for ((i=0;i<=${#p};i++)); do
			if [[ ${p:$i:1} == 1 ]]; then
				echo "constraint stateend[0,4,${i}] = 1;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
			if [[ ${p:$i:1} == 0 ]]; then
				echo "constraint stateend[0,4,${i}] = 0;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
		done
		take=6
		continue
	fi

	if [[ ${take} -eq 6 ]]; then # this is the 1 line
		for ((i=0;i<=${#p};i++)); do
			if [[ ${p:$i:1} == 1 ]]; then
				echo "constraint statestart[1,0,${i}] = 1;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
			if [[ ${p:$i:1} == 0 ]]; then
				echo "constraint statestart[1,0,${i}] = 0;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi

		done
		take=7
		continue
	fi

	if [[ ${take} -eq 7 ]]; then # this is the 2 line
		for ((i=0;i<=${#p};i++)); do
			if [[ ${p:$i:1} == 1 ]]; then
				echo "constraint statestart[1,1,${i}] = 1;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
			if [[ ${p:$i:1} == 0 ]]; then
				echo "constraint statestart[1,1,${i}] = 0;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
		done
		take=8
		continue
	fi

	if [[ ${take} -eq 8 ]]; then # this is the 3 line
		for ((i=0;i<=${#p};i++)); do
			if [[ ${p:$i:1} == 1 ]]; then
				echo "constraint statestart[1,2,${i}] = 1;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
			if [[ ${p:$i:1} == 0 ]]; then
				echo "constraint statestart[1,2,${i}] = 0;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
		done
		take=9
		continue
	fi


	if [[ ${take} -eq 9 ]]; then # this is the 4 line
		for ((i=0;i<=${#p};i++)); do
			if [[ ${p:$i:1} == 1 ]]; then
				echo "constraint statestart[1,3,${i}] = 1;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
			if [[ ${p:$i:1} == 0 ]]; then
				echo "constraint statestart[1,3,${i}] = 0;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
		done
		take=10
		continue
	fi



	if [[ ${take} -eq 10 ]]; then # this is the 5 line
		for ((i=0;i<=${#p};i++)); do
			if [[ ${p:$i:1} == 1 ]]; then
				echo "constraint statestart[1,4,${i}] = 1;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
			if [[ ${p:$i:1} == 0 ]]; then
				echo "constraint statestart[1,4,${i}] = 0;" >> ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn
			fi
		done
		take=0
		max2; minizinc --solver "chuffed" -a -D "nr = ${nr};" --time-limit 7200000 --output-time --statistics ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/Our_${nr}rd_${num}.mzn > ./$1/diff/iterative_calls_${nr}nr_${sboxnum}sbox/results/Our_results_${num}.txt &
		num=$((num + 1))
		echo num $num
	fi
done < The_states_in_the_kenerl/Sbox_${sboxnum}.txt




