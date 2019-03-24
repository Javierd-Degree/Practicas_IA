*Javier Delgado del Cerro y Javier López Cano - Pareja 2*

### Práctica 2

### Ejercicio 1

##### Batería de ejemplos

Comentar antes de empezar este apartado que no incluiremos en ninguna de estas baterías de ejemplos los ejemplos dados en la documentación de la práctica o en el fichero de pruebas proporcionado, pues ya hemos comprobado su correcto funcionamiento en estos casos, y consideramos que sería redundante.

En este caso específico, podemos ver que casi todos los casos conflictivos han sido pedidos en el enunciado, con lo que quedaría simplemente comprobar las expresiones en las que una o ambas de las entradas es NIL

```commonlisp
(f-h-price NIL NIL) ;;; ---> NIL
(f-h-price NIL *estimate*) ;;; ---> NIL
(f-h-price 'Nantes NIL) ;;; ---> NIL
```
Y, efectivamente, vemos que funciona de la manera esperada.

##### Pseudo-código

A pesar de tener que elaborar dos funciones distintas, el pseudo-código es prácticamente el mismo para ambas, pues se basa en recorrer recursivamente la lista *sensors*, por tanto, mostramos únicamente el pseudo-código de una de ellas:

```
f-h-time (state, sensors):
	si vacio(sensors):
		devolver false
	si primer_elemento(sensors).state == state:
		devolver primer_elemento(sensors).time
	si no:
		f-h-time (state, resto(sensors))
```



##### Comentarios sobre la implementación

En este caso, el apartado no ha requerido tomar ninguna decisión especial sobre la implementación.



### Ejercicio 2

##### Batería de ejemplos

Como en el apartado anterior, dado que las funciones pedidas tienen un funcionamiento bastante sencillo, la batería de pruebas es muy reducida. Con los ejemplos proporcionados comprobamos que el funcionamiento es correcto en los casos en que el origen existe en el grafo, tanto si tiene algún posible destino como si no (como es el caso de Orleans), y teniendo en cuenta también la lista de ciudades prohibidas, como en el ejemplo `(navigate-train-price 'Avignon *trains* '(Marseille))`. 

Queda por tanto probar únicamente los casos en los que uno o ambos de los campos de entrada sea NIL. Como las cuatro funciones se basan en una principal que es la que realiza la búsqueda (explicado en el apartado siguiente), basta probarlo en una de las cuatro funciones pedidas:

```commonlisp
(navigate-canal-time NIL *canals*) ;;; ---> NIL
(navigate-canal-time 'Nancy NIL) ;;; ---> NIL
(navigate-canal-time NIL NIL) ;;; ---> NIL
```

Comprobamos que, efectivamente, funcionan de la manera esperada.

##### Comentarios sobre la implementación

Para la implementación de este apartado hemos decidido definir, como se mencionaba en el enunciado, una función genérica *navigate* que, dado un estado, una lista de los vértices del grafo, una función para extraer el coste deseado del vértice y un nombre para dicha acción, junto con una posible lista de ciudades prohibidas, permite obtener una lista de estados a los que podemos llegar aplicando una acción. 

De esta forma, las otras cuatro funciones son llamadas a esta primera variando la lista de vertices según sea por tren o por canal, la función para seleccionar el coste (que consiste básicamente en coger el primer o segundo elemento de una tupla), y el nombre de la acción, además de incluir o no la lista de prohibidas

##### Pseudo-código

Mostramos entonces únicamente el pseudo-código de la función *navigate*, pues las otras cuatro son extremadamente simples y se han mencionado en el apartado anterior.

```
navigate (state, lst-edges, cfun, name, forbidden):
	si vacia(lst-edges):
		devolver NIL
	si (primer_elemento(sensors).origen == state) y 
		(primer_elemento(sensors).destino no esta en fobidden):
		devolver crear_accion(primer_elemento(sensors), state, name, cfun)
			concatenado con navigate(state, resto(lst-edges), cfun, name, forbidden)
	
	si no:
		navigate (state, resto(lst-edges), cfun, name, forbidden)
```

La función *crear_accion(primer_elemento(sensors))* correspondería simplemente a inicializar una accion como:

```
crear_accion(elem, state, name, cfun):
    accion.name = name
    accion.state = state
    accion.final = elem.destino
    accion.coste = cfun(elem.costes)
    devolver accion
```

### Ejercicio 3

##### Batería de ejemplos

En este caso, la batería de ejemplos consiste en probar los casos en que:

- El nodo no está en la lista de destinos.
- El nodo está en la lista de destinos, pero el trayecto no incluye todas las ciudades obligatorias.
- El nodo está en la lista de destinos y el trayecto incluye todas las ciudades obligatorias.
- Alguno o varios de los parámetros son NIL.

Los tres primeros casos están probados en el fichero de pruebas porporcionado, por lo que solo quedaría probar las entradas conflictivas en los que uno o varios de los argumentos son NIL:

```commonlisp
(f-goal-test node-calais '(Calais Marseille) NIL);;; ---> T
(f-goal-test node-paris '(Calais Marseille) NIL);;; ---> NIL
(f-goal-test node-calais NIL NIL);;; ---> NIL
(f-goal-test NIL '(Calais Marseille) '(Paris Nancy));;; ---> NIL
```

##### Comentarios sobre la implementación

Para la implementación de este ejercicio hemos decidido crear dos funciones auxiliares:

- Una primera función *navigate-path*, que devuelve uns lista desde el elemento raís hasta el nodo pasado como parámetro. Esta función se utilizará en apartados posteriores como en el 10. Para poder devolver el camino recorrido en orden, desde el nodo raís hasta el final, usamos una función auxiliar *navigate-path-aux* que se encarga de hacer la recusión.

- Una función *check-mandatory* que, dado una lista que represente el path, generada con la función anterior, y una lista de ciudades obligatorias, comprueba si todas las ciudades obligatorias están en el path recorrido.

Por último, la función *f-goal-test* se encarga únicamente de comprobar que el nodo pasado como argumento es uno de los destinos, y de llamar a *check-mandatory* para asegurar que se han recorrido todas las ciudades obligatorias.

##### Pseudo-código

El pseudo-código para estas funciones sería entonces:

```
navigate-path-aux(node, path):
	si node no tiene padre:
		devolver concatenar(node-nombre, path)
	si no:
		devolver navigate-path-aux(node.padre, concatenar(node-nombre, path))

navigate-path(node):
	si node es null:
		devolver NIL
	si no:
		devolver navigate-path-aux(node, lista())

check-mandatory (path, mandatory):
	si vacio(mandatory):
		devolver true
	si primer_elemento(mandatory) no esta en path:
		devolver NIL
	si no:
		devolver check-mandatory (path, resto(mandatory))
	
f-goal-test (node, destination, mandatory):
	si node es null:
		devolver NIL
	si node.nombre no esta en destination:
		devolver NIL
	si no:
		devolver check-mandatory (navigate-path(node), mandatory)
```

### Ejercicio 4

##### Batería de ejemplos

El comprobar que dos nodos corresponden a la misma ciudad es elemental, pues basta con comparar el campo *state* de ambos nodos. Lo complicado es, sin embargo, comprobar que los caminos son equivalentes, es decir, que tienen las mismas ciudades obligatorias. Sin embargo, la corrección de esta característica se comprueba simplemente con los ejemplos dados en el documento de pruebas. Además, en esta función no merece la pena controlar si uno o ambos de los nodos son NIL, pues al ser la función llamada cada vez que expandimos un nodo, sería muy ineficiente. Controlamos desde el resto de funciones  que nunca haya un NIL en la lista de nodos abiertos.

Por tanto, la batería de ejemplos sería básicamente la proporcionada.

##### Comentarios sobre la implementación

Para la resolución del apartado únicamente cabe destacar que hemos desarrollado una función auxiliar, *f-equivalent-paths* que es la encargada de comprobar si los caminos son o no equivalentes. Estos caminos se obtienen mediante la función *navigate-path(node)* desarrollada en el ejercicio anterior.

##### Pseudo-código

El pseudo-código para estas funciones sería entonces:

```commonlisp
f-equivalent-paths(path-1, path-2, mandatory):
	si vacio(mandatory):
		devolver True
	si primer_elemento(mandatory) no esta en path-1 pero si en path-2:
		devolver NIL
	si primer_elemento(mandatory) no esta en path-2 pero si en path-1:
		devolver NIL
	si no:
		devolver f-equivalent-paths(path-1, path-2, resto(mandatory))

f-search-state-equal (node-1, node-2, mandatory):
	si node-1.nombre != node-2.nombre:
		devolver NIL
	si no:
		devolver f-equivalent-paths(navigate-path(path-1), navigate-path(path-2), mandatory)
```



### Ejercicio 5

En este caso, como simplemente hemos tenido que definir las estructuras haciendo uso de todas las funciones desarrolladas anteriormente, por lo que no hay ninguna batería de pruebas o comentarios sobre la implementación que podamos hacer. La comprobación de las estructuras definidas se hace en el siguiente ejercicio.

### Ejercicio 6

##### Batería de ejemplos

Con el ejemplo dado, comprobamos que, la función obtiene únicamente Toulouse mediante la acción *NAVIGATE-TRAIN-TIME*, y que no expande Avignon, pues está en la lista de ciudades prohibidas. Además, no tenemos ningún destino mediante las acciones de los canales, pues Marseille no tiene ninguna salida mediante estos. 

Quedaría por tanto comprobar únicamente la estructura *travel-cheap*, que debería devolver lo mismo, variando únicamente los valores de g, f y h. Probamos por último con un nodo que tenga destinos mediante canales y mediante trenes, como puede ser *Reims*.

```commonlisp
(defparameter node-marseille-ex6
   (make-node :state 'Marseille :depth 12 :g 10 :f 20) )
(expand-node node-marseille-ex6 *travel-cheap*) ;; --->
;(#S(NODE :STATE TOULOUSE
;         :PARENT #S(NODE
;                    :STATE MARSEILLE
;                    :PARENT NIL
;                    :ACTION NIL
;                    :DEPTH 12
;                    :G 10
;                    :H 0
;                    :F 20)
;         :ACTION #S(ACTION
;                    :NAME NAVIGATE-TRAIN-PRICE
;                    :ORIGIN MARSEILLE
;                    :FINAL TOULOUSE
;                    :COST 65.0)
;         :DEPTH 13
;         :G 130.0
;         :H 130.0
;         :F 260.0)) 

(defparameter node-reims-ex6
   (make-node :state 'Reims :depth 12 :g 10 :f 20) )
(expand-node node-reims-ex6 *travel-cheap*) ;; --->
;(#S(NODE :STATE CALAIS
;         :PARENT #S(NODE
;                    :STATE REIMS
;                    :PARENT NIL
;                    :ACTION NIL
;                    :DEPTH 12
;                    :G 10
;                    :H 0
;                    :F 20)
;         :ACTION #S(ACTION
;                    :NAME NAVIGATE-CANAL-PRICE
;                    :ORIGIN REIMS
;                    :FINAL CALAIS
;                    :COST 15.0)
;         :DEPTH 13
;         :G 25.0
;         :H 0.0
;         :F 25.0)
;#S(NODE :STATE CALAIS
;         :PARENT #S(NODE
;                    :STATE REIMS
;                    :PARENT NIL
;                    :ACTION NIL
;                    :DEPTH 12
;                    :G 10
;                    :H 0
;                    :F 20)
;         :ACTION #S(ACTION
;                    :NAME NAVIGATE-TRAIN-PRICE
;                    :ORIGIN REIMS
;                    :FINAL CALAIS
;                    :COST 70.0)
;         :DEPTH 13
;         :G 80.0
;         :H 0.0
;         :F 80.0)
;#S(NODE :STATE NANCY
;         :PARENT #S(NODE
;                    :STATE REIMS
;                    :PARENT NIL
;                    :ACTION NIL
;                    :DEPTH 12
;                    :G 10
;                    :H 0
;                    :F 20)
;         :ACTION #S(ACTION
;                    :NAME NAVIGATE-TRAIN-PRICE
;                    :ORIGIN REIMS
;                    :FINAL NANCY
;                    :COST 55.0)
;         :DEPTH 13
;         :G 65.0
;         :H 50.0
;         :F 115.0))
```

Podemos ver entonces que funciona correctamente. No hemos puesto el ejemplo `(expand-node node-reims-ex6 *travel-fast*)` pues los resultados son practicamente los mismos, cambiando únicamente los nombres de las acciones y sus costes, sin embargo, sí que lo hemos probado. 

En este ejercicio, no tiene sentido probar los casos en los que el nodo o el problema son NIL, pues esto solo puede pasar por un fallo en el programa, el algoritmo no debería continuar en dicho caso.

##### Comentarios sobre la implementación

Hemos definido una función auxiliar, *expand-node-action*, que permite obtener el nodo resultante de aplicar una accion a un nodo padre.
De esta forma, la función *expand-node* se encarga de iterar esta función auxiliar sobre las acciones generadas a partir del nodo dado y de los problem-operators de problema pasado como argumento.
 ##### Pseudo-código
 El pseudo-código de estas funciones sería entonces:
 ```
 expand-node-action (action, parent, problem):
 	crear_nodo(state=action.final,
 		parent=parent,
 		action=action,
 		depth=parent.depth + 1,
 		g=parent.gaction.cost,
 		h=problem.f-h(action.final),
 		f=parent.gaction.cost + problem.f-h(action.final)

expand-node(node, problem):
	action-lst = aplicar cada operador en problem.operator a node
	devolver (expand-node-action(act, node, problem) para cada act en action-lst)
 ```

### Ejercicio 7

##### Batería de ejemplos

De nuevo, basta con comprobar que el algoritmo usado ordena los elementos dentro de una lista, para lo cual es suficiente el ejemplo dado en el fichero de pruebas, con el que hemos comprobado que sí que funciona correctamente.

##### Comentarios sobre la implementación

En este caso, hemos seguidp la implementación sugerida en el enunciado, de forma que desarrollamos tres funciones.
Una primera, *insert-node*, que utiliza la recursión para insertar un nodo en una lista ordenada según una función *node-compare-p*.
La segunda función, *insert-nodes*, que permite insertar todos los nodos de una lista en otra lista, de forma que la lista destino está ordenada respecto a una función *node-compare-p*.
Y, con estas dos funciones anteriores, la función pedida consiste en llamar a *insert-nodes* usando como función de comparación la definida en la estrategia.

##### Pseudo-código
El pseudo-código de las funciones desarrolladas en este apartado sería entonces:
```
insert-node (node, lst-nodes, node-compare-p):
	si vacio(lst-nodes):
		devolver lista(node)
	si node-compare-p(node, primer_elemento(lst-nodes)):
		devolver concatenar(node, lst-nodes)
	si no:
		devolver concatenar(primer_elemento(lst-nodes), insert-node(node, resto(lst-				nodes), node-compare-p))
		
insert-nodes(nodes, lst-nodes, node-compare-p):
	si vacio(nodes):
		devolver lst-nodes
	si no:
		devolver insert-node(primer_elemento(nodes),
        			insert-nodes(resto(nodes), lst-nodes, node-compare-p),
        			node-compare-p)
        		
insert-nodes-strategy (nodes, lst-nodes, strategy)
	devolver insert-nodes(nodes, lst-nodes, strategy.node-compare-p)
```

### Ejercicio 8