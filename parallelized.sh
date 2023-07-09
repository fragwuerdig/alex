#! /bin/bash

NUM_PROC=8

for i in $(seq 0 $(( ${NUM_PROC} - 1 ))); do
	SKIP=${NUM_PROC} OFFSET=$i ./query_balances.sh > result_$i.txt &
done
