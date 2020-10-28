export CORE_PEER_TLS_ENABLED=true
export ORDERER_CA=${PWD}/artifacts/channel/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem
export PEER0_ORG1_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export PEER0_ORG2_CA=${PWD}/artifacts/channel/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export FABRIC_CFG_PATH=${PWD}/artifacts/channel/config/

export PRIVATE_DATA_CONFIG=${PWD}/artifacts/private-data/collections_config.json

export CHANNEL_NAME=mychannel

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

addCar() {

    setGlobalsForPeer0Org1

    ## Solicita dados para transacao
    echo -e '\n Digite os dados para adicionar novo registro:'
    echo -e '\nChave: '
    read chave
    echo -e '\nMake: '
    read make
    echo -e '\nModel: '
    read model
    echo -e '\nColor: '
    read color
    echo -e '\nOwner: '
    read owner
    echo -e '\n'

    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"Args":["createCar", "'$chave'", "'$make'", "'$model'", "'$color'", "'$owner'"]}' 
}

changeCarOwner() {

    setGlobalsForPeer0Org1

    ## Solicita dados para transacao
    echo -e '\n Digite a chave do carro e novo proprietario:'
    echo -e '\nChave: '
    read chave
    echo -e '\nOwner: '
    read owner
    echo -e '\n'

    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"Args":["changeCarOwner", "'$chave'", "'$owner'"]}' 
}

getHistory() {

    setGlobalsForPeer0Org1

    ## Solicita dados para transacao
    echo -e '\n Digite a chave do carro e novo proprietario:'
    echo -e '\nChave: '
    read chave
    # echo -e '\nOwner: '
    # read owner
    # echo -e '\n'

    peer chaincode invoke -o localhost:7050 \
        --ordererTLSHostnameOverride orderer.example.com \
        --tls $CORE_PEER_TLS_ENABLED \
        --cafile $ORDERER_CA \
        -C $CHANNEL_NAME -n ${CC_NAME} \
        --peerAddresses localhost:7051 --tlsRootCertFiles $PEER0_ORG1_CA \
        --peerAddresses localhost:9051 --tlsRootCertFiles $PEER0_ORG2_CA \
        -c '{"Args":["getHistoryForAsset", "'$chave'"]}'
    
        
}

queryAllCars() {

    setGlobalsForPeer0Org1

    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["queryAllCars"]}'

    
}

# queryAllCars

queryCar() {

    setGlobalsForPeer0Org1

    echo -e '\nChave: '
    read chave


    peer chaincode query -C $CHANNEL_NAME -n ${CC_NAME} -c '{"Args":["queryCar", "'$chave'"]}'
}
# queryCar
    
menu(){

clear
echo -e '*** Hyperledger Fabric Interaction *** \n'
echo -e ' **  Escolha a opcao de consulta   ** \n'
select i in addCar changeOwner getHistory queryCar queryAllCars sair
    do

        case "$i" in

            addCar)
                echo -e '\n'
                addCar
                echo -e '\n'
                read -n 1 -s -r -p "Pressine qualquer tecla para continuar..."
                menu
                ;;

            changeOwner)
                echo -e '\n'
                changeCarOwner
                echo -e '\n'
                read -n 1 -s -r -p "Pressine qualquer tecla para continuar..."
                menu
                ;;

            getHistory)
                echo -e '\n'
                getHistory
                echo -e '\n'
                read -n 1 -s -r -p "Pressine qualquer tecla para continuar..."
                menu
                ;;

            queryCar)
                echo -e '\n'
                queryCar
                echo -e '\n'
                read -n 1 -s -r -p "Pressine qualquer tecla para continuar..."
                menu
                ;;

            queryAllCars)
                echo -e '\n'
                queryAllCars
                echo -e '\n'
                read -n 1 -s -r -p "Pressine qualquer tecla para continuar..."
                menu                
                ;;

            sair)
                echo -e '\n'
                echo "saindo..."
                break
                ;;

            *)
                echo "opcao invalida, tente novamente"
                ;;
                   
                   
        esac
    done

exit 0
}
menu