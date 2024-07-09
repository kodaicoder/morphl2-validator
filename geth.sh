#! /usr/bin/bash

cd ${ROOT_DIR:-/root/.morph} && \

nohup ./morph/go-ethereum/build/bin/geth \
--datadir=${ROOT_DIR:-/root/.morph}/geth-data \
--verbosity=3 \
--http \
--http.corsdomain="*" \
--http.vhosts="*" \
--http.addr=0.0.0.0 \
--http.port=${HTTP_PORT:-8545} \
--http.api=web3,eth,txpool,net,engine \
--ws \
--ws.addr=0.0.0.0 \
--ws.port=${WS_PORT:-8546} \
--ws.origins="*" \
--ws.api=web3,eth,txpool,net,engine \
--networkid=${NETWORK_ID:-2810} \
--authrpc.addr="0.0.0.0" \
--authrpc.port "${AUTH_RPC_PORT:-8551}" \
--authrpc.vhosts="*" \
--authrpc.jwtsecret="${ROOT_DIR:-/root/.morph}/${JWT_FILE_NAME:-jwt-secret.txt}" \
--gcmode=archive \
--metrics \
--metrics.addr=0.0.0.0 \
--metrics.port=${METRICS_PORT:-6060} \
--miner.gasprice="100000000" \
--maxpeers=50
