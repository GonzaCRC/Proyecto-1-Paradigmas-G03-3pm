:- module(rsTriggerSort, [striggers/1]).

read_file(Stream, Lines) :-
    read(Stream, Line),    
   (at_end_of_stream(Stream) -> Lines = [] ;  Lines = [Line|NewLines],  read_file(Stream, NewLines)).
	
striggers(File) :- 
	atom_concat('./riveRepository/', File, PathInFile),
    atom_concat(PathInFile, '.out', RSOutFile),
	open(RSOutFile, read, Str), read_file(Str, Lines), close(Str),assert(trigs([])),assert(others([])),
	save_triggers(Lines),sort_trigers,trigger_s(Ss),w_l(Ss,Ts),op_trigger(J2),w_l(J2,JJ2),append(Ts,JJ2,MM),trigger_w(Sw),w_l(Sw,Tw),
	append(MM,Tw,Tf), o_trigger(Vv),w_l(Vv,Mn),append(Tf,Mn,TT),others(O), append(TT,O,JJ),
	retractall(o_trigger(_)),retractall(others(_)),retractall(trigs(_)),retractall(trigger_w(_)),retractall(trigger_s(_)),
	retractall(s_trigger_w(_)),retractall(only_trigger_w(_)),retractall(op_trigger(_)),retractall(s_trigger_o(_)),

	open(RSOutFile,write, OverW),
    forall(member(X,JJ),(write(OverW,X),write(OverW,'.'),write(OverW,'\n'),write(OverW,'\n'))),
    close(OverW),
	!
.



save_triggers([]).

save_triggers([X|L]):- 
	(X = trigger(_,_) , trigs(M), append(M,[X],B) , retract(trigs(_)) , assert(trigs(B)), save_triggers(L) ; 
	others(O), append(O,[X],K) , retract(others(_)) , assert(others(K)),save_triggers(L)).

																
sort_trigers :- 
	trigs(X),
	assert(trigger_s([trigger(_,[])])),
	assert(trigger_w([trigger(_,[])])),
	assert(o_trigger([trigger(_,[asterisk(_)])])),
	assert(op_trigger([trigger(_,[asterisk(_)])])),
	assert(s_trigger_w([])),
	assert(only_trigger_w([])),
	assert(s_trigger_o([])),
	sort_trigers_s(X),
	s_trigger_o(G),
	sort_trigers_op(G),
	s_trigger_w(D),
	sort_trigers_w(D),
	only_trigger_w(Ow),
	sort_trigers_only_w(Ow)
	
.
	

sort_trigers_s([]).
sort_trigers_s([X|L]) :- 
	X = trigger(_,L1), 
	trigger_s(J),
	(
	only_wildcard(L1),only_trigger_w(T), append([X],T,F),retractall(only_trigger_w(_)),assert(only_trigger_w(F)),sort_trigers_s(L);
	contain_opcional(L1), s_trigger_o(T),append([X],T,F),retractall(s_trigger_o(_)),assert(s_trigger_o(F)),sort_trigers_s(L);
	contain_wildcard(L1),s_trigger_w(T), append([X],T,F),retractall(s_trigger_w(_)),assert(s_trigger_w(F)),sort_trigers_s(L);
	special(J,X,0,I),
	insertAt(X,I,J,J2),
	retractall(trigger_s(_)),
	assert(trigger_s(J2)),
	sort_trigers_s(L)
	)
.

sort_trigers_w([]) :- !.
sort_trigers_w([X|L]) :- 
	trigger_w(J),
	special_w(J,X,0,I),
	insertAt(X,I,J,J2),
	retractall(trigger_w(_)),
	assert(trigger_w(J2)),
	sort_trigers_w(L)
.

sort_trigers_only_w([]).
sort_trigers_only_w([X|L]) :- 
	o_trigger(J),
	special_only_w(J,X,0,I),
	insertAt(X,I,J,J2),
	retractall(o_trigger(_)),
	assert(o_trigger(J2)),
	sort_trigers_only_w(L)
.


sort_trigers_op([]).
sort_trigers_op([X|L]) :- 
	op_trigger(J),
    special_op(J,X,0,I),
	insertAt(X,I,J,J2),
	retractall(op_trigger(_)),
	assert(op_trigger(J2)),
	sort_trigers_op(L)
.


insertAt(Element,0,L,[Element|L]). 
insertAt(Element,Pos,[E|L],[E|ZL]):- 
    Pos1 is Pos-1,
    insertAt(Element,Pos1,L,ZL)
. 
	
special([],_,_,_).
special([T1|L],T,N,I):- 
	T1 = trigger(_,L1), 
	T = trigger(_,L2),
	length(L1,Le1), 
	length(L2,Le2),
	(
	 Le2>Le1, I = N ;  
	 Le2=Le1, atomics_to_string(L1," ",L1s), atomics_to_string(L2," ",L2s),string_length(L1s,Xl), string_length(L2s,Pl),
	 (
	   Pl>Xl,I = N;
	   Pl=Xl, compare(W, L1s,L2s), W = (>),I = N
	 );
	 N1 = N+1, special(L,T,N1,I)
	)
.


special_op([],_,_,_).
special_op([T1|L],T,N,I):- 
	T1 = trigger(_,Y1), 
	T = trigger(_,Y2),
	string_list(Y1,[],L1),
	string_list(Y2,[],L2),
	length(L1,Le1), 
	length(L2,Le2),
	(
	 Le2>Le1, I = N ;  
	 Le2=Le1, atomics_to_string(L1," ",L1s), atomics_to_string(L2," ",L2s),string_length(L1s,Xl), string_length(L2s,Pl),
	 (
	   Pl>Xl,I = N;
	   Pl=Xl, compare(W, L1s,L2s), (L1s= "",L2s = "", I = N ;W = (>),I = N)
	 );
	 N1 = N+1, special_op(L,T,N1,I)
	)
.

special_w([],_,_,_).
special_w([T1|L],T,N,I):- 
	T1 = trigger(_,Y1), 
	T = trigger(_,Y2),
	string_list(Y1,[],L1),
	string_list(Y2,[],L2),
	length(L1,Le1), 
	length(L2,Le2),
	(
	 Le2>Le1, I = N ;  
	 Le2=Le1, atomics_to_string(L1," ",L1s), atomics_to_string(L2," ",L2s),string_length(L1s,Xl), string_length(L2s,Pl),
	 (
	   Pl>Xl,I = N;
	   Pl=Xl, compare(W, L1s,L2s), (L1s= "",L2s = "", I = N ;W = (>),I = N)
	 );
	 N1 = N+1, special_w(L,T,N1,I)
	)
.


special_only_w([],_,_,_).
special_only_w([T1|L],T,N,I):- 
	T1 = trigger(_,[Y1|_]), 
	T = trigger(_,[Y2|_]),
	(
	 Y2 = [], I = N;
	 Y2 = asterisk(_), Y1 = asterisk(_), I = N ;
	 Y2 = underscore(_), Y1 = asterisk(_), I = N;
	 Y2 = hash(_), Y1 = asterisk(_), I = N;
	 
	 Y2 = asterisk(_), Y1 = underscore(_), N1 = N+1, writeln(L),special_only_w(L,T,N1,I);
	 Y2 = underscore(_), Y1 = underscore(_), I = N;
	 Y2 = hash(_), Y1 = underscore(_), N1 = N+1, special_only_w(L,T,N1,I);
	 
	 Y2 = asterisk(_), Y1 = hash(_), N1 = N+1, special_only_w(L,T,N1,I);
	 Y2 = underscore(_), Y1 = hash(_), I = N;
	 Y2 = hash(_), Y1 = hash(_), I = N;
	 N1 = N+1, special_only_w(L,T,N1,I)
	)
.

string_list([],V,V).
string_list([X|L],V,A) :- 
	(
	string(X), append(V,[X],B), string_list(L,B,A);
	string_list(L,V,A)
	),
	!.
	
contain_wildcard([]) :- false.
contain_wildcard([X|_]) :- X = asterisk(_), !.
contain_wildcard([X|_]) :- X = hash(_), !.
contain_wildcard([X|_]) :- X = underscore(_), !.
contain_wildcard([_|L]) :- contain_wildcard(L).

contain_opcional([]) :- false.
contain_opcional([X|_]) :- X = optionals(_), !.
contain_opcional([X|_]) :- X = optional_asterisk(_), !.
contain_opcional([_|L]) :- contain_opcional(L).

only_wildcard([X|Y]) :- X = asterisk(_),(Y = [weight(_)];Y = []), !.
only_wildcard([X|Y]) :- X = hash(_), (Y = [weight(_)];Y = []), !.
only_wildcard([X|Y]) :- X = underscore(_), (Y = [weight(_)];Y = []), !.
only_wildcard([_]) :- false.

w_l([X|Xs], Ys) :-                 
   w_l_a(Xs, Ys, X).            

w_l_a([], [], _).
w_l_a([X1|Xs], [X0|Ys], X0) :-  
   w_l_a(Xs, Ys, X1).         

