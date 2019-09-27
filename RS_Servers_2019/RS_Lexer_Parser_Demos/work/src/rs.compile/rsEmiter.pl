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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
genCodeToFile(File, RS_Prog) :-
   writeln(RS_Prog  ),nl,
   open(File, write, Out),
   genCode(Out, RS_Prog),
   close(Out)
.
genCode(P) :- genCode(user_output, P)
.
genCode(Out, rsProg(L)) :- !,
    get_time(TS), 
    format_time(atom(T), '*** Rive Program *** : Generated at: %d/%m/%y %H:%M:%S', TS),
    
    genCode(Out, comment(T)), 
    
    genCodeList(Out, L)
.
genCode(Out, trigger_block(T)) :- !,
    nl(Out),
    genCode(Out, comment('>>> Trigger Block')),
    genCodeTrigger(Out, T)
.

genCode(Out, response_block(T)) :- !,
    nl(Out),
    genCode(Out, comment('>>> Response Block')),
    genCodeResponse(Out, T)
.

genCode(Out, word(N)) :- !, genCode(Out, atom(N))
.

genCode(Out, weight(N)) :- !, genCodeWeight(Out, atom(N))
.

genCode(Out, hash(_)) :- !, genCodeHash(Out, atom(_))
.

genCode(Out, star(_)) :- !, genCodeStar(Out, atom(_))
.

genCode(Out, id(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, num(N))  :- !, genCode(Out, atom(N))
.
genCode(Out, oper(N)) :- !, genCode(Out, atom(N))
.
genCode(Out, set(I, E)) :-  !,
   genCode(Out, operation(oper('='), I, E))
   
.
% Internal Representations
genCode(Out, operation(O, L, R)) :- !,
    genCodeList(Out, [L, O, R])
.

genCode(Out, atom(N)) :- !, format(Out, '~a ', [N])
.

genCode(Out, comment(C)):-
     format(Out, '// ~a \n', [C])
.
%%%% Error case %%%%%%%%%%%%%%%%%%%%%%%%%%
genCode(Out, E ) :- close(Out),!,
                    throw(genCode('genCode unhandled Tree', E))
.

genCodeWeight(Out, atom(N)) :- !, format(Out, '{weight=~d} ', [N])
.

genCodeHash(Out, atom(_)) :- !, format(Out, '# ', [])
.

genCodeStar(Out, atom(_)) :- !, format(Out, '* ', [])
.

genCodeResponse(Out, trigger(WL)) :- !,
     format(Out, '- ', []),
     genCodeList(Out, WL),
     nl(Out)
.

genCodeTrigger(Out, trigger(WL)) :- !,
     format(Out, '+ ', []),
     genCodeList(Out, WL),
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
