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
    jq \
    nano

# Clone morph-l2 repositories & check out on V0.1.0-beta
RUN mkdir -p ${ROOT_DIR} && \
    cd ${ROOT_DIR} && \
    git clone https://github.com/morph-l2/morph.git  && \
    cd morph  && \
    git checkout v0.2.0-beta

## uncompress package

# Build go-ethereum
RUN cd ${ROOT_DIR}/morph && \
    make nccc_geth

# Build Node
RUN cd ${ROOT_DIR}/morph/node && \
    make build

# Download the config files and make data dir
RUN cd ${ROOT_DIR} && \
    wget https://raw.githubusercontent.com/morph-l2/config-template/main/holesky/data.zip && \
    unzip data.zip && \
    rm -f data.zip

# Create a shared secret with node
RUN cd ${ROOT_DIR} && \
    openssl rand -hex 32 > ${JWT_FILE_NAME} && \
    echo "######### JWT SECRET KEEP THIS SAFE #########" && \
    echo cat ${JWT_FILE_NAME} && \
    echo "###########################################"

# Download Snapshot
RUN cd ${ROOT_DIR} && \
    wget -q --show-progress https://snapshot.morphl2.io/holesky/snapshot-20240805-1.tar.gz && \
    tar -xvf snapshot-20240805-1.tar.gz && \
    rm -f snapshot-20240805-1.tar.gz && \
    mv snapshot-20240805-1/geth geth-data && \
    mv snapshot-20240805-1/data node-data

# Copy start, geth and node script
COPY start.sh /start.sh
COPY geth.sh /geth.sh
COPY node.sh /node.sh


# Run geth, node and start script
RUN chmod +x /geth.sh
RUN chmod +x /node.sh
RUN chmod +x /start.sh

# Expose necessary ports
EXPOSE ${HTTP_PORT} ${WS_PORT}

# Set the entry point
ENTRYPOINT ["/start.sh"]