;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Apartado 1.1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cosine-distance (x y)
;;; Calcula la distancia coseno de un vector de forma recursiva
;;; Se asume que los dos vectores de entrada tienen la misma longitud.
;;;
;;; INPUT: x: vector, representado como una lista
;;;         y: vector, representado como una lista
;;; OUTPUT: distancia coseno entre x e y
;;;
(defun cosine-distance (x y distance-measure)
  (if (and (null x) (null y))
      0
      (let ((denominator (* (sqrt (funcall distance-measure x x)) (sqrt (funcall distance-measure y y)))))
      (if (= denominator 0)
        nil
        (- 1 (/ (funcall distance-measure x y) denominator))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; dot-product-rec (x y)
;;; Calcula el producto escalar de los vectores x e y de forma recursiva
;;; Se asume que los dos vectores de entrada tienen la misma longitud.
;;;
;;; INPUT: x: vector, representado como una lista
;;;         y: vector, representado como una lista
;;;
;;; OUTPUT: producto escalar del vector x por el vector y
;;;
(defun dot-product-rec (x y)
  (if (or (null x) (null y))
    0
    (+ (* (first x) (first y)) (dot-product-rec (rest x) (rest y)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cosine-distance-rec (x y)
;;; Calcula la distancia coseno de un vector de forma recursiva
;;; Se asume que los dos vectores de entrada tienen la misma longitud.
;;;
;;; INPUT: x: vector, representado como una lista
;;;         y: vector, representado como una lista
;;; OUTPUT: distancia coseno entre x e y
;;;
(defun cosine-distance-rec (x y)
  (cosine-distance x y #'dot-product-rec))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; dot-product-mapcar (x y)
;;; Calcula el producto escalar de los vectores x e y usando mapcar
;;; Se asume que los dos vectores de entrada tienen la misma longitud.
;;;
;;; INPUT: x: vector, representado como una lista
;;;         y: vector, representado como una lista
;;;
;;; OUTPUT: producto escalar del vector x por el vector y
;;;
(defun dot-product-mapcar (x y)
    (apply #'+ (mapcar #'* x y)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; cosine-distance-mapcar
;;; Calcula la distancia coseno de un vector usando mapcar
;;; Se asume que los dos vectores de entrada tienen la misma longitud.
;;;
;;; INPUT:  x: vector, representado como una lista
;;;         y: vector, representado como una lista
;;; OUTPUT: distancia coseno entre x e y
;;;
(defun cosine-distance-mapcar (x y)
  (cosine-distance x y #'dot-product-mapcar))

(print "Apartado 1.1")
;;; Recursiva
;;; (print (cosine-distance-rec '(1 0) '(0 1)))
;;; (print (cosine-distance-rec '(1 2 3) '(1 2 3)))
;;; (print (cosine-distance-rec '(1 2 3) '(-1 -2 -3)))

;;; (print (cosine-distance-rec '(1 2) '(1 2 3)))
;;; (print (cosine-distance-rec nil '(1 2 3)))
;;; (print (cosine-distance-rec '() '()))
;;; (print (cosine-distance-rec '(0 0) '(0 0)))

;;; Mapcar
;;; (print (cosine-distance-mapcar '(1 2 3) nil))
;;; (print (cosine-distance-mapcar '(1 0) '(0 1)))
;;; (print (cosine-distance-mapcar '(1 2 3) '(1 2 3)))
;;; (print (cosine-distance-mapcar '(1 2 3) '(-1 -2 -3)))

;;; (print (cosine-distance-mapcar '(1 2) '(1 2 3)))
;;; (print (cosine-distance-mapcar nil '(1 2 3)))
;;; (print (cosine-distance-mapcar '() '()))
;;; (print (cosine-distance-mapcar '(0 0) '(0 0)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Apartado 1.2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; map-vectors-cosine-distance
;;; Devuelve una lista de tuplas de vectores con su distancia coseno
;;; a vector, siempre que esta distancia sea menor que
;;; confidence-level
;;; INPUT:  vector: vector que representa a una categoria,
;;;                 representado como una lista
;;;         lst-of-vectors vector de vectores
;;;         confidence-level: Nivel de confianza (parametro opcional)
;;;			dist-func: Funcion usada para medir la distancia coseno
;;;						(parametro opcional)
;;; OUTPUT: Lista de tuplas de vectores y su distancia coseno a vector,
;;;			siempre que esta sea menor que confidence-level
;;;
(defun map-vectors-cosine-distance (vector lst-of-vectors &optional (confidence-level 0))
	;;; Tenemos que comprobar que la distancia es menor o igual que 1 - el nivel de confianza. Te esta forma, sabemos
	;;; que el elemento de la lista está lo suficientemente cerca del vector referencia.
	;;; Si la distancia es nil o se cumple la condición anterior, el lambda devuelve nil y por tanto mapcan no lo añade a la lista
    ;;; mapcan concatena los elemetos, por lo que tenemos que hacer (list (list v confidence))
	(mapcan (lambda (v) (let ((distance (cosine-distance-mapcar v vector))) (when (and distance (<= distance (- 1 confidence-level))) (list (list v distance))))) lst-of-vectors))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; order-vectors-cosine-distance
;;; Devuelve aquellos vectores similares a una categoria
;;; INPUT:  vector: vector que representa a una categoria,
;;;                 representado como una lista
;;;         lst-of-vectors vector de vectores
;;;         confidence-level: Nivel de confianza (parametro opcional)
;;; OUTPUT: Vectores cuya semejanza con respecto a la
;;;         categoria es superior al nivel de confianza,
;;;         ordenados de mayor a menor confianza
;;;
(defun order-vectors-cosine-distance (vector lst-of-vectors &optional (confidence-level 0))
	;;; Ordenamos una copia del vector por ser sort una función destructiva
	(mapcar #'first (sort (copy-list (map-vectors-cosine-distance vector lst-of-vectors confidence-level)) #'> :key #'second)))

;;; (print "Apartado 1.2")
;;; (print (order-vectors-cosine-distance '(1 2 3) '((0 0 0))))
;;; (print (order-vectors-cosine-distance '(0 0 0) '((1 2 3))))
;;; (print (order-vectors-cosine-distance '(1 2 3) '((1 2 3) (2 1 1)) 0.99))
;;; (print (order-vectors-cosine-distance '(1 2 3) '((1 2 3) (2 1 1)) 1))
;;; (print (order-vectors-cosine-distance '(1 0) '((1 0) (0 1) (1 0.1) (1 0.2))))
;;; (print (order-vectors-cosine-distance nil '((1 2 3) (2 1 1))))
;;; (print (order-vectors-cosine-distance '(1 2 3) nil))
;;; (print (order-vectors-cosine-distance nil nil))

;;; (print (order-vectors-cosine-distance '(1 2 3) '((32 454 123) (133 12 1) (4 2 2)) 0.5))
;;; (print (order-vectors-cosine-distance '(1 2 3) '((32 454 123) (133 12 1) (4 2 2)) 0.3))
;;; (print (order-vectors-cosine-distance '(1 2 3) '((32 454 123) (133 12 1) (4 2 2)) 0.99))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Apartado 1.3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get-text-category_dist
;;; Devuelve una lista con una tupla con el id de la categoría
;;; y su distancia al texto
;;;
;;; INPUT : category: 	lista que representa la categoría
;;;         text:       lista que representa al texto
;;;         distance-measure: funcion de distancia
;;; OUTPUT: lista con una tupla formada por el id de la categoría
;;;         y su distancia al texto
;;;
( defun get-text-category-dist (category text distance-measure)
	(let ((distance (funcall distance-measure (rest text) (rest category))))
		(if (null distance)
			nil
			(list (list (first category) distance)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get-text-category
;;; Asigna a cada texto la categoría que le corresponde
;;;
;;; INPUT : categories: vector de vectores, representado como
;;;                     una lista de listas
;;;         text:       lista que representa al texto
;;;         distance-measure: funcion de distancia
;;; OUTPUT: Par formado por el vector que identifica la categoria
;;;         de menor distancia , junto con el valor de dicha distancia
;;;
( defun get-text-category (categories text distance-measure)
	;;; Ordenamos una copia del vector por ser sort una función destructiva
	(first (sort (copy-list (mapcan (lambda (cat) (get-text-category-dist cat text distance-measure)) categories)) #'> :key #'second)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; get-vectors-category (categories vectors distance-measure)
;;; Clasifica a los textos en categorias .
;;;
;;; INPUT : categories: vector de vectores, representado como
;;;                     una lista de listas
;;;         texts:      vector de vectores, representado como
;;;                     una lista de listas
;;;         distance-measure: funcion de distancia
;;; OUTPUT: Pares formados por el vector que identifica la categoria
;;;         de menor distancia , junto con el valor de dicha distancia
;;;
( defun get-vectors-category (categories texts distance-measure)
	(if (or (null categories) (null texts))
		nil
		(mapcar (lambda (text) (get-text-category categories text distance-measure)) texts)))

;;; (print "Apartado 1.3")
;;; (setf categories '((1 43 23 12) (2 33 54 24)))
;;; (setf texts '((1 3 22 134) (2 43 26 58)))

;;; (print (get-vectors-category '((1 1 2) (2 2 1)) '((1 2 1) (2 1 2)) #'cosine-distance-mapcar))
;;; (print (get-vectors-category '((1 1 2)) '((1 2 1) (2 1 2)) #'cosine-distance-mapcar))
;;; (print (get-vectors-category '((1 0 0)) '((1 2 1) (2 1 2)) #'cosine-distance-mapcar))
;;; (print (get-vectors-category '((1 1 2) (2 2 1)) '((1 0 0)) #'cosine-distance-mapcar))
;;; (print (get-vectors-category nil '((1 2 1) (2 1 2)) #'cosine-distance-mapcar))
;;; (print (get-vectors-category '((1 2 1) (2 1 2)) nil #'cosine-distance-mapcar))
;;; (print (get-vectors-category nil nil #'cosine-distance-mapcar))
;;; (print (get-vectors-category '((1 1 2 3) ()) '((1 1 2 3) (2 4 5 6)) #'cosine-distance-mapcar))
;;; (print (get-vectors-category '((1 4 5 6) (2 2 1 3)) '(() (2 4 5 6)) #'cosine-distance-mapcar))
;;; (print (get-vectors-category '(() (1 4 5 6)) '(() (2 4 5 6)) #'cosine-distance-mapcar))

;;; (print (get-vectors-category categories texts #'cosine-distance-rec))
;;; (print (get-vectors-category categories texts #'cosine-distance-mapcar))
;;; (print (get-vectors-category '(()) '(()) #'cosine-distance-mapcar))
;;; (print (get-vectors-category '((1 4 2) (2 1 2)) '((1 1 2 3)) #'cosine-distance-mapcar))
;;; (print (get-vectors-category '(()) '((1 1 2 3) (2 4 5 6)) #'cosine-distance-mapcar))


;;; Apartado 1.4 - Medición de tiempos
;;; (print "Apartado 1.4 - Tiempos")
;;; (time (get-vectors-category categories texts #'cosine-distance-rec))
;;; (time (get-vectors-category categories texts #'cosine-distance-mapcar))
;;; (time (get-vectors-category '((1 43 23 12 1) (2 33 54 24 5) (3 58 32 15 93)) '((1 3 22 134 47) (2 43 26 58 69) (2 39 12 46 81)) #'cosine-distance-rec))
;;; (time (get-vectors-category '((1 43 23 12 1) (2 33 54 24 5) (3 58 32 15 93)) '((1 3 22 134 47) (2 43 26 58 69) (2 39 12 46 81)) #'cosine-distance-mapcar))

;;; (print "Apartado 1.4 - Preguntas")
;;; (print (get-vectors-category '(()) '(()) #'cosine-distance-mapcar))
;;; (print (get-vectors-category '((1 4 2) (2 1 2)) '((1 1 2 3)) #'cosine-distance-mapcar))
;;; (print (get-vectors-category '(()) '((1 1 2 3) (2 4 5 6)) #'cosine-distance-mapcar))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Apartado 2.1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; newton
;;; Estima el cero de una funcion mediante Newton-Raphson
;;;
;;; INPUT : f: funcion cuyo cero se desea encontrar
;;; df: derivada de f
;;; max-iter : maximo numero de iteraciones
;;; x0: estimacion inicial del cero ( semilla )
;;; tol: tolerancia para convergencia ( parametro opcional )
;;; OUTPUT : estimacion del cero de f, o NIL si no converge
;;;
(defun newton (f df max-iter x0 &optional ( tol 0.001))
	(if (<= max-iter 0)
		NIL
		(let ((division (/ (funcall f x0) (funcall df x0))))
			(if (<= (abs division) tol)
				x0
				(newton f df (- max-iter 1) (- x0 division) tol)))))


;;; (print "Apartado 2.1")
;;; (print (newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 4.0))
;;; (print (newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 0.6 0.001))
;;; (print (newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 30 -2.5 0))
;;; (print (newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 10 100.0 0.005))
;;; (print (newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 4.0 0.007))

;;; (print (newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 3.0))
;;; (print (newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 0.6))
;;; (print (newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 30 -2.5))
;;; (print (newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 10 100.0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Apartado 2.2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; one-root-newton
;;; Prueba con distintas semillas iniciales hasta que Newton
;;; converge
;;;
;;; INPUT : f: funcion de la que se desea encontrar un cero
;;; df: derivada de f
;;; max-iter : maximo numero de iteraciones
;;; semillas : semillas con las que invocar a Newton
;;; tol: tolerancia para convergencia ( parametro opcional )
;;;
;;; OUTPUT : el primer cero de f que se encuentre , o NIL si se diverge
;;; para todas las semillas
;;;
(defun one-root-newton (f df max-iter semillas &optional ( tol 0.001))
	(let ((newton-res (newton f df max-iter (first semillas) tol)))
		(if (null newton-res)
			(if (null (rest semillas))
				NIL
				(one-root-newton f df max-iter (rest semillas) tol))
			newton-res)))

;;; (print "Apartado 2.2")
;;; (print (one-root-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 7 '(50.0 0.6)))
;;; (print (one-root-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 7 '(3.0 50.0)))
;;; (print (one-root-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 1 '(3.0 -2.5)))
;;; (print (one-root-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 '(0.6 3.0 -2.5) 0))

;;; (print (one-root-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 '(0.6 3.0 -2.5)))
;;; (print (one-root-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 '(3.0 -2.5)))
;;; (print (one-root-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 1 '(3.0 -2.5)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Apartado 2.3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; all-roots-newton
;;; Prueba con distintas semillas iniciales y devuelve las raices
;;; encontradas por Newton para dichas semillas
;;;
;;; INPUT : f: funcion de la que se desea encontrar un cero
;;; df: derivada de f
;;; max-iter : maximo numero de iteraciones
;;; semillas : semillas con las que invocar a Newton
;;; tol: tolerancia para convergencia ( parametro opcional )
;;;
;;; OUTPUT : las raices que se encuentren para cada semilla o nil
;;; si para esa semilla el metodo no converge
;;;
(defun all-roots-newton (f df max-iter semillas &optional ( tol 0.001))
  (mapcar #'(lambda (x) (newton f df max-iter x tol)) semillas))

;;; (print "Apartado 2.3")
;;; (print (all-roots-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 '(-2.5 3.0 10000.0)))
;;; (print (all-roots-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 '(-2.5 3.0 10000.0) 0))

;;; (print (all-roots-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 '(0.6 3.0 -2.5)))
;;; (print (all-roots-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 '(0.6 3.0 10000.0)))
;;; (print (all-roots-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 1 '(0.6 3.0 -2.5)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Apartado 2.3.1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; list-not-nil-roots-newton
;;; Quita los nil de la lista que devuelve all-roots-newton
;;; con los parámetros pasados como argumento
;;;
;;; INPUT : f: funcion de la que se desea encontrar un cero
;;; df: derivada de f
;;; max-iter : maximo numero de iteraciones
;;; semillas : semillas con las que invocar a Newton
;;; tol: tolerancia para convergencia ( parametro opcional )
;;;
;;; OUTPUT : las raices que se encuentren para cada semilla sin nil
;;;
(defun list-not-nil-roots-newton (f df max-iter semillas &optional ( tol 0.001))
	(mapcan (lambda (x)
        (if (null x)
            '()
            (list x)))
        (all-roots-newton f df max-iter semillas tol)))

;;; (print "Apartado 2.3.1")
;;; (print (list-not-nil-roots-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 '(0.6 3.0 -2.5)))
;;; (print (list-not-nil-roots-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 '(0.6 3.0 10000.0)))
;;; (print (list-not-nil-roots-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 1 '(0.6 3.0 -2.5)))
;;; (print (list-not-nil-roots-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 '(0.6 3.0 10000.0) 0))

;;; (print (list-not-nil-roots-newton #'(lambda(x) (* (- x 4) (- x 1) (+ x 3))) #'(lambda (x) (- (* x (- (* x 3) 4)) 11)) 20 '(0.6 3.0 10000.0)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Apartado 3.1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; combine-elt-lst
;;; Combina un elemento dado con todos los elementos de una lista
;;;
;;; INPUT: elem: elemento a combinar
;;;        lst: lista con la que se quiere combinar el elemento
;;;
;;; OUTPUT: lista con las combinacion del elemento con cada uno de los
;;;         de la lista. Si alguno de los elementos es nil, devolvemos
;;;			nil
(defun combine-elt-lst (elt lst)
	(if (null lst))
		nil
		(mapcar (lambda (x) (list elt x)) lst))

;;; (print "Apartado 3.1")
;;; (print (combine-elt-lst 'a '(1 2 3)))

;;; (print (combine-elt-lst 'a nil))
;;; (print (combine-elt-lst nil nil))
;;; (print (combine-elt-lst nil '(a b)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Apartado 3.2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; combine-lst-lst
;;; Calcula el producto cartesiano de dos listas
;;;
;;; INPUT: lst1: primera lista
;;;        lst2: segunda lista
;;;
;;; OUTPUT: producto cartesiano de las dos listas
(defun combine-lst-lst (lst1 lst2)
	;;; Usamos mapcan porque combine-elt-lst devuelve una lista, y mapcan concatena estas listas
 	(mapcan (lambda (elt) (combine-elt-lst elt lst2)) lst1))

;;; (print "Apartado 3.2")
;;; (print (combine-lst-lst '(a b c) '(1 2)))

;;; (print (combine-lst-lst nil nil))
;;; (print (combine-lst-lst '(a b c) nil))
;;; (print (combine-lst-lst nil '(a b c)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Apartado 3.3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; combine-elt-lst-aux
;;; Combina un elemento dado con todos los elementos de una lista
;;;
;;; INPUT: elem: elemento a combinar
;;;        lst: lista con la que se quiere combinar el elemento
;;;
;;; OUTPUT: lista con las combinacion del elemento con cada uno de los
;;;         de la lista, como una concatenación de ambos.
;;;			Si alguno de los elementos es nil, devolvemos nil
(defun combine-elt-lst-aux (elt lst)
	(if (or (null elt) (null lst))
		nil
		(mapcar (lambda (x) (cons elt x)) lst)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; combine-lst-lst-aux
;;; Calcula el producto cartesiano de dos listas
;;;
;;; INPUT: lst1: primera lista
;;;        lst2: segunda lista
;;;
;;; OUTPUT: producto cartesiano de las dos listas
(defun combine-lst-lst-aux (lst1 lst2)
  (if (or (null lst1) (null lst2))
    nil
    (append (combine-elt-lst-aux (first lst1) lst2) (combine-lst-lst-aux (rest lst1) lst2))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; combine-list-of-lsts
;;; Calcula todas las posibles disposiciones de elementos
;;; pertenecientes a N listas de forma que en cada disposicion
;;; aparezca unicamente un elemento de cada lista
;;;
;;; INPUT: lstolsts: lista de listas
;;;
;;; OUTPUT: lista con todas las posibles combinaciones de elementos
(defun combine-list-of-lsts (lstolsts)
  (if (null lstolsts)
    (list nil)
		(combine-lst-lst-aux (first lstolsts) (combine-list-of-lsts (rest lstolsts)))))

;;; (print "Apartado 3.3")
;;; (print (combine-list-of-lsts '((a b c) (1 2))))
;;; (print (combine-list-of-lsts '((a b c) (+ -) (1 2))))

;;; (print (combine-list-of-lsts '(() (+ -) (1 2 3 4))))
;;; (print (combine-list-of-lsts '((a b c) () (1 2 3 4))))
;;; (print (combine-list-of-lsts '((a b c) (+ -) ())))
;;; (print (combine-list-of-lsts '((1 2 3 4))))
;;; (print (combine-list-of-lsts '(nil)))
;;; (print (combine-list-of-lsts nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; defino operadores logicos
(defconstant +bicond+ '<=>)
(defconstant +cond+   '=>)
(defconstant +and+    '^)
(defconstant +or+     'v)
(defconstant +not+    '!)

;; definiciones de valores de verdad, conectores y atomos
(defun truth-value-p (x)
  (or (eql x T) (eql x NIL)))

(defun unary-connector-p (x)
  (eql x +not+))

(defun binary-connector-p (x)
  (or (eql x +bicond+)
      (eql x +cond+)))

(defun n-ary-connector-p (x)
  (or (eql x +and+)
      (eql x +or+)))

(defun bicond-connector-p (x)
  (eql x +bicond+))

(defun cond-connector-p (x)
    (eql x +cond+))

(defun connector-p (x)
  (or (unary-connector-p  x)
      (binary-connector-p x)
      (n-ary-connector-p  x)))

(defun positive-literal-p (x)
  (and (atom x)
       (not (truth-value-p x))
       (not (connector-p x))))

(defun negative-literal-p (x)
  (and (listp x)
       (eql +not+ (first x))
       (null (rest (rest x)))
       (positive-literal-p (second x))))

(defun literal-p (x)
  (or (positive-literal-p x)
      (negative-literal-p x)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Apartado 4.1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; solve-simple-implication
;;; Funcion que dada una implicación (=> A B) devuelve (v (! A) B).
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar de
;;;           la forma (=> A B).
;;; OUTPUT : (v (! A) B)
;;;
(defun solve-simple-implication (fbf)
    (list +or+ (list +not+ (second fbf)) (third fbf)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; solve-double-implication
;;; Funcion que dada una doble implicación (<=> A B) devuelve
;;; (^ (v (! A) B) (v (! B) A)).
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar de
;;;           la forma (<=> A B).
;;; OUTPUT : (^ (v (! A) B) (v (! B) A))
;;;
(defun solve-double-implication (fbf)
    (list +and+ (solve-simple-implication fbf) (solve-simple-implication (list (first fbf) (third fbf) (second fbf)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; solve-implication
;;; Funcion que dada una implicación o doble implicacion
;;; devuelve su equivalente.
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar de
;;;           la forma (=> A B) o (<=> A B).
;;; OUTPUT : Equivalente de la expresion
;;;
(defun solve-implication (fbf)
    (if (cond-connector-p (first fbf))
        (solve-simple-implication fbf)
        (solve-double-implication fbf)))

;;(print (solve-implication '(=> A B)))
;;(print (solve-double-implication '(<=> A B)))

(defun negate(fbf)
	(if (null (rest fbf))
		(list (cons +not+ fbf))
		(cons (list +not+ (first fbf)) (negate (rest fbf)))))


(defun not-connector (fbf)
    (cond ((positive-literal-p fbf) (list +not+ fbf))
    	((unary-connector-p (first fbf)) (second fbf))
    	((binary-connector-p (first fbf)) (not-connector (solve-implication fbf)))
    	((eql +and+ (first fbf)) (cons +or+ (negate(rest fbf))))
    	(t (cons +and+ (negate(rest fbf))))))


(defun limpiar (fbf)
	(cond ((literal-p fbf) fbf)
		((binary-connector-p (first fbf)) (limpiar (solve-implication fbf)))
		((unary-connector-p (first fbf)) (limpiar (not-connector (second fbf))))
		(t (cons (first fbf) (mapcar (lambda (x) (limpiar x)) (rest fbf))))))



(defun add-to-lists (elem lsts)
	(if (null lsts) 
		(list elem)
		(add-rec elem lsts)))
	

(defun add-rec (elem lsts)
	(cond ((null lsts) nil)
		((literal-p (first lsts)) (cons (list elem (first lsts)) (add-rec elem (rest lsts))))
		(t (cons (cons elem (first lsts)) (add-rec elem (rest lsts))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; exapand-truth-tree-aux
;;; Función resursiva que ecibe una expresion y construye su arbol
;;; de verdad para determinar si es SAT o UNSAT
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar.
;;; OUTPUT : T   - FBF es SAT
;;;          N   - FBF es UNSAT
;;;
(defun expand-truth-tree-aux (fbf tree)
   (cond ((eql fbf +and+) tree)
        ((literal-p fbf) (expand-truth-tree-aux +and+ (add-to-lists fbf tree)))
   		((eql (first fbf) +or+) (mapcan #'(lambda (x) (expand-truth-tree-aux x tree)) (rest fbf)))
   		((eql (first  fbf) +and+) 
   			(if (null (second fbf))
   				tree
   				(expand-truth-tree-aux (cons +and+ (cddr fbf)) (expand-truth-tree-aux (second fbf) tree))))
   		(t NIL)))




(defun contradiction (pos neg fbf)
	(cond ((null fbf) NIL)
		((positive-literal-p fbf) NIL)
		((positive-literal-p (first fbf)) 
			(if (member (first fbf) neg)
				t
				(contradiction (cons (first fbf) pos) neg (rest fbf))))
		((negative-literal-p (first fbf))
			(if (member (second (first fbf)) pos)
				t
				(contradiction pos (cons (second (first fbf)) neg) (rest fbf))))
		(t NIL)))


(defun sat (fbf)
	(cond ((null fbf) NIL)
		((contradiction '() '() (first fbf)) (sat (rest fbf)))
		(t t)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; truth-tree
;;; Recibe una expresion y construye su arbol de verdad para
;;; determinar si es SAT o UNSAT
;;;
;;; INPUT  : fbf - Formula bien formada (FBF) a analizar.
;;; OUTPUT : T   - FBF es SAT
;;;          N   - FBF es UNSAT
;;;
(defun truth-tree (fbf)
	(sat (expand-truth-tree-aux (limpiar fbf) '())))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; EJERCICIO 5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Breadth-first-search in graphs
;;;
(defun bfs (end queue net)
	(if (null queue) ;;mientras Q no este vacía
		'()
		(let* ((path (first queue))
			(node (first path))) ;;coger primer nodo de Q
			(if (eql node end)  
				(reverse path) ;;si nodo == fin: devolver dar.vuelta(camino)
				(bfs end (append (rest queue) (new-paths path node net)) net))))) ;;si no: se llama a si mismo añadiendo los vecinos a Q, los vecinos se cogen con new-paths.


(defun new-paths (path node net)
	(mapcar #'(lambda (n)
		(cons n path))
		(rest (assoc node net)))) 


(defun shortest-path (start end net)
	(bfs end (list (list start)) net))

;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;(shortest-path 'a 'f '((a d) (b d f) (c e) (d f) (e b f) (f)))
;;	(bfs 'f '((a)) '((a d) (b d f) (c e) (d f) (e b f) (f)))
;;		(bfs 'f '((d a)) '((a d) (b d f) (c e) (d f) (e b f) (f)))
;;			(bfs 'f '((f d a)) '((a d) (b d f) (c e) (d f) (e b f) (f)))
;;			-> (a d f)
;;		-> (a d f)
;;	-> (a d f)
;;-> (a d f)

;;(shortest-path 'b 'g '((a b c d e) (b a d e f) (c a g) (d a b g h) (e a b g h) (f b h) (g c d e h) (h d e f g)))
;;-> (b d g)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; shortest-path-improved
;;; Version de busqueda en anchura que no entra en recursion
;;; infinita cuando el grafo tiene ciclos
;;; INPUT:   end: nodo final
;;;          queue: cola de nodos por explorar
;;;          net: grafo
;;; OUTPUT: camino mas corto entre dos nodos
;;;         nil si no lo encuentra



(defun bfs-improved (end queue net)
	(bfs-improved-aux end queue net NIL))


(defun bfs-improved-aux (end queue net explored)
	(if (null queue)
		'()
		(if (null (first queue))
			NIL
			(let* ((path (first queue))
				(node (first path)))
				(if (eql node end)
					(reverse path)
					(if (null (member node explored))
						(bfs-improved-aux end (append (rest queue) (new-paths path node net)) net (cons node explored))
						(bfs-improved-aux end (rest queue) net explored)))))))
				

(defun shortest-path-improved (start end net)
	(bfs-improved end (list (list start)) net))






;;bfs(fin camino grafo):
;;	inicio = primer(camino)
;;	si inicio == fin:
;;		devolver dar.vuelta(camino)
;;	si no:
;;		devolver bfs(fin, concatenar(camino, vecinos(inicio, grafo)), grafo)


;;vecinos(nodo, grafo):
;;	devolver resto(buscar.sublista(nodo, grafo)))