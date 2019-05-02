(defpackage :2302_P02_aaf45;
(:use :common-lisp :conecta4)
(:export :heuristica :*alias*))
(in-package 2302_P02_aaf45)

(defvar *alias* '|Coco_v2.0|)

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
		 (vertical (contar-vertical tablero ficha-actual columna fila))
		 (horizontal (contar-horizontal tablero ficha-actual columna fila))
		 (diagonal-ascendente (contar-diagonal-ascendente tablero ficha-actual columna fila))
		 (diagonal-descendente (contar-diagonal-descendente tablero ficha-actual columna fila))
		 (vertical-espacios (contar-vertical-espacios tablero ficha-actual ficha-oponente columna fila))
		 (horizontal-espacios (contar-horizontal-espacios tablero ficha-actual ficha-oponente columna fila))
		 (diagonal-ascendente-espacios (contar-diagonal-ascendente-espacios tablero ficha-actual ficha-oponente columna fila))
		 (diagonal-descendente-espacios (contar-diagonal-descendente-espacios tablero ficha-actual ficha-oponente columna fila))
		 (espacios-v (espacios-vertical tablero ficha-actual ficha-oponente columna fila))
		 (espacios-h (espacios-diagonal-ascendente tablero ficha-actual ficha-oponente columna fila))
		 (espacios-da (espacios-vertical tablero ficha-actual ficha-oponente columna fila))
		 (espacios-dd (espacios-diagonal-descendente tablero ficha-actual ficha-oponente columna fila)))
	(setf puntuacion-actual
		  (+ puntuacion-actual
		  (if (eql espacios-v -1)
		  	0
		  	(+ (* espacios-v 200)
		  		(cond ((= vertical 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= vertical 1) 10)
				   ((= vertical 2) 400)
				   ((= vertical 3) 1500))
		  		(cond ((= vertical-espacios 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= vertical-espacios 1) 10)
				   ((= vertical-espacios 2) 400)
				   ((>= vertical-espacios 3) 1000))))
		  (if (eql espacios-h -1)
		  	0
		  	(+ (* espacios-h 200)
		  		(cond ((= horizontal 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= horizontal 1) 10)
				   ((= horizontal 2) 400)
				   ((= horizontal 3) 1500))
		  		(cond ((= horizontal-espacios 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= horizontal-espacios 1) 10)
				   ((= horizontal-espacios 2) 400)
				   ((>= horizontal-espacios 3) 1000))))
		  (if (eql espacios-da -1)
		  	0
		  	(+ (* espacios-da 200)
		  		(cond ((= diagonal-ascendente 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= diagonal-ascendente 1) 10)
				   ((= diagonal-ascendente 2) 400)
				   ((= diagonal-ascendente 3) 1500))
		  		(cond ((= diagonal-ascendente-espacios 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= diagonal-ascendente-espacios 1) 10)
				   ((= diagonal-ascendente-espacios 2) 400)
				   ((>= diagonal-ascendente-espacios 3) 1000))))
		  (if (eql espacios-dd -1)
		  	0
		  	(+ (* espacios-dd 200)
		  		(cond ((= diagonal-descendente 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= diagonal-descendente 1) 10)
				   ((= diagonal-descendente 2) 400)
				   ((= diagonal-descendente 3) 1500))
		  		(cond ((= diagonal-descendente-espacios 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= diagonal-descendente-espacios 1) 10)
				   ((= diagonal-descendente-espacios 2) 400)
				   ((>= diagonal-descendente-espacios 3) 1000)))))))
	  (let* ((altura (altura-columna tablero columna))
		 (fila (1- altura))
		 (vertical (contar-vertical tablero ficha-oponente columna fila))
		 (horizontal (contar-horizontal tablero ficha-oponente columna fila))
		 (diagonal-ascendente (contar-diagonal-ascendente tablero ficha-oponente columna fila))
		 (diagonal-descendente (contar-diagonal-descendente tablero ficha-oponente columna fila))
		 (vertical-espacios (contar-vertical-espacios tablero ficha-oponente ficha-actual columna fila))
		 (horizontal-espacios (contar-horizontal-espacios tablero ficha-oponente ficha-actual columna fila))
		 (diagonal-ascendente-espacios (contar-diagonal-ascendente-espacios tablero ficha-oponente ficha-actual columna fila))
		 (diagonal-descendente-espacios (contar-diagonal-descendente-espacios tablero ficha-oponente ficha-actual columna fila))
		 (espacios-v (espacios-vertical tablero ficha-oponente ficha-actual columna fila))
		 (espacios-h (espacios-diagonal-ascendente tablero ficha-oponente ficha-actual columna fila))
		 (espacios-da (espacios-vertical tablero ficha-oponente ficha-actual columna fila))
		 (espacios-dd (espacios-diagonal-descendente tablero ficha-oponente ficha-actual columna fila)))
	(setf puntuacion-oponente
		  (+ puntuacion-oponente
		  (if (eql espacios-v -1)
		  	0
		  	(+ (* espacios-v 200)
		  		(cond ((= vertical 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= vertical 1) 10)
				   ((= vertical 2) 400)
				   ((= vertical 3) 1500))
		  		(cond ((= vertical-espacios 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= vertical-espacios 1) 10)
				   ((= vertical-espacios 2) 400)
				   ((>= vertical-espacios 3) 1000))))
		  (if (eql espacios-h -1)
		  	0
		  	(+ (* espacios-h 200)
		  		(cond ((= horizontal 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= horizontal 1) 10)
				   ((= horizontal 2) 400)
				   ((= horizontal 3) 1500))
		  		(cond ((= horizontal-espacios 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= horizontal-espacios 1) 10)
				   ((= horizontal-espacios 2) 400)
				   ((>= horizontal-espacios 3) 1000))))
		  (if (eql espacios-da -1)
		  	0
		  	(+ (* espacios-da 200)
		  		(cond ((= diagonal-ascendente 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= diagonal-ascendente 1) 10)
				   ((= diagonal-ascendente 2) 400)
				   ((= diagonal-ascendente 3) 1500))
		  		(cond ((= diagonal-ascendente-espacios 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= diagonal-ascendente-espacios 1) 10)
				   ((= diagonal-ascendente-espacios 2) 400)
				   ((>= diagonal-ascendente-espacios 3) 1000))))
		  (if (eql espacios-dd -1)
		  	0
		  	(+ (* espacios-dd 200)
		  		(cond ((= diagonal-descendente 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= diagonal-descendente 1) 10)
				   ((= diagonal-descendente 2) 400)
				   ((= diagonal-descendente 3) 1500))
		  		(cond ((= diagonal-descendente-espacios 0) 0)       ;; Priorizamos el caso el caso en el que tenemos varias nuestras debajo
				   ((= diagonal-descendente-espacios 1) 10)
				   ((= diagonal-descendente-espacios 2) 400)
				   ((>= diagonal-descendente-espacios 3) 1000)))))))
		(- puntuacion-actual puntuacion-oponente)))))



(defun espacios-horizontal (tablero ficha ficha-oponente columna fila)
	(let ((espacios 
			(1- (+ (derecha-espacios-validos tablero ficha ficha-oponente columna fila)
     		(izquierda-espacios-validos tablero ficha ficha-oponente columna fila)))))
		(if (< espacios 4)
			-1
			(- espacios 4))))

(defun espacios-vertical (tablero ficha ficha-oponente columna fila)
	(let ((espacios 
			(1- (+ (abajo-espacios-validos tablero ficha ficha-oponente columna fila)
     		(arriba-espacios-validos tablero ficha ficha-oponente columna fila)))))
		(if (< espacios 4)
			-1
			(- espacios 4))))

(defun espacios-diagonal-ascendente (tablero ficha ficha-oponente columna fila)
	(let ((espacios 
			(1- (+ (arriba-derecha-espacios-validos tablero ficha ficha-oponente columna fila)
     		(abajo-izquierda-espacios-validos tablero ficha ficha-oponente columna fila)))))
		(if (< espacios 4)
			-1
			(- espacios 4))))

(defun espacios-diagonal-descendente (tablero ficha ficha-oponente columna fila)
	(let ((espacios 
			(1- (+ (abajo-derecha-espacios-validos tablero ficha ficha-oponente columna fila)
     		(arriba-izquierda-espacios-validos tablero ficha ficha-oponente columna fila)))))
		(if (< espacios 4)
			-1
			(- espacios 4))))

(defun abajo-espacios-validos (tablero ficha ficha-oponente columna fila)
	(let ((total 0))
		(loop for line from fila over (- fila 4)
			until (or (not (dentro-del-tablero-p tablero columna line)) (eql (obtener-ficha tablero columna line) ficha-oponente))
			do (setf total (1+ total))
			total)))

(defun arriba-espacios-validos (tablero ficha ficha-oponente columna fila)
	(let ((total 0))
		(loop for line from fila below (+ fila 4)
			until (or (not (dentro-del-tablero-p tablero columna line)) (eql (obtener-ficha tablero columna line) ficha-oponente))
			do (setf total (1+ total))
			total)))

(defun derecha-espacios-validos (tablero ficha ficha-oponente columna fila)
	(let ((total 0))
		(loop for column from columna below (+ columna 4) 
			until (or (not (dentro-del-tablero-p tablero column fila)) (eql (obtener-ficha tablero column fila) ficha-oponente))
			do (setf total (1+ total))
			total)))

(defun izquierda-espacios-validos (tablero ficha ficha-oponente columna fila)
	(let ((total 0))
		(loop for column from columna over (- columna 4)
			until (or (not (dentro-del-tablero-p tablero column fila)) (eql (obtener-ficha tablero column fila) ficha-oponente))
			do (setf total (1+ total))
			total)))

(defun arriba-izquierda-espacios-validos (tablero ficha ficha-oponente columna fila)
	(let ((total 0))
		(loop for column from columna over (- columna 4)
			for line from fila  below (+ fila 4)
			until (or (not (dentro-del-tablero-p tablero column line)) (eql (obtener-ficha tablero column line) ficha-oponente))
			do (setf total (1+ total))
			total)))

(defun abajo-izquierda-espacios-validos (tablero ficha ficha-oponente columna fila)
	(let ((total 0))
		(loop for column from columna over (- columna 4)
			for line from fila  over (- fila 4)
			until (or (not (dentro-del-tablero-p tablero column line)) (eql (obtener-ficha tablero column line) ficha-oponente))
			do (setf total (1+ total))
			total)))

(defun arriba-derecha-espacios-validos (tablero ficha ficha-oponente columna fila)
	(let ((total 0))
		(loop for column from columna below (+ columna 4)
			for line from fila  below (+ fila 4)
			until (or (not (dentro-del-tablero-p tablero column line)) (eql (obtener-ficha tablero column line) ficha-oponente))
			do (setf total (1+ total))
			total)))

(defun abajo-derecha-espacios-validos (tablero ficha ficha-oponente columna fila)
	(let ((total 0))
		(loop for column from columna below (+ columna 4)
			for line from fila  over (- fila 4)
			until (or (not (dentro-del-tablero-p tablero column line)) (eql (obtener-ficha tablero column line) ficha-oponente))
			do (setf total (1+ total))
			total)))

(defun contar-horizontal (tablero ficha columna fila)
  (+ (contar-derecha tablero ficha columna fila)
     (contar-izquierda tablero ficha (1- columna) fila)))

(defun contar-vertical (tablero ficha columna fila)
  (+ (contar-abajo tablero ficha columna fila)
     (contar-arriba tablero ficha columna (1+ fila))))
  
(defun contar-diagonal-ascendente (tablero ficha columna fila)
  (+ (contar-abajo-izquierda tablero ficha columna fila)
     (contar-arriba-derecha tablero ficha (1+ columna) (1+ fila))))
  
(defun contar-diagonal-descendente (tablero ficha columna fila)
  (+ (contar-abajo-derecha tablero ficha columna fila)
     (contar-arriba-izquierda tablero ficha (1- columna) (1+ fila))))

(defun contar-horizontal-espacios (tablero ficha ficha-oponente columna fila)
  (1- (+ (contar-derecha-espacios tablero ficha ficha-oponente columna fila)
     (contar-izquierda-espacios tablero ficha ficha-oponente columna fila))))

(defun contar-vertical-espacios (tablero ficha ficha-oponente columna fila)
  (1- (+ (contar-abajo-espacios tablero ficha ficha-oponente columna fila)
     (contar-arriba-espacios tablero ficha ficha-oponente columna fila))))
  
(defun contar-diagonal-ascendente-espacios (tablero ficha ficha-oponente columna fila)
  (1- (+ (contar-abajo-izquierda-espacios tablero ficha ficha-oponente columna fila)
     (contar-arriba-derecha-espacios tablero ficha ficha-oponente columna fila))))
  
(defun contar-diagonal-descendente-espacios (tablero ficha ficha-oponente columna fila)
  (1- (+ (contar-abajo-derecha-espacios tablero ficha ficha-oponente columna fila)
     (contar-arriba-izquierda-espacios tablero ficha ficha-oponente columna fila))))

(defun contar-abajo-espacios (tablero ficha ficha-oponente columna fila)
 	(let ((total 0))
		(loop for line from fila over (- fila 4)
			until (or (not (dentro-del-tablero-p tablero columna line)) (eql (obtener-ficha tablero columna line) ficha-oponente))
			do (if (eql (obtener-ficha tablero columna line) ficha) 
				(setf total (1+ total)))
			total)))


(defun contar-arriba-espacios (tablero ficha ficha-oponente columna fila)
 	(let ((total 0))
		(loop for line from fila below (+ fila 4)
			until (or (not (dentro-del-tablero-p tablero columna line)) (eql (obtener-ficha tablero columna line) ficha-oponente))
			do (if (eql (obtener-ficha tablero columna line) ficha) 
				(setf total (1+ total)))
			total)))


(defun contar-derecha-espacios (tablero ficha ficha-oponente columna fila)
 	(let ((total 0))
		(loop for column from columna below (+ columna 4) 
			until (or (not (dentro-del-tablero-p tablero column fila)) (eql (obtener-ficha tablero column fila) ficha-oponente))
			do (if (eql (obtener-ficha tablero columna line) ficha) 
				(setf total (1+ total)))
			total)))


(defun contar-izquierda-espacios (tablero ficha ficha-oponente columna fila)
 	(let ((total 0))
		(loop for column from columna over (- columna 4)
			until (or (not (dentro-del-tablero-p tablero column fila)) (eql (obtener-ficha tablero column fila) ficha-oponente))
			do (if (eql (obtener-ficha tablero columna line) ficha) 
				(setf total (1+ total)))
			total)))

(defun contar-abajo-derecha-espacios (tablero ficha ficha-oponente columna fila)
 	(let ((total 0))
		(loop for column from columna below (+ columna 4)
			for line from fila  over (- fila 4)
			until (or (not (dentro-del-tablero-p tablero column line)) (eql (obtener-ficha tablero column line) ficha-oponente))
			do (if (eql (obtener-ficha tablero columna line) ficha) 
				(setf total (1+ total)))
			total)))

(defun contar-abajo-izquierda-espacios (tablero ficha ficha-oponente columna fila)
 	(let ((total 0))
		(loop for column from columna over (- columna 4)
			for line from fila  over (- fila 4)
			until (or (not (dentro-del-tablero-p tablero column line)) (eql (obtener-ficha tablero column line) ficha-oponente))
			do (if (eql (obtener-ficha tablero columna line) ficha) 
				(setf total (1+ total)))
			total)))

(defun contar-arriba-derecha-espacios (tablero ficha ficha-oponente columna fila)
 	(let ((total 0))
		(loop for column from columna below (+ columna 4)
			for line from fila  below (+ fila 4)
			until (or (not (dentro-del-tablero-p tablero column line)) (eql (obtener-ficha tablero column line) ficha-oponente))
			do (if (eql (obtener-ficha tablero columna line) ficha) 
				(setf total (1+ total)))
			total)))

(defun contar-arriba-izquierda-espacios (tablero ficha ficha-oponente columna fila)
 	(let ((total 0))
		(loop for column from columna over (- columna 4)
			for line from fila  below (+ fila 4)
			until (or (not (dentro-del-tablero-p tablero column line)) (eql (obtener-ficha tablero column line) ficha-oponente))
			do (if (eql (obtener-ficha tablero columna line) ficha) 
				(setf total (1+ total)))
			total)))