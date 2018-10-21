#define ASCENDENTE 1
#define DESCENDENTE 0

typedef struct _nodo {
   int valor;
   struct _nodo *siguiente;
   struct _nodo *anterior;
} tipoNodo;

typedef tipoNodo *pNodo;

typedef struct _lista {
   pNodo primero;
   pNodo ultimo;
} Lista;



/* Funciones con listas: */
void insertarAdelante(Lista *l, int v);
void insertarAtras(Lista *l, int v);
void mostrarLista(Lista *l);

Lista crearLista();