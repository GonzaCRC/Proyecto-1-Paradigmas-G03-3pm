%%%%%%%%%%%%%%%%%%%%%%%%%%%% Modules %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- use_module(library(http/websocket)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_dispatch)).

:-  use_module(rsEval).

:- initialization(start_server).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Handlers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- http_handler(root(chat), http_upgrade_to_websocket(chat, []), [spawn([])]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chat(WebSocket) :-
    ws_receive(WebSocket, Message, [format(json)]),
    (   Message.opcode == close ->  true;
        cors_enable,
        arg(2,Message.data,Msg), %mensaje
        arg(4,Message.data,NameFile), %nombre de archivo
        rsEval:genCodeToFile(NameFile, Msg, R),
    	ws_send(WebSocket, text(R)),
        chat(WebSocket)
    ).

/*static_server_endpoint('http://localhost:9000/getResponse').

post_msg_to_static_server(Msg, NameFile, Reply) :-
  static_server_endpoint(NodeEndPoint),
  format(atom(AtomMsg), '{"msg":"~s", "nameFile":"~s"}', [Msg,NameFile]),
  http_post(NodeEndPoint, atom(AtomMsg), Reply, []).*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Server Control %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

default_port(9010).