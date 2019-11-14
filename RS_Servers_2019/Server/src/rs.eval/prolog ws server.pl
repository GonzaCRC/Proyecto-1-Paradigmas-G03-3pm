/*
Creadores:
Erick Vargas Arias 
Esteban Zúñiga Cruz
Gonzalo Gonzalez Garro
Gabriel Araya Ruiz

Colaboradores:
Carlos Loría Saenz
EIF400 loriacarlos@gmail.com
*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Modules %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- use_module(library(http/websocket)).
:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_client)).
:- use_module(library(http/http_dispatch)).

:- use_module(rsEval).

:- assert(file_search_path(lib, '../../lib/')).
:- use_module( lib(prosqlite) ).

:- initialization(start_server).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Handlers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- http_handler(root(chat), http_upgrade_to_websocket(chat, []), [spawn([])]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

chat(WebSocket) :-
    ws_receive(WebSocket, Message, [format(json)]),
    (   Message.opcode == close ->  true;
        cors_enable,
        arg(2,Message.data,User), %Usuario 
        arg(4,Message.data,Msg), %Mensaje
		arg(6,Message.data,NameFile), %Nombre del archivo
		saveMessage(User,NameFile,Msg),
        rsEval:get_response(User, NameFile, Msg, R),
		saveMessage(User, NameFile,R),
    	ws_send(WebSocket, text(R)),
        chat(WebSocket)
    ).
	
saveMessage(User,Bot,Message):-
	%debug( sqlite ),
	DataBase = '../../dataBase/dataProyect.sqlite',
    sqlite_connect( DataBase , dataProyect ),
	format(atom(Statement), 'insert into chats (user,bot,message) values ("~s","~s","~s")',[User,Bot,Message]),
	sqlite_query(dataProyect,Statement,_),
	sqlite_disconnect( dataProyect ).

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