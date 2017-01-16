# LBRY in a Box

Run all of the LBRY network locally inside docker containers. The LBRY
blockchain is configured to use `regtest`. This is intended as a tool
for developers to provide an isolated environment for testing.  Using
`regtest` has the advantage that coins are free and any bugs in
publishing or metadata won't propogate out to rest of the
network. Additionally, extra blocks can be mined on demand so there is
no need to wait for claims or transactions to propogate.

## Prerequisites 

- Install [docker](https://docs.docker.com/engine/installation/)
- Install [docker-compose](https://github.com/docker/compose/releases)

## Usage

Clone the repo

    git clone --recursive https://github.com/lbryio/lbry-in-a-box.git
    cd lbry-in-a-box
    docker-compose up

After waiting to boot up, you can interact with lbry-in-in-a-box in the following ways

 1. The lbrynet jsonrpc api is available on localhost:5279
 2. lighthouse is available on locahost:50005
 3. lbrycrd jsonrpc api is available on localhost:19001
 4. connect a lbryum wallet to the lbryum server at localhost:50001

The external services can be found by looking at the `ports` listing in the
`docker-compose.yml` file.

In order to use the UI, there is some more steps to do. The lbry-in-a-box
branch contains patches needed to get the UI to work.  Do something like:

    git clone https://github.com/lbryio/lbry-web-ui.git
    cd lbry-web-ui
    git checkout lbry-in-a-box
    npm install
    ./node_modules/.bin/node-sass --output dist/css --sourcemap=none scss/
    ./node_modules/.bin/webpack-dev-server --progress --colors \
        --port=5280 --content-base=dist

Then, open http://localhost:5280 and you should see the usual UI.
The discover page will be busted because none of the hard-coded names
in there will be available.


## Blockchain, Credits, and Mining

The regtest blockchain in `lbry-in-a-box` starts off with 150 blocks "mined"
already, with the credits in the wallet available on localhost:19001.

To send the lbrynet instance 10 credits, run:

    ./lbrycrd-cli -rpcconnect=127.0.0.1 -rpcport=19001 -rpcuser=rpcuser \
       -rpcpassword=jhopfpusrx -regtest=1  \
       sendtoaddress `lbrynet-cli get_new_address | tr -d '"'` 10


In order for the credits to show up, you'll need six confirmations. 
The regtest network is mined on demand so run something like:

    ./lbrycrd-cli -rpcconnect=127.0.0.1 -rpcport=19001 -rpcuser=rpcuser \
        -rpcpassword=jhopfpusrx -regtest=1 generate 6

## Container Configuration

Docker is very flexible in its ability to mount files and directories.
For each service, the behavior can be changed by mounting a
configuration file, or over-writing a data directory. At some point,
we'll probably have standard blockchain data and blob data that can be
pre-populated into the containers.

Check the Dockerfile and README files for each container for more information.

## Note about submodules

This is very much a work in progress. All of the components are linked
into this repo via submodules. And all of them have been modified to
be compatible to run in an isolated container. Each modification is in
a branch named `lbry-in-a-box`. Ideally, the code would run the main
branches for each repo and use environment variables to configure the
behavior. That is definitely work for the future.  Anyway - if there
are updates to a component - you'll have to pull in those changes and
update the `lbry-in-a-box` branch.
