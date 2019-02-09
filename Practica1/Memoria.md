## Prática 1

### Ejercicio 1

#### Batería de ejemplos

```lisp

```

#### Apartado 1.1

##### Batería de ejemplos

##### Pseudo-código

La única diferencia en el pseudocódigo de las dos funciones pedidas es la forma de calcular el producto escalar, por lo que especificaremos una única función `cosine-distance` que emplee `dot-product`, y dicho producto escalar será uno de los dos explicados.

```
cosine-distance(x, y):
	denominador = raiz(dot-product(x, x))*raiz(dot-product(y, y))
	si denominador == 0:
		devolver null
	si no:
		devolver dot-product(x, y)/denominador
		
dot-product-rec(x, y):
	si (x vacio) o (y vacio):
		devolver 0
	devolver (primer elem x)*(primer elem y)+dot-product-rec(resto de x, resto de y)

dot-product-mapcar(x, y):
	sumar(multiplicar el elemento xi por el yi)
```



##### Comentarios sobre la implementación

Para desarrollar las funciones `cosine-distance-rec` y `cosine-distance-mapcar` creamos dos funciones que nos permiten calcular el producto escalar de dos vectores de forma recursiva y usando mapcar, estas funciones son `dot-product-rec` y `dot-product-mapcar` respectivamente. Además, para evitar repeticiones de código creamos una tercera función `cosine-distance` que recibe como parámetro la función distancia a utilizar, con lo que `cosine-distance-rec` y `cosine-distance-mapcar`  son simplemente llamadas a `cosine-distance`. El resultado de la evaluación de los casos indicados sería:

| Expresión                           | Evaluación recurrente | Evaluación mapcar |
| ----------------------------------- | --------------------- | ----------------- |
| `(cosine-distance '(1 2) '(1 2 3))` | 0.40238577            | 0.40238577        |
| `(cosine-distance nil '(1 2 3))`    | NIL                   | NIL               |
| `(cosine-distance '() '())`         | NIL                   | NIL               |
| `(cosine-distance '(0 0) '(0 0))`   | NIL                   | NIL               |

#### Apartado 1.2

##### Batería de ejemplos

##### Pseudo-código

```
order-vectors-cosine-distance (vector lst-of-vectors confidence-level):
	para cada v en lst-of-vectors:
		resultado.añadir(v, cosine-distance(vector, v))
	resultado.ordenar()
	delvolver resultado.primer-elemento-tuplas()	
```



##### Comentarios sobre la implementación

Para codificar dicha función, es claro que necesitamos obtener la distancia coseno de cada uno de los vectores de `lst-of-vectors` a `vector`, eliminar aquellos cuya distancia sea mayor que `1 - confidence-level` y finalmente, ordenarlos respecto a dicho parámetro de menor a mayor. Para conseguir esto, desarrollamos la funcion `map-vectors-cosine-distance` que se encarga de crear una lista de tuplas (cada una de ellas con un vector y su distancia coseno respecto al vector de referencia) con los vectores cuya distancia coseno es menor o igual que que `1 - confidence-level`. Posteriormente, basta con ordenar esta lista (para lo que usamos `vector-order` y una copia de la lista, pues `sort`es una función destructiva) y coger únicamente el primer elemento de cada tupla.

Al ejecutar los ejemplos dados en el PDF obtenemos exactamente los mismos resultados. Para los casos de prueba pedidos, obtenemos lo siguiente:

| Expresión                                                | Evaluación |
| -------------------------------------------------------- | ---------- |
| `(order-vectors-cosine-distance '(1 2 3) '()`            | NIL        |
| `(order-vectors-cosine-distance '() '((4 3 2) (1 2 3)))` | NIL        |

Como era de esperar.

#### Apartado 1.3

##### Batería de ejemplos

##### Pseudo-código

```
get-vectors-category (categories texts distance-measure):
	para cada text en texts:
		lista.crear()
		para cada cat en categories:
			lista.añadir(id(cat) distance-measure(vector(text), vector(text)))
		resultado.añadir(lista.coger_minima_distancia())
	devolver resultado
```

##### Comentarios sobre la implementación

En este tercer apartado, empleamos dos funciones auxiliares para llegar a la pedida. En primer lugar `get-text-category-dist` nos permite, dado un texto y una categoría, obtener una tupla con el id de la categoria y la distancia del texto a la categoría, y en segundo lugar `get-text-category` nos permite obtener la categoría de un texto. De esta forma en ` get-vectors-category` simplemente tenemos que llamar a `get-text-category ` para cada uno de los textos.

#### Apartado 1.4

Usando la macro time con algunos ejemplos para medir la diferencia de rendimiento entre ambas funciones, podemos ver que:



Además, para los ejemplos planteados obtenemos los siguientes resultados:

| Expresión                                                    | Evaluación |
| ------------------------------------------------------------ | ---------- |
| `(get-vectors-category '(()) '(()) #'cosine-distance)`       |            |
| `(get-vectors-category '((1 4 2) (2 1 2)) '((1 1 2 3)) #'cosine-distance)` |            |
| `(get-vectors-category '(()) '((1 1 2 3) (2 4 5 6)) #'cosine-distance)` |            |



### Ejercicio 2



### Ejercicio 3

#### Apartado 3.1

##### Batería de ejemplos

##### Pseudo-código

```
combine-elt-lst (elt, lst):
	para cada elemento en lst:
		resultado.añadir(lista(elt lst))
	devolver resultado
		
```

##### Comentarios sobre la implementación

En este caso, la implementación ha sido muy sencilla y lo único a destacar es la decisión que hemos tomado de, si o bien el `elt`o bien `lst` son vacíos o nil, devolver nil directamente. Por tanto, la evaluación de las expresiones pedidas es la siguiente:

| Expresión                      | Evaluación |
| ------------------------------ | ---------- |
| `(combine-elt-lst 'a nil)`     | NIL        |
| `(combine-elt-lst nil nil)`    | NIL        |
| `(combine-elt-lst nil '(a b))` | NIL        |

#### Apartado 3.2

##### Batería de ejemplos

##### Pseudo-código

Una vez desarrollada la función del aparado anterior, esta es bastante sencilla

```
combine-lst-lst (lst1, lst2):
	para cada elt en lst1:
		resultado.concatenar(combine-elt-lst(elt lst))
	devolver resultado
		
```

##### Comentarios sobre la implementación

Como  `combine-elt-lst` devuelve una lista, usamos mapcan para aplicar esta función con cada elemento de lst1 sobre lst2. De esta forma, mapcan concatena las listas. Además, en el caso de ser alguno de los campos vacío o nil, mapcan devuelve simplemente nil, pues no añade nada la lista.
Por tanto, la evaluación de las expresiones pedidas es la siguiente:

| Expresión                      | Evaluación |
| ------------------------------ | ---------- |
| `(combine-lst-lst nil nil)`     | NIL        |
| `(combine-lst-lst '(a b c) nil)`    | NIL        |
| `(combine-lst-lst nil '(a b c))` | NIL        |