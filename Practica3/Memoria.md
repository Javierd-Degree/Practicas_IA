*Javier Delgado del Cerro y Javier López Cano - Pareja 2*

## Práctica 3

En esta práctica, como el código de las funciones es muy simple y corto, incluimos el código directamente en cada apartado.

### Ejercicio 1

#### Batería de ejemplos

En este caso, al ser la función tan simple, la batería de ejemplos es bastante reducida.

```
?- duplica([1], [1, 1]). %%% true
?- duplica([1, 2, 3], [1, 1, 2, 2, 3, 3]). %%% true
?- duplica([1, 2, 3], X). %%% X = [1, 1, 2, 2, 3, 3]
```

Comprobamos que todos los ejemplos funcionan correctamente.

#### Pseudo-código
```
duplica(L1, L2):
    vacia(L1) y vacia(L2):
        devolver true
    si L1[0] == L2[0] == L2[1]:
        devolver duplica(resto(L1), resto(resto(L2)))
    si no:
    devolver false

```

#### Código

```
duplica([], []).
duplica([X|T], [X, X|L]):-duplica(T, L).
```

### Ejercicio 2

#### Batería de ejemplos

Incluimos los ejemplos de prueba para las dos funciones que hemos desarrollado en este apartado:

```
?- concatena([], [], []). %%% true
?- concatena([1], [], [1]). %%% true
?- concatena([], [1], [1]). %%% true
?- concatena([1], [], []). %%% false
?- concatena([], [1], []). %%% false
?- concatena([1, 2], [3, 4], [1, 2, 3, 4]). %%% true
?- concatena([1, 2], [3, 4], [1, 2, 3]). %%% false
?- concatena([1, 2], [3, 4], X). %%% X = [1, 2, 3, 4]

?- invierte([], []). %%% true
?- invierte([1], [1]). %%% true
?- invierte([1, 2], [2, 1]). %%% true
?- invierte([1, 2], [1, 2]). %%% false
?- invierte([1, 2, 3], X) %%% X = [3, 2, 1]
```

De nuevo, tras ejecutar estos ejemplos comprobamos que la función es correcta.

#### Pseudo-código
Incluimos simplemente el pseudo-código de la función *invierte*, pues el código de *concatena* se nos da en el enunciado de la práctica.
```
invierte(L1, L2):
		si vacio(L1) y vacio(L2):
				devolver true
		si no:
				H = primer_elem(L1)
				T = resto(L1)
				devolver (R tal que satisface invierte(T, R)) y concatena(R, lista(H), L2)
```

#### Código

```
concatena([], L, L).
concatena([X|L1], L2, [X|L3]):-concatena(L1, L2, L3).

invierte([], []).
invierte([H|T],L):-invierte(T,R),concatena(R,[H],L).
```

### Ejercicio 3
#### Batería de ejemplos

```
?- palindromo([]). %%% true
?- palindromo([1]). %%% true
?- palindromo([1, 1]). %%% true
?- palindromo([1, 2]). %%% false
?- palindromo([1, 2, 3, 2, 1]). %%% true
?- palindromo([1, 2, 3, 3, 1]). %%% false
```

En el caso de llamar a la función con una variable no instanciada, genera la lista vacía, pero pulsando los botones *Next*, *10*, *100*... que aparecen, se muestran nuevos ejemplos con listas que incluyen posiciones de memoria, de forma que las listas son palíndromos. En nuestro ejemplo, generando 10 más:
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
#### Código

```
palindromo(L):-invierte(L, L).
```

#### Comentarios sobre la implementación

En el caso de esta función, su implementación se basa simplemente en llamar a la función *invierte* desarrollada en el apartado anterior, pues internamente realizan la misma función. Por esta razón, consideramos que no es necesario realizar el pseudocódigo de la función, pues no aporta nada y empeora la lectura del texto.

### Ejercicio 4

#### Batería de ejemplos

```
?- divide([1], 1, [1], []). %%% true
?- divide([1], 1, [], [1]). %%% false
?- divide([1, 2, 3, 4, 5], 3, [1, 2, 3], [4, 5]). %%% true
?- divide([1, 2, 3, 4, 5], 3, L1, [4, 5]). %%% L1 = [1, 2, 3]
?- divide([1, 2, 3, 4, 5], 3, [1, 2, 3], L2). %%% L2 = [4, 5]
?- divide([1, 2, 3, 4, 5], 3, L1,L2). %%% L1 = [1, 2, 3], L2 = [4, 5]
?- divide([1, 2, 3, 4, 5], 3, L1, [3, 4, 5]). %%% false
?- divide([1, 2, 3, 4, 5], 3, [1, 2], L2). %%% false
```

#### Pseudo-código

```
divide(L, N, L1, L2):
	X = primer_elem(L)
	T = resto(L)
	si (L1 == lista(X)) y (L2 == T) y (N == 1):
		devolver true
	si no:
		devolver (existe H tal que satisface divide(T, N-1, H, L2)) y concatena(lista(X), H, L1)
```

#### Código

```
divide([X|T],1,[X],T).
divide([X|T],N,L1,L2):-
	N2 is N-1,
	divide(T, N2, H, L2),
	concatena([X], H, L1).
```

### Ejercicio 5

En el caso de ponerlo al revés, como *aplasta(R,  [a, b, c, d]).* la función devuelve false, porque no es ninguno de los casos base

#### Batería de ejemplos

#### Pseudo-código
```
aplasta(L, Res):
		si vacio(L) y vacio(Res):
				devolver true
		si Res == lista(L):
				devolver true
		si no:
				L1 = lista aplastada de primer_elem(L)
				L2 = lista aplastada de resto(L)
				devolver concatenar(L1, L2) == Res
```

#### Código

```
aplasta([], []) :- !.
aplasta([X|T], Res) :-
    !,
    aplasta(X, L1),
    aplasta(T, L2),
    append(L1, L2, Res).
aplasta(L, [L]).
```

### Ejercicio 6

#### Batería de ejemplos

```
next_factor(5, 2, NF) %%%% 3, el caso base
next_factor(2, 5, NF) %%% FALSE porque 5 &lt; sqrt(2)
next_factor(2, 1, NF) %%% 3
next_factor(25, 3, NF) %%% 5
next_factor(25, 5, NF) %%% false

primos(1, []) %%% true, el caso base
primos(4, [2, 2]) %%% true
primos(4, [2, 3]) %%% false
primos(63, [3, 3, 7]) %%% true
primos(63, [3, 3, 8]) %%% false
primos(63, L) [3, 3, 7]
primos(4, L) [2, 2]
```

#### Pseudo-código
Definimos, como se indica en el enunciado, la función *next_factor*, además de otra función auxiliar, *primos_aux* que se encarga de hacer toda la recusión para obtener los divisores, de forma que *primos* se basa en comprobar si el numero es 1, y en caso contrario, llamar a *primos_aux* con el factor 2.
```
next_factor(N, F, NF):
		si F==2 y NF==3:
				return true
		si (F < sqrt(N)) y (NF == F+2):
				devolver true
		si F < N:
				devolver true
		si no:
				devolver false

primos_aux(N, L, F):
		si N == 1:
				return true
		si primer_elem(L) == F:
				T = resto(L)
				devolver ((N%F == 0) y primos_aux(N/F, T, F))
		si no:
				Fn = numero que satisface next_factor(N, F, Fn)
				devolver (N%F != 0) y primos_aux(N, L, Fn)

primos(N, L):
		si (N == 1) y vacia(L):
				devolver true
		si no:
			devolver primos_aux(N, L, 2)
```

#### Código

```
next_factor(_, 2, 3).
next_factor(N, F, NF):- F < sqrt(N), NF is F + 2.
next_factor(N, F, N):- F < N.

primos_aux(1, [], _).
primos_aux(N, [F|T], F) :-
   	0 is mod(N, F),
    Nn is N/F,
    primos_aux(Nn, T, F), !.

primos_aux(N, L, F) :-
   	0\= mod(N, F),
    next_factor(N, F, Fn),
    primos_aux(N, L, Fn).

primos(1, []).
primos(N, L) :-
    primos_aux(N, L, 2).
```



### Ejercicio 8

#### 8.1

```
concatena2(X, Y, X-Y).

build_tree([X], Y):-
	concatena2(Y, _, X),
    Y = tree(X, nil, nil).
build_tree([X|Rs], Y):-
	concatena2(Z, _, X),
    L = tree(Z, nil, nil),
    build_tree(Rs, R),
    Y = tree(1, L, R).
```

#### 8.2

```
encode_elem(X, Y, T):-
    Y = [],
    T = tree(X, nil, nil).

encode_elem(X, [1|Y], T):-
    T = tree(1, _, R),
    encode_elem(X, Y, R).

encode_elem(X, [0], T):-
    T = tree(1, L, _),
    encode_elem(X, _, L).
```



encode_elem(X, Y, T):-
    Y = [],
    T = tree(X, nil, nil).

encode_elem(X, [1|Y], T):-
    T = tree(1, _, R),
    encode_elem(X, Y, R).

encode_elem(X, [0], T):-
    T = tree(1, L, _),
    encode_elem(X, _, L).

#### 8.3

```
encode_list([X], [Y], T):-
    encode_elem(X, Y, T).
encode_list([X|R1], [Y|R2], T):-
    encode_elem(X, Y, T),
    encode_list(R1, R2, T).
```

#### 8.4 -Aún no funciona.

number_times(X, [], [X, 0]).
number_times(X, [X|R], [X, N]):-
    number_times(X, R, [X, N2]),
    N is N2+1.
number_times(X, [_|R], [X, N]):-
    number_times(X, R, [X, N]).

diccionario([a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z]).

%ordena(L1, L2):
    % comprobar que los elementos de L1 están en diccionario.
    % eliminar duplicados L1
    % ordenar la lista sin duplicados en L2 según el número de veces (number_times()) que el caracter está en L1.

encode(L1, L2):-
    ordena(L1, L),
    build_tree(L, T),
    encode_list(L1, L2, T).
