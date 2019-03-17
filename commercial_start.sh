docker rm -f $(docker ps -aq)
docker rmi $(docker images |grep 'dev-peer0.org1')
cd basic-network
./start.sh
cd ../commercial-paper/organization/magnetocorp/configuration/cli/
./monitordocker.sh net_basic
docker-compose -f docker-compose.yml up -d cliMagnetoCorp
cd ../../contract
docker exec cliMagnetoCorp peer chaincode install -n papercontract -v 0 -p /opt/gopath/src/github.com/contract -l node
docker exec cliMagnetoCorp peer chaincode instantiate -n papercontract -v 0 -l node -c '{"Args":["org.papernet.commercialpaper:instantiate"]}' -C mychannel -P "AND ('Org1MSP.member')"
