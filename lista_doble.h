#include <string.h>

#define ASCENDENTE 1
#define DESCENDENTE 0

typedef struct _nodo {
   char *valor;
   int indice;
   char *tipo;
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
void insertarAtras(Lista *l, char *v, int indice);
void insertarAtrasTipo(Lista *l, char *v, int indice, char *tipo);
void mostrarLista(Lista *l);
void reemplazarValor(Lista *lista, char *v, int indice);
void obtenerValor(Lista *lista, char *v, int indice);
void obtenerTipo(Lista *lista, char *t, char * v);
char* modificarNombre(char* n, char *rep, char *with);

Lista crearLista();