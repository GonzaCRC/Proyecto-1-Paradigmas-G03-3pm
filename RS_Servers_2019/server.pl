/*
Socket server
loriacarlos@gmail.com
EIF400 II-2019
Para arrancar (lo hace en puerto 3000)
swipl echo-ws-server

*/

:- use_module(library(http/http_server)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_files)).
:- use_module(library(http/websocket)).
:- use_module(library(http/http_json)).
:- use_module(library(http/json)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_parameters)).


:- initialization(start_server).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Server Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
default_port(3000).

start_server :-
    default_port(Port),
    start_server(Port).
start_server(Port) :-
    http_server(http_dispatch, [port(Port)]).

stop_server() :-
    default_port(Port),
    stop_server(Port).
stop_server(Port) :-
    http_stop_server(Port, []).


%%%%%%%%%%%%%%%%%%%%% Configure handlers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% static files handler
:- http_handler(root(.),
                http_reply_from_files('./AngularBuild', []),
                [prefix])
.
% websocket echo handler
:- http_handler(root(echo), 
                http_upgrade_to_websocket(echo, []),
                [spawn([])])
.

echo(WebSocket) :-
    ws_receive(WebSocket, Message),
    (   Message.opcode == close
    ->  true
    ;   ws_send(WebSocket, Message),
        echo(WebSocket)
    )
.

% Test handler GET
:- http_handler(root(api/chats),api_get,[method(get)]).

param(id,  [length >= 1 ]).

api_get(Request) :- 
	http_parameters(Request,[
                        id(Id)
                        ],
                        [ attribute_declarations(param)
                        ]),
	get_chat(Id,Reply),
	cors_enable,
    reply_json(json([data(Reply)]))
.

% Test handler POST
:- http_handler(root(api2),api_post,[method(post)]).

api_post(Request) :-
	http_read_json(Request, Data, [json_object(term), tag(id), tag(owner), tag(body)]),
    arg(1,Data,Text),
	post_msg(Text,Reply),
	cors_enable,
    reply_json(json([data(Reply)]))
.


%%%%%%%%%%%%%%%%%%%%% Code Client Node %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

node_endpoint_chats('http://localhost:3001/chats').

post_msg(Msg,Reply) :-
  node_endpoint_chats(NodeEndPoint),
  format(atom(AtomMsg), '{"id":~d, "owner": "~s", "body": "~s"}', [Msg.id, Msg.owner, Msg.body]), 
  http_post(NodeEndPoint, form_data([ data = AtomMsg]), Reply, [])
.

get_chats(Reply) :-
  node_endpoint_chats(NodeEndPoint),
  http_get(NodeEndPoint, Reply, [])
.

node_endpoint_chat('http://localhost:3001/chats').

get_chat(Id, Reply) :-
	atomic_concat('http://localhost:3001/chats/', Id, X),
	http_get(X, Reply, [])
.





