# Alex' Repository

This is a collection of queries for the USTC team.

- `query_base_accounts.sh` queries all base accounts from the Terra Classic blockchain and outputs them to `stdout`
- `query_balances.sh` takes a file `accounts.txt` from the current workspace and queries USTC balances at the two given block heights (which are given as variables inside the script)
- `parallelized.sh` is a wrapper script that calls `query_balances.sh` in a parallelized manner - spreading the queries over multiple cores.
