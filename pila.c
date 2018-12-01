#include <stdio.h>
#include <stdlib.h>
#include "pila.h"

Pila crearPila()
{
   Pila pila;
   pila.base = NULL;
   pila.tope = NULL;
   return pila;
}

void apilar(Pila *pila, char *v){
   /* Crear un nodo nuevo */
   pNodoPila nuevo = (pNodoPila)malloc(sizeof(tipoNodoPila));
   nuevo->valor = (char*)malloc(sizeof(char)*100);
   strcpy(nuevo->valor, v);

   if(pila->tope == NULL)
   {
      pila->base = pila->tope = nuevo;
      nuevo->anterior = NULL;
   } else {
      nuevo->anterior = pila->tope;
      pila->tope = nuevo;
   }
}

void desapilar(Pila *pila, char *v){
	if(pila->tope == NULL){
		return;
	}
	pNodoPila aux;
	strcpy(v, pila->tope->valor);
	aux = pila->tope;
	pila->tope = pila->tope->anterior;
	free(aux);

}

int buscarEnPila(Pila *pila, char *v){
	if(pila->tope == NULL){
		return 0;
	}
	pNodoPila aux;
	aux = pila->tope;
	while(aux != NULL)
	{
		if (strcmp(v, aux->valor) == 0)
		{
			return 1;
		}
		aux = aux->anterior;
	}
	return 0;

}

void mostrarPila(Pila *pila)
{
   pNodoPila nodo = pila->tope;
   while(nodo)
   {
      printf("%s\n", nodo->valor);
      nodo = nodo->anterior;
   }

}