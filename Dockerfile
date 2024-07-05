# Use Ubuntu:latest as the base image
FROM ubuntu:latest

# declare args
# ARG GO_VERSION
ARG ROOT_DIR
ARG JWT_FILE_NAME
ARG HTTP_PORT
ARG WS_PORT

# Install required dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    make \
    wget \
    unzip \
    openssl \
    golang-go \
    jq

# # Install Go
# RUN wget "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz" && \
#     tar -C /usr/local -xzf "go${GO_VERSION}.linux-amd64.tar.gz" && \
#     rm "go${GO_VERSION}.linux-amd64.tar.gz"

# # Set Go environment variables
# ENV PATH=$PATH:/usr/local/go/bin:/root/go/bin

# Create a root directory for the chain & Build go-ethereum
RUN mkdir -p ${ROOT_DIR} && \
    cd ${ROOT_DIR} && \
    git clone https://github.com/morph-l2/go-ethereum.git &&\
    cd go-ethereum && \
    git checkout v0.2.1-beta && \
    make nccc_geth

# Build Node
RUN cd ${ROOT_DIR} && \
    git clone https://github.com/morph-l2/node.git && \
    cd node && \
    git checkout v0.2.1-beta && \
    make build

# Config Preparation
RUN cd ${ROOT_DIR} && \
    wget https://raw.githubusercontent.com/morph-l2/config-template/main/sepolia-beta/data.zip && \
    unzip data.zip && \
    rm -f data.zip

# Create a shared secret with node
RUN cd ${ROOT_DIR} && \
    openssl rand -hex 32 > ${JWT_FILE_NAME} && \
    echo cat ${JWT_FILE_NAME}

# Write geth genesis state locally
RUN cd ${ROOT_DIR} && \
    ./go-ethereum/build/bin/geth --verbosity=3 init --datadir=/root/.morph/geth-data /root/.morph/geth-data/genesis.json

# Copy geth and node script
COPY geth.sh /geth.sh
COPY node.sh /node.sh
RUN chmod +x /geth.sh
RUN chmod +x /node.sh

# Copy the start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose necessary ports
EXPOSE ${HTTP_PORT} ${WS_PORT}

# Set the entry point
ENTRYPOINT ["/start.sh"]