#include <string.h>

#define ASCENDENTE 1
#define DESCENDENTE 0

typedef struct _nodo {
   char *valor;
   struct _nodo *siguiente;
   struct _nodo *anterior;
} tipoNodo;

typedef tipoNodo *pNodo;

typedef struct _lista {
   pNodo primero;
   pNodo ultimo;
} Lista;



/* Funciones con listas: */
void insertarAdelante(Lista *l, char *v);
void insertarAtras(Lista *l, char *v);
void mostrarLista(Lista *l);

Lista crearLista();