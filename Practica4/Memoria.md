*Javier Delgado del Cerro y Javier López Cano - Pareja 2*

## Práctica 4

En esta práctica, como teníamos que implementar tres heurísticas distintas para el juego *Conecta 4* propuesto, decidimos dividir el trabajo para así tener más posibilidades de obtener posiciones altas en el ranking. 

Nuestro objetivo era, desarrollar cada uno de nosotros una heurística distinta, asegurándonos que fuesen mejores o iguales a las dadas, y a las desarrolladas anteriormente. De esta forma, la tercera heurística sería la que resultase mejor de entre las dos anteriores en cada uno de los torneos. Esto nos permite poner en común ideas similares sobre posibles estrategias y probar implementaciones distintas para averiguar cuál resultaba ser mejor, teniendo siempre en el ranking el mejor jugador de la etapa anterior, para así poder comparar si realmente nuestro jugador era mejor en general, o solo contra los que habíamos desarrollado nosotros.

En un principio, y hacernos una pequeña idea del funcionamiento de las heurísticas dadas, decidimos basarnos en *f-eval-bueno* para a partir de ahí, tener una base sobre la que hacer modificaciones. Intentamos entonces variar ligeramente los valores, para probar distintas combinaciones, y encontramos que según estos valores podía haber diferencias bastante serias. Decidimos que los para casos decisivos, como tener tres fichas juntas en una dirección, deberían ser mayores para el oponente que para nuestro jugador, de forma que damos preferencia a los estados en los que el jugador opuesto tiene menos probabilidades de ganar.

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
	(if (altura_columnas_medio tablero)
		(+ puntuacion-oponente 
			(* 3000 (contar-abajo tablero ficha-oponente 3 (1- (altura-columna tablero 3))))
			(* 1700 (contar-abajo tablero ficha-oponente 4 (1- (altura-columna tablero 4))))
			(* 1700 (contar-abajo tablero ficha-oponente 2 (1- (altura-columna tablero 2)))))
		puntuacion-oponente))
```









El principal problema que hemos tenido ha sido la falta de tiempo para probar correctamente las heurísticas en el ranking. En alguna ocasión han transcurrido más de 48 horas entre torneo y torneo, lo que nos impedía probar correctamente los jugadores para mejorarlos lo más rápido posible. Probablemente simplemente cambiando los pesos de los distintos factores de la heurística podríamos haber conseguido valores muy superiores.