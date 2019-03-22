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



##### Comentarios sobre la implementación
