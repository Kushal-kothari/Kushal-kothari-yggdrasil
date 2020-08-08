
I was trying to find repository where UNIX socket in hackney have been used.I only found this using UNIX socket where looking at the code I understood that I can never write them. So I started to look at the output of the below repository and found out that even I can make it by doing the tricks differently.(which ofcouse is a vey naive way but it works 100%)

https://github.com/emmanuelJet/aedoc/blob/f322d88eb41fbade4794d24700555d53cc188913/aeternity/system_test/common/helpers/aest_docker_api.erl


So Here are the features with the examples:


# Listeners #
A listener is a set of processes whose role is to listen on a port for new connections. It manages a pool of acceptor processes, each of them indefinitely accepting connections. When it does, it starts a new process executing the protocol handler code. All the socket programming is abstracted through the use of transport handlers.

The listener takes care of supervising all the acceptor and connection processes, allowing developers to focus on building their application.

# STARTING A LISTENER #

A listener can be started by calling the yggdrasil_app:yggdrasil_connect/0 function. Before doing so however, you must ensure that the json file  is properly given path.(It takes the Yggdrasil tunnel to connect the server).

```
yggdrasil_app:yggdrasil_connect().
listening on port 2000
{{2020,8,8},{16,41,18}} Yggdrasil Server Started.
ok

```

You can then connect to it using telnet and see the echo server reply everything you send to it. Then when you're done testing, you can use the "exit" escape to the telnet command line to exit.

Connecting to the example listener with telnet

```

$ telnet 203:18f0:c3bb:cd12:66d2:bb08:ce8d:9fde 2000
Trying 203:18f0:c3bb:cd12:66d2:bb08:ce8d:9fde...
Connected to 203:18f0:c3bb:cd12:66d2:bb08:ce8d:9fde.
Escape character is '^]'.
Welcome! This is a Erlang Yggdrasil server developed under Barrel Db Labs...

```

# Installation #

Download the sources from our GitLab repository

To run the application simply run 'rebar3 compile'.

compile, is required to fetch dependencies and compile all applications.

then 'rebar3 shell'



# Basic usage #
The basic usage of yggdrasil is:

# Start Yggdrasil #

To start in the console run:

```erlang

$ rebar3 shell

```

# Simple request #
Do a simple request that will return a client state

Once a valid request is received, the response stanza in JSON is returned.

getPeers
Expects no additional request fields.

Returns one or more records containing information about active peer sessions. The first record typically refers to the current node.


yggdrasil_app:peers()

```

1> yggdrasil_app:peers().  
#{<<"201:6a49:40cc:c40e:db1c:33d0:bb14:93ec">> =>
      #{<<"box_pub_key">> =>
            <<"120915e044fb981b4681448072079592bf92dadd2c1256d35f1e1d4e480d2e2e">>,
        <<"bytes_recvd">> => 1246171,<<"bytes_sent">> => 453311,
        <<"endpoint">> =>
            <<"tcp://[2001:1af8:4700:a119:7::1]:35239">>,
        <<"port">> => 2,<<"proto">> => <<"tcp">>,
        <<"uptime">> => 5874.782067068},
  <<"203:18f0:c3bb:cd12:66d2:bb08:ce8d:9fde">> =>
      #{<<"box_pub_key">> =>
            <<"64735dcf73c1afa1fde9a8b238077b2dcc474adf42cfa55b5ccfa90ddb1ce011">>,
        <<"bytes_recvd">> => 5092019,<<"bytes_sent">> =>


```

getSwitchPeers
Expects no additional request fields.

Returns zero or more records containing information about switch peers.

```
#{<<"1">> =>
      #{<<"box_pub_key">> =>
            <<"120915e044fb981b4681448072079592bf92dadd2c1256d35f1e1d4e480d2e2e">>,
        <<"bytes_recvd">> => 966536,<<"bytes_sent">> => 736652,
        <<"coords">> => <<"[1 79 1]">>,
        <<"endpoint">> => <<"85.17.15.221">>,
        <<"ip">> => <<"201:6a49:40cc:c40e:db1c:33d0:bb14:93ec">>,
        <<"port">> => 1,<<"proto">> => <<"tcp">>},
  <<"2">> =>
      #{<<"box_pub_key">> =>
            <<"120915e044fb981b4681448072079592bf92dadd2c1256d35f1e1d4e480d2e2e">>,
        <<"bytes_recvd">> => 1449809,<<"bytes_sent">> => 502526,
        <<"coords">> => <<"[1 79 1]">>,
        <<"endpoint">> => <<"2001:1af8:4700:a119:7::1">>,
        <<"ip">> => <<"201:6a49:40cc:c40e:db1c:33d0:bb14:93ec">>,
        <<"port">> => 2,<<"proto">> => <<"tcp">>},
  <<"3">> =>
      #{<<"box_pub_key">> =>
            <<"15bfab4e09218e033bd7feb290e9d4991dbe99f064e606f1718c27568dbb5d71">>,
        <<"bytes_recvd">> => 1016,<<"bytes_sent">> => 0,
        <<"coords">> => <<"[1 16 1]">>,
        <<"endpoint">> => <<"212.129.52.193">>,
        <<"ip">> => <<"204:4738:37c6:d295:1b34:2722:62dd:e8de">>,
        <<"port">> => 3,<<"proto">> => <<"tls">>}}


```
