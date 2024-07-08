#!/bin/bash

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
echo "Ethereum_Holesky_RPC=$Ethereum_Holesky_RPC"
echo "Ethereum_Holesky_BEACON_RPC=$Ethereum_Holesky_BEACON_RPC"

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
    ## this for debugging
     tail -f /dev/null
    # exit 1
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
        pkill -f geth &&\
        ## this for debugging
         tail -f /dev/null
        #exit 1
    else
        echo "Validator node started successfully with PID $NODE_PID"
        sleep 5
        cd ${ROOT_DIR:-/root/.morph} && \
        # Keep the container running
        tail -f node.log
        #tail -f /dev/null
        #tail -f geth.log node.log
    fi
fi
