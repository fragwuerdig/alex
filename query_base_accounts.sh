#! /bin/bash

usage() {
	echo "$0"
	echo "-n		Select the node to query (default https://lcd.terrarebels.net)"
	echo "-s		Select a sleep timer (in s) between pagination queries (default 1)"
	echo "-l		Select a pagination limit (default 10000)"
}

verify_sleep() {
  pattern='^[1-9][0-9]*$|^[1-9][0-9]*\.[0-9]+$'
  if [[ $1 =~ $pattern ]]; then
    return 0
  else
    return 1
  fi
}

verify_limit() {
  pattern='^[1-9][0-9]*$'
  if [[ $1 =~ $pattern ]]; then
    return 0
  else
    return 1
  fi
}

NODE="https://lcd.terrarebels.net"
SLEEP=1
LIMIT=10000

while getopts n:s:l: arg; do
	case ${arg} in
		n)
			NODE=$OPTARG
			;;
		s)	
			if verify_sleep "$OPTARG"; then
				SLEEP="$OPTARG"
			else
				echo "not a valid sleep timer"
				usage
				exit -1
			fi
			;;
		l)
			if verify_limit "$OPTARG"; then
				SLEEP="$OPTARG"
			else
				echo "not a valid pagination limit"
				usage
				exit -1
			fi
			;;
	esac
done

res=$(curl -s --data-urlencode "pagination.limit=${LIMIT}" ${NODE}/cosmos/auth/v1beta1/accounts)
next=$(echo $res | jq -r ."pagination"."next_key")
echo $res | jq -r '.accounts[] | select(."@type" == "/cosmos.auth.v1beta1.BaseAccount") | .address'
sleep $SLEEP

while [ "${next}" != "null" ]; do

	res=$(curl -s --data-urlencode "pagination.limit=${LIMIT}" --data-urlencode "pagination.key=${next}" ${NODE}/cosmos/auth/v1beta1/accounts)
	prev=${next}
	next=$(echo ${res} | jq -r ."pagination"."next_key")
	
	## Dunno why that can happens on rebels endpoints - but it does
	if [ "${prev}" = "${next}" ]; then
		continue
	fi
	echo ${res} | jq -r '.accounts[] | select(."@type" == "/cosmos.auth.v1beta1.BaseAccount") | .address'
	sleep $SLEEP

done
