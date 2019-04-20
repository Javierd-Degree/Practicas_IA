(defpackage :2302_P02_b0cdd;
(:use :common-lisp :conecta4)
(:export :heuristica :*alias*))
(in-package 2302_P02_b0cdd)

(defvar *alias* '|Avocado V2|)

(defun comprobar_gana (abajo izq der abajo-der abajo-izq arriba-der arriba-izq)
  (cond ((= (+ arriba-der abajo-izq) 3) t)						;; Completamos una diagonal
    ((= (+ arriba-izq abajo-der) 3) t)							;; Completamos otra diagonal
	((= (+ izq der) 3) t)										;; Completamos la horizontal
	((= abajo 3) t)												;; Completamos la vertical
	(t NIL)))

;; Buscamos que la suma de nuestros puntos cuando ganamos sea mayor que la del oponente cuando gana.
;; Cualquier suma de nuestros puntos cuando NO ganamos, tiene que ser menor que la de nuestro oponente cuando gana.
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
		 (abajo (contar-abajo tablero ficha-actual columna fila))
		 (der (contar-derecha tablero ficha-actual columna fila))
		 (izq (contar-izquierda tablero ficha-actual columna fila))
		 (abajo-der (contar-abajo-derecha tablero ficha-actual columna fila))
		 (arriba-izq (contar-arriba-izquierda tablero ficha-actual columna fila))
		 (abajo-izq (contar-abajo-izquierda tablero ficha-actual columna fila))
		 (arriba-der (contar-arriba-derecha tablero ficha-actual columna fila))
		 (abajo-o (contar-abajo tablero ficha-oponente columna fila))
		 (der-o (contar-derecha tablero ficha-oponente columna fila))
		 (izq-o (contar-izquierda tablero ficha-oponente columna fila))
		 (abajo-der-o (contar-abajo-derecha tablero ficha-oponente columna fila))
		 (arriba-izq-o (contar-arriba-izquierda tablero ficha-oponente columna fila))
		 (abajo-izq-o (contar-abajo-izquierda tablero ficha-oponente columna fila))
		 (arriba-der-o (contar-arriba-derecha tablero ficha-oponente columna fila)))

	(setf puntuacion-actual
		  (+ puntuacion-actual
		 (cond ((and (= fila 0) (= columna 3)) 1500)       					;; Primer movimiento al centro
			   ((and (= fila 0) (or (= columna 2) (= columna 4))) 700)			;; Cerca del centro en los movimientos iniciales	
			   ((= columna 3) 200)												;; Intentamos favorecer posiciones centrales
			   ((or (= columna 2) (= columna 4)) 100)
			   (t 0))
		 (if (comprobar_gana abajo izq der abajo-der abajo-izq arriba-der arriba-izq) ;; Comprobamos si ganaríamos la partida
		   10000 
		   0)	
		 (cond ((= abajo 0) 0)       ;; Priorizamos el caso el caso en el que enemos varias nuestras debajo
			   ((= abajo 1) 10)
			   ((= abajo 2) 200)
			   ((= abajo 3) 10000))
		 (cond ((= der 0) 0)
			   ((= der 1) 10)
			   ((= der 2) 100)
			   ((= der 3) 10000))
		 (cond ((= izq 0) 0)
			   ((= izq 1) 10)
			   ((= izq 2) 100)
			   ((= izq 3) 10000))
		 (cond ((= abajo-izq 0) 0)
			   ((= abajo-izq 1) 10)
			   ((= abajo-izq 2) 100)
			   ((= abajo-izq 3) 10000))
		 (cond ((= abajo-der 0) 0)      ;; Añadimos los otros casos
			   ((= abajo-der 1) 10)
			   ((= abajo-der 2) 100)
			   ((= abajo-der 3) 10000))
		 (cond ((= arriba-izq 0) 0)
			   ((= arriba-izq 1) 10)
			   ((= arriba-izq 2) 100)
			   ((= arriba-izq 3) 10000))
		 (cond ((= arriba-der 0) 0)
			   ((= arriba-der 1) 10)
			   ((= arriba-der 2) 100)
			   ((= arriba-der 3) 10000))))

	(setf puntuacion-oponente
		  (+ puntuacion-oponente												;; En este caso, bajamos las puntuaciones del oponente en casos finales. Preferimos ganar nosotros a que pierda el
		 (cond ((and (= fila 0) (= columna 3)) 1000)       						;; Primer movimiento al centro
			   ((and (= fila 0) (or (= columna 2) (= columna 4))) 500)			;; Cerca del centro en los movimientos iniciales	
			   ((= columna 3) 200)												;; Intentamos favorecer posiciones centrales
			   ((or (= columna 2) (= columna 4)) 100)
			   (t 0))
		 (if (comprobar_gana abajo-o izq-o der-o abajo-der-o abajo-izq-o arriba-der-o arriba-izq-o) ;; Comprobamos si ganaríamos la partida
		   10000 
		   0)
		 (cond ((= abajo-o 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
			   ((= abajo-o 1) 10)
			   ((= abajo-o 2) 200)
			   ((= abajo-o 3) 10000))
		 (cond ((= der-o 0) 0)
			   ((= der-o 1) 10)
			   ((= der-o 2) 100)
			   ((= der-o 3) 10000))
		 (cond ((= izq-o 0) 0)
			   ((= izq-o 1) 10)
			   ((= izq-o 2) 100)
			   ((= izq-o 3) 10000))
		 (cond ((= abajo-izq-o 0) 0)
			   ((= abajo-izq-o 1) 10)
			   ((= abajo-izq-o 2) 100)
			   ((= abajo-izq-o 3) 10000))
		 (cond ((= abajo-der-o 0) 0)      										;; Añadimos los otros casos
			   ((= abajo-der-o 1) 10)
			   ((= abajo-der-o 2) 100)
			   ((= abajo-der-o 3) 10000))
		 (cond ((= arriba-izq-o 0) 0)
			   ((= arriba-izq-o 1) 10)
			   ((= arriba-izq-o 2) 100)
			   ((= arriba-izq-o 3) 10000))
		 (cond ((= arriba-der-o 0) 0)
			   ((= arriba-der-o 1) 10)
			   ((= arriba-der-o 2) 100)
			   ((= arriba-der-o 3) 10000))))))
(cond ((>= puntuacion-actual 10000) 10000)
	((>= puntuacion-oponente 10000) -10000)
	(t (- puntuacion-actual puntuacion-oponente)))))))