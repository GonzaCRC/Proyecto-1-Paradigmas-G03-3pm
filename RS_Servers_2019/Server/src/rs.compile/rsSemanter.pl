/*
Creadores:
Erick Vargas Arias 
Esteban Zúñiga Cruz
Gonzalo Gonzalez Garro
Gabriel Araya Ruiz

Colaboradores:
Carlos Loría Saenz
EIF400 loriacarlos@gmail.com
*/

:- module(rsSemanter, [chSeman/1]).

read_file(Stream, Lines) :-
    read(Stream, Line),    
   (at_end_of_stream(Stream) -> Lines = [] ;  Lines = [Line|NewLines],  read_file(Stream, NewLines)).
	
chSeman(File) :- 
	atom_concat('./riveRepository/', File, PathInFile),
    atom_concat(PathInFile, '.out', RSOutFile),
	open(RSOutFile, read, Str), read_file(Str, Lines), close(Str),assert(vars([])),assert(dinamic_vars([])),assert(aux([])),save_vars(Lines),
	compare_wl(Lines),!
.
		
save_vars([]).	
save_vars([X|L]) :- 
	(X = botVariable(B, _), vars(V), append([B],V,O), retractall(vars(_)), assert(vars(O)), save_vars(L);
	(X = response(_,D);X = response_condition(_,_,_,_,D)),dinamic_vars(V), cond_var(D,[],K), K \= [] ,append(K,V,O), retractall(dinamic_vars(_)), assert(dinamic_vars(O)), save_vars(L);
	X = array(B, _), vars(V), append([B],V,O), retractall(vars(_)), assert(vars(O)), save_vars(L);
	save_vars(L))
.

%((V = variable(Val),Z = botVariable(Val2);Z = variable(Val), V = botVariable(Val2);Z = variable(Val), V = variable(Val2);Z = botVariable(Val), V = botVariable(Val2)),
%(sublist([Val],Var),sublist([Val2],Var)   ;throw(semanticError('One or more variables or <stars> calls does not exist on the rive', X))),compare_wl(L);

compare_wl([]).
compare_wl([X|L]) :- 
	(aux(M),M \= [],X = trigger(_,_),retractall(aux(_)), assert(aux([]));
	 true),
	(aux(V),V = [] ,X = trigger(_,U),verify_trigs(U),trigs_v(U,[],UU),append(UU,V,O), retractall(aux(_)), assert(aux(O)),compare_wl(L); 
	X = response(_,T),resp_v(T,[],TT),(verify(TT),compare_wl(L);throw(semanticError('One or more variables or <stars> calls does not exist on the rive', X)));
	X = response_condition(_,V,_,Z,K),vars(Var),dinamic_vars(DV),
	((V = variable(Val),sublist([Val],DV);V = botVariable(Val),sublist([Val],Var);Z = variable(Val),sublist([Val],DV);Z = botVariable(Val),sublist([Val],Var);
	V = star(Val),aux(Vtt) ,sublist([Val],Vtt));
	throw(semanticError('One or more variables or <stars> calls does not exist on the rive', X)))
	,resp_v(K,[],TT),(verify(TT),compare_wl(L);throw(semanticError('undetermined error',X)));
	compare_wl(L))
.
 
verify([]).
verify([X|L]) :- 
	(X = variable(Val), dinamic_vars(S),sublist([Val],S),verify(L);
	 X = botVariable(Val),vars(S),sublist([Val],S),verify(L);
	 X = star(Val),aux(H) ,sublist([Val],H),verify(L); 
	 false),!.
	
verify_trigs([]).
verify_trigs([X|L]) :- 
	((X = array(Val); X = array(_,Val)),vars(S),(sublist([Val],S),verify_trigs(L);throw(semanticError('One or more array calls does not exist on the rive', X)));
	  verify_trigs(L)),!.
	  
	 
	
sublist([],_).
sublist([X|Xs],Y) :- member(X,Y) , sublist(Xs,Y),!.

trigs_v([],V,V).
trigs_v([X|L],V,A) :- 
	((X = asterisk(Val);X = hash(Val);X = underscore(Val);X = array(Val,_)), append(V,[Val],B), trigs_v(L,B,A);
	trigs_v(L,V,A)),!.
	
resp_v([],V,V).
resp_v([X|L],V,A) :- 
	((X = variable(_);X = star(_);X = botVariable(_)), append(V,[X],B), resp_v(L,B,A);
	resp_v(L,V,A)),!.
	
cond_var([],V,V).
cond_var([X|L],V,A) :- 
	((X = variable(Y,_);X = botVariable(Y,_)), append(V,[Y],B), cond_var(L,B,A);
	cond_var(L,V,A)),!.

