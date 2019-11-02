/*
EIF400 loriacarlos@gmail.com
II-2019
Colaboradores:

Erick Vargas Arias 
Esteban Zúñiga Cruz
Gonzalo Gonzalez Garro
Gabriel Araya Ruiz

*/

:- module(rsParser, [testParser/1, parse/2]).

:-  use_module(rsLexer).
:-  use_module(rsIndexer).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main Test %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

testParser(P) :-
    File = '../../cases/40_sort_triggers.rive',
    format('~n~n*** Parsing file: ~s ***~n~n', File),
    parse(File, P),
	writeln(P),
    line_number(LN),
    format('File ~s parsed: ~d lines processed~n~n', [File, LN])
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main Parse predicate %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
parse(_, _) :- reset_line_number, 
               reset_some_indexes([star, optional, trigger]),
               fail
.
parse(File, ProgAst) :- 
    tokenize(File, Tokens),
	append(Tokens, ['\n'], FTokens),
    rsProgram(ProgAst, FTokens, []),
    !
.
parse(File, _) :-
    Msg = 'Parsing fails. File: ~s. Last Seen Line Number: ~d',
    line_number(N),
    format(atom(A), Msg, [File, N]),
    throw(syntaxError(A, ''))    
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rs Program Grammar %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- dynamic triggerBlock/1.
:- dynamic responseBlock/1.

rsProgram(rsProg(FL)) --> rsCommandList(FL)
.
rsCommandList([]) --> [], {triggerBlock(true)}, {responseBlock(true)}
.
rsCommandList(L) --> ['\n'], {inc_line_number}, rsCommandList(L)
.
rsCommandList([trigger_block(B) | R]) --> trigger_block(B), !, {reset_some_indexes([star, optional])}, {assert(triggerBlock(true))}, rsCommandList(R)
.
rsCommandList([response_block(B) | R]) --> {assert(responseBlock(true))}, response_block(B), !, rsCommandList(R)
.
rsCommandList([define_block(B) | R])  --> define_block(B), !, rsCommandList(R)
.
rsCommandList([comment_block(B) | R])  --> comment_block(B), !, rsCommandList(R)
.
rsCommandList([topic_block(B) | R])  --> topic_block(B), !, rsCommandList(R)
.

rsCommandList([sub_block(B) | R])  --> sub_block(B), !, rsCommandList(R)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TOPIC BLOCK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

topic_block(TL) --> ['>'], ['topic'], [B], topic_token_list(B, TL), ['<'], ['topic']
.

topic_token_list(_, []), ['<'] --> ['<'], {inc_line_number}
.

topic_token_list(B, L) --> ['\n'], {inc_line_number}, topic_token_list(B,L)
.
topic_token_list(B, [T | TL])  --> topic_token(B, T), topic_token_list(B, TL)
.

topic_token(B, trigger_topic(B,ID, TL)) --> ['+'], trigger_token_list(TL), {get_index(trigger, ID)}
.

topic_token(B, response_topic(B,ID, TL)) --> ['-'], response_token_list(TL), {get_index(trigger, ID)}
.

topic_token(B, comment_topic(B, TL)) -->  ['/'], ['/'], comment_token_list(TL)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% COMMENT BLOCK %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

comment_block(comment(TL)) --> ['/'], ['/'], comment_token_list(TL)
.

comment_token_list([])  --> ['\n'], {inc_line_number}
.
comment_token_list([T | TL])  --> comment_token(T), comment_token_list(TL)
.

comment_token(W) --> word(W)
.

comment_token(W) --> wild_card(W)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trigger Block %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trigger_block(trigger(ID, TL)) --> ['+'], trigger_token_list(TL), {get_index(trigger, ID)}
.

trigger_token_list([])  --> ['\n'], {inc_line_number}, {next_index(trigger, _)}
.
trigger_token_list([T | TL])  --> trigger_token(T), trigger_token_list(TL)
.

trigger_token(T) --> wild_card(T)
.
trigger_token(T) --> trigger_tag(T)
.
trigger_token(W) --> word(W)
.

trigger_tag(get(W)) --> ['<'], [get], id(W), ['>']
.

trigger_tag(I) --> ['<'], input_ref(I),  ['>']
.
trigger_tag(I) --> ['<'], reply_ref(I),  ['>']
.

trigger_tag(I) --> ['<'], star_ref(I),  ['>'], fail
.

trigger_tag(weight(I)) --> ['{'], [weight, '=', V], ['}'], 
                                  {enforce_integer(V, I, 'Invalid weight'), !}
.

trigger_tag(array(inline, WL)) --> ['('], word_list(WL), [')']
.

trigger_tag(array(N, W)) --> ['('], ['@'], id(W), [')'], {next_index(star, N)}
.

trigger_tag(array(W)) --> ['@'], id(W)
.

trigger_tag(W) --> ['{'], word_list(W), ['}']
.

trigger_tag(optional(optional_asterisk(N))) --> ['['], ['*'], [']'], {next_index(optional, N)}
.

trigger_tag(optional(W)) --> ['['], word(W), [']']
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Response Block/Commands %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

response_weight_token_list([]) --> ['\n'], {inc_line_number}
.

response_weight_token_list([]), ['{'] --> ['{'], {inc_line_number}
.

response_weight_token_list([T | TL])  --> response_token(T), response_weight_token_list(TL), {!}
.

response_weight_tag(weight(I)) --> ['{'], [weight, '=', V], ['}'], 
                                  {enforce_integer(V, I, 'Invalid weight'), !}
.

response_block(response_weight(ID, TL, W)) --> ['-'], {reset_some_indexes([star])}, response_weight_token_list(TL), response_weight_tag(W), ['\n'], {get_index(trigger, ID)}
.

response_block(response(ID, TL)) --> ['-'], response_token_list(TL), {get_index(trigger, ID)}
.

response_block(response_condition(ID, V, O , B, D)) --> ['*'], ['<', get], id(V), ['>'], operator(O), [B], ['=', '>'], response_token_list(D), {get_index(trigger, ID)}
.

response_block(response_condition(ID, V, O , B, D)) --> ['*'], response_tag(V), operator(O), response_tag(B), ['=', '>'], response_token_list(D), {get_index(trigger, ID)}
.

response_token_list([])  --> ['\n'], {inc_line_number}
.

response_token_list([T | TL])  --> response_token(T), response_token_list(TL)
.


response_token(T) --> response_tag(T)
.
response_token(W) --> word(W)
.

% Generate updateBotVariable tree
token_list_variable([]), ['>']  --> ['>']
.

token_list_variable([T | TL])  --> word(T), token_list_variable(TL)
.

% Generate formal tag tree
token_list_formal([]) --> ['{'], ['/'], [formal], ['}']
.

token_list_formal([T | TL])  --> response_token(T), token_list_formal(TL)
.

response_tag(star(1)) --> ['<'], [star],  ['>']
.

response_tag(I) --> ['<'], star_ref(I),  ['>']
.

response_tag(get(W)) --> ['<', get], id(W), ['>']
.

response_tag(set(W, V)) --> ['<', set], id(W), ['='], response_token(V), ['>']
.

response_tag(updateBotVariable(W, V)) --> ['<'], [bot], id(W), ['='], token_list_variable(V), ['>']
.

response_tag(bot(V)) --> ['<'], [bot], id(V), ['>']
.

response_tag(formal(I)) --> ['{'], [formal], ['}'], token_list_formal(I)
.

response_tag(formal([star(1)])) --> ['<'], [formal], ['>']
.

response_tag(topic(T)) --> ['{'], ['topic'], ['='], [T], ['}']
.

response_tag(M) --> ['<'], input_ref(M), ['>']
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% AUX PREDICATES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

star_ref(star(N)) --> [IW], {atomic(IW), separate(IW, star, N)}
.

input_ref(input(N)) --> [IW], {atomic(IW), separate(IW, input, N)}
.
reply_ref(reply(N)) --> [IW], {atomic(IW), separate(IW, reply, N)}
.
separate(W, Pref, Num) :- between(1, 9, Num), atomic_list_concat([Pref, Num], W), !
.
separate(W, W, 1)
.

enforce_integer(N, N, _) :- integer(N), !
.
enforce_integer(A, N, _):- atom_number(A, N)
.
enforce_integer(A, _, Msg) :- throw(syntaxError(Msg, A))
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Define Block/Commands %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate formal tag tree

token_list_define([]), ['='] --> ['=']
.

token_list_define([])  --> ['\n']
.

token_list_define([T | TL])  --> word(T), token_list_define(TL)
.

token_list_substitution([]), ['='] --> ['=']
.

token_list_substitution([])  --> ['\n']
.

token_list_substitution([T | TL])  --> word(T), ['\''], token_list_substitution(TL)
.

token_list_substitution([T | TL])  --> word(T), token_list_substitution(TL)
.

define_block(B) --> ['!'], define_command(B)
.

define_command(var(bot, N, V)) --> [var], word(word(N)), ['='], token_list_define(V)
.

define_command(var(version, [V])) --> [version], ['='], [T], [.], [T2], {convert_value(T, V)}, {convert_value(T2, _)}
.

define_command(var(version, [V])) --> [version], ['='], [T], {convert_value(T, V)}
.

define_command(var(global, N, V)) --> [global], word(word(N)), {reserved_name(N)},
                                      ['='], [T], {convert_value(T, V)}
.
define_command(substitution(N, V)) --> ['sub'], token_list_substitution(N), ['='], token_list_substitution(V)
.

define_command(array(B, N)) --> ['array'], id(B), ['='], token_list_define(N)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Common Tools %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wild_card(hash(N)) --> ['#'], {next_index(star, N)}
.
wild_card(asterisk(N)) --> ['*'], {next_index(star, N)}
.
wild_card(underscore(N)) --> ['_'], {next_index(star, N)}
.

word(num(N)) --> id(id(W)), {convert_value(W, num(N))}
.

word(word(W)) --> id(id(W))
.
word_list([]), [')'] --> [')']
.
word_list([W]) --> word(W), word_list([]), !
.
word_list([W | WL]) --> word(W), ['|'], !, word_list(WL)
.

idList([]), [')'] --> [')']
.
idList([I]) --> id(I), idList([])
.
idList([I, J | L]) --> id(I), [','], id(J), idList(L)
.

id(id(I)) --> [I], {atomic(I)}
.

operator(oper(eq)) --> ['==']
.

operator(oper(ne)) --> ['!=']
.

operator(oper(O)) --> {member(O, ['+', '*', '-', '/']), !}
.

convert_value(undefined, const(undefined)) :- !
.
convert_value(T, num(N)) :- atom_number(T, N), !
.
convert_value(T, bool(T)) :- member(T, [true, false])
.
convert_value(T, word(T) ) :- atomic(T)
.

available_name(N) :- \+ reserved_name(N)
.
reserved_name('array')
.
reserved_name('debug')
.
reserved_name('global')
.
reserved_name('var')
.
reserved_name('version')
.
reserved_name('undefined')
.
reserved_name(N) :- member(N, ['+', '-', '*', '/', '@', '^']), !
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
