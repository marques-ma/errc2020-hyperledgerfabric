#!/bin/bash

export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export PRIVATE_DATA_CONFIG=${PWD}/artifacts/private-data/collections_config.json

CHANNEL_NAME="mychannel"
CC_RUNTIME_LANGUAGE="golang"
VERSION="1"
CC_SRC_PATH="./artifacts/src/github.com/fabcar/go"
CC_NAME="fabcar"

setGlobalsForPeer0Org1() {
    export CORE_PEER_LOCALMSPID="Org1MSP"
    export CORE_PEER_TLS_ROOTCERT_FILE=$PEER0_ORG1_CA
    export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
    # export CORE_PEER_MSPCONFIGPATH=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/msp
    export CORE_PEER_ADDRESS=localhost:7051
}

DoS() {
    setGlobalsForPeer0Org1

    for ((loop=1; loop>0; loop++))
    do
            peer chaincode invoke -o localhost:7050 \
                --ordererTLSHostnameOverride orderer.example.com \
                --tls $CORE_PEER_TLS_ENABLED \
                --cafile $ORDERER_CA \
                -C $CHANNEL_NAME -n ${CC_NAME} \
                --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
                --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
                -c '{"Args":["createCar", "KEY'$loop'", "VW", "Fusca", "Azul", "Marco"]}' 
    done
}

DoS