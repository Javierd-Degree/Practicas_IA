*Javier Delgado del Cerro y Javier López Cano - Pareja 2*

## Práctica 4

En esta práctica, como teníamos que implementar tres heurísticas distintas para el juego *Conecta 4* propuesto, decidimos dividir el trabajo para así tener más posibilidades de obtener posiciones altas en el ranking. 

Nuestro objetivo era, desarrollar cada uno de nosotros una heurística distinta, asegurándonos que fuesen mejores o iguales a las dadas, y a las desarrolladas anteriormente. De esta forma, la tercera heurística sería la que resultase mejor de entre las dos anteriores en cada uno de los torneos. Esto nos permite poner en común ideas similares sobre posibles estrategias y probar implementaciones distintas para averiguar cuál resultaba ser mejor, teniendo siempre en el ranking el mejor jugador de la etapa anterior, para así poder comparar si realmente nuestro jugador era mejor en general, o solo contra los que habíamos desarrollado nosotros.



### IA 1

En un principio, para hacernos una pequeña idea del funcionamiento de las heurísticas dadas, decidimos basarnos en *f-eval-bueno* para a partir de ahí, tener una base sobre la que hacer modificaciones. Intentamos entonces variar ligeramente los valores, para probar distintas combinaciones, y encontramos que según estos valores podía haber diferencias bastante serias. Decidimos que los para casos decisivos, como tener tres fichas juntas en una dirección, deberían ser mayores para el oponente que para nuestro jugador, de forma que damos preferencia a los estados en los que el jugador opuesto tiene menos probabilidades de ganar.

Una de nuestras prioridades ha sido entonces conseguir que el jugador comience la partida en el centro del tablero, y de más prioridad a dicho centro, pues es más sencillo ganar si empiezas colocando fichas en el centro: más posibilidades de conectar cuatro fichas en horizontal y en diagonal, pues puedes conseguirlo hacia los dos lados. Tras investigar el funcionamiento de la heurística, añadimos, después del *loop* que analiza todas las posiciones del tablero, el código (con valores diferentes):

```commonlisp
(setf puntuacion-actual
	(+ puntuacion-actual 
		(* 2000 (contar-abajo tablero ficha-actual 3 (1- (altura-columna tablero 3))))
		(* 1200 (contar-abajo tablero ficha-actual 4 (1- (altura-columna tablero 4))))
		(* 1200 (contar-abajo tablero ficha-actual 2 (1- (altura-columna tablero 2))))))

(setf puntuacion-oponente
	(+ puntuacion-oponente
		(* 3000 (contar-abajo tablero ficha-oponente 3 (1- (altura-columna tablero 3))))
		(* 1700 (contar-abajo tablero ficha-oponente 4 (1- (altura-columna tablero 4))))
		(* 1700 (contar-abajo tablero ficha-oponente 2 (1- (altura-columna tablero 2))))))
```

Esto nos permite dar más prioridad a las tres filas centrales, y especialmente a la del medio.

Tras esto, decidimos implementar una función que nos permitiese saber, a partir de una posición en un tablero, si hay o no alguna forma de que, colocando una ficha en esa posición, el jugador gane la partida. Esto estaba contemplado en la heurística original únicamente en los casos en que una casilla tiene tres fichas en uno de sus lados o en una de las diagonales, pero no cuando tiene dos a un lado y dos al otro, por ejemplo. Desarrollamos entonces dos funciones distintas:

```commonlisp
(defun comprobar_gana (abajo izq der abajo-der abajo-izq arriba-der arriba-izq)
  (cond ((= (+ arriba-der abajo-izq) 3) t)						
    ((= (+ arriba-izq abajo-der) 3) t)							
	((= (+ izq der) 3) t)										
	((= abajo 3) t)												
	(t NIL)))

(defun comprobar_gana_num (abajo izq der abajo-der abajo-izq arriba-der arriba-izq)
	(+ 0
		(if (>= (+ arriba-der abajo-izq) 3) 1 0)				
		(if (>= (+ arriba-izq abajo-der) 3) 1 0)				
		(if (>= (+ izq der) 3) 1 0)								
		(if (>= abajo 3) 1 0)))		
```

La primera permite saber si se podría completar una linea de cuatro de alguna de las formas expuestas, mientras que la segunda permite cuantificar el número de formas que tendríamos de conectar estas cuatro piezas. Ambas funciones se utilizan dentro del *loop*, sumando un valor a la puntuación del jugador en función del resultado de la función. Así, a mayor número de posibilidades de conectar cuatro casillas en un tablero, mayor puntuación tendría dicho tablero para el jugador. 
Cabe resaltar que tras probar ambas funciones tanto en torneos locales como en el ranking, la segunda resultó ser superior, como era de esperar, por lo que optamos por mantener esta.

Otra de las mejoras que implementamos fue el eliminar la prioridad dada a las columnas centralesuna vez alcanzado un cierto nivel en el tablero, pues es posible que en ese caso convenga colocar las fichas en diagonal por ejemplo, y esta prioridad añadida sería un obstáculo. Desarrollamos para esto la función:

```commonlisp
(defun altura_columnas_medio (tablero)
	(let ((columna-central (>= 2 (1- (altura-columna tablero 3))))
			(columna-izq (>= 2 (1- (altura-columna tablero 2))))
			(columna-der (>= 2 (1- (altura-columna tablero 4)))))
		(or (and columna-central columna-izq)
			(and columna-central columna-izq)
			(and columna-central columna-izq))))
```

y la parte final de la heurística quedaría entonces como:

```commonlisp
(setf puntuacion-actual
	(if (altura_columnas_medio tablero)
		(+ puntuacion-actual 
			(* 2000 (contar-abajo tablero ficha-actual 3 (1- (altura-columna tablero 3))))
			(* 1200 (contar-abajo tablero ficha-actual 4 (1- (altura-columna tablero 4))))
			(* 1200 (contar-abajo tablero ficha-actual 2 (1- (altura-columna tablero 2)))))
		puntuacion-actual))

(setf puntuacion-oponente
	(if (altura_columnas_medio tablero)z
		(+ puntuacion-oponente 
			(* 3000 (contar-abajo tablero ficha-oponente 3 (1- (altura-columna tablero 3))))
			(* 1700 (contar-abajo tablero ficha-oponente 4 (1- (altura-columna tablero 4))))
			(* 1700 (contar-abajo tablero ficha-oponente 2 (1- (altura-columna tablero 2)))))
		puntuacion-oponente))
```





### IA 2

En el caso de la otra IA implementada el primer paso que se dio con esta fue añadir las funciones `vertical`, `horizontal` y similares, que suman las fichas propias en ambos sentidos de la recta correspondiente, para poder saber así exactamente cuantas fichas seguidas se tienen. Estas funciones ya estaban implementadas en el archivo `conecta4.cl` que se nos proporcionaba con otros nombres, sin embargo tuvimos que copiarlas en el archivo de los jugadores y en las heurísticas como funciones auxiliares, puesto que no estaban incluidas en el paquete conecta4 y por tanto no eran accesibles. Al añadir estas funciones añadimos las funciones equivalentes que cuentan diagonales `contar-diagonal-ascendente` y `contar-diagonal-descendente` ya que nos dimos cuenta de que en la implementación del "jugador bueno" que se nos daba como ejemplo no se tenían en cuenta las diagonales y nos pareció una buena mejora para obtener un mejor resultado.

```commonlisp
defun horizontal (tablero ficha columna fila)
  	(-
	  	(+ 	
	  		(contar-derecha tablero ficha columna fila)
	     	(contar-izquierda tablero ficha columna fila))
		1))

(defun vertical (tablero ficha columna fila)
  	(- 	
  		(+ 
  			(contar-abajo tablero ficha columna fila)
     		(contar-arriba tablero ficha columna fila))
  		1))
  
(defun diagonal-ascendente (tablero ficha columna fila)
  	(-	
  		(+ 	
  			(contar-abajo-izquierda tablero ficha columna fila)
     		(contar-arriba-derecha tablero ficha columna fila))
  		1))
  
(defun diagonal-descendente (tablero ficha columna fila)
  	(-	
  		(+ 	
  			(contar-abajo-derecha tablero ficha columna fila)
     		(contar-arriba-izquierda tablero ficha columna fila))
  		1))
```

Tras esto implementamos las funciones que contaban tanto los espacios como las fichas propias disponibles en línea recta desde la posición que se esta analizando. El objetivo de estas funciones es saber en que caso no se dispone de 4 casillas en línea (entre propias y vacías) puesto que si se tienen menos de 4, es imposible conseguir 4 en línea en esa posición concreta, por lo tanto esa "línea" no proporciona ningún beneficio. Estas funciones son `contar-abajo-espacios`, `contar-arriba-espacios`... y todas las análogas en las demás direcciones, que luego se emplean en las funciones `contar-vertical-espacios`, `contar-horizontal-espacios` que de nuevo combinan los resultados de las funciones de ambas direcciones de la misma recta, pues es este el resultado que nos interesa.

```commonlisp
(defun contar-abajo-espacios (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(if (or (eql (obtener-ficha tablero columna fila) ficha) (eql (obtener-ficha tablero columna fila) NIL))
			(contar-abajo-espacios tablero ficha columna (- fila 1) (+ valor 1) (+ num 1))
			valor)))

(defun contar-arriba-espacios (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(if (or (eql (obtener-ficha tablero columna fila) ficha) (eql (obtener-ficha tablero columna fila) NIL))
			(contar-arriba-espacios tablero ficha columna (+ fila 1) (+ valor 1) (+ num 1))
			valor)))

(defun contar-derecha-espacios (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(if (or (eql (obtener-ficha tablero columna fila) ficha) (eql (obtener-ficha tablero columna fila) NIL))
			(contar-derecha-espacios tablero ficha (+ columna 1) fila (+ valor 1) (+ num 1))
			valor)))

(defun contar-izquierda-espacios (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(if (or (eql (obtener-ficha tablero columna fila) ficha) (eql (obtener-ficha tablero columna fila) NIL))
			(contar-izquierda-espacios tablero ficha (- columna 1) fila (+ valor 1) (+ num 1))
			valor)))

(defun contar-arriba-izquierda-espacios (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(if (or (eql (obtener-ficha tablero columna fila) ficha) (eql (obtener-ficha tablero columna fila) NIL))
			(contar-arriba-izquierda-espacios tablero ficha (- columna 1) (+ fila 1) (+ valor 1) (+ num 1))
			valor)))

(defun contar-arriba-derecha-espacios (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(if (or (eql (obtener-ficha tablero columna fila) ficha) (eql (obtener-ficha tablero columna fila) NIL))
			(contar-arriba-derecha-espacios tablero ficha (+ columna 1) (+ fila 1) (+ valor 1) (+ num 1))
			valor)))

(defun contar-abajo-izquierda-espacios (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(if (or (eql (obtener-ficha tablero columna fila) ficha) (eql (obtener-ficha tablero columna fila) NIL)) 
			(contar-abajo-izquierda-espacios tablero ficha (- columna 1) (- fila 1) (+ valor 1) (+ num 1))
			0)))

(defun contar-abajo-derecha-espacios (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(if (or (eql (obtener-ficha tablero columna fila) ficha) (eql (obtener-ficha tablero columna fila) NIL))
			(contar-abajo-derecha-espacios tablero ficha (+ columna 1) (- fila 1) (+ valor 1) (+ num 1))
			valor)))
			
-------------------------------------------------------------------------------------

(defun contar-vertical-espacios (tablero ficha columna fila)
	(- 
		(+ 
			(contar-abajo-espacios tablero ficha columna fila 0 0) 
			(contar-arriba-espacios tablero ficha columna fila 0 0))
		1))

(defun contar-horizontal-espacios (tablero ficha columna fila)
	(- 
		(+ 
			(contar-derecha-espacios tablero ficha columna fila 0 0) 
			(contar-izquierda-espacios tablero ficha columna fila 0 0))
		1))

(defun contar-diagonal-ascendente-espacios (tablero ficha columna fila)
	(- 
		(+ 
			(contar-abajo-izquierda-espacios tablero ficha columna fila 0 0) 
			(contar-arriba-derecha-espacios tablero ficha columna fila 0 0))
		1))

(defun contar-diagonal-descendente-espacios (tablero ficha columna fila)
	(- 
		(+ 
			(contar-abajo-derecha-espacios tablero ficha columna fila 0 0) 
			(contar-arriba-izquierda-espacios tablero ficha columna fila 0 0))
		1))
```

También se han desarrollado para esta segunda IA funciones similares, pero que en esta ocasión cuentan únicamente las fichas propias en una línea ignorando los espacios pero parando si se encuentran una ficha del enemigo. El objetivo de estas funciones es valorar los casos en los que en una misma fila tenemos, por ejemplo, 2 fichas seguidas, luego un espacio, y luego otra ficha. Estos son casos "especiales" que son positivos y permiten realizar jugadas realmente beneficiosas, pero que no se estaban teniendo en cuenta en las funciones anteriores. Para esto implementamos `contar-abajo-e`, `contar-derecha-e`... etc que van recorriendo la recta en la dirección adecuada (en `contar-abajo-e` hacia abajo por ejemplo) y suman 1 cuando encuentran una ficha propia, no suman nada si encuentran una casilla vacía, y dejan de contar (devolviendo el valor calculado) si se encuentran con una ficha del oponente, llegan al final del tablero, o han recorrido ya 4 posiciones desde la posición inicial que se esta analizando (pues pasadas 4 posiciones desde esta ya no tiene ningún beneficio). De nuevo como en las funciones de los tipos anteriores, los resultados de estas funciones se combinan en las funciones `contar-vertical`, ``contar-horizontal` y análogas, que combinan el valor de las funciones que cuentan en las 2 direcciones de la misma recta.

```commonlisp
(defun contar-abajo-e (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(cond 
			((eql (obtener-ficha tablero columna fila) ficha) 
				(contar-abajo-e tablero ficha columna (- fila 1) (+ valor 1) (+ num 1)))
			((eql (obtener-ficha tablero columna fila) NIL) 
				(contar-abajo-e tablero ficha columna (- fila 1) valor (+ num 1)))
			(t 0))))

(defun contar-arriba-e (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(cond 
			((eql (obtener-ficha tablero columna fila) ficha) 
				(contar-arriba-e tablero ficha columna (+ fila 1) (+ valor 1) (+ num 1)))
			((eql (obtener-ficha tablero columna fila) NIL) 
				(contar-arriba-e tablero ficha columna (+ fila 1) valor (+ num 1)))
			(t 0))))

(defun contar-derecha-e (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(cond 
			((eql (obtener-ficha tablero columna fila) ficha) 
				(contar-derecha-e tablero ficha (+ columna 1) fila (+ valor 1) (+ num 1)))
			((eql (obtener-ficha tablero columna fila) NIL) 
				(contar-derecha-e tablero ficha (+ columna 1) fila valor (+ num 1)))
			(t 0))))

(defun contar-izquierda-e (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(cond 
			((eql (obtener-ficha tablero columna fila) ficha) 
				(contar-izquierda-e tablero ficha (- columna 1) fila (+ valor 1) (+ num 1)))
			((eql (obtener-ficha tablero columna fila) NIL) 
				(contar-izquierda-e tablero ficha (- columna 1) fila valor (+ num 1)))
			(t 0))))

(defun contar-arriba-izquierda-e (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(cond 
			((eql (obtener-ficha tablero columna fila) ficha) 
				(contar-arriba-izquierda-e tablero ficha (- columna 1) (+ fila 1) (+ valor 1) (+ num 1)))
			((eql (obtener-ficha tablero columna fila) NIL) 
				(contar-arriba-izquierda-e tablero ficha (- columna 1) (+ fila 1) valor (+ num 1)))
			(t 0))))

(defun contar-arriba-derecha-e (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(cond 
			((eql (obtener-ficha tablero columna fila) ficha) 
				(contar-arriba-derecha-e tablero ficha (+ columna 1) (+ fila 1) (+ valor 1) (+ num 1)))
			((eql (obtener-ficha tablero columna fila) NIL) 
				(contar-arriba-derecha-e tablero ficha (+ columna 1) (+ fila 1) valor (+ num 1)))
			(t 0))))

(defun contar-abajo-izquierda-e (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(cond 
			((eql (obtener-ficha tablero columna fila) ficha) 
				(contar-abajo-izquierda-e tablero ficha (- columna 1) (- fila 1) (+ valor 1) (+ num 1)))
			((eql (obtener-ficha tablero columna fila) NIL) 
				(contar-abajo-izquierda-e tablero ficha (- columna 1) (- fila 1) valor (+ num 1)))
			(t 0))))

(defun contar-abajo-derecha-e (tablero ficha columna fila valor num)
	(if (or (not (dentro-del-tablero-p tablero columna fila)) (= num 4))
		valor
		(cond 
			((eql (obtener-ficha tablero columna fila) ficha) 
				(contar-abajo-derecha-e tablero ficha (+ columna 1) (- fila 1) (+ valor 1) (+ num 1)))
			((eql (obtener-ficha tablero columna fila) NIL) 
				(contar-abajo-derecha-e tablero ficha (+ columna 1) (- fila 1) valor (+ num 1)))
			(t 0))))

-----------------------------------------------------------------------------------------

(defun contar-vertical (tablero ficha columna fila)
	(- 
		(+ 
			(contar-abajo-e tablero ficha columna fila 0 0) 
			(contar-arriba-e tablero ficha columna fila 0 0))
		1))

(defun contar-horizontal (tablero ficha columna fila)
	(- 
		(+ 
			(contar-derecha-e tablero ficha columna fila 0 0) 
			(contar-izquierda-e tablero ficha columna fila 0 0))
		1))

(defun contar-diagonal-ascendente (tablero ficha columna fila)
	(- 
		(+ 
			(contar-abajo-izquierda-e tablero ficha columna fila 0 0) 
			(contar-arriba-derecha-e tablero ficha columna fila 0 0))
		1))

(defun contar-diagonal-descendente (tablero ficha columna fila)
	(- 
		(+ 
			(contar-abajo-derecha-e tablero ficha columna fila 0 0) 
			(contar-arriba-izquierda-e tablero ficha columna fila 0 0))
		1))
```

En todas las funciones de este estilo (las que cuentan fichas, las que cuentan fichas y las que cuentan fichas ignorando espacios) a la hora de "combinar" los resultados de las funciones que corresponden a la misma recta lo que se hace es sumar el valor de ambas y restarle uno, pues las funciones comienzan en la misma posición, y por tanto hay que restarle el "1" que se añadiría en esa posición pues de lo contrario lo estaríamos añadiendo 2 veces. 

La última modificación que se ha realizado a esta IA en la heurística es añadir un condicional que aumenta  la "puntuación" o el "valor" que se le da a un determinado tablero en función de las columnas, es decir, que haga que se de un mayor valor a las columnas centrales que a las laterales. Para ello se emplea el bucle mostrado a continuación:

```commonlisp
(if (not (dentro-del-tablero-p tablero columna fila))
		      		0
			      	(+
			      		(if (and (= columna 3) (eql (obtener-ficha tablero columna fila) ficha-oponente))
		      				500
		      				0)
		      			(if (and (= columna 2) (eql (obtener-ficha tablero columna fila) ficha-oponente))
		      				200
		      				0)
		      			(if (and (= columna 4) (eql (obtener-ficha tablero columna fila) ficha-oponente))
		      				200
		      				0)
		      			(if (and (= columna 1) (eql (obtener-ficha tablero columna fila) ficha-oponente))
		      				100
		      				0)
		      			(if (and (= columna 5) (eql (obtener-ficha tablero columna fila) ficha-oponente))
		      				100
		      				0)))
```

En un momento dado nos planteamos que, para asegurarnos de que siempre comenzase jugando en la columna central, podríamos añadir algunas líneas de código que nos diesen una puntuación "extra" si el jugador poseía la casilla de columna 3 y fila 0, sin embargo esta opción se acabó descartando pues descubrimos que, si se ajustaban correctamente los valores del condicional que aumenta el valor de las columnas centrales, se conseguía que la IA comenzase en la columna central in necesidad de añadir esta "puntuación extra", y que entonces esta no aportaba ningún beneficio.

Finalmente la función heurística de esta IA  aplica estas funciones a las posiciones más altas ocupadas de cada columna del tablero y asigna un "valor" o "puntuación" al valor que devuelven estas funciones, sumando por un lado, las puntuaciones del jugador, y por otro las del oponente, y, tras esto resta las propias menos las del oponente y devuelve este valor, del mismo modo que la heurística . De modo que la función `negamax` del archivo conecta4.cl selecciona la jugada que mayor puntuación dé al jugador de la IA.

```commonlisp
(defun heuristica (estado)
; current player standpoint
  (let* ((tablero (estado-tablero estado))
	 (ficha-actual (estado-turno estado))
	 (ficha-oponente (siguiente-jugador ficha-actual)))
    (if (juego-terminado-p estado)
	(let ((ganador (ganador estado)))
	  (cond ((not ganador) 0)
		((eql ganador ficha-actual) +val-max+)
		(t +val-min+)))
      (let ((puntuacion-actual 0)
	    (puntuacion-oponente 0))
	(loop for columna from 0 below (tablero-ancho tablero) do
	      (let* ((altura (altura-columna tablero columna))
		     (fila (1- altura))
		     (contar-v (contar-vertical tablero ficha-actual columna fila))
		     (contar-h (contar-horizontal tablero ficha-actual columna fila))
		     (contar-da (contar-diagonal-ascendente tablero ficha-actual columna fila))
		     (contar-dd	(contar-diagonal-descendente tablero ficha-actual columna fila))
		     (esp-v (contar-vertical-espacios tablero ficha-actual columna fila))
		     (esp-h	(contar-horizontal-espacios tablero ficha-actual columna fila))
		     (esp-da (contar-diagonal-ascendente-espacios tablero ficha-actual columna fila))
		     (esp-dd (contar-diagonal-descendente-espacios tablero ficha-actual columna fila))
		     (ver (vertical tablero ficha-actual columna fila))
		     (hor (horizontal tablero ficha-actual columna fila))
		     (diag-asc (diagonal-ascendente tablero ficha-actual columna fila))
		     (diag-des (diagonal-descendente tablero ficha-actual columna fila)))
		(setf puntuacion-actual
		      (+ puntuacion-actual
		      	(if (eql (obtener-ficha tablero 3 0) ficha-actual)
		      		1000
		      		0)
		      	(if (not (dentro-del-tablero-p tablero columna fila))
		      		0
			      	(+
			      		(if (and (= columna 3) (eql (obtener-ficha tablero columna fila) ficha-actual))
		      				500
		      				0)
		      			(if (and (= columna 2) (eql (obtener-ficha tablero columna fila) ficha-actual))
		      				200
		      				0)
		      			(if (and (= columna 4) (eql (obtener-ficha tablero columna fila) ficha-actual))
		      				200
		      				0)
		      			(if (and (= columna 1) (eql (obtener-ficha tablero columna fila) ficha-actual))
		      				100
		      				0)
		      			(if (and (= columna 5) (eql (obtener-ficha tablero columna fila) ficha-actual))
		      				100
		      				0)))

		      	(if (< esp-v 4)
		      		0
		      		(+
			      		(cond ((= ver 0) 0)
				       		((= ver 1) 10)
				       		((= ver 2) 300)
				       		((= ver 3) 1000))
			      		(* contar-v 50)))

		      	(if (< esp-h 4)
		      		0
		      		(+
			      		(cond ((= hor 0) 0)
				       		((= hor 1) 10)
				       		((= hor 2) 300)
				       		((= hor 3) 1000))
			      		(* contar-h 50)))

		      	(if (< esp-da 4)
		      		0
		      		(+
			      		(cond ((= diag-asc 0) 0)
				       		((= diag-asc 1) 10)
				       		((= diag-asc 2) 300)
				       		((= diag-asc 3) 1000))
			      		(* contar-da 50)))

		      	(if (< esp-dd 4)
		      		0
		      		(+
			      		(cond ((= diag-des 0) 0)
				       		((= diag-des 1) 10)
				       		((= diag-des 2) 300)
				       		((= diag-des 3) 1000))
			      		(* contar-dd 50))))))
	      (let* ((altura (altura-columna tablero columna))
		     (fila (1- altura))
		     (contar-v (contar-vertical tablero ficha-oponente columna fila))
		     (contar-h (contar-horizontal tablero ficha-oponente columna fila))
		     (contar-da (contar-diagonal-ascendente tablero ficha-oponente columna fila))
		     (contar-dd	(contar-diagonal-descendente tablero ficha-oponente columna fila))
		     (esp-v (contar-vertical-espacios tablero ficha-oponente columna fila))
		     (esp-h	(contar-horizontal-espacios tablero ficha-oponente columna fila))
		     (esp-da (contar-diagonal-ascendente-espacios tablero ficha-oponente columna fila))
		     (esp-dd (contar-diagonal-descendente-espacios tablero ficha-oponente columna fila))
		     (ver (vertical tablero ficha-oponente columna fila))
		     (hor (horizontal tablero ficha-oponente columna fila))
		     (diag-asc (diagonal-ascendente tablero ficha-oponente columna fila))
		     (diag-des (diagonal-descendente tablero ficha-oponente columna fila)))
		(setf puntuacion-oponente
		      (+ puntuacion-oponente
		      	(if (not (dentro-del-tablero-p tablero columna fila))
		      		0
			      	(+
			      		(if (and (= columna 3) (eql (obtener-ficha tablero columna fila) ficha-oponente))
		      				500
		      				0)
		      			(if (and (= columna 2) (eql (obtener-ficha tablero columna fila) ficha-oponente))
		      				200
		      				0)
		      			(if (and (= columna 4) (eql (obtener-ficha tablero columna fila) ficha-oponente))
		      				200
		      				0)
		      			(if (and (= columna 1) (eql (obtener-ficha tablero columna fila) ficha-oponente))
		      				100
		      				0)
		      			(if (and (= columna 5) (eql (obtener-ficha tablero columna fila) ficha-oponente))
		      				100
		      				0)))
		      	(if (< esp-v 4)
		      		0
		      		(+
			      		(cond ((= ver 0) 0)
				       		((= ver 1) 10)
				       		((= ver 2) 300)
				       		((= ver 3) 1000))
			      		(* contar-v 50)))

		      	(if (< esp-h 4)
		      		0
		      		(+
			      		(cond ((= hor 0) 0)
				       		((= hor 1) 10)
				       		((= hor 2) 300)
				       		((= hor 3) 1000))
			      		(* contar-h 50)))

		      	(if (< esp-da 4)
		      		0
		      		(+
			      		(cond ((= diag-asc 0) 0)
				       		((= diag-asc 1) 10)
				       		((= diag-asc 2) 300)
				       		((= diag-asc 3) 1000))
			      		(* contar-da 50)))

		      	(if (< esp-dd 4)
		      		0
		      		(+
			      		(cond ((= diag-des 0) 0)
				       		((= diag-des 1) 10)
				       		((= diag-des 2) 300)
				       		((= diag-des 3) 1000))
			      		(* contar-dd 50)))))))		 
	(- puntuacion-actual puntuacion-oponente)))))
```

Sobre esta función `heurística` es interesante comentar que cuando calculamos las "puntuaciones" de los jugadores, tenemos en cuenta las variables "esp" (`esp-v`, `esp-h`, `esp-da` y `esp-dd`), simplemente comprobando si son menores que cuatro, y, si lo son, no sumamos ninguna puntuación por las combinaciones de fichas que se tienen en esa línea. Esto se debe a que estas variables indican el resultado de las funciones que cuentan solo los espacios vacíos (`contar-horizontal-espacios`, `contar-vertical-espacios`...) y por tanto simplemente queremos que si el número de espacios en esa recta es mejor que 4 no tenga en cuenta la puntuación de esa línea pues no hay posibilidad de una combinación.

Básicamente, como he explicado anteriormente, se da un "valor" o "puntuación" al tablero dependiendo del resultado de las funciones implementadas. El valor que se asigna al resultado de cada una de las funciones se ha decidido, en primer lugar por lógica, y tras esto se ha ido modificando y perfeccionando mediante "prueba-error", es decir, subiendo versiones con distintos valores al torneo y viendo cuales tenían un mejor resultado, hasta que finalmente hemos decidido quedarnos con los mostrados en el código.

Por último cabe destacar que tras varias pruebas subiendo distintas versiones de esta IA al torneo, nos dimos cuenta de que esta mostraba un mejor rendimiento si, a diferencia de la otra IA, se daba un "valor" o "puntuación" igual al oponente que al jugador propio. Es decir, vale lo mismo que el jugador propio tenga 3 fichas seguidas, que si esas 3 fichas seguidas las tiene el contrario (pero con signo opuesto). En este caso por tanto, no se da preferencia a evitar que el oponente haga jugadas óptimas,  sino que se juega de forma equilibrada entre evitar jugadas del oponente y desarrollar jugadas propias.

##### Análisis de IA 2

En general creemos que esta IA, muestra un buen rendimiento en cuanto a priorizar las columnas centrales y a mostrar una clara facilidad para realizar combinaciones en todas las direcciones posibles. Sin embargo, al probarla contra varias IAs notamos que tiene ciertas dificultades a la hora de evitar que el oponente consiga buenas combinaciones (probablemente por haber decidido no dar prioridad a perjudicar al rival, aunque en el torneo esto ofrecía un mayor rendimiento).

Este, sería por tanto el principal punto débil a solucionar en esta IA, y, estamos seguros que, con un mayor número de enfrentamientos para poder analizar la IA con más detalle, así como con un mayor tiempo a nuestra disposición, podríamos haber hallado unos "valores" más adecuados para la heurística que hubiesen solucionado o mitigado este "punto débil".



### Conclusión

El principal problema que hemos tenido ha sido la falta de tiempo para probar correctamente las heurísticas en el ranking. En alguna ocasión han transcurrido más de 48 horas entre torneo y torneo, lo que nos impedía probar correctamente los jugadores para mejorarlos lo más rápido posible. Una mayor asiduidad en los torneos habría hecho posible un desarrollo mucho más rápido de las IAs pues nos habría dado muchas más oportunidades de "prueba-error" para experimentar con los valores y las funciones auxiliares de las heurísticas, permitiéndonos hacer un mayor análisis de lo que funciona para el juego, y lo que no es beneficioso. Además nos habría permitido realizar muchas mas pruebas con los valores que se da a la heurística pues probablemente simplemente cambiando los pesos de los distintos factores de la heurística podríamos haber conseguido valores muy superiores.