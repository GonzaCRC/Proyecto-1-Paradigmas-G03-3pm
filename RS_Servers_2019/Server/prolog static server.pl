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

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_files)).
:- use_module(library(http/websocket)).

:- use_module(library(http/http_parameters)).
:- use_module(library(http/mimepack)).
:- use_module(library(http/http_client)).
:- use_module(library(http/html_write)).
:- use_module(library(lists)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_json)).


:- assert(file_search_path(lib, 'lib/')).
:- use_module( lib(prosqlite) ).

:- assert(file_search_path(rs_path, 'src/rs.compile/')).

:- use_module(rs_path(rsCompiler)).

:- initialization(start_server).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Handlers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- http_handler(root(.),
                http_reply_from_files('./AngularBuild', []),
               [prefix])
.

:- http_handler(root(upload), upload, []).
:- http_handler(root(getRiveFiles), getRiveFiles, [method(get)]).
:- http_handler(root(validateUser), validateUser, [method(post)]).
:- http_handler(root(getChat), listMessages, [method(post)]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

upload(Request) :-
	(   memberchk(method(post), Request),
	    http_read_data(Request, DataRequest, [form_data(mime)]),
	    member(mime(AttributesFile, DataFile, []), DataRequest),
	    memberchk(filename(FileName), AttributesFile),
		atom_concat('temp/', FileName, PathFile),
		open(PathFile,write,Out),
	    write(Out,DataFile),
	    close(Out),
		cors_enable, 
		format('Content-type: text/plain~n~n'),
		rsCompiler:compile('temp/','riveRepository/',FileName),
		delete_file(PathFile)		
		;throw(http_reply(bad_request(bad_file_upload)))
	).

prolog:message(bad_file_upload) --> [ 'Error' ].

getRiveFiles(_Request) :- 
	listFiles('riveRepository/', Files),
	cors_enable,
    reply_json(json([data(Files)]))
.

listFiles(Path,FileList):- findall(File, directory_member(Path,File,[]), FileList). 

validateUser(Request) :-
	http_read_json(Request, Data, [json_object(term)]),
	arg(1,Data,UserInfo),
	existUser(UserInfo.user,UserInfo.pass, Role),
	reply_json(json([success('True'), role(Role)]));
	reply_json(json([success('False')])).

existUser(User,Pass,Role):-
	getUsers(Users),
	member(row(User,Pass,Role),Users),!.

getUsers(Users) :-
	%debug( sqlite ),
	DataBase = 'dataBase/dataProyect.sqlite',
    sqlite_connect( DataBase , dataProyect ),
	Statement = 'Select user,pass,role from users',
	findall( Data, sqlite_query(dataProyect,Statement,Data), Users ),
	sqlite_disconnect( dataProyect ).
		
listMessages(Request):-
	http_read_json(Request, Data, [json_object(term)]),
	arg(1,Data,UserInfo),
	getChat(UserInfo.user,UserInfo.bot,Chat),
	reply_json(json([chat(Chat)])).
		
getChat(User,Bot,Chat):-
	%debug( sqlite ),
	DataBase = 'dataBase/dataProyect.sqlite',
    sqlite_connect( DataBase , dataProyect ),
	format(atom(Statement), "select message from chats where user='~s' and bot='~s'",[User,Bot]),
	findall( Data, (sqlite_query(dataProyect,Statement,Result),arg(1,Result,Data)), Chat ),
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

default_port(9000).