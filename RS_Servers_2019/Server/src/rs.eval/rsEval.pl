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


capitalize_aux(Word,UPword):- 
atom_chars(Word, [FirstLow|Rest]),
upcase_atom(FirstLow,R),
atom_chars(UPword, [R|Rest]).

capitalize([], []).
capitalize([word(H1)|T1], [H2|T2]):- 
capitalize_aux(H1,H2),
capitalize(T1,T2).
capitalize([H1|T1], [H2|T2]):- 
capitalize_aux(H1,H2),
capitalize(T1,T2).

initializeVariables([]).
initializeVariables([X|L]) :- X = hash(N), assert(star(N, undefined)), initializeVariables(L).
initializeVariables([X|L]) :- X = underscore(N), assert(star(N, undefined)), initializeVariables(L).
initializeVariables([X|L]) :- X = asterisk(N), assert(star(N, undefined)), initializeVariables(L).
initializeVariables([X|L]) :- X = set(id(H),_), assert(variable(H, undefined)), initializeVariables(L).
initializeVariables([_|L]) :- initializeVariables(L).

symbolTable([], [], _).
symbolTable([], [asterisk(_)], _).
symbolTable([X|L], [X2|L2], A2) :- term_string(X3, X), X2 = optional(N), (X3 == N, symbolTable(L, L2, A2); symbolTable([X3|L], L2, A2)).
symbolTable([X|L], [X2|L2], A2) :- term_string(X3, X), X3 == X2, symbolTable(L, L2, A2). 
symbolTable([X|L], [X2|L2], A2) :- term_string(X3, X), X2 = hash(N), number(X3), retract(star(N, _)), assert(star(N, X3)), symbolTable(L, L2, A2).
symbolTable([X|L], [X2|L2], A2) :- term_string(X3, X), X2 = underscore(N), retract(star(N, _)), assert(star(N, X3)), symbolTable(L, L2, A2).
symbolTable([X|L], [X2|[Y|L2]], A2) :- term_string(X3, X), X2 = asterisk(N),((Y == X3); (symbolTable([X|L], [Y|L2], A2))), star(N, M), M \= 'undefined', symbolTable([X|L], [Y|L2], A2).
symbolTable([X|L], [X2|L2], A2) :- term_string(X3, X), X2 = asterisk(N), retract(star(N, M)), ((M == 'undefined', P = ''); P = M), assert(star(N, [X3|P])), symbolTable(L, [asterisk(N)|L2], A2).
symbolTable([_|L], [X2|L2], A2) :- X2 = set(id(H),formal([star(P)])), star(P, N), capitalize(N,U), retract(variable(H, _)), assert(variable(H, U)), symbolTable(L, L2, A2).
symbolTable([_|L], [X2|L2], A2) :- X2 = set(id(H),star(P)), star(P, N), retract(variable(H, _)), assert(variable(H, N)), symbolTable(L, L2, A2).

interpreter([], A, A).
interpreter([X|L], A, R) :- X = underscore(P), star(P, M), interpreter(L, [M|A], R).
interpreter([X|L], A, R) :- X = hash(P), star(P, M), interpreter(L, [M|A], R).
interpreter([X|L], A, R) :- X = weight(_), interpreter(L, A, R).
interpreter([X|L], A, R) :- X = star(P), star(P, M), interpreter(L, [M|A], R).
interpreter([X|L], A, R) :- X = formal([get(id(P))|N]), variable(P, M), capitalize([M|N],U), reverse(U, U2), flatten([U2|A], L2), writeln(L2), interpreter(L, L2, R).
interpreter([X|L], A, R) :- X = formal(star(P)), star(P, M),capitalize(M,U),interpreter(L, [U|A], R).
interpreter([X|L], A, R) :- X = formal(bot(id(P))), botVariable(P, M),capitalize([M],K),interpreter(L, [K|A], R).
interpreter([X|L], A, R) :- X = bot(N), botVariable(N, M), interpreter(L, [M|A], R).
interpreter([X|L], A, R) :- X = get(P), variable(P, M), interpreter(L, [M|A], R).
interpreter([X|L], A, R) :- X = set(id(H),formal([star(P)])), star(P, N), capitalize(N,U), retract(variable(H, _)), assert(variable(H, U)), interpreter(L, A, R).
interpreter([X|L], A, R) :- X = set(id(H),star(P)), star(P, N), retract(variable(H, _)), assert(variable(H, N)), interpreter(L, A, R).
% interpreter([X|L], A, R) :- X = response_condition(id(V), O, B, _), O == 'eq', variable(V, M); (initializeVariables([set(V,_)]), variable(V, M)), M == B, interpreter(L, A, R));  false).
% interpreter([X|L], A, R) :- X = response_condition(id(V), O, B, _), O == 'ne', ((variable(V, M), M \= B, interpreter(L, A, R)); false).
interpreter([X|L], A, R) :- interpreter(L, [X|A], R).

:- dynamic triggerFlag/1.
:- dynamic responseFlag/1.


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
	open('response.txt', write, Out),
    term_string(Atom, String, [var_prefix(true)]),
	genCode(Out, Atom),
	!,
	close(Out),
	open('response.txt', read, Str2),
	read_string(Str2, '\n', '\t', End, String2),
	!,
	close(Str2),
	retractall(triggerFlag(_)),
    retractall(responseFlag(_)),
    retractall(question(_)),
    retractall(star(_,_)),
    retractall(botVariable(_,_)),
    retractall(palabra(_,_)),
    retractall(variable(_,_))
.

walkTree(Out, L) :- walkTree(Out, L, ''). 
walkTree(_, [], _).
walkTree(Out, [C], _) :- genCode(Out, C).
walkTree(Out, [X, Y | L], Sep) :-(triggerFlag(true), responseFlag(true)); (genCode(Out, X), 
                                    walkTree(Out, [Y | L], Sep); 
                                    walkTree(Out, [Y | L], Sep))
. 


genCode(P) :- genCode(user_output, P)
.
genCode(Out, rsProg(L)) :- !,
    walkTree(Out, L)
. 

genCode(Out, trigger_block(T)) :- !,
    genCodeTrigger(Out, T)
.

genCode(_, comment_block(_)) :- !
.

genCode(Out, response_block(T)) :- !,
    genCodeResponse(Out, T) 
.

genCode(Out, define_block(T)) :- !,
    genCodeDefine(Out, T) 
.

genCode(_, word('')) :- !, assert(palabra(''''))
.

genCode(_, set(I, E)) :-  !, assert(palabra(set(I, E)))
.

genCode(_, optional(word(N))) :- !, assert(palabra(optional(N)))
.

genCode(_, get(id(N))) :- !, assert(palabra(get(N)))
.

genCode(_, bot(id(N))) :- !, assert(palabra(bot(N)))
.

genCode(Out, word(N)) :- !, genCode(Out, atom(N))
.

genCode(Out, id(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, num(N))  :- !, genCode(Out, atom(N))
.
genCode(Out, oper(N)) :- !, genCode(Out, atom(N))
.

% Internal Representations
genCode(Out, operation(O, L, R)) :- !, walkTree(Out, [L, O, R])
.

genCode(_, atom(N)) :- !, assert(palabra(N))
.

genCode(_, N) :- !, assert(palabra(N))
.

%%%% Error case %%%%%%%%%%%%%%%%%%%%%%%%%%
genCode(Out, E) :- close(Out),!,
                    throw(genCode('genCode unhandled Tree', E))
.

saveResponse(_, []).
saveResponse(Out,[X|L]) :- format(Out, '~a ', [X]), saveResponse(Out, L).

genCodeResponse(Out, response(WL)) :- !,
    initializeVariables(WL),
    ((triggerFlag(true),
    walkTree(Out, WL),
	findall(X, palabra(X), L),
	retractall(palabra(_)),
	assert(responseFlag(true)),
	interpreter(L, [], R), 
	flatten(R, R2),
	reverse(R2, R3),
    saveResponse(Out,R3)); (retractall(palabra(_)), true))
.

genCodeResponse(Out, response_condition(V, O, B, D)) :- !,
    assert(palabra(response_condition(V, O, B, _))),
    ((triggerFlag(true),
    walkTree(Out, D),
	findall(X, palabra(X), L),
	retractall(palabra(_)),
	interpreter(L, [], R), 
	flatten(R, R2),
	reverse(R2, R3),
    saveResponse(Out,R3), 
	assert(responseFlag(true))); (retractall(palabra(_)), true))
.

genCodeTrigger(Out, trigger(WL)) :- !,
    retractall(hash(N)),
    retractall(underscore(N)),
    retractall(asterisk(N)),
    initializeVariables(WL),
    walkTree(Out, WL),
    findall(X, palabra(X), L),
    question(M),
    (symbolTable(M, L, []), assert(triggerFlag(true)) ; (true)),
    retractall(palabra(_))
.

genCodeDefine(_,var(B, V, [word(W)])) :- !,
	B = bot,
    assert(botVariable(V,W))
.

genCodeDefine(_,var(B, V, [num(W)])) :- !,
	B = bot,
    assert(botVariable(V,W))
.
