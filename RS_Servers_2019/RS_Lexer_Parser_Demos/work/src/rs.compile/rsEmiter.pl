/*
loriacarlos@gmail.com
EIF400 II-2019
Colaboradores:

Erick Vargas Arias 
Esteban Zúñiga Cruz
Gonzalo Gonzalez Garro
Gabriel Araya Ruiz

*/

:- module(rsEmiter, [
                       genCodeToFile/2,
                       genCode/1,
                       genCode/2
                    ]).


:- use_module(rsParser).

testEmiter :-
    rsParser:testParser(P),
    genCode(P)
.

capitalize_aux(Word,UPword):- 
atom_chars(Word, [FirstLow|Rest]),
upcase_atom(FirstLow,R),
atom_chars(UPword, [R|Rest]).

capitalize([], []).
capitalize([H1|T1], [H2|T2]):- 
capitalize_aux(H1,H2),
capitalize(T1,T2).

tablaSimbolos([], [], A2):- assert(asterisk(1, A2)), !.
tablaSimbolos([], _, A2) :- assert(asterisk(1, A2)), !.
tablaSimbolos([X|L], [X2|L2], A2) :- X == X2, tablaSimbolos(L, L2, A2), !. 
tablaSimbolos([X|L], [X2|L2], A2) :- X2 == *, tablaSimbolos(L, [*|L2], [X|A2]), !.

evaluador([], A, A) :- !.
evaluador([X|L], A, R) :- X = star(P), asterisk(P, M), evaluador(L, [M|A], R), !.
evaluador([X|L], A, R) :- X = formal(star(P)), asterisk(P, M),capitalize(M,U),evaluador(L, [U|A], R), !.
evaluador([X|L], A, R) :- X = formal(bot(id(P))), botVariable(P, M),capitalize([M],K),evaluador(L, [K|A], R), !.
evaluador([X|L], A, R) :- X = bot(N), botVariable(N, M), evaluador(L, [M|A], R), !.
evaluador([X|L], A, R) :- X = set(id(H),formal([star(P)])), asterisk(P, N),capitalize(N,U),assert(variable(H, U)), evaluador(L, A, R), !.
evaluador([X|L], A, R) :- X = get(P), variable(P, M), evaluador(L, [M|A], R), !.
evaluador([X|L], A, R) :- evaluador(L, [X|A], R), !.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
genCodeToFile(File, RS_Prog) :-
   writeln(RS_Prog  ),nl,
   open(File, write, Out),
   genCode(Out, RS_Prog),
   close(Out)
. 

:- dynamic bandera/1.
:- dynamic banderaRespuesta/1.

genCodeList(Out, L) :- genCodeList(Out, L, '')
.
genCodeList(_, [], _).
genCodeList(Out, [C], _) :- genCode(Out, C).
genCodeList(Out, [X, Y | L], Sep) :- bandera(verdadera), banderaRespuesta(verdadera); (genCode(Out, X), 
                                    format(Out, '~a', [Sep]),
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
	 bandera(verdadera),
     genCodeList(Out, WL),
	 findall(X, palabra(X), L),
	 writeln(L),
	 retractall(palabra(_)),
	 assert(banderaRespuesta(verdadera)),
	 evaluador(L, [], R), 
	 flatten(R, R2),
	 reverse(R2, R3),
     printList(Out,R3)
.

genCodeTrigger(Out, trigger(WL)) :- !,
     genCodeList(Out, WL),
     findall(X, palabra(X), L),
	 retractall(palabra(_)),
     tablaSimbolos([hello,world], L, []),
     assert(bandera(verdadera))
.

genCodeDefine(_,var(B, V, word(W))) :- !,
	B = bot,
    assert(botVariable(V,W))
.

genCodeDefine(_,var(B, V, num(W))) :- !,
	B = bot,
    assert(botVariable(V,[W]))
.
