#! /usr/bin/bash
cd ${ROOT_DIR:-/root/.morph} && \

export MORPH_NODE_L2_ENGINE_AUTH="./jwt-secret.txt"
export MORPH_NODE_L2_ETH_RPC="http://127.0.0.1:${HTTP_PORT}"
export MORPH_NODE_L2_ENGINE_RPC="http://127.0.0.1:${AUTH_RPC_PORT}"
export MORPH_NODE_L1_ETH_RPC=${Ethereum_Holesky_RPC}
export MORPH_NODE_VALIDATOR_PRIVATE_KEY=${Your_Validator_Private_Key}
export MORPH_NODE_SYNC_DEPOSIT_CONTRACT_ADDRESS=${Your_Deposit_Contract_Address}
export MORPH_NODE_ROLLUP_ADDRESS=0xd8c5c541d56f59d65cf775de928ccf4a47d4985c
export MORPH_NODE_DERIVATION_START_HEIGHT=1434640
export MORPH_NODE_SYNC_START_HEIGHT=1434640
export MORPH_NODE_DERIVATION_FETCH_BLOCK_RANGE=1000
export MORPH_NODE_VALIDATOR=true
export MORPH_NODE_MOCK_SEQUENCER=false && \

nohup ./node/build/bin/morphnode \
--validator \
--home ${NODE_DATA_DIR}