set -eu
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
source ${SCRIPT_DIR}/vars.sh

stride_val=$($STRIDED keys show val1 -a)
code_id=$(cat $METADATA/code_id.txt)
init_msg=$(cat << EOF
{ 
    "admin_address": "$stride_val",
    "transfer_channel_id": "channel-0"
}
EOF
)

echo "Instantiating contract..."

echo ">>> strided tx wasm instantiate $code_id "$init_msg""
tx_hash=$($STRIDED tx wasm instantiate $code_id "$init_msg" --from val1 --label "ica-oracle" --no-admin $GAS -y | grep -E "txhash:" | awk '{print $2}') 

echo "Tx Hash: $tx_hash"
echo $tx_hash > $METADATA/instantiate_tx_hash.txt

sleep 3

contract_address=$($STRIDED q tx $tx_hash | grep contract_address -m 1 -A 1 | tail -1 | awk '{print $2}')
echo "Contract Address: $contract_address"
echo $contract_address > $METADATA/contract_address.txt