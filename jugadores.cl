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


(defun horizontal (tablero ficha columna fila)
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
(print (partida *jugador-humano* *jugador-mod* 4))
;;