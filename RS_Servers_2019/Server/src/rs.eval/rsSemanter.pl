read_file(Stream, Lines) :-
    read(Stream, Line),    
   (at_end_of_stream(Stream) -> Lines = [] ;  Lines = [Line|NewLines],  read_file(Stream, NewLines)).
	
chSeman(File) :- 
	atom_concat('../../riveRepository/', File, PathInFile),
    atom_concat(PathInFile, '.rive.out', RSOutFile),
	open(RSOutFile, read, Str), read_file(Str, Lines), close(Str),assert(vars([])),assert(aux([])),save_vars(Lines),
	compare_wl(Lines),
	!
.
	
save_vars([]).	
save_vars([X|L]) :- 
	(
	X = botVariable(B, _), vars(V), append([B],V,O), retractall(vars(_)), assert(vars(O)), save_vars(L);
	X = response(_,D),vars(V), cond_var(D,[],K), K \= [] ,writeln(K),append(K,V,O), retractall(vars(_)), assert(vars(O)), save_vars(L);
	save_vars(L)
	)
.

compare_wl([]).
compare_wl([X|L]) :- 
	(
	 aux(M),M \= [],X = trigger(_,_),writeln(M),retractall(aux(_)), assert(aux([]));
	 true
	),
	(
	aux(V),V = [] ,X = trigger(_,U),trigs_v(U,[],UU),append(UU,V,O), retractall(aux(_)), assert(aux(O)),writeln('1'),compare_wl(L); 
	X = response(_,T),writeln(T),resp_v(T,[],TT),(verify(TT),compare_wl(L),writeln('3'); writeln('fail44'),!,fail);
	compare_wl(L)
	)
.

%trigger(2, [asterisk(1),hash(2)])

%response(2, [variable(name),star(1),star(3),variable(cosi)])

verify([]).
verify([X|L]) :- 
	(
	 X = variable(Val), vars(S), writeln(Val),sublist([Val],S),writeln(Val),verify(L);
	 X = star(Val),aux(H),writeln('star') ,sublist([Val],H),verify(L); 
	 false
	),
	!.
	
sublist([],_).
sublist([X|Xs],Y) :- member(X,Y) , sublist(Xs,Y),!.

trigs_v([],V,V).
trigs_v([X|L],V,A) :- 
	(
	(X = asterisk(Val);X = hash(Val);X = underscore(Val)), append(V,[Val],B), trigs_v(L,B,A);
	trigs_v(L,V,A)
	),
	!.
	
resp_v([],V,V).
resp_v([X|L],V,A) :- 
	(
	(X = variable(_);X = star(_)), append(V,[X],B), resp_v(L,B,A);
	resp_v(L,V,A)
	),
	!.
cond_var([],V,V).
cond_var([X|L],V,A) :- 
	(
	X = variable(Y,_), append(V,[Y],B), cond_var(L,B,A);
	cond_var(L,V,A)
	),
	!.

