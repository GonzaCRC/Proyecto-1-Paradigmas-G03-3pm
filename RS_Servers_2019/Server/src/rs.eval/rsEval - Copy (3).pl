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
                       genCode/1
                    ]).


capitalize_optional(Word,UPword):- 
atom_chars(Word, [FirstLow|Rest]),
upcase_atom(FirstLow,R),
atom_chars(UPword, [R|Rest]).

capitalize([], []).
capitalize([word(H1)|T1], [H2|T2]):- 
capitalize_optional(H1,H2),
capitalize(T1,T2).
capitalize([H1|T1], [H2|T2]):- 
capitalize_optional(H1,H2),
capitalize(T1,T2).

initializeVariables([]).
initializeVariables([X|L]) :- X = hash(N), assert(star(N, undefined)), initializeVariables(L).
initializeVariables([X|L]) :- X = underscore(N), assert(star(N, undefined)), initializeVariables(L).
initializeVariables([X|L]) :- X = asterisk(N), assert(star(N, undefined)), initializeVariables(L).
initializeVariables([X|L]) :- X = set(id(H),_), assert(variable(H, undefined)), initializeVariables(L).
initializeVariables([_|L]) :- initializeVariables(L).

/*
[rsEval].
genCodeToFile('04_star_set_get_formal','i dreamed potado',R).
*/
symbolTable([], [], _) :- !.
symbolTable(N, [], _) :- N \= [], false.
symbolTable([], [asterisk(_)], _) :- !. 
symbolTable(L, [X2|L2], A2) :- X2 = optional(N), N = asterisk(M), assert(star(M, undefined)), symbolTable(L, [asterisk(M)|L2], A2), !.
symbolTable([X|L], L2, A2) :- atom_string(X, S), re_replace('\'', ' ', S, R), atom_string(Z, R), substitution(Z, N), atomic_list_concat(M, ' ', N), flatten([M|L], L3), symbolTable(L3, L2, A2), !.
symbolTable([X|L], [X2|L2], A2) :- term_string(X3, X), X2 = optional(N), (X3 == N, symbolTable(L, L2, A2); symbolTable([X|L], L2, A2)), !.
symbolTable([X|L], [X2|L2], A2) :- term_string(X3, X), X3 == X2, symbolTable(L, L2, A2), !. 
symbolTable([X|L], [X2|L2], A2) :- term_string(X3, X), X2 = hash(N), number(X3), retract(star(N, _)), assert(star(N, X3)), symbolTable(L, L2, A2), !.
symbolTable([X|L], [X2|L2], A2) :- term_string(X3, X), X2 = underscore(N), retract(star(N, _)), assert(star(N, X3)), symbolTable(L, L2, A2), !.
symbolTable([X|L], [X2|[Y|L2]], A2) :- X2 = asterisk(N), Y = asterisk(_), star(N, M), M \= 'undefined', symbolTable([X|L], [Y|L2], A2), !.
symbolTable([X|L], [X2|[Y|L2]], A2) :- X2 = asterisk(N), term_string(X3, X), Y == X3, star(N, M), M \= 'undefined', symbolTable([X|L], [Y|L2], A2), !.
symbolTable([X|L], [X2|[Y|[H|L2]]], A2) :- X2 = asterisk(N), Y \= asterisk(_), symbolTable([X|L], [Y|[H|L2]], A2), star(N, M), M \= 'undefined', (H = asterisk(_); symbolTable([X|L], [Y|[H|L2]], A2)), !.
symbolTable([X|L], [X2|L2], A2) :- X2 = asterisk(N), term_string(X3, X), retract(star(N, M)), ((M == 'undefined', P = []); P = M), assert(star(N, [X3|P])), symbolTable(L, [asterisk(N)|L2], A2), !.
symbolTable([_|L], [X2|L2], A2) :- X2 = set(id(H),formal([star(P)])), star(P, N), capitalize(N,U), retract(variable(H, _)), assert(variable(H, U)), symbolTable(L, L2, A2), !.
symbolTable([_|L], [X2|L2], A2) :- X2 = set(id(H),star(P)), star(P, N), retract(variable(H, _)), assert(variable(H, N)), symbolTable(L, L2, A2), !.
symbolTable([X|L], [X2|L2], A2) :- X2 = array(K, word(N)), retract(array(N, [Y|V])), assert(array(N, V)), term_string(X3, X), (X3 == Y; symbolTable([X|L], [X2|L2], A2)), assert(star(K, X)), symbolTable(L, L2, A2), !.
symbolTable([X|L], [X2|L2], A2) :- X2 = array(word(N)), retract(array(N, [Y|V])), assert(array(N, V)), term_string(X3, X), ((X3 == Y, symbolTable(L, L2, A2)); symbolTable([X|L], [X2|L2], A2)), !.

interpreter([], A, A) :- !.
interpreter([X|L], A, R) :- X = underscore(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = underscore(P), star(P, M), interpreter(L, [M|A], R), !.
interpreter([X|L], A, R) :- X = underscore(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = hash(P), star(P, M), interpreter(L, [M|A], R), !. 
interpreter([X|L], A, R) :- X = hash(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = weight(_), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = star(P), star(P, M), interpreter(L, [M|A], R), !.
interpreter([X|L], A, R) :- X = star(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = formal([]), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = formal([word(P)|N]), capitalize([P],U), interpreter([formal(N)|L], [U|A], R), !.
interpreter([X|L], A, R) :- X = formal([get(id(P))|N]), variable(P, M), capitalize(M,U), interpreter([formal(N)|L], [U|A], R), !.
interpreter([X|L], A, R) :- X = formal([bot(id(P))|N]), botVariable(P, M), capitalize(M,U), interpreter([formal(N)|L], [U|A], R), !.
interpreter([X|L], A, R) :- X = formal([star(P)|N]), star(P, M), capitalize(M,U), interpreter([formal(N)|L], [U|A], R), !.
interpreter([X|L], A, R) :- X = formal([bot(id(P))]), botVariable(P, M),capitalize([M],K),interpreter(L, [K|A], R), !.
interpreter([X|L], A, R) :- X = formal(star(P)), star(P, M), capitalize(M,U),interpreter(L, [U|A], R), !.
interpreter([X|L], A, R) :- X = formal(bot(id(P))), botVariable(P, M),capitalize([M],K),interpreter(L, [K|A], R), !.
interpreter([X|L], A, R) :- X = bot(N), botVariable(N, M), interpreter(L, [M|A], R), !.
interpreter([X|L], A, R) :- X = bot(id(N), word(M)), retractall(botVariable(N, _)), assert(botVariable(N, M)), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = bot(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = get(P), variable(P, M), interpreter(L, [M|A], R), !.
interpreter([X|L], A, R) :- X = get(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = set(id(H),formal([star(P)])), star(P, N), capitalize(N,U), retractall(variable(H, _)), assert(variable(H, U)), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = set(id(H),star(P)), star(P, N), retractall(variable(H, _)), assert(variable(H, N)), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = set(id(H),get(id(P))), variable(P, N), retractall(variable(H, _)), assert(variable(H, N)), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = response_condition(formal([star(N)]), O, bot(id(M)), _), O == 'eq', !, star(N, P), capitalize(P, [U]), botVariable(M, K), U == K, interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = response_condition(formal([star(N)]), O, bot(id(M)), _), O == 'ne', !, star(N, P), capitalize(P, [U]), botVariable(M, K), U \= K, interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = response_condition(formal([star(N)]), O, get(id(M)), _), O == 'eq', !, star(N, P), capitalize(P, U), variable(M, K), U == K, interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = response_condition(formal([star(N)]), O, get(id(M)), _), O == 'ne', !, star(N, P), capitalize(P, U), variable(M, K), U \= K, interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = response_condition(id(V), O, B, _), O == 'eq', (variable(V, M); M = 'undefined'), !, B == M, interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = response_condition(id(V), O, B, _), O == 'ne', (variable(V, M); M = 'undefined'), !, B \= M, interpreter(L, A, R), !.
interpreter([X|_], _, _) :- X = response_condition(id(_), _, _, _), !, interpreter(_, _, []), fail.
interpreter([X|L], A, R) :- interpreter(L, [X|A], R), !.

:- dynamic answer/1.
:- dynamic triggerFlag/1.
:- dynamic responseFlag/1.
:- dynamic variable/2.
:- dynamic botVariable/2.
:- dynamic substitution/2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

genCodeToFile(File,Ques, R) :- !,
    atom_concat('../../riveRepository/', File, PathInFile),
    atom_concat(PathInFile, '.rive.out', RSOutFile),
    split_string(Ques, " ", "", L),
    assert(question(L)), assert(responseFlag(false)), assert(triggerFlag(false)), assert(condition(false)),
    open(RSOutFile, read, Str),
    read_string(Str, '\n', '\t', End, String),
	!,
    close(Str),
    term_string(Atom, String, [var_prefix(true)]),
	genCode(Atom),
	!,
	findall(X, answer(X), L2),
	(random_member(A, L2); A = ["ERR: No Reply Matched"]),
	atomic_list_concat(A, ' ', R),
	retractall(question(_)), retractall(condition(_)), retractall(answer(_)), retractall(star(_,_)),
    retractall(memory(_,_)), retractall(responseFlag(_)), retractall(triggerFlag(_))
.

walkTree(L) :- walkTree(L, ''). 
walkTree([], _).
walkTree([C], _) :- genCode(C).
walkTree([X, Y | L], Sep) :- genCode(X), 
                             walkTree([Y | L], Sep)
. 

genCode(rsProg(L)) :- !,
    walkTree(L)
. 

genCode(trigger_block(T)) :- !,
	((triggerFlag(false),
    genCodeTrigger(T));
	(retractall(responseFlag(_)), assert(responseFlag(true))))
.

genCode(comment_block(_)) :- !
.

genCode(response_block(T)) :- !,
	((responseFlag(false), condition(false),
    genCodeResponse(T)); true)
.

genCode(define_block(T)) :- !,
    genCodeDefine(T) 
.

genCode(topic(T, L)) :- !,
    genCodeTopic(T, L) 
.

genCode(word(''))
.

genCode(word('\''))
.

genCode(word(''''))
.

genCode(set(I, E)) :-  !, assert(memory(set(I, E)))
.

genCode(optional(word(N))) :- !, assert(memory(optional(N)))
.

genCode(get(id(N))) :- !, assert(memory(get(N)))
.

genCode(bot(id(N))) :- !, assert(memory(bot(N)))
.

genCode(word(N)) :- !, genCode(atom(N))
.

genCode(id(N)) :- !, genCode(atom(N))
.
genCode(num(N))  :- !, genCode(atom(N))
.
genCode(oper(N)) :- !, genCode(atom(N))
.

% Internal Representations
genCode(operation(O, L, R)) :- !, walkTree([L, O, R])
.

genCode(atom(N)) :- !, assert(memory(N))
.

genCode(N) :- !, assert(memory(N))
.

%%%% Error case %%%%%%%%%%%%%%%%%%%%%%%%%%
% genCode(E) :- close(Out),!,
%                    throw(genCode('genCode unhandled Tree', E))
% .

genCode(E) :- throw(genCode('genCode unhandled Tree', E))
.


genCodeResponse(response(WL)) :- !,
    initializeVariables(WL),
    ((triggerFlag(true),
    walkTree(WL),
	findall(X, memory(X), L),
	retractall(memory(_)),
	interpreter(L, [], R), 
	flatten(R, R2),
	reverse(R2, R3),
	assert(answer(R3))); (retractall(memory(_)), true))
.

genCodeResponse(response_condition(V, O, B, D)) :- !,
    assert(memory(response_condition(V, O, B, _))),
    ((triggerFlag(true),
    walkTree(D),
	findall(X, memory(X), L),
	retractall(memory(_)),
	!,
	interpreter(L, [], R),
	flatten(R, R2),
	reverse(R2, R3),
	retractall(answer(_)), assert(answer(R3)), 
	assert(condition(true))); (retractall(memory(_)), true))
.

genCodeTrigger(trigger(WL)) :- !,
    retractall(star(_,_)),
    initializeVariables(WL),
    walkTree(WL),
    findall(X, memory(X), L),
    question(M),
    (symbolTable(M, L, []), retractall(triggerFlag(_)), assert(triggerFlag(true)); (true)),
    retractall(memory(_))
.

genCodeDefine(var(B, V, [word(W)])) :- !,
	B = bot,
    assert(botVariable(V,W))
.

genCodeDefine(var(B, V, [num(W)])) :- !,
	B = bot,
    assert(botVariable(V,W))
.

genCodeDefine(substitution(B, V)) :- !,
    walkTree(B),
	findall(X, memory(X), L),
	retractall(memory(_)),
	!,
	walkTree(V),
	findall(X2, memory(X2), L2),
	atomic_list_concat(L, ' ', A),
	atomic_list_concat(L2, ' ', C),
	retractall(memory(_)),
	assert(substitution(A, C))
.

genCodeDefine(array(N, V)) :- !,
	walkTree(V),
	findall(X, memory(X), L),
	retractall(memory(_)),
	assert(array(N, L))
.

genCodeTopic(_, _) :- !
.

















