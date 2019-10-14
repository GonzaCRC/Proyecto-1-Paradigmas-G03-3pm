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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main Test %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
testParser(P) :-
    File = '../../cases/micro3.rive',
    format('~n~n*** Parsing file: ~s ***~n~n', File),
    parse(File, P),
    line_number(LN),
    format('File ~s parsed: ~d lines processed~n~n', [File, LN])
.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Main Parse predicate %%%%%%%%%%%%%%%%%%%%%%%
parse(_, _) :- reset_line_number, 
               reset_some_indexes([asterisk, hash, underscore]),
               fail
.
parse(File, ProgAst) :- 
    tokenize(File, Tokens),
    rsProgram(ProgAst, Tokens, []),
    !
.
parse(File, _) :-
    Msg = 'Parsing fails. File: ~s. Last Seen Line Number: ~d',
    line_number(N),
    format(atom(A), Msg, [File, N]),
    throw(syntaxError(A, ''))    
.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Rs Program Grammar %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rsProgram(rsProg(FL)) --> rsCommandList(FL)
.
rsCommandList([]) --> []
.
rsCommandList(L) --> ['\n'], {inc_line_number}, rsCommandList(L)
.
rsCommandList([trigger_block(B) | R]) --> trigger_block(B), !, {reset_some_indexes([asterisk, hash, underscore])}, rsCommandList(R)
.
rsCommandList([response_block(B) | R]) --> response_block(B), !, rsCommandList(R)
.
rsCommandList([define_block(B) | R])  --> define_block(B), !, rsCommandList(R)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trigger Block %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trigger_block(trigger(TL)) --> ['+'], trigger_token_list(TL)
.

trigger_token_list([])  --> ['\n'], {inc_line_number}
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

trigger_tag(I) --> ['<'], star_ref(I),  ['>']
.

trigger_tag(array(inline, WL)) --> ['('], word_list(WL), [')']
.

trigger_tag(array(ref, W)) --> ['(', '@'], word(W), [')']
.

trigger_tag(W) --> ['{'], word_list(W), ['}']
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Response Block/Commands %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

response_block(response(TL)) --> ['-'], response_token_list(TL)
.

response_token_list([])  --> ['\n'], {inc_line_number}
.

response_token_list([T | TL])  --> response_token(T), response_token_list(TL)
.

response_token(T) --> wild_card(T)
.
response_token(T) --> response_tag(T)
.
response_token(W) --> word(W)
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

response_tag(bot(W, V)) --> ['<'], [bot], id(W), ['='], response_token(V), ['>']
.

response_tag(bot(V)) --> ['<'], [bot], id(V), ['>']
.

response_tag(weight(I)) --> ['{'], [weight, '=', V], ['}'], 
                                  {enforce_integer(V, I, 'Invalid weight'), !}
.

response_tag(formal(I)) --> ['{'], [formal], ['}'], token_list_formal(I)
.

response_tag(formal([star(1)])) --> ['<'], [formal], ['>']
.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Define Block/Commands %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate formal tag tree

token_list_define([]), ['='] --> ['=']
.

token_list_define([])  --> ['\n']
.

token_list_define([T | TL])  --> word(T), token_list_define(TL)
.

define_block(B) --> ['!'], define_command(B)
.
define_command(var(global, version, V)) --> [version], ['='], [T], {convert_value(T, V)}
.
define_command(var(bot, N, V)) --> [var], word(word(N)), ['='], [T], {convert_value(T, V)}
.
define_command(var(global, N, V)) --> [global], word(word(N)), {reserved_name(N)},
                                      ['='], [T], {convert_value(T, V)}
.
define_command(substitution(N, V)) --> token_list_define(N), ['='], token_list_define(V)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Common Tools %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wild_card(hash(N)) --> ['#'], {next_index(hash, N)}
.
wild_card(asterisk(N)) --> ['*'], {next_index(asterisk, N)}
.
wild_card(underscore(N)) --> ['_'], {next_index(underscore, N)}
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
