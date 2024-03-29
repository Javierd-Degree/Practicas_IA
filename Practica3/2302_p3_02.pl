% Ejercicio 1

duplica([], []).
duplica([X|T], [X, X|L]):-duplica(T, L).

% Ejercicio 2


concatena([], L, L).
concatena([X|L1], L2, [X|L3]):-concatena(L1, L2, L3).

invierte([], []).
invierte([H|T],L):-invierte(T,R),concatena(R,[H],L).


% Ejercicio 3

%Basta con llamar a función *invierte* creada anteriormente. La copiamos de nuevo pues, al estar en otro cuadro de programa, swish-prolog no lo detecta.
%Si se llama con una variable no instanciada, genera la lista vacía, pero pulsando los botones *Next*, *10*, *100*... que aparecen, se muestran nuevos ejemplos con listas que incluyes posiciones de memoria, que son palíndromos. En nuestro ejemplo, generando 10 más:


%X = []
%X = [_1164]
%X = [_1192, _1192]
%X = [_1226, _1232, _1226]
%X = [_1266, _1272, _1272, _1266]
%X = [_1312, _1318, _1324, _1318, _1312]
%X = [_1364, _1370, _1376, _1376, _1370, _1364]
%X = [_1422, _1428, _1434, _1440, _1434, _1428, _1422]
%X = [_1486, _1492, _1498, _1504, _1504, _1498, _1492, _1486]
%X = [_832, _838, _844, _850, _856, _850, _844, _838, _832]
%X = [_908, _914, _920, _926, _932, _932, _926, _920, _914, _908]



concatena([], L, L).
concatena([X|L1], L2, [X|L3]):-concatena(L1, L2, L3).

invierte([], []).
invierte([H|T],L):-invierte(T,R),concatena(R,[H],L).

palindromo(L):-invierte(L, L).


% Ejercicio 4

concatena([], L, L).
concatena([X|L1], L2, [X|L3]):-concatena(L1, L2, L3).

divide([X|T],1,[X],T).
divide([X|T],N,L1,L2):-
	N2 is N-1,
	divide(T, N2, H, L2),
	concatena([X], H, L1).


% Ejercicio 5

aplasta([], []) :- !.
aplasta([X|T], Res) :-
    !,
    aplasta(X, L1),
    aplasta(T, L2),
    append(L1, L2, Res).
aplasta(L, [L]).



% Ejercicio 6

%Ejemplos:
%next_factor(5, 2, NF) 3, el caso base
%next_factor(2, 5, NF) FALSE porque 5 &lt; sqrt(2)
%next_factor(2, 1, NF) 3
%next_factor(25, 3, NF) 5
%next_factor(25, 5, NF) false

%primos(1, []) true, el caso base
%primos(4, [2, 2]) true
%primos(4, [2, 3]) false
%primos(63, [3, 3, 7]) true
%primos(63, [3, 3, 8]) false
%primos(63, L) [3, 3, 7]
%primos(4, L) [2, 2]

next_factor(_, 2, 3) :- !.
next_factor(N, F, NF):- 
	F < sqrt(N), 
	NF is F + 2,
	!.
next_factor(N, F, N):- F < N.

primos_aux(1, [], _).
primos_aux(N, [F|T], F) :-
   	0 is mod(N, F),
    Nn is N/F,
    primos_aux(Nn, T, F), 
    !.

primos_aux(N, L, F) :-
   	0\= mod(N, F),
    next_factor(N, F, Fn),
    primos_aux(N, L, Fn).

primos(1, []) :- !.
primos(N, L) :-
    primos_aux(N, L, 2).


% Ejercicio 7
% Apartado 7.1
cod_primero(X, [], [], [X]).
cod_primero(X, [Y|T], [Y|T], [X]) :-
    Y\=X.

cod_primero(X, [X|T], Lrem, [X|Lfront]) :-
    !,
    cod_primero(X, T, Lrem, Lfront).

% Apartado 7.2
cod_all([], []).
cod_all([X|T], [Y|Lfront]):-
    cod_primero(X, T, Lrem, Y),
    cod_all(Lrem, Lfront).

primero([], []).
primero([X|_], X).

% Apartado 7.3
comprobar_tupla(L, [N, X]) :-
    length(L, N),
    nth0(0, L, X).
    
run_length(L, L1):-
    cod_all(L, Ls),
    run_length_aux(Ls, L1).

run_length_aux([], []).
run_length_aux([X|T], [[N,P]|S]):-
    comprobar_tupla(X, [N, P]),
    run_length_aux(T, S).

% Ejercicio 8

% Apartado 8.0

concatena2(X, Y, X-Y).

build_tree([X], Y):-
	Y = tree(Z, nil, nil),
	concatena2(Z, _, X).

build_tree([X|Rs], Y):-
		concatena2(Z, _, X),
    L = tree(Z, nil, nil),
    build_tree(Rs, R),
    Y = tree(1, L, R).



% Apartado 8.1

encode_elem(X, Y, T):-
    Y = [],
    T = tree(X, nil, nil).

encode_elem(X, [1|Y], T):-
    T = tree(1, _, R),
    encode_elem(X, Y, R).

encode_elem(X, [0], T):-
    T = tree(1, L, _),
    encode_elem(X, _, L).



% Apartado 8.2

encode_list([X], [Y], T):-
    encode_elem(X, Y, T).
encode_list([X|R1], [Y|R2], T):-
    encode_elem(X, Y, T),
    encode_list(R1, R2, T).



% Apartado 8.3

number_times(X, [], [X, 0]).
number_times(X, [X|R], [X, N]):-
    number_times(X, R, [X, N2]),
    N is N2+1.
number_times(X, [_|R], [X, N]):-
    number_times(X, R, [X, N]).

times_list(_, [], []).
times_list(L1, [X|Ls], [Y|L2]):-
	number_times(X, L1, [E, N]),
	Y = E-N,
	times_list(L1, Ls, L2).


diccionario([a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z]).


ordena(L1, L2):-
	sort(L1, Aux),				% Eliminamos repetidos
	invierte(Aux, Aux2),		% Para que en caso de igual número de repeticiones se ordene igual que en el ejemplo propuesto.
	times_list(L1, Aux2, X),
	sort(2, @>=, X, L2).
    

admisible([]).
admisible([X|R]):-
	diccionario(L),
	member(X, L),
	admisible(R).

encode(L1, L2):-
	admisible(L1),
    ordena(L1, L),
    build_tree(L, T),
    encode_list(L1, L2, T).
