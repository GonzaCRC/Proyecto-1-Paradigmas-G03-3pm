/*
Creador:
Carlos Loría Saenz
EIF400 loriacarlos@gmail.com

Colaboradores:
Erick Vargas Arias 
Esteban Zúñiga Cruz
Gonzalo Gonzalez Garro
Gabriel Araya Ruiz
*/

:- module(rsEmiter, [
                       genCodeToFile/2,
                       genCode/1,
                       genCode/2,
					   show_records/1
                    ]).


:- use_module(rsParser).

testEmiter :-
    rsParser:testParser(P),
    genCode(P)
.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
genCodeToFile(File, RS_Prog) :-
   open(File, write, Out),
   genCode(Out, RS_Prog),
   close(Out)
.
genCode(P) :- genCode(user_output, P)
.
genCode(Out, rsProg(L)) :- !,
    
    genCodeList(Out, L)
.
genCode(Out, trigger_block(T)) :- !,
    nl(Out),
    genCodeTrigger(Out, T)
.
genCode(Out, define_block(T)) :- !,
    nl(Out),
    genCodeDefine(Out, T)
.
genCode(Out, topic_block(T)) :- !,
    nl(Out),
    genCodeTopic(Out, T)
.
genCode(Out, response_block(T)) :- !,
    nl(Out),
    genCodeResponse(Out, T)
.

genCode(Out, comment_block(T)) :- !,
    nl(Out),
    genCodeComment(Out, T)
.

genCode(Out, word(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, asterisk(N)) :- !, format(Out, 'asterisk(~a)', [N])
.
genCode(Out, hash(N)) :- !, format(Out, 'hash(~a)', [N])
.
genCode(Out, underscore(N)) :- !, format(Out, 'underscore(~a)', [N])
.
genCode(Out, star(N)) :- !, format(Out, 'star(~a)', [N])
.
genCode(Out, array(M, id(N))) :- !, format(Out, 'array(~a, ~a)', [M, N])
.
genCode(Out, array(inline, N)) :- !, 
	format(Out, 'optionals(', []),
	genCodeList(Out, N, ','),
	format(Out, ')', [])
.
genCode(Out, bot(id(N))) :- !, format(Out, 'botVariable(~a)', [N])
.
genCode(Out, updateBotVariable(id(N), M)) :- !, 
	format(Out, 'updateBotVariable(~a, [', [N]),
	genCodeList(Out, M, ','),
	format(Out, '])', [])
.
genCode(Out, weight(N)) :- !, format(Out, 'weight(~a)', [N])
.
genCode(Out, formal(N)) :- !, 
	format(Out, 'formal([', []),
	genCodeList(Out, N, ','),
	format(Out, '])', [])
.
genCode(Out, get(id(N))) :- !, format(Out, 'variable(~a)', [N])
.
genCode(Out, set(id(N), star(M))) :- !, format(Out, 'variable(~a, star(~a))', [N, M])
.
genCode(Out, set(id(N), M)) :- !, 
	format(Out, 'variable(~a,', [N]),
	genCodeList(Out, [M], ','),
	format(Out, ')', [])
.

genCode(Out, trigger_topic(T, I, WL)) :- !,
     format(Out, 'trigger_topic(~a,~a, [', [T,I]),
     genCodeList(Out, WL, ','),
	 format(Out, ']).', []),
	 nl(Out)
.

genCode(Out, response_topic(T, I, WL)) :- !,
     format(Out, 'response_topic(~a,~a, [', [T,I]),
     genCodeList(Out, WL, ','),
	 format(Out, ']).', []),
	 nl(Out)
.

genCode(Out, comment_topic(N, V)) :- !,
     format(Out, 'comment(~a,[', [N]),
     genCodeList(Out, V, ','),
	 format(Out, ']).', []),
	 nl(Out)
.

genCode(Out, array(id(N))) :- !, format(Out, 'array(~a)', [N])
.
genCode(Out, input(N)) :- !, format(Out, 'input(~a)', [N])
.
genCode(Out, topic(N)) :- !, format(Out, 'topic(~a)', [N])
.

genCode(Out, optional(optional_asterisk(N))) :- !, format(Out, 'optional_asterisk(optional(~a))', [N])
.

genCode(Out, optional(optional_underscore(N))) :- !, format(Out, 'optional_underscore(optional(~a))', [N])
.

genCode(Out, optional(optional_hash(N))) :- !, format(Out, 'optional_hash(optional(~a))', [N])
.
genCode(Out, optional(word(N))) :- !, format(Out, 'optional("~a")', [N])
.
genCode(Out, num(N))  :- !, genCode(Out, atom(N))
.
genCode(Out, oper(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, oper(N)) :- !, genCode(Out, atom(N))
.

genCode(Out, atom(N)) :- !, format(Out, '"~a"', [N])
.
genCode(Out, comment(C)):-
     format(Out, '// ~a \n', [C])
.
%%%% Error case %%%%%%%%%%%%%%%%%%%%%%%%%%
genCode(Out, E ) :- close(Out),!,
                    throw(genCode('genCode unhandled Tree', E))
.

genCodeResponse(Out, response(I, WL)) :- !,
     format(Out, 'response(~a, [', [I]),
     genCodeList(Out, WL, ','),
	 format(Out, ']).', []),
     nl(Out)
.


genCodeResponse(Out, response_condition(M, formal(N), oper(O), bot(id(V)), WL)) :- !,
     format(Out, 'response_condition(~a,', [M]),
	 genCodeList(Out, [formal(N)], ','),
	 format(Out, ',~a,', [O]),
	 genCodeList(Out, [bot(id(V))], ','),
	 format(Out, ',[', []),
	 genCodeList(Out, WL, ','),
	 format(Out, ']).', []),
     nl(Out)
.

genCodeResponse(Out, response_condition(M, star(N), oper(O), word(V), WL)) :- !,
     format(Out, 'response_condition(~a,star(~a),~a,"~a",[', [M, N, O, V]),
     genCodeList(Out, WL, ','),
	 format(Out, ']).', []),
     nl(Out)
.

genCodeResponse(Out, response_condition(M, star(N), oper(O), num(V), WL)) :- !,
     format(Out, 'response_condition(~a,star(~a),~a,"~d",[', [M, N, O, V]),
     genCodeList(Out, WL, ','),
	 format(Out, ']).', []),
     nl(Out)
.

genCodeResponse(Out, response_condition(M, star(N), oper(O), input(V), WL)) :- !,
     format(Out, 'response_condition(~a,star(~a),~a,input(~a),[', [M, N, O, V]),
     genCodeList(Out, WL, ','),
	 format(Out, ']).', []),
     nl(Out)
.

genCodeResponse(Out, response_condition(M, get(id(N)), oper(O), word(V), WL)) :- !,
     format(Out, 'response_condition(~a,variable(~a),~a,"~a",[', [M, N, O, V]),
     genCodeList(Out, WL, ','),
	 format(Out, ']).', []),
     nl(Out)
.

genCodeResponse(Out, response_condition(M, get(id(N)), oper(O), num(V), WL)) :- !,
     format(Out, 'response_condition(~a,variable(~a),~a,"~d",[', [M, N, O, V]),
     genCodeList(Out, WL, ','),
	 format(Out, ']).', []),
     nl(Out)
.

genCodeResponse(Out, response_weight(M, WL, W)) :- !,
     format(Out, 'response_weight(~a, [', [M]),
     genCodeList(Out, WL, ','),
	 format(Out, '],', []),
	 genCodeList(Out, [W], ','),
	 format(Out, ').', []),
     nl(Out)
.


genCodeTrigger(Out, trigger(I, WL)) :- !,
     format(Out, 'trigger(~a, [', [I]),
     genCodeList(Out, WL, ','),
	 format(Out, ']).', []),
     nl(Out)
.

genCodeDefine(Out, var(B, V, WL)) :- !,
	B = bot,
     format(Out, 'botVariable(~a, [', [V]),
     genCodeList(Out, WL, ','),
	 format(Out, ']).', []),
     nl(Out)
.

genCodeDefine(Out, var(B, V)) :- !,
     format(Out, 'variable(~a,', [B]),
     genCodeList(Out, V, ','),
	 format(Out, ').', []),
     nl(Out)
.

genCodeDefine(Out, substitution(N, M)) :- !,
    format(Out, 'substitution([', []),
	genCodeList(Out, N, ','),
	format(Out, '], [', []),
	genCodeList(Out, M, ','),
	format(Out, ']).', []),
    nl(Out)
.

genCodeDefine(Out, array(id(N), M)) :- !,
     format(Out, 'array(~a,[', [N]),
	genCodeList(Out, M, ','),
	format(Out, ']).', []),
    nl(Out)
.

genCodeComment(Out, comment(V)) :- !,
     format(Out, 'comment(', []),
     genCodeList(Out, V, ','),
	 format(Out, ').', []),
     nl(Out)
.

show_records([]).
show_records([A|B]) :-
  writeln(A),
  show_records(B).

genCodeTopic(Out, V) :- !,
     genCodeList(Out, V),
     nl(Out)
.

genCodeList(Out, L) :- genCodeList(Out, L, '')
.
genCodeList(_, [], _).
genCodeList(Out, [C], _) :- genCode(Out, C).
genCodeList(Out, [X, Y | L], Sep) :- genCode(Out, X), 
                                     format(Out, '~a', [Sep]),
                                     genCodeList(Out, [Y | L], Sep)
.
