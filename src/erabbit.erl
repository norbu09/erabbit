-module(erabbit).

-include_lib("deps/rabbitmq_server/include/rabbit.hrl").
-include("deps/rabbitmq-erlang-client/include/amqp_client.hrl").
-include("erabbit.hrl").

-compile([export_all]).

start(Conn) ->
    #erabbit_conn{q = Q, channel = Channel} = Conn,
    lib_amqp:declare_queue(Channel, Q),
    io:format("** Queue declared~n"),
    ok.

write(Conn, Payload) ->
    #erabbit_conn{q = Q, channel = Channel} = Conn,
    lib_amqp:publish(Channel, <<>>, Q, Payload),
    ok.

dump(Conn) ->
    #erabbit_conn{q = Q, channel = Channel} = Conn,
     Content = lib_amqp:get(Channel, Q),
     case Content of
         #content{payload_fragments_rev = Payload} ->
             {ok, Payload};
         'basic.get_empty' ->
             {ok, empty};
         _ -> {err, unknown}
     end.

stop(Conn) ->
    #erabbit_conn{channel = Channel, connection = Connection} = Conn,
    lib_amqp:teardown(Connection, Channel),
    io:format("** connection closed~n"),
    ok.

setup_channel(Conn) ->
    #erabbit_conn{host = Host, user = User, pass = Pass, vhost = Vhost} = Conn,
    io:format("** starting ...~n"),
    Connection = amqp_connection:start(User, Pass, Host, Vhost),
    io:format("** Connection started~n"),
    Channel = lib_amqp:start_channel(Connection),
    amqp_channel:register_return_handler(Channel, self()),
    io:format("** Channel started~n"),
    {ok, {Channel, Connection}}.
