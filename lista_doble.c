#include <stdio.h>
#include <stdlib.h>
#include "lista_doble.h"

Lista crearLista()
{
   Lista lista;
   lista.primero = NULL;
   lista.ultimo = NULL;
   return lista;
}

void insertarAdelante(Lista *lista, char *v) {
   pNodo nuevo;

   /* Crear un nodo nuevo */
   nuevo = (pNodo)malloc(sizeof(tipoNodo));
   nuevo->valor = (char*)malloc(sizeof(char)*100);
   strcpy(nuevo->valor, v);
   nuevo->anterior = NULL;

   if(lista->primero == NULL)
   {
      lista->primero = lista->ultimo = nuevo;
      nuevo->siguiente = NULL;
   } else {
      nuevo->siguiente = lista->primero;
      lista->primero->anterior = nuevo;
      lista->primero = nuevo;
   }
}

void insertarAtras(Lista *lista, char *v, int indice) {
   pNodo nuevo;

   /* Crear un nodo nuevo */
   nuevo = (pNodo)malloc(sizeof(tipoNodo));
   nuevo->valor = (char*)malloc(sizeof(char)*100);
   nuevo->indice = indice;
   strcpy(nuevo->valor, v);
   nuevo->siguiente = NULL;

   if(lista->ultimo == NULL)
   {
      lista->primero = lista->ultimo = nuevo;
      nuevo->anterior = NULL;
   } else {
      nuevo->anterior = lista->ultimo;
      lista->ultimo->siguiente = nuevo;
      lista->ultimo = nuevo;
   }
}

void insertarAtrasTipo(Lista *lista, char *v, int indice, char *tipo) {
   pNodo nuevo;

   /* Crear un nodo nuevo */
   nuevo = (pNodo)malloc(sizeof(tipoNodo));
   nuevo->valor = (char*)malloc(sizeof(char)*100);
   nuevo->tipo = (char*)malloc(sizeof(char)*11);
   nuevo->indice = indice;
   strcpy(nuevo->valor, v);
   strcpy(nuevo->tipo, tipo);
   nuevo->siguiente = NULL;

   if(lista->ultimo == NULL)
   {
      lista->primero = lista->ultimo = nuevo;
      nuevo->anterior = NULL;
   } else {
      nuevo->anterior = lista->ultimo;
      lista->ultimo->siguiente = nuevo;
      lista->ultimo = nuevo;
   }
}

void reemplazarValor(Lista *lista, char *v, int indice){
   pNodo nodo = lista->primero->siguiente;
   pNodo primerNodo = lista->primero;
   if(primerNodo->indice == indice){
		strcpy(primerNodo->valor, v);
		return;
   }
   while(nodo != primerNodo)
   {
		if(nodo->indice == indice){
			strcpy(nodo->valor, v);
			return;
		}	
		nodo = nodo->siguiente;
   }
}
void obtenerValor(Lista *lista, char *v, int indice){
   pNodo nodo = lista->primero->siguiente;
   pNodo primerNodo = lista->primero;
   if(primerNodo->indice == indice){
		strcpy(v,primerNodo->valor);
		return;
   }
   while(nodo != primerNodo)
   {
		if(nodo->indice == indice){
			strcpy(v,nodo->valor);
			return;
		}	
		nodo = nodo->siguiente;
   }
}

void obtenerTipo(Lista *lista, char *t, char * v){
   pNodo nodo = lista->primero->siguiente;
   pNodo primerNodo = lista->primero;
   if(strcmp(primerNodo->valor,v)==0){
		strcpy(t,primerNodo->tipo);
		return;
   }
   while(nodo != primerNodo)
   {
		if(strcmp(nodo->valor,v)==0){
			strcpy(t,nodo->tipo);
			return;
		}	
		nodo = nodo->siguiente;
   }
   strcpy(t,"X");
}

void mostrarLista(Lista *lista)
{
   pNodo nodo = lista->primero;
   while(nodo)
   {
      printf("%d: %s\n",nodo->indice, nodo->valor);
      nodo = nodo->siguiente;
   }

}

char* modificarNombre(char* n, char *rep, char *with)
{
	 char *result; 
    char *ins;    
    char *tmp;   
    int len_rep;  
    int len_with; 
    int len_front; 
    int count;    
	len_rep = strlen(rep);
	len_with = strlen(with);
    ins = n;
    for (count = 0; tmp = strstr(ins, rep); ++count) {
        ins = tmp + len_rep;
    }

    tmp = result = malloc(strlen(n) + (len_with - len_rep) * count + 1);

    if (!result)
        return NULL;

    while (count--) {
        ins = strstr(n, rep);
        len_front = ins - n;
        tmp = strncpy(tmp, n, len_front) + len_front;
        tmp = strcpy(tmp, with) + len_with;
        n += len_front + len_rep; 
    }
    strcpy(tmp, n);
    return result;
}