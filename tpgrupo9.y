%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"
#include "lista_doble.h"
#include "pila.h"

int yylex();
int yyerror();

#define LIM_REAL 2147483647
#define LIM_INT 32768
#define LIM_STR 30

int yystopparser=0;
FILE  *yyin;
FILE *tos;         
int TOStop = 0;	

// TABLA SIMBOLOS
typedef struct 
{
    char nombre[100];
    char tipo  [11];
    char valor [100];
    int limite;
    int longitud;
} tablaDeSimbolo;

int cantPolaca = 0;
char auxBetween[100];
int contInlist;
tablaDeSimbolo TOS[100];
char tokens[100][100];  
int indexTokens = 0; 	
Lista polacaInversa;
Pila pValores;
	
int buscarEnTOS(char*);
char* getTipoTOS(char*);
void escribirSymbol(FILE* archAS,char * valor, int* puntPol,Pila* pAssembly,int* cantAuxAs);
void escribirAsembler();
void escribirCabecera();
int convertRef(char * ref);
void insertar_ID_en_Tabla(char*);
void insertar_STRING_en_Tabla(char*);
void insertar_ENTERO_en_Tabla(int);
void insertar_REAL_en_Tabla(double);
void mostrarTOS();
void GrabaArchivoTabla();
void guardarTokens(char*);
void asignarTipo(int);
char* floatAString(float);
char* intAString(int);
char* getComparadorAssembler(char*);
char* getComparadorAssemblerI(char*);
void insertarPolaca(Lista *lista, char *v);
void insertarPolacaTipo(Lista *lista, char *v, char *t);
%}

%union {
int int_val;
double float_val;
char *str_val;
}

%start program

%token ID
%token ASIG
%token OP_COMPARACION_IGUAL
%token OP_COMPARACION_DISTINTO
%token OP_SUMA
%token OP_RESTA
%token OP_MUL
%token OP_DIV
%token  P_A
%token  P_C
%token  PUNTOCOMA
%token  DOSPUNTOS
%token  COMA
%token  LL_A
%token  LL_C
%token  C_A
%token  C_C
%token  COMENTARIO_INICIO
%token  COMENTARIO_FIN
%token  OP_COMPARACION_MAYOR_A 
%token  OP_COMPARACION_MAYOR_IGUAL_A
%token  OP_COMPARACION_MENOR_A 
%token  OP_COMPARACION_MENOR_IGUAL_A

%token  BETWEEN
%token  IF
%token  THEN
%token  ELSE
%token  ENDIF
%token  WHILE
%token  ENDWHILE
%token  INLIST
%token  AND
%token  OR
%token  NOT
%token  DECVAR
%token  ENDDEC
%token  FLOAT
%token  STRING
%token  INTEGER
%token  WRITE
%token  READ
%token ENTERO REAL CADENA
%%

program: 
	programa 
		{ 
			printf("Compilacion OK\n"); 
			mostrarTOS();
			GrabaArchivoTabla();
		};

programa: 
	bloque_declaracion lista_sentencias 
		{ 
			printf("programa OK\n");
		};

bloque_declaracion: 
	DECVAR lista_declaraciones ENDDEC 
		{ 
			printf("Declaraciones OK\n");
		};

lista_declaraciones: 
	lista_declaraciones declaracion | 
	declaracion;

declaracion: 
	lista_ids 
		{
			printf("lista_ids OK\n");
		} 
	DOSPUNTOS tipo_variable 
		{
			printf("Declaracion OK\n");
		};

lista_ids: 
	lista_ids COMA ID  
		{
			printf("ID en DECVAR es: %s\n", $<str_val>$);
			insertar_ID_en_Tabla($<str_val>$);
			guardarTokens($<str_val>$);
		}

    | ID 
	    {
	    	printf("ID en DECVAR es: %s\n", $<str_val>$);
	    	insertar_ID_en_Tabla($<str_val>$);
	    	guardarTokens($<str_val>$);
	    };

tipo_variable:
	FLOAT
		{
			asignarTipo(3);
		} 
	| STRING
		{
			asignarTipo(1);
		} 
	| INTEGER 
		{
			asignarTipo(2);
		};

lista_sentencias: 
	lista_sentencias sentencia
		{
			printf("sentencia OK\n");
		} 
	| sentencia 
        {
        	printf("sentencia OK\n");
        };

sentencia: 
	iteracion 
	| decision 
	| asignacion 
	| entrada 
	| salida 
		{
			printf("salida OK\n");
		};

decision: 
	IF condicion THEN lista_sentencias ENDIF
		{
			printf("decision simple OK\n");
			char aux[100];
			char aux2[100];
			int auxInt;
			desapilar(&pValores,aux);
			auxInt = atoi(aux); // convierto el lugar a int
			sprintf(aux,"%d",cantPolaca);
			printf(aux);
			strcpy(aux2,"_etiq");
			strcat(aux2, aux);
			reemplazarValor(&polacaInversa,aux2,auxInt); // reemplazo el lugar que habia guardado con la posicion proxima donde empieza el bloque
			strcat(aux2, ":");
			insertarPolaca(&polacaInversa, aux2);
		}
	| IF condicion THEN lista_sentencias ELSE
		{
			char aux[100];
			char aux2[100];
			int auxInt;
			desapilar(&pValores,aux);
			auxInt = atoi(aux); // convierto el lugar a int
			sprintf(aux,"%d",cantPolaca+2) ;
			strcpy(aux2,"_etiq");
			strcat(aux2, aux);
			reemplazarValor(&polacaInversa,aux2,auxInt); // reemplazo el lugar que habia guardado con la posicion proxima donde empieza el bloque
			strcat(aux2, ":");
			insertarPolaca(&polacaInversa, "BI");
			insertarPolaca(&polacaInversa, "");
			sprintf(aux,"%d",cantPolaca-1);
			apilar(&pValores, aux);
			insertarPolaca(&polacaInversa, aux2);
			
		}
		lista_sentencias ENDIF
		{
			printf("decision compuesta OK\n");
			char aux[100];
			char aux2[100];
			int auxInt;
			desapilar(&pValores,aux);
			auxInt = atoi(aux); // convierto el lugar a int
			sprintf(aux,"%d",cantPolaca) ;
			strcpy(aux2,"_etiq");
			strcat(aux2,aux);
			reemplazarValor(&polacaInversa,aux2,auxInt); // reemplazo el lugar que habia guardado con la posicion proxima donde empieza el bloque
			strcat(aux2,":");
			insertarPolaca(&polacaInversa, aux2);
		};

condicion: 
	P_A evaluable P_C
		{
			printf("condicion OK\n");
		};

evaluable: 
	condicion_simple 
	{
		char aux[100];
		desapilar(&pValores,aux);
		insertarPolaca(&polacaInversa, getComparadorAssemblerI(aux));
		insertarPolaca(&polacaInversa, "");
		sprintf(aux,"%d",cantPolaca-1);
		apilar(&pValores, aux);
	}
	| condicion_multiple;

condicion_simple: 
	expresion comparador expresion {	
		
		insertarPolaca(&polacaInversa, "CMP");
		}
	| operacion_between 
	{
		char aux[100];
		int auxInt;
		char aux2[100];
		desapilar(&pValores,aux);
		
		auxInt = atoi(aux); // convierto el lugar a int
		sprintf(aux,"%d",cantPolaca) ;
		strcpy(aux2,"_etiq");
		strcat(aux2,aux);
		reemplazarValor(&polacaInversa,aux2,auxInt);
		strcat(aux2,":");
		insertarPolaca(&polacaInversa, aux2);
	};
	| operacion_inlist
	{
		char aux[100];
		int auxInt;
		char aux2[100];
		desapilar(&pValores,aux);
		
		auxInt = atoi(aux); // convierto el lugar a int
		sprintf(aux,"%d",cantPolaca) ;
		strcpy(aux2,"_etiq");
		strcat(aux2,aux);
		reemplazarValor(&polacaInversa,aux2,auxInt);
		strcat(aux2,":");
		insertarPolaca(&polacaInversa, aux2);
	};

condicion_multiple: 
	condicion_simple AND {
		char aux[100];
		desapilar(&pValores,aux); // desapilo el simbolo de comparacion
		insertarPolaca(&polacaInversa, getComparadorAssemblerI(aux));
		insertarPolaca(&polacaInversa, ""); // dejo el lugar para el salto
		sprintf(aux,"%d",cantPolaca-1); 
		apilar(&pValores, aux); //guardo la posicion del espacio que guarde
	}
	condicion_simple {
		char aux[100];
		char aux2[100];
		int auxInt;
		desapilar(&pValores,aux); //recupero el simbolo de comparacion
		insertarPolaca(&polacaInversa, getComparadorAssembler(aux));
		sprintf(aux,"%d",cantPolaca+2); 
		insertarPolaca(&polacaInversa, aux); // si es verdadero esquivo el salto que me lleva al fin del bloque
		desapilar(&pValores,aux);// recupero el lugar que guarde antes
		auxInt = atoi(aux); // convierto el lugar a int
		sprintf(aux,"%d",cantPolaca) ;
		strcpy(aux2,"_etiq");
		strcat(aux2,aux);
		reemplazarValor(&polacaInversa,aux2,auxInt); // reemplazo el lugar que habia guardado con la posicion del salto incondicional al final del bloque
		strcat(aux2,":");
		insertarPolaca(&polacaInversa,aux2);
		insertarPolaca(&polacaInversa, "BI");
		insertarPolaca(&polacaInversa, ""); // dejo el lugar para el salto
		sprintf(aux,"%d",cantPolaca-1);
		apilar(&pValores, aux); // guardo la posicion
	}
	| condicion_simple OR
	{
		char aux[100];
		desapilar(&pValores,aux); // desapilo el simbolo de comparacion
		insertarPolaca(&polacaInversa, getComparadorAssembler(aux));
		insertarPolaca(&polacaInversa, ""); // dejo el lugar para el salto
		sprintf(aux,"%d",cantPolaca-1); 
		apilar(&pValores, aux); //guardo la posicion del espacio que guarde
	}
	condicion_simple
	{
		char aux[100];
		char aux2[100];
		int auxInt;
		desapilar(&pValores,aux); //recupero el simbolo de comparacion
		insertarPolaca(&polacaInversa, getComparadorAssemblerI(aux));
		insertarPolaca(&polacaInversa, ""); // dejo el lugar para el salto
		desapilar(&pValores,aux);// recupero el lugar que guarde antes
		auxInt = atoi(aux); // convierto el lugar a int
		sprintf(aux,"%d",cantPolaca) ;
		strcpy(aux2,"_etiq");
		strcat(aux2,aux);
		reemplazarValor(&polacaInversa,aux2,auxInt); // reemplazo el lugar que habia guardado con la posicion proxima donde empieza el bloque
		strcat(aux2,":");
		insertarPolaca(&polacaInversa,aux2);
		sprintf(aux,"%d",cantPolaca-1);
		apilar(&pValores, aux); // guardo la posicion
	}	
	| NOT condicion_simple
	{
		char aux[100];
		desapilar(&pValores,aux);
		insertarPolaca(&polacaInversa, getComparadorAssembler(aux));
		insertarPolaca(&polacaInversa, "");
		sprintf(aux,"%d",cantPolaca-1);
		apilar(&pValores, aux);
	};

comparador: 
	OP_COMPARACION_DISTINTO 
		{
			printf("Comparador OK\n");
			apilar(&pValores, "!=");
		};
	| OP_COMPARACION_MAYOR_A 
		{
			printf("Comparador OK\n");
			apilar(&pValores, ">");
		};
	| OP_COMPARACION_MAYOR_IGUAL_A 
		{
			printf("Comparador OK\n");
			apilar(&pValores, ">=");
		};
	| OP_COMPARACION_MENOR_A 
		{
			printf("Comparador OK\n");
			apilar(&pValores, "<");
		};
	| OP_COMPARACION_MENOR_IGUAL_A 
		{
			printf("Comparador OK\n");
			apilar(&pValores, "<=");
		};
	| OP_COMPARACION_IGUAL
		{
			printf("Comparador OK\n");
			apilar(&pValores, "==");
		};

operacion_between: 
	BETWEEN P_A ID COMA C_A
		{
			char tipo[11];
			strcpy(tipo,getTipoTOS($<str_val>3));
			insertarPolacaTipo(&polacaInversa, $<str_val>3, tipo);
			strcpy(auxBetween,$<str_val>3);
			
		}
	expresion
		{
			char aux[100];
			int auxInt;
			insertarPolaca(&polacaInversa, "CMP");
			insertarPolaca(&polacaInversa, "BLT");
			insertarPolaca(&polacaInversa, "");
			sprintf(aux,"%d",cantPolaca-1); 
			apilar(&pValores, aux); //guardo la posicion del espacio que guarde
			
			

		}
	PUNTOCOMA
		{
			
			
			
			insertarPolaca(&polacaInversa, auxBetween);
			
		}
	expresion
		{
			char aux[100];
			char aux2[100];
			char aux3 [100];
			int auxInt;
			
			insertarPolaca(&polacaInversa, "CMP");
			insertarPolaca(&polacaInversa, "BLE");
			sprintf(aux,"%d",cantPolaca+6); 
			// si es verdadero esquivo la comparacion con 0 y su salto por negativo
			strcpy(aux2,"_etiq");
			strcat(aux2,aux);
			insertarPolaca(&polacaInversa, aux2); 
			strcpy(aux3, aux2);
			strcat(aux3, ":");
			desapilar(&pValores,aux);// recupero el lugar que guarde antes
			auxInt = atoi(aux); // convierto el lugar a int
			sprintf(aux,"%d",cantPolaca);
			strcpy(aux2,"_etiq");
			strcat(aux2,aux);
			reemplazarValor(&polacaInversa,aux2,auxInt); // reemplazo el lugar que habia guardado con la posicion del salto incondicional al final del bloque
			strcat(aux2,":");
			insertarPolaca(&polacaInversa, aux2);
			insertarPolaca(&polacaInversa, "0");
			insertarPolaca(&polacaInversa, "1");
			insertarPolaca(&polacaInversa, "CMP");
			insertarPolaca(&polacaInversa, "BI");
			insertarPolaca(&polacaInversa, "");
			sprintf(aux,"%d",cantPolaca-1); 
			//strcpy(aux2,"_etiq");
			//strcat(aux2,aux);
			//insertarPolaca(&polacaInversa, aux2);
			insertarPolaca(&polacaInversa, aux3);
			//strcat(aux2,":");
			insertarPolaca(&polacaInversa, "1");
			insertarPolaca(&polacaInversa, "1");
			//insertarPolaca(&polacaInversa, aux2);
			insertarPolaca(&polacaInversa, "CMP");
			apilar(&pValores, "=="); // Apilo el simbolo para simular una comparacion
			apilar(&pValores, aux);
			
		}
	C_C P_C 
		{
			printf("between OK\n");
		};

operacion_inlist: 
	INLIST P_A ID 
	{
		apilar(&pValores, $<str_val>3);
		contInlist=0;
	}
	COMA C_A lista_expresiones C_C P_C 
		{
			
			printf("Inlist OK\n");
			
			char aux[100];
			char aux2[100];
			char aux3[100];
			char aux4[100];
			int auxInt;
			desapilar(&pValores,aux); // obtengo el ID
			insertarPolaca(&polacaInversa, "0");
			insertarPolaca(&polacaInversa, "1");
			insertarPolaca(&polacaInversa, "CMP");
			insertarPolaca(&polacaInversa, "BI");
			insertarPolaca(&polacaInversa, "");
			sprintf(aux4,"%d",cantPolaca-1); 
			
			//insertarPolaca(&polacaInversa, aux);		
			sprintf(aux,"%d",cantPolaca);		
			int i;
			for(i = 0; i<contInlist ; i++){
				desapilar(&pValores,aux2); // obtengo la posicion
				auxInt = atoi(aux2); // convierto el lugar a int
				strcpy(aux3,"_etiq");
				strcat(aux3,aux);
				reemplazarValor(&polacaInversa,aux3,auxInt);
			}
			strcat(aux3,":");
			insertarPolaca(&polacaInversa, aux3);
			insertarPolaca(&polacaInversa, "1");
			insertarPolaca(&polacaInversa, "1");
			insertarPolaca(&polacaInversa, "CMP");
			apilar(&pValores, "=="); // Apilo el simbolo para simular una comparacion
			apilar(&pValores, aux4);
			
			
		};

lista_expresiones: 
	lista_expresiones PUNTOCOMA	expresion 
		{
			char aux[100];
			char aux2[100];
			desapilar(&pValores,aux); // obtengo el ID
			char tipo[11];
			strcpy(tipo,getTipoTOS(aux));
			insertarPolacaTipo(&polacaInversa, aux, tipo);
			//insertarPolaca(&polacaInversa, aux);
			insertarPolaca(&polacaInversa, "CMP");
			insertarPolaca(&polacaInversa, "BEQ");
			insertarPolaca(&polacaInversa, "");
			sprintf(aux2,"%d",cantPolaca-1) ;
			apilar(&pValores, aux2); // apilo la posicion
			apilar(&pValores, aux); // apilo el ID
			contInlist++;
			
		};
	| expresion
		{
			char aux[100];
			char aux2[100];
			desapilar(&pValores,aux); // obtengo el ID
			char tipo[11];
			strcpy(tipo,getTipoTOS(aux));
			insertarPolacaTipo(&polacaInversa, aux, tipo);
			//insertarPolaca(&polacaInversa, aux);
			insertarPolaca(&polacaInversa, "CMP");
			insertarPolaca(&polacaInversa, "BEQ");
			insertarPolaca(&polacaInversa, "");
			sprintf(aux2,"%d",cantPolaca-1) ;
			apilar(&pValores, aux2); // apilo la posicion
			apilar(&pValores, aux); // apilo el ID
			contInlist++;
			
			
		};

asignacion: 
	ID
		{
			//insertarPolaca(&polacaInversa, $<str_val>$);
			char tipo[11];
			strcpy(tipo,getTipoTOS($<str_val>1));
			insertarPolacaTipo(&polacaInversa, $<str_val>1, tipo);
		} 
	ASIG 
		{
			printf("Asignacion ID:%s \n", $<str_val>1);
		} 
	asignable
		{
			insertarPolaca(&polacaInversa, "=");
		};
      
asignable: 
	expresion 
		{
			printf("Num OK\n");
		}
	| CADENA
		{
			printf("STR:%s \n", $<str_val>1);
			insertar_STRING_en_Tabla($<str_val>1);
			insertarPolaca(&polacaInversa, $<str_val>1);
		};

salida:
	WRITE CADENA 
		{
			char tipo[11];
			strcpy(tipo,"CADENA");
			insertar_STRING_en_Tabla($<str_val>2);
			insertarPolacaTipo(&polacaInversa, $<str_val>2, tipo);
			//insertarPolaca(&polacaInversa, $<str_val>2);
			insertarPolaca(&polacaInversa, "WRITE");
		}
	| WRITE ID
		{
			printf("WRITE OK \n");
			char tipo[11];
			strcpy(tipo,getTipoTOS($<str_val>2));
			insertarPolacaTipo(&polacaInversa, $<str_val>2, tipo);
			//insertarPolaca(&polacaInversa, $<str_val>2);
			insertarPolaca(&polacaInversa, "WRITE");
		};

entrada: 
	READ ID 
		{
			printf("entrada OK\n");
			char tipo[11];
			strcpy(tipo,getTipoTOS($<str_val>2));
			insertarPolacaTipo(&polacaInversa, $<str_val>2, tipo);
			//insertarPolaca(&polacaInversa, $<str_val>2);
			insertarPolaca(&polacaInversa, "READ");
		};

iteracion:
	WHILE 
		{
			char aux[100];
			char aux2[100];
			printf("While OK\n");
			sprintf(aux,"%d",cantPolaca);
			strcpy(aux2,"_etiq");
			strcat(aux2,aux);
			strcat(aux2,":");
			insertarPolaca(&polacaInversa, aux2);
			apilar(&pValores, aux);
		} 
	condicion THEN lista_sentencias ENDWHILE 
		{
			printf("iteracion OK\n");
			char aux[100];
			char aux2[100];
			char aux3[100];
			int auxInt;
			desapilar(&pValores,aux);
			auxInt = atoi(aux); // convierto el lugar a int
			sprintf(aux,"%d",cantPolaca+2) ;
			strcpy(aux2,"_etiq");
			strcat(aux2,aux);
			strcpy(aux3,aux2);
			reemplazarValor(&polacaInversa,aux2,auxInt); // reemplazo el lugar que habia guardado con la posicion proxima donde empieza el bloque
			
			insertarPolaca(&polacaInversa, "BI");
			desapilar(&pValores,aux);
			strcpy(aux2,"_etiq");
			strcat(aux2,aux);
			insertarPolaca(&polacaInversa, aux2);
			strcat(aux3,":");
			insertarPolaca(&polacaInversa, aux3);
		};







    
expresion:
	termino
	|expresion OP_RESTA termino
		{
			printf("Resta OK\n");
			insertarPolaca(&polacaInversa, "-");
		}
	|expresion OP_SUMA termino
		{
			printf("Suma OK\n");
			insertarPolaca(&polacaInversa, "+");
		};

termino: 
	factor
	|termino OP_MUL factor  
		{
			printf("Multiplicación OK\n");
			insertarPolaca(&polacaInversa, "*");
		}
	|termino OP_DIV factor  
		{
		-	printf("División OK\n");
			insertarPolaca(&polacaInversa, "/");
		};

factor: 
	ID
		{
			printf("ID en FACTOR es: %s \n", $<str_val>$);
			char tipo[11];
			strcpy(tipo,getTipoTOS($<str_val>$));
			insertarPolacaTipo(&polacaInversa, $<str_val>$, tipo);
			//insertarPolaca(&polacaInversa, $<str_val>$);
		}
	| ENTERO 
		{
			printf("ENTERO en FACTOR es: %d \n", $<int_val>$);
			insertar_ENTERO_en_Tabla($<int_val>$);
			insertarPolacaTipo(&polacaInversa, intAString($<int_val>$), "ENTERO");
			//insertarPolaca(&polacaInversa, intAString($<int_val>$));
		}
	| REAL 
		{
			printf("REAL en FACTOR es: %f \n", $<float_val>$);
			insertar_REAL_en_Tabla($<float_val>$);
			insertarPolacaTipo(&polacaInversa, floatAString($<int_val>$), "REAL");
			//insertarPolaca(&polacaInversa, floatAString($<float_val>$));
		}
	|P_A expresion P_C;

%%
int main(int argc,char *argv[])
{
	polacaInversa = crearLista();
	pValores = crearPila();

  if ((yyin = fopen(argv[1], "rt")) == NULL)
  {
	printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
  }
  else
  {
	  yyparse();
	  if ((tos = fopen ("TablaDeSimbolos.txt","w"))== NULL)
	  {
		  printf("No se puede crear el archivo de la tabla de simbolos");
		  exit(1);
	  }
	  mostrarTOS();
	  if(fclose(tos)!=0)
	  {
		  printf("No se puede CERRAR el archivo de la tabla de simbolos");
		  exit(1);
	  }
	  mostrarLista(&polacaInversa);
	  escribirAsembler();
  }
  fclose(yyin);
  return 0;
}
int yyerror(void)
     {
       printf("Syntax Error\n");
   system ("Pause");
   exit (1);
     }

void mostrarError(char *mensaje) {
  printf("ERROR!!!: %s\n", mensaje);
  exit(1);
}

void insertar_ID_en_Tabla(char* token)
{
	char aux[100];
	strcat(aux, token);
	if(!buscarEnTOS(token))
	{
		strcpy(TOS[TOStop].nombre, token);
		strcpy(TOS[TOStop].tipo,"ID" );
		TOStop++;
	}
}

void insertar_STRING_en_Tabla(char* token)
{
	char aux[100];
	strcpy(aux,"_");
	strcat(aux, token);
	if(!buscarEnTOS(aux))
	{
		strcpy(TOS[TOStop].nombre, aux);
		strcpy(TOS[TOStop].tipo,"CADENA" );
		strcpy(TOS[TOStop].valor, token);
		TOS[TOStop].longitud = (strlen(token));
		TOS[TOStop].limite = LIM_STR;
		TOStop++;
	}
}

void insertar_ENTERO_en_Tabla(int token)
{			
	char aux[100];
	char aux2[100];
	sprintf(aux2, "%d", token);
	strcpy(aux,"_");
	strcat(aux, aux2);
	if(!buscarEnTOS(aux))
	{
		strcpy(TOS[TOStop].nombre, aux);
		strcpy(TOS[TOStop].tipo,"ENTERO");
		strcpy(TOS[TOStop].valor, aux2);
		TOS[TOStop].limite = LIM_INT;
		TOStop++;
	}
}

void guardarTokens(char* token)
{
	strcpy(tokens[indexTokens], token);
	indexTokens++;
}


void asignarTipo(int tipo)
{
	int i;
	int j;
	for (i=0; i<indexTokens; i++)
    {
		for(j=0; j<TOStop; j++)
		{

			if(strcmp(TOS[j].nombre, tokens[i]) == 0)
			{
				switch (tipo)
				{
					case 1:
						strcpy(TOS[j].tipo, "CADENA");
						TOS[j].limite=LIM_STR;
					break;
					case 2:
						strcpy(TOS[j].tipo, "ENTERO");
						TOS[j].limite=LIM_INT;
					break;
					case 3:
						strcpy(TOS[j].tipo, "REAL");
						TOS[j].limite=LIM_REAL;
					break;
				}
			}
		}
	}
	indexTokens =0;
}

void insertar_REAL_en_Tabla(double token)
{
	char aux[100];
	strcpy(aux,"_");
	char aux2[100];
	sprintf(aux2, "%lf", token);
	strcat(aux, aux2);
	if(!buscarEnTOS(aux))
	{
		strcpy(TOS[TOStop].nombre,aux);
		strcpy(TOS[TOStop].tipo,"REAL");
		strcpy(TOS[TOStop].valor, aux2);
		TOS[TOStop].limite = LIM_REAL;
		TOStop++;
	}
}

void GrabaArchivoTabla()
{
     FILE * tsBin = fopen("TS_assembler.txt","wb");
     int k;
     for(k=0;k<TOStop;k++)
         fwrite(&TOS[k],sizeof(tablaDeSimbolo),1,tsBin);
     fclose(tsBin);
}



void mostrarTOS()
{
    int i;
	char aux[100];
    fprintf(tos,"\n------------------------------ TABLA DE  SIMBOLOS ------------------------------\n");
    for (i=0; i<TOStop; i++)
    {
		sprintf(aux, "%d", TOS[i].longitud);
		if(strcmp(aux, "0") == 0)
			aux[0] = '\0';
        fprintf(tos,"Nombre: %s  | Tipo: %s   | Valor: %s | Limite: %d | Longitud: %s \n",TOS[i].nombre, TOS[i].tipo, TOS[i].valor, TOS[i].limite, aux);
    }

    fprintf(tos,"\n------------------------------ TABLA DE  SIMBOLOS ------------------------------\n");
}


int buscarEnTOS(char* nombre)
{
	int i;
	for (i=0; i<TOStop; i++)
    {
		if(strcmp(TOS[i].nombre, nombre) == 0)
		{
			return 1;
		}
	}
	
	return 0;
}

char * getTipoTOS(char* nombre)
{
	int i;
	char * result=(char*)malloc(sizeof(char) * 11);
	for (i=0; i<TOStop; i++)
    {
		if(strcmp(TOS[i].nombre, nombre) == 0)
		{
			strcpy(result,TOS[i].tipo);
			return result;
		}
	}
	
	strcpy(result,"");
	return result;
}

/*****************************
	METODOS DE POLACA INVERSA 
*****************************/

char* floatAString(float numero)
{
	char *aux = (char*)malloc(sizeof(char) * 100);
	sprintf(aux,"%f",numero);
	printf("probando: %s\n", aux);
	return aux;
}

char* intAString(int numero)
{
	char *aux = (char*)malloc(sizeof(char) * 100);
	sprintf(aux,"%d",numero);
	return aux;
}

void insertarPolaca(Lista *lista, char *v) {
	insertarAtras(lista,v,cantPolaca);
	cantPolaca++;
}

void insertarPolacaTipo(Lista *lista, char *v, char *t) {
	insertarAtrasTipo(lista,v,cantPolaca, t);
	cantPolaca++;
}

//Obtiene el codigo assembler para tal comparador
char* getComparadorAssembler(char* cadena)
{

	printf("Cadena: %s" , cadena);
	if(strcmp(cadena, "<") == 0)
		return "BLT";
	if(strcmp(cadena, ">=") == 0)
		return "BGE";
	if(strcmp(cadena, "==") == 0)
		return "BEQ";
	if(strcmp(cadena, ">") == 0)
		return "BGT";
	if(strcmp(cadena, "!=") == 0)
		return "BNE";
	if(strcmp(cadena, "<=") == 0)
		return "BLE";
	return NULL;
}
char* getComparadorAssemblerI(char* cadena)
{

	printf("Cadena: %s" , cadena);
	if(strcmp(cadena, "<") == 0)
		return "BGE";
	if(strcmp(cadena, ">=") == 0)
		return "BLT";
	if(strcmp(cadena, "==") == 0)
		return "BNE";
	if(strcmp(cadena, ">") == 0)
		return "BLE";
	if(strcmp(cadena, "!=") == 0)
		return "BEQ";
	if(strcmp(cadena, "<=") == 0)
		return "BGT";
	return NULL;
}

void escribirCabecera()
{
    FILE *tabla = fopen("TS_assembler.txt","r");
    tablaDeSimbolo datos;
	FILE* archAS = fopen("test.asm", "w");
	int len;
	char tipo[3]="";
	fprintf(archAS, "include macros2.asm \n");
    fprintf(archAS, "include number.asm \n");
   
	
    fprintf(archAS, ".MODEL LARGE ; Modelo de memoria. \n");
    fprintf(archAS, ".386 ; Tipo de procesador. \n");
    fprintf(archAS, ".STACK 200h ;Bytes en el Stack. \n\n");

	fprintf(archAS, ".DATA \n\n");
	
	fread(&datos, sizeof(datos), 1, tabla);

    while (feof(tabla) == 0)
    {
      if (strcmp(datos.tipo,"ENTERO")==0)
      {
         strcpy(tipo,"DD");
		 len = strlen(datos.valor);
		 if(len > 0)
		 {
			fprintf(archAS, "%s \t %s \t %s  \n", datos.nombre,tipo,datos.valor);
		 } else {
			fprintf(archAS, "%s \t %s \t ? \n", datos.nombre,tipo);
		 }
      }

      if (strcmp(datos.tipo,"REAL")==0)
      {
         strcpy(tipo,"DD");
		 len = strlen(datos.valor);
		 if(len > 0)
		 {
			fprintf(archAS, "%s \t %s \t %s  \n", datos.nombre,tipo,datos.valor);
		 } else {
			fprintf(archAS, "%s \t %s \t ? \n", datos.nombre,tipo);
		 }
      }
      
      if ((strcmp(datos.tipo,"CADENA")==0))
      {
         strcpy(tipo,"DB");
		 len = strlen(datos.valor);
		 if(len > 0)
		 {
			fprintf(archAS, "%s \t %s \t \"%s\" , '$', %d dup(?) \n", datos.nombre, tipo, datos.valor, LIM_STR - datos.longitud +1);
		 } else {
			fprintf(archAS, "%s \t %s \t %d dup(?), '$'  \n", datos.nombre, tipo, LIM_STR);
		 }
      }

      fread(&datos, sizeof(datos), 1, tabla);
   }
	
	fprintf(archAS, ".CODE \n\n");
	fprintf(archAS, "MOV AX, @DATA \n\n");
	fprintf(archAS, "MOV DS,AX \n\n");
   fclose(archAS);

}

	
void escribirAsembler(){
	
	escribirCabecera();
	FILE* archAS = fopen("test.asm", "a+");
	char auxAssS[100];
	int cantAuxAs = 0;
	int i;
	Pila pAssembly = crearPila();
	//fprintf(archAS, "hola");
	for(i = 0; i < cantPolaca; i++){
		obtenerValor(&polacaInversa, auxAssS, i);
		escribirSymbol(archAS,auxAssS,&i,&pAssembly,&cantAuxAs);	
	}		
	fclose(archAS);
}

int convertRef(char * ref){
	return atoi(ref);
}

void escribirSymbol(FILE* archAS,char * valorLeido, int* puntPol,Pila* pAssembly,int* cantAuxAs){
	char auxTest[100];
	char auxTest2[100];
	FILE* archPOL = fopen("polaca.txt", "a+");
	char tipo[11];
	fprintf(archPOL, " %s \n",valorLeido);
	
	if(strcmp(valorLeido, "BI") == 0){
		(*puntPol)++;
		obtenerValor(&polacaInversa, auxTest, *puntPol);
		fprintf(archAS, "jmp %s\n", auxTest);
		return;
	}
	if(strcmp(valorLeido, "BLT") == 0){
		(*puntPol)++;
		obtenerValor(&polacaInversa, auxTest, *puntPol);
		fprintf(archAS, "jb %s \n",auxTest);
		return;
	}
	if(strcmp(valorLeido, "BLE") == 0){
		(*puntPol)++;
		obtenerValor(&polacaInversa, auxTest, *puntPol);
		fprintf(archAS, "jbe %s \n",auxTest);
		return;
	}
	if(strcmp(valorLeido, "BNE") == 0){
		(*puntPol)++;
		obtenerValor(&polacaInversa, auxTest, *puntPol);
		fprintf(archAS, "jne %s \n",auxTest);
		return;
	}
	if(strcmp(valorLeido, "BEQ") == 0){
		(*puntPol)++;
		obtenerValor(&polacaInversa, auxTest, *puntPol);
		fprintf(archAS, "je %s \n",auxTest);
		return;
	}
	if(strcmp(valorLeido, "BGT") == 0){
		(*puntPol)++;
		obtenerValor(&polacaInversa, auxTest, *puntPol);
		fprintf(archAS, "jg %s \n",auxTest);
		return;
	}
	if(strcmp(valorLeido, "BGE") == 0){
		(*puntPol)++;
		obtenerValor(&polacaInversa, auxTest, *puntPol);
		fprintf(archAS, "jge %s \n",auxTest);
		return;
	}
	if(strcmp(valorLeido, "CMP") == 0){
		desapilar(pAssembly,auxTest2);
		desapilar(pAssembly,auxTest);
		fprintf(archAS, "CMP %s,%s\n",auxTest2,auxTest);
		return;
	}
	if(strcmp(valorLeido, "=") == 0){
		desapilar(pAssembly,auxTest2);
		desapilar(pAssembly,auxTest);
		fprintf(archAS, "MOV R1,%s\n",auxTest2);
		fprintf(archAS, "MOV %s,R1\n",auxTest);
		return;
	}
	if(strcmp(valorLeido, "+") == 0){
		desapilar(pAssembly,auxTest2);
		desapilar(pAssembly,auxTest);
		fprintf(archAS, "MOV R1,%s\n",auxTest);
		fprintf(archAS, "ADD R1,%s\n",auxTest2);
		sprintf(auxTest,"@aux%d",*cantAuxAs);
		fprintf(archAS, "MOV %s,R1\n",auxTest);
		apilar(pAssembly,auxTest);
		(*cantAuxAs)++;
		return;
	}
	if(strcmp(valorLeido, "-") == 0){
		desapilar(pAssembly,auxTest2);
		desapilar(pAssembly,auxTest);
		fprintf(archAS, "MOV R1,%s\n",auxTest);
		fprintf(archAS, "SUB R1,%s\n",auxTest2);
		sprintf(auxTest,"@aux%d",*cantAuxAs);
		fprintf(archAS, "MOV %s,R1\n",auxTest);
		apilar(pAssembly,auxTest);
		(*cantAuxAs)++;
		return;
	}
	if(strcmp(valorLeido, "*") == 0){
		desapilar(pAssembly,auxTest2);
		desapilar(pAssembly,auxTest);
		fprintf(archAS, "MOV R1,%s\n",auxTest);
		fprintf(archAS, "MUL R1,%s\n",auxTest2);
		sprintf(auxTest,"@aux%d",*cantAuxAs);
		fprintf(archAS, "MOV %s,R1\n",auxTest);
		apilar(pAssembly,auxTest);
		(*cantAuxAs)++;
		return;
	}
	if(strcmp(valorLeido, "/") == 0){
		desapilar(pAssembly,auxTest2);
		desapilar(pAssembly,auxTest);
		fprintf(archAS, "MOV R1,%s\n",auxTest);
		fprintf(archAS, "DIV R1,%s\n",auxTest2);
		sprintf(auxTest,"@aux%d",*cantAuxAs);
		fprintf(archAS, "MOV %s,R1\n",auxTest);
		apilar(pAssembly,auxTest);
		(*cantAuxAs)++;
		return;
	}
	if(strcmp(valorLeido, "WRITE") == 0){
		desapilar(pAssembly,auxTest);
		obtenerTipo(&polacaInversa, tipo, auxTest);
		if(strcmp(tipo,"ENTERO") == 0)
		{
			fprintf(archAS, "DisplayInteger %s \n",auxTest);
		}
		if(strcmp(tipo,"REAL") == 0)
		{
			fprintf(archAS, "DisplayFloat %s,6  \n",auxTest);
		}
		if(strcmp(tipo,"CADENA") == 0)
		{
			fprintf(archAS, "displayString %s \n",auxTest);
		}
		return;
	}
	if(strcmp(valorLeido, "READ") == 0){
		desapilar(pAssembly,auxTest);
		obtenerTipo(&polacaInversa, tipo, auxTest);
		if(strcmp(tipo,"ENTERO") == 0)
		{
			fprintf(archAS, "GetInteger %s \n",auxTest);
		}
		if(strcmp(tipo,"REAL") == 0)
		{
			fprintf(archAS, "GetFloat %s,6  \n",auxTest);
		}
		if(strcmp(tipo,"CADENA") == 0)
		{
			fprintf(archAS, "getString %s \n",auxTest);
		}
		return;
	}
	
	
	apilar(pAssembly,valorLeido);

}

