(use-package 'conecta4)

(declaim #+sbcl(sb-ext:muffle-conditions style-warning))

;; -------------------------------------------------------------------------------
;; Funciones de evaluación
;; -------------------------------------------------------------------------------

(defun f-eval-bueno (estado)
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
		     (arriba-der (contar-arriba-derecha tablero ficha-actual columna fila)))
		(setf puntuacion-actual
		      (+ puntuacion-actual
			 (cond ((= abajo 0) 0)
			       ((= abajo 1) 10)
			       ((= abajo 2) 100)
			       ((= abajo 3) 1000))
			 (cond ((= der 0) 0)
			       ((= der 1) 10)
			       ((= der 2) 100)
			       ((= der 3) 1000))
			 (cond ((= izq 0) 0)
			       ((= izq 1) 10)
			       ((= izq 2) 100)
			       ((= izq 3) 1000))
			 (cond ((= abajo-izq 0) 0)
			       ((= abajo-izq 1) 10)
			       ((= abajo-izq 2) 100)
			       ((= abajo-izq 3) 1000)))))
	      (let* ((altura (altura-columna tablero columna))
		     (fila (1- altura))
		     (abajo (contar-abajo tablero ficha-oponente columna fila))
		     (der (contar-derecha tablero ficha-oponente columna fila))
		     (izq (contar-izquierda tablero ficha-oponente columna fila))
		     (abajo-der (contar-abajo-derecha tablero ficha-oponente columna fila))
		     (arriba-izq (contar-arriba-izquierda tablero ficha-oponente columna fila))
		     (abajo-izq (contar-abajo-izquierda tablero ficha-oponente columna fila))
		     (arriba-der (contar-arriba-derecha tablero ficha-oponente columna fila)))
		(setf puntuacion-oponente
		      (+ puntuacion-oponente
			 (cond ((= abajo 0) 0)
			       ((= abajo 1) 10)
			       ((= abajo 2) 100)
			       ((= abajo 3) 1000))
			 (cond ((= der 0) 0)
			       ((= der 1) 10)
			       ((= der 2) 100)
			       ((= der 3) 1000))
			 (cond ((= izq 0) 0)
			       ((= izq 1) 10)
			       ((= izq 2) 100)
			       ((= izq 3) 1000))
			 (cond ((= abajo-izq 0) 0)
			       ((= abajo-izq 1) 10)
			       ((= abajo-izq 2) 100)
			       ((= abajo-izq 3) 1000))))))
	(- puntuacion-actual puntuacion-oponente)))))

(defun f-eval-mod (estado)
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
	(puntuacion-oponente 0)
	(puntuacion-min +val-max+))
(loop for columna from 0 below (tablero-ancho tablero) do
	  (let* ((altura (altura-columna tablero columna))
		 (fila (1- altura))
		 (abajo (contar-abajo tablero ficha-actual columna fila))
		 (der (contar-derecha tablero ficha-actual columna fila))
		 (izq (contar-izquierda tablero ficha-actual columna fila))
		 (abajo-der (contar-abajo-derecha tablero ficha-actual columna fila))
		 (arriba-izq (contar-arriba-izquierda tablero ficha-actual columna fila))
		 (abajo-izq (contar-abajo-izquierda tablero ficha-actual columna fila))
		 (arriba-der (contar-arriba-derecha tablero ficha-actual columna fila)))
	(setf puntuacion-actual
		  (+
		 (cond ((= abajo 0) 0)       ;; Priorizamos el caso el caso en el que enemos varias nuestras debajo
			   ((= abajo 1) 10)
			   ((= abajo 2) 200)
			   ((= abajo 3) 4000))
		 (cond ((= der 0) 0)
			   ((= der 1) 10)
			   ((= der 2) 100)
			   ((= der 3) 1000))
		 (cond ((= izq 0) 0)
			   ((= izq 1) 10)
			   ((= izq 2) 100)
			   ((= izq 3) 1000))
		 (cond ((= abajo-izq 0) 0)
			   ((= abajo-izq 1) 10)
			   ((= abajo-izq 2) 100)
			   ((= abajo-izq 3) 1000))
		 (cond ((= abajo-der 0) 0)      ;; Añadimos los otros casos
			   ((= abajo-der 1) 10)
			   ((= abajo-der 2) 100)
			   ((= abajo-der 3) 1000))
		 (cond ((= arriba-izq 0) 0)
			   ((= arriba-izq 1) 10)
			   ((= arriba-izq 2) 100)
			   ((= arriba-izq 3) 1000))
		 (cond ((= arriba-der 0) 0)
			   ((= arriba-der 1) 10)
			   ((= arriba-der 2) 100)
			   ((= arriba-der 3) 1000)))))
	  (let* ((altura (altura-columna tablero columna))
		 (fila (1- altura))
		 (abajo (contar-abajo tablero ficha-oponente columna fila))
		 (der (contar-derecha tablero ficha-oponente columna fila))
		 (izq (contar-izquierda tablero ficha-oponente columna fila))
		 (abajo-der (contar-abajo-derecha tablero ficha-oponente columna fila))
		 (arriba-izq (contar-arriba-izquierda tablero ficha-oponente columna fila))
		 (abajo-izq (contar-abajo-izquierda tablero ficha-oponente columna fila))
		 (arriba-der (contar-arriba-derecha tablero ficha-oponente columna fila)))
	(setf puntuacion-oponente
		  (+
		 (cond ((= abajo 0) 0)       ;; Si el contrario va a ganar, aumentamos su puntuacion
			   ((= abajo 1) 10)
			   ((= abajo 2) 200)
			   ((= abajo 3) 6000))
		 (cond ((= der 0) 0)
			   ((= der 1) 10)
			   ((= der 2) 100)
			   ((= der 3) 2000))
		 (cond ((= izq 0) 0)
			   ((= izq 1) 10)
			   ((= izq 2) 100)
			   ((= izq 3) 2000))
		 (cond ((= abajo-izq 0) 0)
			   ((= abajo-izq 1) 10)
			   ((= abajo-izq 2) 100)
			   ((= abajo-izq 3) 2000))
		 (cond ((= abajo-der 0) 0)      ;; Añadimos los otros casos
			   ((= abajo-der 1) 10)
			   ((= abajo-der 2) 100)
			   ((= abajo-der 3) 2000))
		 (cond ((= arriba-izq 0) 0)
			   ((= arriba-izq 1) 10)
			   ((= arriba-izq 2) 100)
			   ((= arriba-izq 3) 2000))
		 (cond ((= arriba-der 0) 0)
			   ((= arriba-der 1) 10)
			   ((= arriba-der 2) 100)
			   ((= arriba-der 3) 2000)))))
	(if (< (- puntuacion-actual puntuacion-oponente) puntuacion-min)
		(setf puntuacion-min (- puntuacion-actual puntuacion-oponente))))
	puntuacion-min))))

(defun anacardo (estado)
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
		 (arriba-der (contar-arriba-derecha tablero ficha-actual columna fila)))
	(setf puntuacion-actual
		  (+ puntuacion-actual
		 (cond ((= abajo 0) 0)       ;; Priorizamos el caso el caso en el que enemos varias nuestras debajo
			   ((= abajo 1) 10)
			   ((= abajo 2) 200)
			   ((= abajo 3) 4000))
		 (cond ((= der 0) 0)
			   ((= der 1) 10)
			   ((= der 2) 100)
			   ((= der 3) 1000))
		 (cond ((= izq 0) 0)
			   ((= izq 1) 10)
			   ((= izq 2) 100)
			   ((= izq 3) 1000))
		 (cond ((= abajo-izq 0) 0)
			   ((= abajo-izq 1) 10)
			   ((= abajo-izq 2) 100)
			   ((= abajo-izq 3) 1000))
	 (cond ((= abajo-der 0) 0)      ;; Añadimos los otros casos
		   ((= abajo-der 1) 10)
		   ((= abajo-der 2) 100)
		   ((= abajo-der 3) 1000))
	 (cond ((= arriba-izq 0) 0)
		   ((= arriba-izq 1) 10)
		   ((= arriba-izq 2) 100)
		   ((= arriba-izq 3) 1000))
	 (cond ((= arriba-der 0) 0)
		   ((= arriba-der 1) 10)
		   ((= arriba-der 2) 100)
		   ((= arriba-der 3) 1000)))))
	  (let* ((altura (altura-columna tablero columna))
		 (fila (1- altura))
		 (abajo (contar-abajo tablero ficha-oponente columna fila))
		 (der (contar-derecha tablero ficha-oponente columna fila))
		 (izq (contar-izquierda tablero ficha-oponente columna fila))
		 (abajo-der (contar-abajo-derecha tablero ficha-oponente columna fila))
		 (arriba-izq (contar-arriba-izquierda tablero ficha-oponente columna fila))
		 (abajo-izq (contar-abajo-izquierda tablero ficha-oponente columna fila))
		 (arriba-der (contar-arriba-derecha tablero ficha-oponente columna fila)))
	(setf puntuacion-oponente
		  (+ puntuacion-oponente
		 (cond ((= abajo 0) 0)       ;; Si el contrario va a ganar, aumentamos su puntuacion
			   ((= abajo 1) 10)
			   ((= abajo 2) 200)
			   ((= abajo 3) 6000))
		 (cond ((= der 0) 0)
			   ((= der 1) 10)
			   ((= der 2) 100)
			   ((= der 3) 2000))
		 (cond ((= izq 0) 0)
			   ((= izq 1) 10)
			   ((= izq 2) 100)
			   ((= izq 3) 2000))
		 (cond ((= abajo-izq 0) 0)
			   ((= abajo-izq 1) 10)
			   ((= abajo-izq 2) 100)
			   ((= abajo-izq 3) 2000))
	 (cond ((= abajo-der 0) 0)      ;; Añadimos los otros casos
		   ((= abajo-der 1) 10)
		   ((= abajo-der 2) 100)
		   ((= abajo-der 3) 2000))
	 (cond ((= arriba-izq 0) 0)
		   ((= arriba-izq 1) 10)
		   ((= arriba-izq 2) 100)
		   ((= arriba-izq 3) 2000))
	 (cond ((= arriba-der 0) 0)
		   ((= arriba-der 1) 10)
		   ((= arriba-der 2) 100)
		   ((= arriba-der 3) 2000))))))
(- puntuacion-actual puntuacion-oponente)))))


(defun comprobar_gana_num (abajo izq der abajo-der abajo-izq arriba-der arriba-izq)
	(+ 0
		(if (>= (+ arriba-der abajo-izq) 3) 1 0)				;; Completamos una diagonal
		(if (>= (+ arriba-izq abajo-der) 3) 1 0)				;; Completamos otra diagonal
		(if (>= (+ izq der) 3) 1 0)								;; Completamos la horizontal
		(if (>= abajo 3) 1 0)))									;; Completamos la vertical

(defun comprobar_gana (abajo izq der abajo-der abajo-izq arriba-der arriba-izq)
  (cond ((= (+ arriba-der abajo-izq) 3) t)						;; Completamos una diagonal
    ((= (+ arriba-izq abajo-der) 3) t)							;; Completamos otra diagonal
	((= (+ izq der) 3) t)										;; Completamos la horizontal
	((= abajo 3) t)												;; Completamos la vertical
	(t NIL)))


;; Buscamos que la suma de nuestros puntos cuando ganamos sea mayor que la del oponente cuando gana.
;; Cualquier suma de nuestros puntos cuando NO ganamos, tiene que ser menor que la de nuestro oponente cuando gana.

(defun avocado01 (estado)
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
			   ((= arriba-der-o 3) 10000))))

	))

(setf puntuacion-actual																;; Lo ideal colocar las fichas más cerca del centro
	(+ puntuacion-actual 
		(* 10000 (contar-abajo tablero ficha-actual 3 (1- (altura-columna tablero 3))))
		(* 5000 (contar-abajo tablero ficha-actual 4 (1- (altura-columna tablero 4))))
		(* 5000 (contar-abajo tablero ficha-actual 2 (1- (altura-columna tablero 2))))))

(setf puntuacion-oponente																;; Lo ideal colocar las fichas más cerca del centro
	(+ puntuacion-oponente
		(* 10000 (contar-abajo tablero ficha-oponente 3 (1- (altura-columna tablero 3))))
		(* 5000 (contar-abajo tablero ficha-oponente 4 (1- (altura-columna tablero 4))))
		(* 5000 (contar-abajo tablero ficha-oponente 2 (1- (altura-columna tablero 2))))))

;(print "DEBUG")
;(muestra-tablero tablero)
;(format t "Fichas centrales jugador: ~S ~%" (contar-abajo tablero ficha-actual 3 (1- (altura-columna tablero 3))))
;(format t "Fichas centrales oponente: ~S ~%" (contar-abajo tablero ficha-oponente 3 (1- (altura-columna tablero 3))))
;(format t "Jugador: ~S  Puntuacion: ~S  Oponente: ~S  Final: ~S" ficha-actual puntuacion-actual puntuacion-oponente (- puntuacion-actual puntuacion-oponente))
;(print "FIN DEBUG")

(- puntuacion-actual puntuacion-oponente)))))

(defun avocado02 (estado)
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
		 (* (comprobar_gana_num abajo izq der abajo-der abajo-izq arriba-der arriba-izq) 10000) ;; Posibilidades de ganar la partida
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
		 (* (comprobar_gana_num abajo-o izq-o der-o abajo-der-o abajo-izq-o arriba-der-o arriba-izq-o) 10000) ;; Posibilidades de ganar la partida
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
			   ((= arriba-der-o 3) 10000))))

	))

(setf puntuacion-actual																;; Lo ideal colocar las fichas más cerca del centro
	(+ puntuacion-actual 
		(* 4000 (contar-abajo tablero ficha-actual 3 (1- (altura-columna tablero 3))))
		(* 2500 (contar-abajo tablero ficha-actual 4 (1- (altura-columna tablero 4))))
		(* 2500 (contar-abajo tablero ficha-actual 2 (1- (altura-columna tablero 2))))))

(setf puntuacion-oponente																;; Lo ideal colocar las fichas más cerca del centro
	(+ puntuacion-oponente
		(* 4000 (contar-abajo tablero ficha-oponente 3 (1- (altura-columna tablero 3))))
		(* 2500 (contar-abajo tablero ficha-oponente 4 (1- (altura-columna tablero 4))))
		(* 2500 (contar-abajo tablero ficha-oponente 2 (1- (altura-columna tablero 2))))))

;(print "DEBUG")
;(muestra-tablero tablero)
;(format t "Fichas centrales jugador: ~S ~%" (contar-abajo tablero ficha-actual 3 (1- (altura-columna tablero 3))))
;(format t "Fichas centrales oponente: ~S ~%" (contar-abajo tablero ficha-oponente 3 (1- (altura-columna tablero 3))))
;(format t "Jugador: ~S  Puntuacion: ~S  Oponente: ~S  Final: ~S" ficha-actual puntuacion-actual puntuacion-oponente (- puntuacion-actual puntuacion-oponente))
;(print "FIN DEBUG")

(- puntuacion-actual puntuacion-oponente)))))


(defun avocado (estado)
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
		 (arriba-der (contar-arriba-derecha tablero ficha-actual columna fila)))
	(setf puntuacion-actual
		  (+ puntuacion-actual
		  (* (comprobar_gana_num abajo izq der abajo-der abajo-izq arriba-der arriba-izq) 4000) ;; Posibilidades de ganar la partida
		 (cond ((= abajo 0) 0)       ;; Priorizamos el caso el caso en el que enemos varias nuestras debajo
			   ((= abajo 1) 10)
			   ((= abajo 2) 200)
			   ((= abajo 3) 4000))
		 (cond ((= der 0) 0)
			   ((= der 1) 10)
			   ((= der 2) 100)
			   ((= der 3) 1000))
		 (cond ((= izq 0) 0)
			   ((= izq 1) 10)
			   ((= izq 2) 100)
			   ((= izq 3) 1000))
		 (cond ((= abajo-izq 0) 0)
			   ((= abajo-izq 1) 10)
			   ((= abajo-izq 2) 100)
			   ((= abajo-izq 3) 1000))
	 (cond ((= abajo-der 0) 0)      ;; Añadimos los otros casos
		   ((= abajo-der 1) 10)
		   ((= abajo-der 2) 100)
		   ((= abajo-der 3) 1000))
	 (cond ((= arriba-izq 0) 0)
		   ((= arriba-izq 1) 10)
		   ((= arriba-izq 2) 100)
		   ((= arriba-izq 3) 1000))
	 (cond ((= arriba-der 0) 0)
		   ((= arriba-der 1) 10)
		   ((= arriba-der 2) 100)
		   ((= arriba-der 3) 1000)))))
	  (let* ((altura (altura-columna tablero columna))
		 (fila (1- altura))
		 (abajo (contar-abajo tablero ficha-oponente columna fila))
		 (der (contar-derecha tablero ficha-oponente columna fila))
		 (izq (contar-izquierda tablero ficha-oponente columna fila))
		 (abajo-der (contar-abajo-derecha tablero ficha-oponente columna fila))
		 (arriba-izq (contar-arriba-izquierda tablero ficha-oponente columna fila))
		 (abajo-izq (contar-abajo-izquierda tablero ficha-oponente columna fila))
		 (arriba-der (contar-arriba-derecha tablero ficha-oponente columna fila)))
	(setf puntuacion-oponente
		  (+ puntuacion-oponente
		 (* (comprobar_gana_num abajo izq der abajo-der abajo-izq arriba-der arriba-izq) 6000) ;; Posibilidades de ganar la partida
		 (cond ((= abajo 0) 0)       ;; Si el contrario va a ganar, aumentamos su puntuacion
			   ((= abajo 1) 10)
			   ((= abajo 2) 200)
			   ((= abajo 3) 6000))
		 (cond ((= der 0) 0)
			   ((= der 1) 10)
			   ((= der 2) 100)
			   ((= der 3) 2000))
		 (cond ((= izq 0) 0)
			   ((= izq 1) 10)
			   ((= izq 2) 100)
			   ((= izq 3) 2000))
		 (cond ((= abajo-izq 0) 0)
			   ((= abajo-izq 1) 10)
			   ((= abajo-izq 2) 100)
			   ((= abajo-izq 3) 2000))
	 (cond ((= abajo-der 0) 0)      ;; Añadimos los otros casos
		   ((= abajo-der 1) 10)
		   ((= abajo-der 2) 100)
		   ((= abajo-der 3) 2000))
	 (cond ((= arriba-izq 0) 0)
		   ((= arriba-izq 1) 10)
		   ((= arriba-izq 2) 100)
		   ((= arriba-izq 3) 2000))
	 (cond ((= arriba-der 0) 0)
		   ((= arriba-der 1) 10)
		   ((= arriba-der 2) 100)
		   ((= arriba-der 3) 2000))))))

(setf puntuacion-actual																;; Lo ideal colocar las fichas más cerca del centro
	(+ puntuacion-actual 
		(* 2000 (contar-abajo tablero ficha-actual 3 (1- (altura-columna tablero 3))))
		(* 1200 (contar-abajo tablero ficha-actual 4 (1- (altura-columna tablero 4))))
		(* 1200 (contar-abajo tablero ficha-actual 2 (1- (altura-columna tablero 2))))))

(setf puntuacion-oponente																;; Lo ideal colocar las fichas más cerca del centro
	(+ puntuacion-oponente
		(* 3000 (contar-abajo tablero ficha-oponente 3 (1- (altura-columna tablero 3))))
		(* 1700 (contar-abajo tablero ficha-oponente 4 (1- (altura-columna tablero 4))))
		(* 1700 (contar-abajo tablero ficha-oponente 2 (1- (altura-columna tablero 2))))))

(- puntuacion-actual puntuacion-oponente)))))

(defun prueba (estado)
; current player standpoint
(let* ((tablero (estado-tablero estado))
 (columna-central (floor (/ (tablero-ancho tablero) 2)))
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
		 (izq (contar-izquierda tablero ficha-actual columna fila)))

	(setf puntuacion-actual
		  (+ puntuacion-actual
		 (cond ((= columna columna-central) 1500)       					;; Primer movimiento al centro
			   (t 0))))

	(format t "C: ~S R: ~S. Abajo: ~S  Der: ~S  Izq: ~S ~%" columna fila abajo der izq)

	))

	(print "DEBUG")
	(muestra-tablero tablero)
	(print ficha-actual)
	(print puntuacion-actual)
	(print columna-central)
	(print "FIN DEBUG")
puntuacion-actual))))

(defun prueba2 (estado)
; current player standpoint
(let* ((tablero (estado-tablero estado))
	(columna-central (floor (/ (tablero-ancho tablero) 2)))
	(ficha-actual (estado-turno estado)))
	(print "DEBUG")
	(muestra-tablero tablero)
	(print (contar-arriba tablero ficha-actual columna-central 0))
	(print "FIN DEBUG")
	(contar-arriba tablero ficha-actual columna-central 0)))

;; -------------------------------------------------------------------------------
;; Jugadores
;; -------------------------------------------------------------------------------

(defvar *jugador-aleatorio* (make-jugador :nombre 'Jugador-aleatorio
					  :f-jugador #'f-jugador-aleatorio
					  :f-eval  #'f-eval-aleatoria))

(defvar *jugador-bueno* (make-jugador :nombre 'Jugador-bueno
				      :f-jugador #'f-jugador-negamax
				      :f-eval  #'f-eval-bueno))

(defvar *jugador-humano* (make-jugador :nombre 'Jugador-humano
				       :f-jugador #'f-jugador-humano
				       :f-eval  #'f-no-eval))

(defvar *jugador-mod* (make-jugador :nombre 'Jugador-mod
				      :f-jugador #'f-jugador-negamax
				      :f-eval  #'f-eval-mod))

(defvar *jugador-anacardo* (make-jugador :nombre 'Jugador-anacardo
				      :f-jugador #'f-jugador-negamax
				      :f-eval  #'anacardo))

(defvar *jugador-avocado01* (make-jugador :nombre 'Jugador-avocado01
				      :f-jugador #'f-jugador-negamax
				      :f-eval  #'avocado01))

(defvar *jugador-avocado* (make-jugador :nombre 'Jugador-avocado
				      :f-jugador #'f-jugador-negamax
				      :f-eval  #'avocado))
;; -------------------------------------------------------------------------------
;; Algunas partidas de ejemplo:
;; -------------------------------------------------------------------------------

(setf *verbose* t)

;(print (partida *jugador-aleatorio* *jugador-aleatorio*))
;(print (partida *jugador-aleatorio* *jugador-bueno* 4))
;(print (partida *jugador-bueno* *jugador-aleatorio* 4))
;(print (partida *jugador-bueno* *jugador-bueno* 4))
;(print (partida *jugador-humano* *jugador-humano*))
;(print (partida *jugador-humano* *jugador-aleatorio* 4))
;(print (partida *jugador-humano* *jugador-bueno* 4))
;(print (partida *jugador-aleatorio* *jugador-humano*))
(print (partida *jugador-avocado* *jugador-avocado01* 4))
;;
