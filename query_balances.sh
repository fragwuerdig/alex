#!/bin/bash

FILE="accounts.txt"
NODE="https://lcd.terrarebels.net"
SKIP=${SKIP:-8}
OFFSET=${OFFSET:-0}
HEIGHT_NOW=13575000	 # ~9th July 2023
HEIGHT_HIST=11025500 # ~180 days back
i=0

while read -r addr; do
    mod=$(( ($i + $OFFSET) % $SKIP ))
    if [ $mod -eq 0 ]; then
        balance_now=$(curl -s --data-urlencode "denom=uusd" -H "x-cosmos-block-height: ${HEIGHT_NOW}" ${NODE}/cosmos/bank/v1beta1/balances/${addr}/by_denom | jq -r ."balance"."amount" )
        balance_hist=$(curl -s --data-urlencode "denom=uusd" -H "x-cosmos-block-height: ${HEIGHT_HIST}" ${NODE}/cosmos/bank/v1beta1/balances/${addr}/by_denom | jq -r ."balance"."amount" )
        echo "${addr}; ${balance_now}; ${balance_hist}"
    fi
    i=$(( $i+1 ))
done < "$FILE"
