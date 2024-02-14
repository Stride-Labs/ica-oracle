set -eu
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/vars.sh

CONTRACT=./artifacts/ica_oracle.wasm

echo "Storing contract..."

echo ">>> strided tx wasm store $CONTRACT"
tx_hash=$($STRIDED tx wasm store $CONTRACT $GAS --from val1 -y | grep -E "txhash:" | awk '{print $2}') 

echo "Tx Hash: $tx_hash"
echo $tx_hash > $METADATA/store_tx_hash.txt

sleep 3

code_id=$($STRIDED q tx $tx_hash | grep code_id -m 1 -A 1 | tail -1 | awk '{print $2}' | tr -d '"')
echo "Code ID: $code_id"
echo $code_id > $METADATA/code_id.txt