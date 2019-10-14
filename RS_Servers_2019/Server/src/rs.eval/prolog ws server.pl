%%%%%%%%%%%%%%%%%%%%%%%%%%%% Modules %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- use_module(library(http/websocket)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_dispatch)).

:- use_module(rsEval).

:- initialization(start_server).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Handlers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- http_handler(root(chat), http_upgrade_to_websocket(chat, []), [spawn([])]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chat(WebSocket) :-
    ws_receive(WebSocket, Message, [format(json)]),
    (   Message.opcode == close ->  true;
        cors_enable,
        arg(2,Message.data,Msg), %Mensaje
        arg(4,Message.data,NameFile), %Nombre del archivo

        rsEval:genCodeToFile(NameFile, Msg, R),
    	ws_send(WebSocket, text(R)),
        chat(WebSocket)
    ).

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