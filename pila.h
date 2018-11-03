#include <string.h>


typedef struct _nodoP {
   char *valor;
   struct _nodoP *anterior;
} tipoNodoPila;

typedef tipoNodoPila *pNodoPila;

typedef struct _pila {
   pNodoPila tope;
   pNodoPila base;
} Pila;



/* Funciones con pila: */
void apilar(Pila *p, char *v);
void desapilar(Pila *p, char *v);
void mostrarPila(Pila *p);

Pila crearPila();