read_file(Stream, Lines) :-
    read(Stream, Line),               % Attempt a read Line from the stream
    (  at_end_of_stream(Stream)       % If we're at the end of the stream then...
    -> Lines = []                     % ...lines read is empty
    ;  Lines = [Line|NewLines],       % Otherwise, Lines is Line followed by
       read_file(Stream, NewLines)    %   a read of the rest of the file
    ).
	
assert_from_list([]).	
assert_from_list([X|L]) :- assert(X), assert_from_list(L).

capitalize_optional(Word,UPword):- 
	atom_chars(Word, [FirstLow|Rest]),
	upcase_atom(FirstLow,R),
	atom_chars(UPword, [R|Rest])
.

capitalize([], []).
capitalize([word(H1)|T1], [H2|T2]):- 
	capitalize_optional(H1,H2),
	capitalize(T1,T2)
.
capitalize([H1|T1], [H2|T2]):- 
	capitalize_optional(H1,H2),
	capitalize(T1,T2)
.

append_lists([], R, R) :- !.
append_lists([X|L], A, R) :- append(A, X, K), append_lists(L, K, R), !.
append_lists(L, R) :- append_lists(L, [], R), !.

guardar(File, Lines) :- 
	atom_concat('../../riveRepository/', File, PathInFile),
    atom_concat(PathInFile, '.rive.out', RSOutFile),
	open(RSOutFile, read, Str), read_file(Str, Lines), close(Str), write(Lines), nl,
	assert_from_list(Lines)
.

:- dynamic trigger/2.
:- dynamic response/2.
:- dynamic response_weight/3.
:- dynamic response_condition/5.
:- dynamic variable/2.
:- dynamic topic/2.
:- dynamic star/2.
:- dynamic botVariable/2.

initializeVariables([]).
initializeVariables([X|L]) :- X = hash(N), assert(star(N, undefined)), initializeVariables(L).
initializeVariables([X|L]) :- X = underscore(N), assert(star(N, undefined)), initializeVariables(L).
initializeVariables([X|L]) :- X = asterisk(N), assert(star(N, undefined)), initializeVariables(L).
initializeVariables([X|L]) :- X = set(id(H),_), assert(variable(H, undefined)), initializeVariables(L).
initializeVariables([_|L]) :- initializeVariables(L).

trigger_match([], [], A) :- !, A = [].
trigger_match(N, [], A) :- !, N \= [], A = N.
trigger_match([], [asterisk(N)], A) :- !, star(N, M), M \= 'undefined', A = []. 
trigger_match([], [asterisk(_)], A) :- !, A = [asterisk(_)]. 
trigger_match(L, [X2|L2], A2) :- X2 = optional_asterisk(N), assert(star(N, undefined)), trigger_match(L, [asterisk(N)|L2], A2), !.
% trigger_match([X|L], L2, A2) :- atom_string(X, S), re_replace('\'', ' ', S, R), atom_string(Z, R), substitution(Z, N), atomic_list_concat(M, ' ', N), flatten([M|L], L3), trigger_match(L3, L2, A2), !.
trigger_match([X|L], [X2|L2], A2) :- X2 = optional(N), (X == N, trigger_match(L, L2, A2); trigger_match([X|L], L2, A2)), !.
trigger_match([X|L], [X2|L2], A) :- X == X2, trigger_match(L, L2, A), !. 
trigger_match([X|L], [X2|L2], A) :- X2 = hash(N), term_string(X3, X), number(X3), retract(star(N, _)), assert(star(N, X)), trigger_match(L, L2, A), !.
trigger_match([X|L], [X2|L2], A) :- X2 = underscore(N), retract(star(N, _)), assert(star(N, X)), trigger_match(L, L2, A), !.
trigger_match([X|L], [X2|[Y|L2]], A) :- X2 = asterisk(optional(_)), Y == X, trigger_match([X|L], [Y|L2], A), !.
trigger_match([X|L], [X2|[Y|L2]], A) :- X2 = asterisk(N), Y = asterisk(_), star(N, M), M \= 'undefined', trigger_match([X|L], [Y|L2], A), !.
trigger_match([X|L], [X2|[Y|L2]], A) :- X2 = asterisk(N), Y == X, star(N, M), M \= 'undefined', trigger_match([X|L], [Y|L2], A), !.
trigger_match([X|L], [X2|[Y|[H|L2]]], A) :- X2 = asterisk(N), Y \= asterisk(_), trigger_match([X|L], [Y|[H|L2]], A), star(N, M), M \= 'undefined', (H = asterisk(_); trigger_match([X|L], [Y|[H|L2]], A)), !.
trigger_match([X|L], [X2|L2], A) :- X2 = asterisk(N), retract(star(N, M)), ((M == 'undefined', P = []); P = M), assert(star(N, [X|P])), trigger_match(L, [asterisk(N)|L2], A), !.
% trigger_match([_|L], [X2|L2], A2) :- X2 = set(id(H),formal([star(P)])), star(P, N), capitalize(N,U), retract(variable(H, _)), assert(variable(H, U)), trigger_match(L, L2, A2), !.
% trigger_match([_|L], [X2|L2], A2) :- X2 = set(id(H),star(P)), star(P, N), retract(variable(H, _)), assert(variable(H, N)), trigger_match(L, L2, A2), !.
% trigger_match([X|L], [X2|L2], A2) :- X2 = array(K, word(N)), retract(array(N, [Y|V])), assert(array(N, V)), term_string(X3, X), (X3 == Y; trigger_match([X|L], [X2|L2], A2)), assert(star(K, X)), trigger_match(L, L2, A2), !.
% trigger_match([X|L], [X2|L2], A2) :- X2 = array(word(N)), retract(array(N, [Y|V])), assert(array(N, V)), term_string(X3, X), ((X3 == Y, trigger_match(L, L2, A2)); trigger_match([X|L], [X2|L2], A2)), !.


interpreter([], A, A) :- !.
interpreter([X|L], A, R) :- X = input(N), return_input(N, V), interpreter(L, [V|A], R), !.
interpreter([X|L], A, R) :- X = input(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = topic(N), retractall(topic(_, _)), assert(topic(N, true)), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = underscore(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = underscore(P), star(P, M), interpreter(L, [M|A], R), !.
interpreter([X|L], A, R) :- X = underscore(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = hash(P), star(P, M), interpreter(L, [M|A], R), !. 
interpreter([X|L], A, R) :- X = hash(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = weight(N), assert(probability(N)), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = star(P), star(P, M), interpreter(L, [M|A], R), !.
interpreter([X|L], A, R) :- X = star(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = formal([]), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = formal([word(P)|N]), capitalize([P],U), interpreter([formal(N)|L], [U|A], R), !.
interpreter([X|L], A, R) :- X = formal([get(id(P))|N]), variable(P, M), capitalize(M,U), interpreter([formal(N)|L], [U|A], R), !.
interpreter([X|L], A, R) :- X = formal([botVariable(P)|N]), botVariable(P, M), capitalize(M,U), interpreter([formal(N)|L], [U|A], R), !.
interpreter([X|L], A, R) :- X = formal([star(P)|N]), star(P, M), capitalize(M,U), interpreter([formal(N)|L], [U|A], R), !.
interpreter([X|L], A, R) :- X = formal([variable(P)|N]), variable(P, M), capitalize(M,K), interpreter([formal(N)|L], [K|A], R), !.
interpreter([X|L], A, R) :- X = updateBotVariable(N, M), retractall(botVariable(N, _)), assert(botVariable(N, M)), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = botVariable(N), botVariable(N, M), atomic_list_concat(M, ' ', RL), interpreter(L, [RL|A], R), !.
interpreter([X|L], A, R) :- X = botVariable(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = variable(P), variable(P, M), interpreter(L, [M|A], R), !.
interpreter([X|L], A, R) :- X = variable(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = variable(H, star(P)), star(P, N), retractall(variable(H, _)), assert(variable(H, N)), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = variable(H,formal([star(P)])), star(P, N), capitalize(N,U), retractall(variable(H, _)), assert(variable(H, U)), interpreter(L, A, R), !.
% interpreter([X|L], A, R) :- X = set(id(H),get(id(P))), variable(P, N), retractall(variable(H, _)), assert(variable(H, N)), interpreter(L, A, R), !.
% interpreter(L, A, R) :- response_condition(star(N), O, input(M), _), O == 'eq', !, star(N, [P]), return_input(M, K), K == P, interpreter(L, A, R), !.
% interpreter(L, A, R) :- response_condition(star(N), O, input(_), _), O == 'eq', !, star(N, [P]), 'undefined' == P, interpreter(L, A, R), !.
% interpreter(L, A, R) :- response_condition(star(N), O, input(M), _), O == 'ne', !, star(N, [P]), return_input(M, K), K \= P, interpreter(L, A, R), !.
% interpreter(L, A, R) :- response_condition(star(N), O, input(_), _), O == 'ne', !, star(N, [P]), 'undefined' \= P, interpreter(L, A, R), !.
% interpreter(L, A, R) :- response_condition(formal([star(N)]), O, bot(id(M)), _), O == 'ne', !, star(N, P), capitalize(P, [U]), botVariable(M, K), U \= K, interpreter(L, A, R), !.
% interpreter(L, A, R) :- response_condition(formal([star(N)]), O, bot(id(M)), _), O == 'eq', !, star(N, P), capitalize(P, [U]), botVariable(M, K), U == K, interpreter(L, A, R), !.
% interpreter(L, A, R) :- response_condition(formal([star(N)]), O, bot(id(M)), _), O == 'ne', !, star(N, P), capitalize(P, [U]), botVariable(M, K), U \= K, interpreter(L, A, R), !.
% interpreter(L, A, R) :- response_condition(formal([star(N)]), O, get(id(M)), _), O == 'eq', !, star(N, P), capitalize(P, U), variable(M, K), U == K, interpreter(L, A, R), !.
% interpreter(L, A, R) :- response_condition(formal([star(N)]), O, get(id(M)), _), O == 'ne', !, star(N, P), capitalize(P, U), variable(M, K), U \= K, interpreter(L, A, R), !.
interpreter([X|L], A, R) :- interpreter(L, [X|A], R), !.


condition(X, A) :- response_condition(X, variable(V), O, B, A), O == 'ne', once((variable(V, M); M = 'undefined')), B \= M.
condition(X, A) :- response_condition(X, variable(V), O, B, A), O == 'eq', once((variable(V, M); M = 'undefined')), B == M.

get_response(Q, RL) :- 
	split_string(Q, " ", "", L),
	!,
	findall(X, trigger(_, X), W),
	match_question(L, W, RL)
.

match_question(_, [], _) :- 
	retractall(star(_,_)),!.

match_question(Q, [X|_], RL) :- 
	retractall(star(_,_)),
	initializeVariables(X), 
	trigger_match(Q, X, A),
	A == [],
	trigger(V, X),
	(match_condition_response(V, RL); match_response(V, RL)), !
.

match_question(Q, [X|L], RL) :- 
	retractall(star(_,_)),
	initializeVariables(X), 
	match_question(Q, L, RL), !
.

match_response(V, RL) :- 
	findall(Y, response(V, Y), L), 
	findall(YY, response_weight(V, YY, _), LL), 
	findall(N, response_weight(V, _, weight(N)), W), 
	response_weight_list(LL, W, [], F),
	append_lists([L|F], E),
	random_member(A, E), 
	initializeVariables(A), 
	interpreter(A, [], R),
	flatten(R, RF), 
	reverse(RF, RR), 
	atomic_list_concat(RR, ' ', RL)
.

match_condition_response(I, RL) :- 
	condition(I, M),
	interpreter(M, [], R),
	flatten(R, RF), 
	reverse(RF, RR), 
	atomic_list_concat(RR, ' ', RL)
.

response_weight_list([], [], A, A).
response_weight_list([X|L], [Y|P], A, R) :- length(K, Y), maplist(=(X), K), response_weight_list(L, P, [K|A], R).


% [rsEval2].
% guardar('02_star_match', L).
% get_response('hola', R).

























