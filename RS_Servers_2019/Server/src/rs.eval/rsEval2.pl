:- module(rsEval2, [get_response/4]).

read_file(Stream, Lines) :-
    read(Stream, Line),               
    (  at_end_of_stream(Stream)       
    -> Lines = []                    
    ;  Lines = [Line|NewLines],
       read_file(Stream, NewLines)
    )
.
	
assert_from_list([]).

assert_from_list([X|L]) :- 
	current_user(User), 
	current_file_name(File), 
	assert(memory(User, File, X)), 
	assert_from_list(L)
.

capitalize_optional(Word,UPword):- 
	atom_chars(Word, [FirstLow|Rest]),
	upcase_atom(FirstLow,R),
	atom_chars(UPword, [R|Rest])
.

capitalize([], []).

capitalize([H1|T1], [S|T2]):- 
	capitalize_optional(H1,H2),
	atom_string(H2, S),
	capitalize(T1,T2)
.

append_lists([], R, R) :- !.
append_lists([X|L], A, R) :- append(A, X, K), append_lists(L, K, R), !.
append_lists(L, R) :- append_lists(L, [], R), !.

search_in_array(_, [], _) :- false.
search_in_array(Y, [X|_], R) :- Y == X, R = Y.
search_in_array(Y, [_|L], R) :- search_in_array(Y, L, R).

number_in_string_aux([]).
number_in_string_aux([X|_]) :- atom_number(X, _), !, false.
number_in_string_aux([_|L]) :- number_in_string_aux(L).
number_in_string(X) :- atom_codes(A, X), atom_chars(A, C), number_in_string_aux(C).

input_value(I, V) :- 
	current_user(User), 
	current_file_name(File),
	inputs(User, File, X), 
	nth1(I, X, V)
.
	
save_input(I) :- 
	current_user(User), 
	current_file_name(File),
	inputs(User, File, X), 
	split_string(I, " ", "", L),
	append([L], X, V), 
	retract(inputs(User, File, _)), 
	assert(inputs(User, File, V))
.

save_in_memory(File) :- current_user(User), savedMemory(User, File), !.

save_in_memory(File) :- 
	atom_concat('../../riveRepository/', File, PathInFile),
    atom_concat(PathInFile, '.rive.out', RSOutFile),
	open(RSOutFile, read, Str), read_file(Str, Lines), close(Str),
	current_user(User),
	assert(savedMemory(User, File)),
	assert_from_list(Lines), !
.

:- dynamic memory/3.
:- dynamic savedMemory/2.
:- dynamic trigger/2.
:- dynamic trigger_topic/3.
:- dynamic response/2.
:- dynamic response_topic/3.
:- dynamic response_weight/3.
:- dynamic response_condition/5.
:- dynamic variable/4.
:- dynamic topic/2.
:- dynamic star/2.
:- dynamic botVariable/2.
:- dynamic substitution/2.
:- dynamic inputs/3.
:- dynamic topic/3.
:- dynamic current_file_name/1.
:- dynamic current_user/1.

initializeVariables([]).
initializeVariables([X|L]) :- X = hash(N), assert(star(N, undefined)), initializeVariables(L).
initializeVariables([X|L]) :- X = underscore(N), assert(star(N, undefined)), initializeVariables(L).
initializeVariables([X|L]) :- X = asterisk(N), assert(star(N, undefined)), initializeVariables(L).
initializeVariables([X|L]) :- X = set(id(H),_), current_user(User), current_file_name(File), assert(variable(User, File, H, undefined)), initializeVariables(L).
initializeVariables([_|L]) :- initializeVariables(L).

trigger_match([], [], A) :- !, A = [].
trigger_match(N, [], A) :- !, N \= [], A = N.
trigger_match([], [asterisk(optional(_))], A) :- !, A = []. 
trigger_match([], [asterisk(N)], A) :- !, star(N, M), M \= 'undefined', A = []. 
trigger_match([], [asterisk(_), weight(_)], A) :- !, A = []. 
trigger_match([], [asterisk(_)], A) :- !, A = [asterisk(_)]. 
trigger_match(L, [X2|L2], A) :- X2 = optional_asterisk(N), assert(star(N, undefined)), trigger_match(L, [asterisk(N)|L2], A), !.
trigger_match(L, [X2|L2], A) :- X2 = weight(_), trigger_match(L, L2, A), !.
trigger_match([X|L], L2, A) :- re_replace('\'', ',', X, R), split_string(R, ",", "", Y), substitution(Y, N), flatten([N|L], L3), trigger_match(L3, L2, A), !.
trigger_match([X|L], [X2|L2], A) :- X2 = optional(N), (X == N, trigger_match(L, L2, A); trigger_match([X|L], L2, A)), !.
trigger_match([X|L], [X2|L2], A) :- X == X2, trigger_match(L, L2, A), !. 
trigger_match([X|L], [X2|L2], A) :- X2 = hash(N), atom_number(X, _), retract(star(N, _)), assert(star(N, X)), trigger_match(L, L2, A), !.
trigger_match([X|L], [X2|L2], A) :- X2 = underscore(N), number_in_string(X), retract(star(N, _)), assert(star(N, X)), trigger_match(L, L2, A), !.
trigger_match([X|L], [X2|[Y|L2]], A) :- X2 = asterisk(optional(_)), Y == X, trigger_match([X|L], [Y|L2], A), !.
trigger_match([X|L], [X2|[Y|L2]], A) :- X2 = asterisk(N), Y = asterisk(_), star(N, M), M \= 'undefined', trigger_match([X|L], [Y|L2], A), !.
trigger_match([X|L], [X2|[Y|L2]], A) :- X2 = asterisk(N), Y == X, star(N, M), M \= 'undefined', trigger_match([X|L], [Y|L2], A), !.
trigger_match([X|L], [X2|[Y|[H|L2]]], A) :- X2 = asterisk(N), Y \= asterisk(_), trigger_match([X|L], [Y|[H|L2]], A), star(N, M), M \= 'undefined', (H = asterisk(_); trigger_match([X|L], [Y|[H|L2]], A)), !.
trigger_match([X|L], [X2|L2], A) :- X2 = asterisk(N), retract(star(N, M)), ((M == 'undefined', P = []); P = M), assert(star(N, [X|P])), !, trigger_match(L, [asterisk(N)|L2], A), !.
trigger_match([X|L], [X2|L2], A) :- X2 = array(K, N), array(N, V), search_in_array(X, V, R), assert(star(K, R)), trigger_match(L, L2, A), !.
trigger_match([X|L], [X2|L2], A) :- X2 = array(N), array(N, V), search_in_array(X, V, _), trigger_match(L, L2, A), !.

interpreter([], A, A) :- !.
interpreter([X|L], A, R) :- X = input(N), input_value(N, V), interpreter(L, [V|A], R), !.
interpreter([X|L], A, R) :- X = input(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = topic(N), current_user(User), current_file_name(File), retractall(topic(User, File, _)), assert(topic(User, File, N)), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = underscore(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = underscore(P), star(P, M), interpreter(L, [M|A], R), !.
interpreter([X|L], A, R) :- X = underscore(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = hash(P), star(P, M), interpreter(L, [M|A], R), !. 
interpreter([X|L], A, R) :- X = hash(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = weight(N), assert(probability(N)), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = star(P), star(P, M), interpreter(L, [M|A], R), !.
interpreter([X|L], A, R) :- X = star(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = formal([]), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = formal([botVariable(P)|N]), current_user(User), current_file_name(File), memory(User, File, botVariable(P, M)), capitalize(M,U), interpreter([formal(N)|L], [U|A], R), !.
interpreter([X|L], A, R) :- X = formal([star(P)|N]), star(P, M), capitalize(M,U), interpreter([formal(N)|L], [U|A], R), !.
interpreter([X|L], A, R) :- X = formal([variable(P)|N]), current_user(User), current_file_name(File), memory(User, File, variable(P, M)), capitalize(M,K), interpreter([formal(N)|L], [K|A], R), !.
interpreter([X|L], A, R) :- X = updateBotVariable(N, M), current_user(User), current_file_name(File), retractall(memory(User, File, botVariable(N, _))), assert(memory(User, File, botVariable(N, M))), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = botVariable(N), current_user(User), current_file_name(File), memory(User, File, botVariable(N, M)), atomic_list_concat(M, ' ', RL), interpreter(L, [RL|A], R), !.
interpreter([X|L], A, R) :- X = botVariable(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = variable(P), current_user(User), current_file_name(File), memory(User, File, variable(P, M)), interpreter(L, [M|A], R), !.
interpreter([X|L], A, R) :- X = variable(_), interpreter(L, [undefined|A], R), !.
interpreter([X|L], A, R) :- X = variable(H, variable(P)), memory(User, File, variable(P, N)), retractall(memory(User, File, variable(H, _))), assert(memory(User, File, variable(H, N))), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- X = variable(H, formal([star(P)])), star(P, N), capitalize(N,U), retractall(memory(User, File, variable(H, _))), assert(memory(User, File, variable(H, U))), interpreter(L, A, R), !.
interpreter([X|L], A, R) :- interpreter(L, [X|A], R), !.

condition([V|_], [O|_], [B|_], [A|_], A) :- V = variable(U), O == 'ne', current_user(User), current_file_name(File), once((memory(User, File, variable(U, M)); M = 'undefined')), B \= M.
condition([V|_], [O|_], [B|_], [A|_], A) :- V = variable(U), O == 'eq', current_user(User), current_file_name(File), once((memory(User, File, variable(U, M)); M = 'undefined')), B == M.
condition([V|_], [O|_], [B|_], [A|_], A) :- V = formal([star(N)]), B = botVariable(M), O == 'eq', star(N, P), capitalize(P, U), current_user(User), current_file_name(File), once((memory(User, File, botVariable(M, K)); K = 'undefined')), U == K.
condition([V|_], [O|_], [B|_], [A|_], A) :- V = formal([star(N)]), B = botVariable(M), O == 'ne', star(N, P), capitalize(P, U), current_user(User), current_file_name(File), once((memory(User, File, botVariable(M, K)); K = 'undefined')), U \= K.
condition([V|_], [O|_], [B|_], [A|_], A) :- V = star(N), B = input(M), O == 'eq', star(N, P), once((input_value(M, K); K = 'undefined')), reverse(P, I), I == K.
condition([V|_], [O|_], [B|_], [A|_], A) :- V = star(N), B = input(M), O == 'ne', star(N, P), once((input_value(M, K); K = 'undefined')), reverse(P, I), I \= K.
condition([_|L1], [_|L2], [_|L3], [_|L4], A) :- condition(L1, L2, L3, L4, A).

get_response(User, File, Q, RR) :- 
	retractall(current_user(_)), assert(current_user(User)),
	retractall(current_file_name(_)), assert(current_file_name(File)),
	save_in_memory(File),
	split_string(Q, " ", "", L), !,
	(inputs(User, File, _); assert(inputs(User, File, []))),
	findall(X, memory(User, File, trigger(_, X)), W), !,
	once(match_topic(L, RL); match_question(L, W, RL)),
	save_input(Q),
	((var(RL), RR = "ERR: No Reply Matched"); RR = RL), !
.

match_topic(Q, RL) :-
	current_user(User), 
	current_file_name(File),
	topic(User, File, N),
	findall(X, memory(User, File, trigger_topic(N,_, X)), W),
	match_question_topic(Q, W, RL)
.

match_question_topic(_, [], _).

match_question_topic(Q, [X|_], RL) :- 
	current_user(User), 
	current_file_name(File),
	retractall(star(_,_)),
	initializeVariables(X), 
	trigger_match(Q, X, A),
	A == [],
	memory(User, File, trigger_topic(_, V, X)),
	match_response_topic(V, RL), !
.

match_question_topic(Q, [X|L], RL) :- 
	retractall(star(_,_)),
	initializeVariables(X), 
	match_question_topic(Q, L, RL), !
.

match_question(_, [], _).

match_question(Q, [X|_], RL) :- 
	current_user(User), 
	current_file_name(File),
	retractall(star(_,_)),
	initializeVariables(X), 
	trigger_match(Q, X, A),
	A == [],
	memory(User, File, trigger(V, X)),
	(match_response_condition(V, RL); match_response(V, RL)), !
.

match_question(Q, [X|L], RL) :- 
	retractall(star(_,_)),
	initializeVariables(X), 
	match_question(Q, L, RL), !
.

match_response(V, RL) :- 
	current_user(User), 
	current_file_name(File),
	findall(Y, memory(User, File, response(V, Y)), L), 
	findall(YY, memory(User, File, response_weight(V, YY, _)), LL), 
	findall(N, memory(User, File, response_weight(V, _, weight(N))), W), 
	response_weight_list(LL, W, [], F),
	append_lists([L|F], E),
	random_member(A, E), 
	initializeVariables(A), 
	interpreter(A, [], R),
	flatten(R, RF), 
	reverse(RF, RR), 
	atomic_list_concat(RR, ' ', RL)
.

match_response_topic(V, RL) :- 
	current_user(User), 
	current_file_name(File),
	findall(Y, memory(User, File, response_topic(_, V, Y)), L), 
	random_member(A, L), 
	initializeVariables(A), 
	interpreter(A, [], R),
	flatten(R, RF), 
	reverse(RF, RR), 
	atomic_list_concat(RR, ' ', RL)
.

match_response_condition(I, RL) :- 
	findall(V, memory(User, File, response_condition(I, V, _, _, _)), VL), 
	findall(O, memory(User, File, response_condition(I, _, O, _, _)), OL), 
	findall(B, memory(User, File, response_condition(I, _, _, B, _)), BL), 
	findall(L, memory(User, File, response_condition(I, _, _, _, L)), LL), 
	condition(VL, OL, BL, LL, M),
	interpreter(M, [], R),
	flatten(R, RF), 
	reverse(RF, RR), 
	atomic_list_concat(RR, ' ', RL)
.

response_weight_list([], [], A, A).
response_weight_list([X|L], [Y|P], A, R) :- length(K, Y), maplist(=(X), K), response_weight_list(L, P, [K|A], R).


























