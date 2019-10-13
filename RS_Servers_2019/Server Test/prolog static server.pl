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

:- assert(file_search_path(rs_path, 'src/rs.compile/')).

:- use_module(rs_path(rsCompiler)).

:- initialization(start_server).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Handlers %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- http_handler(root(.), http_reply_from_files('.', []), [prefix]).
:- http_handler(root(upload), upload, []).


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
		format('Content-type: text/plain~n~n'),
		rsCompiler:compile('temp/','rive repository/',FileName),
		delete_file(PathFile)		
		;throw(http_reply(bad_request(bad_file_upload)))
	).

prolog:message(bad_file_upload) --> [ 'Error' ].

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