### Prática 1 - Javier Delgado del Cerro y Javier López Cano - Pareja 2

### Ejercicio 1

#### Apartado 1.1

##### Batería de ejemplos

Comentar antes de empezar este apartado que no incluiremos en ninguna de estas baterías de ejemplos las expresiones pedidas en la memoria, que aparecen explicadas en *Comentarios sobre la impementación*, para evitar repetir información. Además, esta batería de ejemplos está siempre en el mismo orden que la ejecución del programa, y seguida en dicha ejecución por los ejempos pedidos, de forma que sea muy sencillo comprobar su verosimilitud.

En este caso específico, podemos ver que casi todos los casos conflictivos han sido pedidos en el enunciado, con lo que quedaría simplemente comprobar el simétrico de `(cosine-distance nil '(1 2 3))` y comprobar con algunos ejemplos que, efectivamente, se calcula correctamente. Como el resultado coincide en la versión recursiva y en la mapcar, lo expresamos como una única fución:

```commonlisp
(cosine-distance '(1 2 3) nil) ;;; ---> NIL
(cosine-distance '(1 0) '(0 1)) ;;; ---> 1
(cosine-distance '(1 2 3) '(1 2 3)) ;;; ---> 0
(cosine-distance '(1 2 3) '(-1 -2 -3)) ;;; ---> 2
```

Como esperábamos (y como se puede ver al ejecutar el archivo), todos los resultados son correctos a excepción de la tercera prueba, donde en vez de obtener $0$ obtenemos $5.96*10^{-8}$, que se debe únicamente a las aproximaciones del procesador (probablemente sobre todo en las raices cuadradas).

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

En este caso, la batería de ejemplos que hemos pensado (sin tener en cuenta los pedidos posteriormente, ni los dados en el enunciado como ejemplo, que también funcionan correctamente) serían:

```lisp
(order-vectors-cosine-distance '(1 2 3) '((0 0 0))) ;; --> NIL
(order-vectors-cosine-distance '(0 0 0) '((1 2 3))) ;; --> NIL
(order-vectors-cosine-distance '(1 2 3) '((1 2 3) (2 1 1)) 0.99) ;; --> ((1 2 3))
(order-vectors-cosine-distance '(1 2 3) '((1 2 3) (2 1 1)) 1) ;; --> ((1 2 3))
(order-vectors-cosine-distance '(1 0) '((1 0) (0 1) (1 0.1) (1 0.2))) ;; --> ((1 0) (1 0.1) (1 0.2) (0 1)) 
(order-vectors-cosine-distance nil '((1 2 3) (2 1 1))) ;; --> NIL
(order-vectors-cosine-distance '(1 2 3) nil) ;; --> NIL
(order-vectors-cosine-distance nil nil) ;; --> NIL
```

Al igual que antes, podemos ver en el tercer caso como, por errores de aproximación, el nivel de confianza 1 no es útil, pues el resultado es NIL en vez de el esperado, al ser la distancia $5.96*10^{-8}$ en vez de cero.

##### Pseudo-código

```
order-vectors-cosine-distance (vector lst-of-vectors confidence-level):
	para cada v en lst-of-vectors:
		resultado.añadir(v, cosine-distance(vector, v))
	resultado.ordenar()
	delvolver resultado.primer-elemento-tuplas()	
```



##### Comentarios sobre la implementación

Para codificar dicha función, es claro que necesitamos obtener la distancia coseno de cada uno de los vectores de `lst-of-vectors` a `vector`, eliminar aquellos cuya distancia sea mayor que `1 - confidence-level` y finalmente, ordenarlos respecto a dicho parámetro de menor a mayor. Para conseguir esto, desarrollamos la funcion `map-vectors-cosine-distance` que se encarga de crear una lista de tuplas (cada una de ellas con un vector y su distancia coseno respecto al vector de referencia) con los vectores cuya distancia coseno es menor o igual que que `1 - confidence-level`. Posteriormente, basta con ordenar esta lista (para lo que usamos `vector-order` y una copia de la lista, pues `sort`es una función destructiva) y coger únicamente el primer elemento de cada tupla. Como alternativa, podríamos haber programado nosotros mismos un algoritmo de ordenación como quicksort y emplear dicha función directamente, pero creemos que la implementación oficial probablemente esté mucho más optimizada que la que podemos desarrollar nosotros.

Al ejecutar los ejemplos dados en el PDF obtenemos exactamente los mismos resultados. Para los casos de prueba pedidos, obtenemos lo siguiente:

| Expresión                                                | Evaluación |
| -------------------------------------------------------- | ---------- |
| `(order-vectors-cosine-distance '(1 2 3) '())`           | NIL        |
| `(order-vectors-cosine-distance '() '((4 3 2) (1 2 3)))` | NIL        |

Como era de esperar.

#### Apartado 1.3

##### Batería de ejemplos

De nuevo, evitamos probar las expresiones que se piden posteriormente y están explicdas en la tabla del apartado 1.4. Además, usamos la expresión `cosine-distance` por ser el resultado independiente del uso de la función recursiva o la función con mapcar. La batería de ejemplos sería entonces:

```commonlisp
(get-vectors-category '((1 1 2) (2 2 1)) '((1 2 1) (2 1 2)) #'cosine-distance) ;;; --> ((2 0.0) (1 0.0)) 
(get-vectors-category '((1 1 2)) '((1 2 1) (2 1 2)) #'cosine-distance) ;;; --> ((1 0.19999999) (1 0.0)) 
(get-vectors-category '((1 0 0)) '((1 2 1) (2 1 2)) #'cosine-distance) ;;; --; (NIL NIL)
(get-vectors-category '((1 1 2) (2 2 1)) '((1 0 0)) #'cosine-distance) ;;; --; (NIL)
(print (get-vectors-category nil '((1 2 1) (2 1 2)) #'cosine-distance) ;;; --> NIL
(get-vectors-category '((1 2 1) (2 1 2)) nil #'cosine-distance) ;;; --> NIL
(get-vectors-category nil nil #'cosine-distance) ;;; --> NIL
(get-vectors-category '((1 1 2 3) ()) '((1 1 2 3) (2 2 4 6)) #'cosine-distance) ;;; --> ((1 0) (1 0.02536)) 
(get-vectors-category '((1 4 5 6) (2 2 1 3)) '(() (2 4 5 6)) #'cosine-distance) ;;; --> (NIL (1 0.0))
(get-vectors-category '(() (1 4 5 6)) '(() (2 4 5 6)) #'cosine-distance) ;;; --> (NIL (1 0.0))
```

Consideramos que en el caso 3 y 4 tiene que devolver listas de NIL, pues aunque ambas listas con válidas (las te categorías y las de textos), ninguno de los textos tiene una categoría que se le pueda asociar.

Sin embargo, en los casos 5, 6 y 7, como o solo una o ninguna de las listas son válidas, devolvemos nil directamente. 

En el caso 8, al igual que ha pasado anteriormente, cabe destacar que no obtenemos exactamente dicho resultado, pues dadas las aproximaciones del ordenador el par `(1 0)` se convierte en `(1 5.9604645E-8)`.

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

En este tercer apartado, empleamos dos funciones auxiliares para llegar a la pedida. En primer lugar `get-text-category-dist` nos permite, dado un texto y una categoría, obtener una lista con una tupla con el id de la categoria y la distancia del texto a la categoría, y en segundo lugar `get-text-category` nos permite obtener la categoría de un texto. Hacemos que `get-text-category-dist` nos devuelva una lista con una tupla para, de esta forma, poder usar mapcan en `get-text-category`, y controlar los casos en los que alguno de los vectores sea, quitando el id, todo ceros.

De esta forma en ` get-vectors-category` simplemente tenemos que llamar a `get-text-category ` para cada uno de los textos.

Hemos decidido además que, en el caso de que alguna de las listas pasadas no tenga elementos, la función devuelva nil, pues en ese caso será imposible que la función haga su cometido.

#### Apartado 1.4

Usando la macro time con algunos ejemplos para medir la diferencia de rendimiento entre ambas funciones, podemos ver que la función recursiva es mucho menos eficiente, como era de esperar, pues sabemos que mapcar paraleliza la ejecución en distintos hilos. Así, por ejemplo, para dos vectores de cuatro elementos como textos y categorías, la función recursiva tarda $8.1*10^{-5}s$ mientras que la función mapcar tarda $3.8*10^{-5}s$. Si aumentamos los vectores para que sean de cinco elementos, y usamos cuatro de estos vectores para cada una de las listas, vemos que los tiempos en este caso serían $1.91*10^{-4}s$ y $7.6*10^{-5}s$  respectivamente, por lo que es claro además que el tiempo de la función recursiva crece mucho más rápido que el de la función mapcar.

Además, para los ejemplos planteados obtenemos los siguientes resultados:

| Expresión                                                    | Evaluación         |
| ------------------------------------------------------------ | ------------------ |
| `(get-vectors-category '(()) '(()) #'cosine-distance)`       | (NIL)              |
| `(get-vectors-category '((1 4 2) (2 1 2)) '((1 1 2 3)) #'cosine-distance)` | `((2 0.40238577))` |
| `(get-vectors-category '(()) '((1 1 2 3) (2 4 5 6)) #'cosine-distance)` | (NIL NIL)          |

Como hemos mencionado en la parte de *batería de ejemplos* del apartado anterior, en el primer y tercer caso, devuelve una lista con  NILs porque, para los textos (que pueden o no ser NIL) no hay ninguna categoría.

### Ejercicio 2



### Ejercicio 3

#### Apartado 3.1

##### Batería de ejemplos

Dada la simplicitud del apartado, además de los ejemplos proporcionados en el enunciado y evaluados en el apartado de *comentarios sobre la implementación*, solo falta comprobar su correcto funcionamiento mediante la expresión:

```commonlisp
(combine-elt-lst 'a '(1 2 3)) ;;; ---> ((A 1) (A 2) (A 3)) 
```

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

Al igual que en el ejemplo anterior, todas las expresiones que pueden causar algún tipo de conflicto están evaluadas en el apartado de *comentarios sobre la implementación*, con lo que solo es necesario probar su correcto funcionamiento, para lo que es suficiente la expresión:

```commonlisp
(combine-lst-lst '(a b c) '(1 2)) ;;; --> ((A 1) (A 2) (B 1) (B 2) (C 1) (C 2)) 
```

##### Pseudo-código

Una vez desarrollada la función del aparado anterior, esta es bastante sencilla

```
combine-lst-lst (lst1, lst2):
	para cada elt en lst1:
		resultado.concatenar(combine-elt-lst(elt lst))
	devolver resultado
		
```

##### Comentarios sobre la implementación

Como  `combine-elt-lst` devuelve una lista, usamos mapcan para aplicar esta función con cada elemento de `lst1` sobre `lst2`. De esta forma, mapcan concatena las listas. Además, en el caso de ser alguno de los campos vacío o NIL, mapcan devuelve simplemente nil, pues no añade nada la lista.
Por tanto, la evaluación de las expresiones pedidas es la siguiente:

| Expresión                      | Evaluación |
| ------------------------------ | ---------- |
| `(combine-lst-lst nil nil)`     | NIL        |
| `(combine-lst-lst '(a b c) nil)`    | NIL        |
| `(combine-lst-lst nil '(a b c))` | NIL        |

#### Apartado 3.3

##### Batería de ejemplos

De nuevo, todas las expresiones que pueden dar lugar a algún tipo de conflicto están evaluadas en el apartado de  *comentarios sobre la implementación*, con lo que basta con ver que funciona correctamente para dos listas (su comportamiento tiene que ser exactamente igual que el de `combine-lst-lst`) y para tres o más listas:

```commonLisp
(combine-list-of-lsts '((a b c) (1 2))) ;;; --> ((A 1) (A 2) (B 1) (B 2) (C 1) (C 2))
(combine-list-of-lsts '((a b c) (+ -) (1 2))) ;;; --> ((A + 1) (A + 2) (A - 1) (A - 2) (B + 1) (B + 2) (B - 1) (B - 2) (C + 1) (C + 2) (C - 1) (C - 2))
```

##### Pseudo-código

Una vez desarrollada la función del aparado anterior, basta con utilizar una recursión cuyo caso base sea el caso en el que `lstolsts` tiene únicamente un elemento, pues en dicho caso el resultado sería, usando un ejemplo, `(combine-list-of-lsts '((a b c))) --> ((A) (B) (C))`

```
combine-list-of-lsts (lstolsts):
	si elementos(lstolsts) == 1:
		para cada item en primer elem lstolsts:
			 resultado.añadir(lista(item))
		devolver resultado
	devolver combine-lst-lst(primer elem lstolsts, combine-list-of-lsts(resto lstolsts))
		
```

##### Comentarios sobre la implementación

Sin embargo, en la implementación nos encontramos con un pequeño problema, y es que la función `combine-elt-lst` crea una lista para cada par, lo que cumple las especificaciones pedidas para el apartado 3.1, sin embargo, al usar dicha función en este tercer apartado, necesitaríamos concatenar el par en otra lista, obteniento así una única lista con dos elementos, y no una lista con dos sublistas.
> Un ejemplo sería: queremos obtener `(A + 1)`, pero con la función actual obtenemos `(A (+ (1)))`. Como hemos dicho, la solución pasaría por concatenar los elementos (función `cons`) en vez de crear una lista, pero esto no cumpliría el formato de salida pedido en el enunciado para esta función, pues el resultado de evaluar `(combine-elt-lst 'a '(1 2 3))` sería `((A . 1) (A . 2) (A . 3))` en vez de `((A 1) (A 2) (A 3))`.

Por tanto, creamos dos nuevas funciones auxiliares, una `combine-elt-lst-aux` que simplemente implementa esta concatenación, y otra `combine-elt-lst-aux` cuya función es la misma que `combine-elt-lst` pero llamando en este caso a `combine-elt-lst-aux`.

Una vez programada la función, comprobamos con el ejemplo dado y con nuestra batería de ejemplos que funciona correctamente, y la evaluación sobre las expresiones pedidas sería:

| Expresión                                         | Evaluación          |
| ------------------------------------------------- | ------------------- |
| `(combine-list-of-lsts '(() (+ -) (1 2 3 4)))`    | NIL                 |
| `(combine-list-of-lsts '((a b c) () (1 2 3 4))) ` | NIL                 |
| `(combine-list-of-lsts '((a b c) (+ -) ()))`      | NIL                 |
| `(combine-list-of-lsts '((1 2 3 4)))`             | `((1) (2) (3) (4))` |
| `(combine-list-of-lsts '(nil))`                   | NIL                 |
| `(combine-list-of-lsts nil)`                      | NIL                 |

