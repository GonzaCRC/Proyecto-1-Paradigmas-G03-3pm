:- module(rsTriggerSort, [sortTriggers/1]).

read_file(Stream, Lines) :-
    read(Stream, Line),    
   (at_end_of_stream(Stream) -> Lines = [] ;  Lines = [Line|NewLines],  read_file(Stream, NewLines)).
	
sortTriggers(File) :- 
	atom_concat('./riveRepository/', File, PathInFile),
    atom_concat(PathInFile, '.out', RSOutFile),
	open(RSOutFile, read, Str), read_file(Str, Lines), close(Str),assert(trigs([])),assert(others([])),
	save_triggers(Lines),sort_trigers,trigger_s(Ss),list_without_last_element(Ss,Ts),op_trigger(J2),list_without_last_element(J2,JJ2),append(Ts,JJ2,MM),trigger_w(Sw),list_without_last_element(Sw,Tw),
	append(MM,Tw,Tf), o_trigger(Vv),list_without_last_element(Vv,Mn),append(Tf,Mn,TT),others(O), append(TT,O,JJ),
	retractall(o_trigger(_)),retractall(others(_)),retractall(trigger_w(_)),retractall(trigger_s(_)),retractall(trigs(_)),
	retractall(s_trigger_w(_)),retractall(only_trigger_w(_)),retractall(op_trigger(_)),retractall(s_trigger_o(_)),
	open(RSOutFile,write, OverW),
    forall(member(X,JJ),(write_canonical(OverW,X),write(OverW,'.'),write(OverW,'\n'),write(OverW,'\n'))),
    close(OverW),
	!
.

save_triggers([]).
save_triggers([X|L]):- 
	(X = trigger(_,_) , trigs(M), append(M,[X],B) , retract(trigs(_)) , assert(trigs(B)), save_triggers(L) ; 
	others(O), append(O,[X],K) , retract(others(_)) , assert(others(K)),save_triggers(L))
.

sort_trigers :- 
	trigs(X),
	assert(trigger_s([trigger(_,[])])),
	assert(trigger_w([trigger(_,[])])),
	assert(o_trigger([trigger(_,[asterisk(_)])])),
	assert(op_trigger([trigger(_,[asterisk(_)])])),
	assert(s_trigger_w([])),
	assert(only_trigger_w([])),
	assert(s_trigger_o([])),
	sort_triggers_atomics(X),
	s_trigger_o(G),
	sort_triggers_opcionals(G),
	s_trigger_w(D),
	sort_triggers_wildcards(D),
	only_trigger_w(Ow),
	sort_triggers_only_wildcard(Ow)
.
	

sort_triggers_atomics([]).
sort_triggers_atomics([X|L]) :- 
	X = trigger(_,L1), 
	trigger_s(J),
	(contain_only_wildcard(L1),only_trigger_w(T), append([X],T,F),retractall(only_trigger_w(_)),assert(only_trigger_w(F)),sort_triggers_atomics(L);
	contain_opcional(L1), s_trigger_o(T),append([X],T,F),retractall(s_trigger_o(_)),assert(s_trigger_o(F)),sort_triggers_atomics(L);
	contain_wildcard(L1),s_trigger_w(T), append([X],T,F),retractall(s_trigger_w(_)),assert(s_trigger_w(F)),sort_triggers_atomics(L);
	index_atomic_trigger_priority(J,X,0,I),
	insert_at_index(X,I,J,J2),
	retractall(trigger_s(_)),
	assert(trigger_s(J2)),
	sort_triggers_atomics(L))
.

sort_triggers_wildcards([]) :- !.
sort_triggers_wildcards([X|L]) :- 
	trigger_w(J),
	index_wildcards_trigger_priority(J,X,0,I),
	insert_at_index(X,I,J,J2),
	retractall(trigger_w(_)),
	assert(trigger_w(J2)),
	sort_triggers_wildcards(L)
.

sort_triggers_only_wildcard([]).
sort_triggers_only_wildcard([X|L]) :- 
	o_trigger(J),
	index_only_wildcards_trigger_priority(J,X,0,I),
	insert_at_index(X,I,J,J2),
	retractall(o_trigger(_)),
	assert(o_trigger(J2)),
	sort_triggers_only_wildcard(L)
.

sort_triggers_opcionals([]).
sort_triggers_opcionals([X|L]) :- 
	op_trigger(J),
    index_opcional_trigger_priority(J,X,0,I),
	insert_at_index(X,I,J,J2),
	retractall(op_trigger(_)),
	assert(op_trigger(J2)),
	sort_triggers_opcionals(L)
.

insert_at_index(Element,0,L,[Element|L]). 
insert_at_index(Element,Pos,[E|L],[E|ZL]):- 
    Pos1 is Pos-1,
    insert_at_index(Element,Pos1,L,ZL)
. 
	
index_atomic_trigger_priority([],_,_,_).
index_atomic_trigger_priority([T1|L],T,N,I):- 
	T1 = trigger(_,L1), 
	T = trigger(_,L2),
	length(L1,Le1), 
	length(L2,Le2),
	(Le2>Le1, I = N ;  
	 Le2=Le1, atomics_to_string(L1," ",L1s), atomics_to_string(L2," ",L2s),string_length(L1s,Xl), string_length(L2s,Pl),
	 (Pl>Xl,I = N;
	 Pl=Xl, compare(W, L1s,L2s), W = (>),I = N,
	 W = (=),I = N);
	 N1 = N+1, index_atomic_trigger_priority(L,T,N1,I))
.

index_opcional_trigger_priority([],_,_,_).
index_opcional_trigger_priority([T1|L],T,N,I):- 
	T1 = trigger(_,Y1), 
	T = trigger(_,Y2),
	list_only_words(Y1,[],L1),
	list_only_words(Y2,[],L2),
	length(L1,Le1), 
	length(L2,Le2),
	(Le2>Le1, I = N ;  
	 Le2=Le1, atomics_to_string(L1," ",L1s), atomics_to_string(L2," ",L2s),string_length(L1s,Xl), string_length(L2s,Pl),
	 (Pl>Xl,I = N;
	 Pl=Xl, compare(W, L1s,L2s), (L1s= "",L2s = "", I = N ;W = (>),I = N ;find_opcional(Y1,R1),find_opcional(Y2,R2),R1>=R2, I = N));
	 N1 = N+1, index_opcional_trigger_priority(L,T,N1,I))
.

index_wildcards_trigger_priority([],_,_,_).
index_wildcards_trigger_priority([T1|L],T,N,I):- 
	T1 = trigger(_,Y1), 
	T = trigger(_,Y2),
	list_only_words(Y1,[],L1),
	list_only_words(Y2,[],L2),
	length(L1,Le1), 
	length(L2,Le2),
	(Le2>Le1, I = N ;  
	 Le2=Le1, atomics_to_string(L1," ",L1s), atomics_to_string(L2," ",L2s),string_length(L1s,Xl), string_length(L2s,Pl),
	 (Pl>Xl,I = N;
	 Pl=Xl, compare(W, L1s,L2s), (L1s= "",L2s = "", I = N ;W = (>),I = N; find_wildcard(Y1,R1),find_wildcard(Y2,R2),R1>=R2, I = N ));
	 N1 = N+1, index_wildcards_trigger_priority(L,T,N1,I))
.

index_only_wildcards_trigger_priority([],_,_,_).
index_only_wildcards_trigger_priority([T1|L],T,N,I):- 
	T1 = trigger(_,[Y1|_]), 
	T = trigger(_,[Y2|_]),
	(Y2 = [], I = N;
	 Y2 = asterisk(_), Y1 = asterisk(_), I = N ;
	 Y2 = underscore(_), Y1 = asterisk(_), I = N;
	 Y2 = hash(_), Y1 = asterisk(_), I = N;
	 Y2 = asterisk(_), Y1 = underscore(_), N1 = N+1, writeln(L),index_only_wildcards_trigger_priority(L,T,N1,I);
	 Y2 = underscore(_), Y1 = underscore(_), I = N;
	 Y2 = hash(_), Y1 = underscore(_), N1 = N+1, index_only_wildcards_trigger_priority(L,T,N1,I);
	 Y2 = asterisk(_), Y1 = hash(_), N1 = N+1, index_only_wildcards_trigger_priority(L,T,N1,I);
	 Y2 = underscore(_), Y1 = hash(_), I = N;
	 Y2 = hash(_), Y1 = hash(_), I = N;
	 N1 = N+1, index_only_wildcards_trigger_priority(L,T,N1,I))
.

list_only_words([],V,V).
list_only_words([X|L],V,A) :- 
	(string(X), append(V,[X],B), list_only_words(L,B,A);
	list_only_words(L,V,A)),!.
	
contain_wildcard([]) :- false.
contain_wildcard([X|_]) :- X = asterisk(_), !.
contain_wildcard([X|_]) :- X = hash(_), !.
contain_wildcard([X|_]) :- X = underscore(_), !.
contain_wildcard([_|L]) :- contain_wildcard(L).

contain_opcional([]) :- false.
contain_opcional([X|_]) :- X = optionals(_), !.
contain_opcional([X|_]) :- X = optional_hash(_), !.
contain_opcional([X|_]) :- X = optional_underscore(_), !.
contain_opcional([X|_]) :- X = optional_asterisk(_), !.
contain_opcional([_|L]) :- contain_opcional(L).

contain_only_wildcard([X|Y]) :- X = asterisk(_),(Y = [weight(_)];Y = []), !.
contain_only_wildcard([X|Y]) :- X = hash(_), (Y = [weight(_)];Y = []), !.
contain_only_wildcard([X|Y]) :- X = underscore(_), (Y = [weight(_)];Y = []), !.
contain_only_wildcard([_]) :- false.

list_without_last_element([X|Xs], Ys) :- list_without_last_element_aux(Xs, Ys, X).            

list_without_last_element_aux([], [], _).
list_without_last_element_aux([X1|Xs], [X0|Ys], X0) :- list_without_last_element_aux(Xs, Ys, X1).       

find_opcional([],_) :- false.
find_opcional([X|_],N) :- X = optionals(_),N is 0,!.
find_opcional([X|_],N) :- X = optional_hash(_), N is 2,!.
find_opcional([X|_],N) :- X = optional_underscore(_), N is 1,!.
find_opcional([X|_],N) :- X = optional_asterisk(_), N is 3,!.
find_opcional([_|L],N) :- find_opcional(L,N).

find_wildcard([],_) :- false.
find_wildcard([X|_],N) :- X = asterisk(_),N is 3,!.
find_wildcard([X|_],N) :- X = hash(_), N is 2,!.
find_wildcard([X|_],N) :- X = underscore(_), N is 1,!.
find_wildcard([_|L],N) :- find_wildcard(L,N).

