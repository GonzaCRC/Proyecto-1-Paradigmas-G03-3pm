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

:- module(rsSemanter, [checkSemantic/1]).

%read_file(+Stream, -Lines)
read_file(Stream, Lines) :-
    read(Stream, Line),    
   (at_end_of_stream(Stream) -> Lines = [] ;  Lines = [Line|NewLines],  read_file(Stream, NewLines)).
	
%checkSemantic(+File)
checkSemantic(File) :- 
	atom_concat('./riveRepository/', File, PathInFile),
    atom_concat(PathInFile, '.out', RSOutFile),
	open(RSOutFile, read, Str), read_file(Str, Lines), close(Str),assert(vars([])),assert(dinamic_vars([])),assert(aux([])),save_bot_user_variables(Lines),
	verify_semantic(Lines),retractall(vars(_)),retractall(dinamic_vars(_)), retractall(aux(_)),!
.
	
%save_bot_user_variables(+List)	
save_bot_user_variables([]).	
save_bot_user_variables([X|L]) :- 
	(X = botVariable(B, _), vars(V), append([B],V,O), retractall(vars(_)), assert(vars(O)), save_bot_user_variables(L);
	(X = response(_,D);X = response_condition(_,_,_,_,D)),dinamic_vars(V), response_set_variables_list(D,[],K), K \= [] ,append(K,V,O), retractall(dinamic_vars(_)), assert(dinamic_vars(O)), save_bot_user_variables(L);
	X = array(B, _), vars(V), append([B],V,O), retractall(vars(_)), assert(vars(O)), save_bot_user_variables(L);
	save_bot_user_variables(L))
.

%verify_semantic(+List)
verify_semantic([]).
verify_semantic([X|L]) :- 
	(aux(M),M \= [],X = trigger(_,_),retractall(aux(_)), assert(aux([]));
	 true),
	(aux(V),V = [] ,X = trigger(_,U),verify_valid_arrays(U),trigger_id_keywords_list(U,[],UU),append(UU,V,O), retractall(aux(_)), assert(aux(O)),verify_semantic(L); 
	X = response(_,T),response_id_keywords_list(T,[],TT),(verify_valid_variables(TT),verify_semantic(L);throw(semanticError('One or more variables or <stars> calls does not exist on the rive', X)));
	X = response_condition(_,V,_,Z,K),vars(Var),dinamic_vars(DV),
	((V = variable(Val),element_in_list([Val],DV);V = botVariable(Val),element_in_list([Val],Var);Z = variable(Val),element_in_list([Val],DV);Z = botVariable(Val),element_in_list([Val],Var);
	V = star(Val),aux(Vtt) ,element_in_list([Val],Vtt));
	throw(semanticError('One or more variables or <stars> calls does not exist on the rive', X)))
	,response_id_keywords_list(K,[],TT),(verify_valid_variables(TT),verify_semantic(L);throw(semanticError('undetermined error',X)));
	verify_semantic(L))
.
 
%verify_valid_variables(+List).
verify_valid_variables([]).
verify_valid_variables([X|L]) :- 
	(X = variable(Val), dinamic_vars(S),element_in_list([Val],S),verify_valid_variables(L);
	 X = botVariable(Val),vars(S),element_in_list([Val],S),verify_valid_variables(L);
	 X = star(Val),aux(H) ,element_in_list([Val],H),verify_valid_variables(L); 
	 false),!.
	
%verify_valid_arrays(+List).
verify_valid_arrays([]).
verify_valid_arrays([X|L]) :- 
	((X = array(Val); X = array(_,Val)),vars(S),(element_in_list([Val],S),verify_valid_arrays(L);throw(semanticError('One or more array calls does not exist on the rive', X)));
	  verify_valid_arrays(L)),!.
	  
	 
%element_in_list(+List, +List)
element_in_list([],_).
element_in_list([X|Xs],Y) :- member(X,Y) , element_in_list(Xs,Y),!.

%trigger_id_keywords_list(+List,+List2,-List3).
trigger_id_keywords_list([],V,V).
trigger_id_keywords_list([X|L],V,A) :- 
	((X = asterisk(Val);X = hash(Val);X = underscore(Val);X = array(Val,_)), append(V,[Val],B), trigger_id_keywords_list(L,B,A);
	trigger_id_keywords_list(L,V,A)),!.
	
%response_id_keywords_list(+List,+List2,-List3).
response_id_keywords_list([],V,V).
response_id_keywords_list([X|L],V,A) :- 
	((X = variable(_);X = star(_);X = botVariable(_)), append(V,[X],B), response_id_keywords_list(L,B,A);
	response_id_keywords_list(L,V,A)),!.
	
%response_set_variables_list(+List,+List2,-List3).
response_set_variables_list([],V,V).
response_set_variables_list([X|L],V,A) :- 
	((X = variable(Y,_);X = botVariable(Y,_)), append(V,[Y],B), response_set_variables_list(L,B,A);
	response_set_variables_list(L,V,A)),!.

