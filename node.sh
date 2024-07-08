#! /usr/bin/bash
cd ${ROOT_DIR:-/root/.morph} && \

export L1MessageQueueWithGasPriceOracle=0x778d1d9a4d8b6b9ade36d967a9ac19455ec3fd0b
export START_HEIGHT=1434640
export Rollup=0xd8c5c541d56f59d65cf775de928ccf4a47d4985c

nohup ./morph/node/build/bin/morphnode --validator --home ./node-data \
     --l2.jwt-secret ${ROOT_DIR:-/root/.morph}/${JWT_FILE_NAME:-jwt-secret.txt} \
     --l2.eth http://localhost:${HTTP_PORT:-8545} \
     --l2.engine http://localhost:${AUTH_RPC_PORT:-8551} \
     --l1.rpc $(Ethereum Holesky RPC)  \
     --l1.beaconrpc ${Ethereum_Holesky_RPC}  \
     --l1.chain-id  17000   \
     --validator.privateKey ${Your_Validator_Private_Key} \
     --sync.depositContractAddr $(L1MessageQueueWithGasPriceOracle) \
     --sync.startHeight  $(START_HEIGHT) \
     --derivation.rollupAddress $(Rollup) \
     --derivation.startHeight  $(START_HEIGHT) \
     --derivation.fetchBlockRange 200 \
     --log.filename ${ROOT_DIR:-/root/.morph}/node.log