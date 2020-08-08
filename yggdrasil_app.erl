%%%-------------------------------------------------------------------
%% @doc yggdrasil public API
%% @end
%%%-------------------------------------------------------------------
-module(yggdrasil_app).

-behaviour(application).

-export([start/2, stop/1]).
-compile(export_all).
-include_lib("kernel/include/logger.hrl").
-define(WELCOME_MESSAGE, [
  "\x1b[32mWelcome! This is a Erlang Yggdrasil server developed under Barrel Db Labs..\x1b[0m.\r\n"]).
-define(LINE_PREFIX, "> ").
-define(FName, "/home/kushal/rebar3/erlang-yggdrasil/yggdrasil/src/test.json").

start(_StartType, _StartArgs) ->
    yggdrasil_sup:start_link().

stop(_State) ->
    ok.

%% internal functions




yggdrasil_connect() -> 
    Json = os:cmd("sudo yggdrasilctl getself"), 
    {ok,S} = file:open(?FName,write),
    io:format(S,"~s~n",[Json]),
    {ok,IoDevice} = file:open(?FName, [read]),                                              
    string:tokens(io:get_line(IoDevice,""), ". "),
    string:tokens(io:get_line(IoDevice,""), ". "),
    Abc = string:tokens(io:get_line(IoDevice,""), ". "),
    Bbc = "IPv6",
    Cbc = re:replace(Abc, Bbc, "", [global,{return,list}]),
    Dbc = "address:",
    Ebc = re:replace(Cbc,Dbc,"",[global,{return,list}]),
    Fbc = "\n",
    Yggdrasil = re:replace(Ebc,Fbc,"",[global,{return,list}]),
    % io:format("~w~n",[Cbc]).
    Port = 2000,
    io:format("listening on port ~w~n", [Port]),
    case re:run(Yggdrasil,"20") of
        {match,[{0,2}]} -> {ok,Parsed_add} = inet:parse_address(Yggdrasil),  
                            spawn(fun () -> {ok, Listen} =  gen_tcp:listen(Port, [binary,inet6,{packet, raw},{nodelay, true},{reuseaddr, true},{active, once},{ip,Parsed_add}]),
                            connect(Listen,Parsed_add)
                            end),
                        io:format("~p Yggdrasil Server Started.~n", [erlang:localtime()]);
        {match,_Rest} -> io:format("Not a Yggdrasil address");                     
        nomatch -> io:format("cannot establish connection : Check your Yggdrasil Address or if Port blocked by firewall")
    end. 


connect(Listen,Parsed_add) -> 
  {ok, Socket} = gen_tcp:accept(Listen),
  inet:setopts(Socket, [binary,inet6,{packet, raw},{nodelay, true},{reuseaddr, true},{active, once},{ip,Parsed_add}]), 
  spawn_link(yggdrasil_logic, connect, [Listen,Parsed_add]),
  gen_tcp:send(Socket, ?WELCOME_MESSAGE),
  gen_tcp:send(Socket, ?LINE_PREFIX),
  recv_loop(Socket),
  gen_tcp:close(Socket).


%% @doc handle_data/2: handles data incoming from a connection 


handle_data(Socket, Data) ->
  io:format("~p ~p ~p~n", [inet:peername(Socket), erlang:localtime(), Data]),
  case Data of
    % "exit\r\n" closes the session.
    <<"exit\r\n">> ->
      io:format("~p ~p Closed.~n", [inet:peername(Socket), erlang:localtime()]),
      gen_tcp:close(Socket);
    % IAC -- Interpret As Command.
    <<255, _Rest/binary>> ->
      % handle_negotiation(Socket, Data),
      recv_loop(Socket);
    % send back all other data received.
    _ ->
      gen_tcp:send(Socket, [Data, "> "]),
      recv_loop(Socket)
  end.


%% @doc recv_loop/1: handles a connection's event loop


recv_loop(Socket) ->
  inet:setopts(Socket, [{active, once}]),
  receive
    {tcp, Socket, Data} ->
      handle_data(Socket, Data);
    {tcp_closed, Socket} ->
       io:format("~p Client Disconnected.~n", [erlang:localtime()])
  end.




tunnelrouting() ->
    Json = os:cmd("sudo yggdrasilctl -json gettunnelrouting"), 
    {ok,S} = file:open(?FName,write),
    io:format(S,"~s~n",[Json]),
    {ok, Body} = file:read_file(?FName), 
    file:close(S),
    Map = jsx:decode(Body, [return_maps]),
    _Tasks = maps:get(<<"enabled">>, Map).



tuntap() ->
    Json = os:cmd("sudo yggdrasilctl -json gettuntap"), 
    {ok,S} = file:open(?FName,write),
    io:format(S,"~s~n",[Json]),
    {ok, Body} = file:read_file(?FName), 
    file:close(S),
    Map = jsx:decode(Body, [return_maps]),
    _Tasks = maps:get(<<"tun0">>, Map).



publickeys() ->
    Json = os:cmd("sudo yggdrasilctl -json getallowedencryptionpublickeys"), 
    {ok,S} = file:open(?FName,write),
    io:format(S,"~s~n",[Json]),
    {ok, Body} = file:read_file(?FName), 
    file:close(S),
    Map = jsx:decode(Body, [return_maps]),
    _Tasks = maps:get(<<"allowed_box_pubs">>, Map).


dht() ->
    Json = os:cmd("sudo yggdrasilctl -json getdht"), 
    {ok,S} = file:open(?FName,write),
    io:format(S,"~s~n",[Json]),
    {ok, Body} = file:read_file(?FName), 
    file:close(S),
    Map = jsx:decode(Body, [return_maps]),
    _Tasks = maps:get(<<"dht">>, Map).



self() ->
    Json = os:cmd("sudo yggdrasilctl -json getself"), 
    {ok,S} = file:open(?FName,write),
    io:format(S,"~s~n",[Json]),
    {ok, Body} = file:read_file(?FName), 
    file:close(S),
    Map = jsx:decode(Body, [return_maps]),
    _Tasks = maps:get(<<"self">>, Map).

subnets() ->
    Json = os:cmd("sudo yggdrasilctl -json getsourcesubnets"), 
    {ok,S} = file:open(?FName,write),
    io:format(S,"~s~n",[Json]),
    {ok, Body} = file:read_file(?FName), 
    file:close(S),
    Map = jsx:decode(Body, [return_maps]),
    _Tasks = maps:get(<<"source_subnets">>, Map).


multicastinterfaces() ->
    Json = os:cmd("sudo yggdrasilctl -json getmulticastinterfaces"), 
    {ok,S} = file:open(?FName,write),
    io:format(S,"~s~n",[Json]),
    {ok, Body} = file:read_file(?FName), 
    file:close(S),
    Map = jsx:decode(Body, [return_maps]),
    _Tasks = maps:get(<<"multicast_interfaces">>, Map).


peers() ->
    Json = os:cmd("sudo yggdrasilctl -json getpeers"), 
    {ok,S} = file:open(?FName,write),
    io:format(S,"~s~n",[Json]),
    file:close(S),
    {ok, Body} = file:read_file(?FName),  %Or, for testing you can paste the json in a file (without the outer quotes), and read_file() will return a binary.
    Map = jsx:decode(Body, [return_maps]),
    _Tasks = maps:get(<<"peers">>, Map).



getsessions() ->
    Json = os:cmd("sudo yggdrasilctl -json getsessions"), 
    {ok,S} = file:open(?FName,write),
    io:format(S,"~s~n",[Json]),
    file:close(S),
    {ok, Body} = file:read_file(?FName),  %Or, for testing you can paste the json in a file (without the outer quotes), and read_file() will return a binary.
    Map = jsx:decode(Body, [return_maps]),
    _Tasks = maps:get(<<"sessions">>, Map).


switchpeers() ->
    Json = os:cmd("sudo yggdrasilctl -json getswitchpeers"), 
    {ok,S} = file:open(?FName,write),
    io:format(S,"~s~n",[Json]),
    {ok, Body} = file:read_file(?FName), 
    file:close(S),
    Map = jsx:decode(Body, [return_maps]),
    _Tasks = maps:get(<<"switchpeers">>, Map).


getroutes() ->
    Json = os:cmd("sudo yggdrasilctl -json getroutes"), 
    {ok,S} = file:open(?FName,write),
    io:format(S,"~s~n",[Json]),
    {ok, Body} = file:read_file(?FName), 
    file:close(S),
    Map = jsx:decode(Body, [return_maps]),
    _Tasks = maps:get(<<"routes">>, Map). 


hackney() ->
    Method = get,

    URL = <<"https://my-json-server.typicode.com/Kushal-kothari/yggdrasil/db">>,

    Headers = [],
    Payload = <<>>,
    Options = [],

    {ok, 200, _RespHeaders, ClientRef} =
        hackney:request(Method, URL, Headers, Payload, Options),
    {ok, Body} = hackney:body(ClientRef),
    Map = jsx:decode(Body, [return_maps]),
    _Tasks = maps:get(<<"peers">>, Map).



create_table(TableName, Tuples) ->
    ets:new(TableName, [set, named_table]),
    insert(TableName, Tuples).

insert(_Table, []) ->
    ok;
insert(Table, [Tuple|Tuples]) ->
    #{<<"id">> := Id} = Tuple,
    ets:insert(Table, {Id, Tuple}),
    insert(Table, Tuples).

retrieve_task(TableName, Id) ->
    [{_Id, Task}] = ets:lookup(TableName, Id), 
    Task.







% get_tasks() ->
%     Method = get,

%     % URL = <<"https+unix:<<///var/run/yggdrasil.sock">>,
%     URL = <<"https://my-json-server.typicode.com/Kushal-kothari/yggdrasil/db">>,


%     Headers = [],
%     Payload = <<>>,
%     Options = [],

%     {ok, 200, _RespHeaders, ClientRef} =
%         hackney:request(Method, URL, Headers, Payload, Options),
%     {ok, Body} = hackney:body(ClientRef),
%     Map = jsx:decode(Body, [return_maps]),
%     _Tasks = maps:get(<<"peers">>, Map).

% create_table(TableName, Tuples) ->
%     ets:new(TableName, [set, named_table]),
%     insert(TableName, Tuples).

% insert(_Table, []) ->
%     ok;
% insert(Table, [Tuple|Tuples]) ->
%     #{<<"id">> := Id} = Tuple,
%     ets:insert(Table, {Id, Tuple}),
%     insert(Table, Tuples).

% retrieve_task(TableName, Id) ->
%     [{_Id, Task}] = ets:lookup(TableName, Id), 
%     Task.






%=== MACROS ====================================================================

% -define(BASE_URL, <<"http+unix:///var/run/yggdrasil.sock">>).



%=== API FUNCTIONS =============================================================

% start() ->
%     {ok, _} = application:ensure_all_started(hackney),
%     ok.


% yggdrasil_put(Path, Query, Body) -> yggdrasil_put(Path, Query, Body, #{}).

% yggdrasil_put(Path, Query, Body, Opts) ->
%     ResultType = maps:get(result_type, Opts, json),
%     case hackney:request(put, url(Path, Query), [], Body, []) of
%         {error, _Reason} = Error -> Error;
%         {ok, Status, _RespHeaders, ClientRef} ->
%             case yggdrasil_fetch_json_body(ClientRef, ResultType) of
%                 {error, _Reason} = Error -> Error;
%                 {ok, Response} -> {ok, Status, Response}
%             end
%     end.

% yggdrasil_fetch_json_body(ClientRef, Type) ->
%     case hackney:body(ClientRef) of
%         {error, _Reason} = Error -> Error;
%         {ok, Body} -> decode(Body, Type)
%     end.
