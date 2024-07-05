#!/bin/bash
# Function to mask the RPC URL
mask_rpc_url() {
    local url=$1
    # Check if the URL contains '/v2/'
    if [[ $url == *"/v2/"* ]]; then
        local base_url=$(echo $url | sed -E 's/(.+\/v2\/).+/\1/')
        local api_key=$(echo $url | sed -E 's/.+\/v2\/(.+)/\1/')
    else
        echo "Debug: URL does not contain '/v2/' pattern" >&2
        return 1
    fi

    local api_key_length=${#api_key}

    if [ $api_key_length -ge 8 ]; then
        local visible_chars=8
        local mask_length=$((api_key_length - visible_chars))
        local masked_api_key="${api_key:0:4}$(printf '*%.0s' $(seq 1 $mask_length))${api_key: -4}"
        echo "${base_url}${masked_api_key}"
    else
        echo "Debug: API key too short to mask" >&2
        echo $url
    fi
}

# Function to mask the private key
mask_private_key() {
    local key=$1
    local key_length=${#key}
    if [ $key_length -ge 12 ]; then
        echo "${key:0:6}*****************************${key: -6}"
    else
        echo $key
    fi
}


echo "######### ENVIRONMENT VARIABLES ##########"
echo "GO_VERSION=$GO_VERSION"
echo "ROOT_DIR=$ROOT_DIR"
echo "JWT_FILE_NAME=$JWT_FILE_NAME"
echo "NODE_DATA_DIR=$NODE_DATA_DIR"
echo "NETWORK_ID=$NETWORK_ID"
echo "HTTP_PORT=$HTTP_PORT"
echo "WS_PORT=$WS_PORT"
echo "AUTH_RPC_PORT=$AUTH_RPC_PORT"
echo "METRICS_PORT=$METRICS_PORT"
# Special handling for RPC
if [ ! -z "$Ethereum_Holesky_RPC" ]; then
    masked_rpc=$(mask_rpc_url "$Ethereum_Holesky_RPC")
    echo "Ethereum_Holesky_RPC=$masked_rpc"
fi
# Special handling for PRIVATE_KEY
if [ ! -z "$Your_Validator_Private_Key" ]; then
    masked_key=$(mask_private_key "$Your_Validator_Private_Key")
    echo "Your_Validator_Private_Key=$masked_key"
fi
echo "##########################################"


echo "Starting go-ethereum..."
./geth.sh > ${ROOT_DIR}/geth.log 2>&1 &
GETH_PID=$!

# Wait for geth to start (adjust time as needed)
sleep 10

# Check if geth is running
if ! ps -p $GETH_PID > /dev/null; then
    echo "Error: go-ethereum failed to start or crashed." && \
    echo "############# geth.log #############" && \
    cat ${ROOT_DIR}/geth.log && \
    echo "####################################" && \
    tail -f /dev/null
else
    echo "go-ethereum started successfully with PID $GETH_PID"
    echo "Starting validator node..."
    ./node.sh > ${ROOT_DIR}/node.log 2>&1 &
    NODE_PID=$!
    # Wait a bit to see if the node starts
    sleep 10
    # Check if node is running
    if ! ps -p $NODE_PID > /dev/null; then
        echo "Error: Validator node failed to start or crashed" && \
        echo "############# node.log #############" && \
        cat ${ROOT_DIR}/node.log && \
        echo "####################################" && \
        kill $GETH_PID &&\
        pkill -f geth && \
        tail -f /dev/null
    else
        echo "Validator node started successfully with PID $NODE_PID"
        # Keep the container running
        tail -f logs/node.log
        #tail -f /dev/null
        #tail -f geth.log node.log
    fi
fi
