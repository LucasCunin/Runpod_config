#!/bin/bash

# Mise à jour des packages et installation de git et unzip
apt update && apt install -y git wget
apt install -y unzip

# Cloner le dépôt text-generation-inference
git clone https://github.com/huggingface/text-generation-inference.git
cd text-generation-inference

# Installer Anaconda
wget https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh
bash Anaconda3-2023.09-0-Linux-x86_64.sh -b -p $HOME/anaconda3
eval "$(~/anaconda3/bin/conda shell.bash hook)"

# Créer un environnement conda pour le projet
conda create -n text-generation-inference python=3.9 -y
conda activate text-generation-inference

# Installer Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env
rustup install stable
rustup default stable

# Télécharger et installer protoc
PROTOC_ZIP=protoc-21.12-linux-x86_64.zip
curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v21.12/$PROTOC_ZIP
unzip -o $PROTOC_ZIP -d /usr/local bin/protoc
unzip -o $PROTOC_ZIP -d /usr/local 'include/*'
rm -f $PROTOC_ZIP

# Installer les bibliothèques de développement SSL et les outils de compilation
apt-get install libssl-dev gcc build-essential pkg-config -y


#! benchmark 
make install-benchmark

export HUGGING_FACE_HUB_TOKEN=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

text-generation-launcher --model-id meta-llama/Llama-2-70b-chat-hf --port 8000 #&
#text-generation-benchmark --tokenizer-name meta-llama/Llama-2-70b-chat-hf