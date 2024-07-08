# A docker compose to running validator node

_build with love for Morphl2 community ❤️🐨_

the purpose for this compose is made you easily running a validator node for morph easier by using docker & docker compose

## Installation

### Prerequisites

First as I said you need docker and docker compose to made this work

> for Windows user if you installed docker-desktop and enable WSL2 already you can skip this section

by using this command to installing it to your linux

```
sudo apt update && \
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
sudo apt update && \
sudo apt install -y docker-ce docker-ce-cli containerd.io && \
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
sudo chmod +x /usr/local/bin/docker-compose
```

verify installation of docker & docker compose by

```
sudo docker run hello-world
```

and

```
docker-compose --version
```

---

### Download with git

you can start using this repository by this command

```
git clone https://github.com/kodaicoder/morphl2-validator.git
```

and then you can accessing to directory

```
cd morphl2-validator
```

> **NOTE** : please running any command after this point in directory `morphl2-validator`

---

### Setting your RPC and wallet address and private key

after you in morphl2-validator directory then you can start editing `.env` file by using

```
nano .env
```

and then you will see 2 lines that end with XXXXXXX

- first line is `Ethereum_Holesky_RPC` you can grab one of rpc endpoint [here](https://www.alchemy.com/)
  then you can replace it

- second line is `Your_Validator_Private_Key` is your wallet private key that want to run a node

then save & exit by press <kbd>Ctrl</kbd> + <kbd>X</kbd>

---

### Building a image and running container

you can build a image by using this command in your terminal

```
docker compose up --build -d
```

---

### Updating a data

if you has changing any value such as in .env file and want to updating to a container, first just stop container by

```
docker compose stop
```

and then update changed to container by

```
docker compose up -d
```

---

### Remove container and rebuild image and restart again

to stop and remove old container you can using

```
docker compose down
```

and then using

```
docker compose up --build -d
```

## Morphl2 Community

- [github](https://github.com/morph-l2)

- [discord](https://discord.gg/5SmG4yhzVZ)

- [X (twitter)](https://twitter.com/Morphl2)

- [telegram](https://t.me/MorphL2official)

- [morph blog](https://blog.morphl2.io/)

- [website](https://www.morphl2.io/)
