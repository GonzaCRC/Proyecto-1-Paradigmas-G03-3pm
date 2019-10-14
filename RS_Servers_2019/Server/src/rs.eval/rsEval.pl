/*
loriacarlos@gmail.com
EIF400 II-2019
Colaboradores:

Erick Vargas Arias 
Esteban Zúñiga Cruz
Gonzalo Gonzalez Garro
Gabriel Araya Ruiz

*/

:- module(rsEval, [
                       genCodeToFile/3,
                       genCode/1,
                       genCode/2
                    ]).

:- use_module(library(memfile)).

capitalize_aux(Word,UPword):- 
atom_chars(Word, [FirstLow|Rest]),
upcase_atom(FirstLow,R),
atom_chars(UPword, [R|Rest]).

capitalize([], []).
capitalize([H1|T1], [H2|T2]):- 
capitalize_aux(H1,H2),
capitalize(T1,T2).

tablaSimbolos([], [X|_], A2) :- X == *, assert(asterisk(1, A2)).
tablaSimbolos([], _, _).
tablaSimbolos([X|L], [X2|L2], A2) :- term_string(X3, X), X2 == *, tablaSimbolos(L, [*|L2], [X3|A2]).
tablaSimbolos([X|L], [X2|L2], A2) :- term_string(X3, X), X3 == X2, tablaSimbolos(L, L2, A2). 

evaluador([], A, A) :- !.
evaluador([X|L], A, R) :- X = star(P), asterisk(P, M), evaluador(L, [M|A], R), !.
evaluador([X|L], A, R) :- X = formal(star(P)), asterisk(P, M),capitalize(M,U),evaluador(L, [U|A], R), !.
evaluador([X|L], A, R) :- X = formal(bot(id(P))), botVariable(P, M),capitalize([M],K),evaluador(L, [K|A], R), !.
evaluador([X|L], A, R) :- X = bot(N), botVariable(N, M), evaluador(L, [M|A], R), !.
evaluador([X|L], A, R) :- X = set(id(H),formal([star(P)])), asterisk(P, N),capitalize(N,U),assert(variable(H, U)), evaluador(L, A, R), !.
evaluador([X|L], A, R) :- X = get(P), variable(P, M), evaluador(L, [M|A], R), !.
evaluador([X|L], A, R) :- evaluador(L, [X|A], R), !.

:- dynamic bandera/1.
:- dynamic banderaRespuesta/1.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
genCodeToFile(File,Ques,String2) :- !,
    atom_concat('../../riveRepository/', File, PathInFile),
    atom_concat(PathInFile, '.rive.out', RSOutFile),
    split_string(Ques, " ", "", L),
    assert(question(L)),
    open(RSOutFile, read, Str),
    read_string(Str, '\n', '\t', End, String),
	!,
    close(Str),
	open('hola.txt', write, Out),
    term_string(Atom, String, [var_prefix(true)]),
	genCode(Out, Atom),
	!,
	close(Out),
	open('hola.txt', read, Str2),
	read_string(Str2, '\n', '\t', End, String2),
	!,
	close(Str2),
	retractall(bandera(_)),
    retractall(banderaRespuesta(_)),
    retractall(question(_)),
    retractall(asterisk(_,_)),
    retractall(botVariable(_,_)),
    retractall(palabra(_,_)),
    retractall(variable(_,_)).

genCodeList(Out, L) :- genCodeList(Out, L, ''). 

genCodeList(_, [], _).
genCodeList(Out, [C], _) :- genCode(Out, C).
genCodeList(Out, [X, Y | L], Sep) :-(bandera(verdadera), banderaRespuesta(verdadera)); (genCode(Out, X), 
                                    genCodeList(Out, [Y | L], Sep); 
                                    genCodeList(Out, [Y | L], Sep))
. 


genCode(P) :- genCode(user_output, P)
.
genCode(Out, rsProg(L)) :- !,
    genCodeList(Out, L)
. 

genCode(Out, trigger_block(T)) :- !,
    genCodeTrigger(Out, T)
.

genCode(Out, response_block(T)) :- !,
    genCodeResponse(Out, T) 
.

genCode(Out, define_block(T)) :- !,
    genCodeDefine(Out, T) 
.

genCode(Out, word(N)) :- !, genCode(Out, atom(N))
.

genCode(_, weight(N)) :- !, assert(palabra(weight(N)))
.

genCode(_, hash(_)) :- !, assert(palabra(hash(1)))
.

genCode(_, star(N)) :- !, assert(palabra(star(N)))
.

genCode(_, get(id(N))) :- !, assert(palabra(get(N)))
.

genCode(_, bot(id(N))) :- !, assert(palabra(bot(N)))
.

genCode(_, asterisk(_)) :- !, assert(palabra(*))
.

genCode(_, formal([N])) :- !, assert(palabra(formal(N)))
.

genCode(Out, id(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, num(N))  :- !, genCode(Out, atom(N))
.
genCode(Out, oper(N)) :- !, genCode(Out, atom(N))
.
genCode(_, set(I, E)) :-  !,
	assert(palabra(set(I, E)))
.

% Internal Representations
genCode(Out, operation(O, L, R)) :- !,
    genCodeList(Out, [L, O, R])
.

genCode(_, atom(N)) :- !, assert(palabra(N))
.

genCode(Out, comment(C)):-
     format(Out, '// ~a \n', [C])
.
%%%% Error case %%%%%%%%%%%%%%%%%%%%%%%%%%
genCode(Out, E ) :- close(Out),!,
                    throw(genCode('genCode unhandled Tree', E))
.


printList(_, []).
printList(Out,[X|L]) :- format(Out, '~a ', [X]), printList(Out, L).

genCodeResponse(Out, response(WL)) :- !,
     ((bandera(verdadera),
     genCodeList(Out, WL),
	 findall(X, palabra(X), L),
	 retractall(palabra(_)),
	 assert(banderaRespuesta(verdadera)),
	 evaluador(L, [], R), 
	 flatten(R, R2),
	 reverse(R2, R3),
     printList(Out,R3)); (retractall(palabra(_)), true))
.

genCodeTrigger(Out, trigger(WL)) :- !,
     genCodeList(Out, WL),
     findall(X, palabra(X), L),
     question(M),
     (tablaSimbolos(M, L, []), assert(bandera(verdadera)) ; (true)),
     retractall(palabra(_))
.

genCodeDefine(_,var(B, V, word(W))) :- !,
	B = bot,
    assert(botVariable(V,W))
.

genCodeDefine(_,var(B, V, num(W))) :- !,
	B = bot,
    assert(botVariable(V,[W]))
.
