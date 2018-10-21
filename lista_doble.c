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

void insertarAtras(Lista *lista, char *v) {
   pNodo nuevo;

   /* Crear un nodo nuevo */
   nuevo = (pNodo)malloc(sizeof(tipoNodo));
   nuevo->valor = (char*)malloc(sizeof(char)*100);
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

void mostrarLista(Lista *lista)
{
   pNodo nodo = lista->primero;
   while(nodo)
   {
      printf("%s\n", nodo->valor);
      nodo = nodo->siguiente;
   }

}