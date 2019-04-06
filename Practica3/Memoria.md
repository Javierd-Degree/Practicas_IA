### Ejercicio 1

```
duplica([], []).
duplica([X|T], [X, X|L]):-duplica(T, L).
```

### Ejercicio 2

```
concatena([], L, L).
concatena([X|L1], L2, [X|L3]):-concatena(L1, L2, L3).

invierte([], []).
invierte([H|T],L):-invierte(T,R),concatena(R,[H],L).
```

### Ejercicio 3
Basta con llamar a función *invierte* creada anteriormente. La copiamos de nuevo pues, al estar en otro cuadro de programa, swish-prolog no lo detecta.
Si se llama con una variable no instanciada, genera la lista vacía, pero pulsando los botones *Next*, *10*, *100*... que aparecen, se muestran nuevos ejemplos con listas que incluyes posiciones de memoria, que son palíndromos. En nuestro ejemplo, generando 10 más:

```
X = []
X = [_1164]
X = [_1192, _1192]
X = [_1226, _1232, _1226]
X = [_1266, _1272, _1272, _1266]
X = [_1312, _1318, _1324, _1318, _1312]
X = [_1364, _1370, _1376, _1376, _1370, _1364]
X = [_1422, _1428, _1434, _1440, _1434, _1428, _1422]
X = [_1486, _1492, _1498, _1504, _1504, _1498, _1492, _1486]
X = [_832, _838, _844, _850, _856, _850, _844, _838, _832]
X = [_908, _914, _920, _926, _932, _932, _926, _920, _914, _908]
```

```
concatena([], L, L).
concatena([X|L1], L2, [X|L3]):-concatena(L1, L2, L3).

invierte([], []).
invierte([H|T],L):-invierte(T,R),concatena(R,[H],L).

palindromo(L):-invierte(L, L).
```

### Ejercicio 4

```
concatena([], L, L).
concatena([X|L1], L2, [X|L3]):-concatena(L1, L2, L3).

divide([X|T],1,[X],T).
divide([X|T],N,L1,L2):-N2 is N-1, divide(T, N2, H, L2), concatena([X], H, L1).
```

### Ejercicio 5

En el caso de ponerlo al reves, como *aplasta(R,  [a, b, c, d]).* la función devuelve false, porque no es ninguno de los casos base

```
aplasta([], []) :- !.
aplasta([X|T], Res) :-
    !,
    aplasta(X, L1),
    aplasta(T, L2),
    append(L1, L2, Res).
aplasta(L, [L]).

```

### Ejercicio 6 - No funciona aún

Ejemplos: 
next_factor(5, 2, NF) 3, el caso base
next_factor(2, 5, NF) FALSE porque 5 &lt; sqrt(2)
next_factor(2, 1, NF) 3
next_factor(25, 3, NF) 5
next_factor(25, 5, NF) false

```
next_factor(_, 2, 3).
next_factor(N, F, NF):- F &lt; sqrt(N), NF is F + 2.

primos_aux(1, [], _).
primos_aux(N, [X|T], F) :- 
    mod(N, F, 0),
    F is X,
    Nn is N/F,
    primos_aux(Nn, [T], F).
    
primos_aux(N, [X|T], F) :- 
   not mod(N, F, 0),
    next_factor(N, F, Fn),
    primos_aux(N, [X|T], Fn).

primos(1, []).
primos(N, L) :-
    primos_aux(N, L, 2).
```

