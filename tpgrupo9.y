%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"

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
struct tablaDeSimbolo
{
    char nombre[100];
    char tipo  [11];
    char valor [100];
    int limite;
    int longitud;
};

struct tablaDeSimbolo TOS[100];
char tokens[100][100];  
int indexTokens = 0; 	
	
int buscarEnTOS(char*);
void insertar_ID_en_Tabla(char*);
void insertar_STRING_en_Tabla(char*);
void insertar_ENTERO_en_Tabla(int);
void insertar_REAL_en_Tabla(double);
void mostrarTOS();
void guardarTokens(char*);
void asignarTipo(int);

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

program: programa { printf("Compilacion OK\n"); mostrarTOS();};

programa: bloque_declaracion lista_sentencias { printf("programa OK\n");};

bloque_declaracion: DECVAR lista_declaraciones ENDDEC { printf("Declaraciones OK\n");};

lista_declaraciones: lista_declaraciones declaracion
          | declaracion;

declaracion: lista_ids {printf("lista_ids OK\n");} DOSPUNTOS tipo_variable { printf("Declaracion OK\n");};

lista_ids: lista_ids COMA ID  {;printf("ID en DECVAR es: %s\n", $<str_val>$);insertar_ID_en_Tabla($<str_val>$);guardarTokens($<str_val>$);}
      | ID {;printf("ID en DECVAR es: %s\n", $<str_val>$);insertar_ID_en_Tabla($<str_val>$);guardarTokens($<str_val>$);};

tipo_variable: FLOAT {;asignarTipo(3);} | STRING {;asignarTipo(1);} | INTEGER {;asignarTipo(2);};

lista_sentencias: lista_sentencias sentencia {printf("sentencia OK\n");} 
        | sentencia {printf("sentencia OK\n");};

sentencia: iteracion | decision | asignacion | entrada | salida {printf("salida OK\n");};

decision: IF condicion THEN lista_sentencias ENDIF {printf("decision simple OK\n");}
        | IF condicion THEN lista_sentencias ELSE lista_sentencias ENDIF {printf("decision compuesta OK\n");};

condicion: P_A evaluable P_C {printf("condicion OK\n");};

evaluable: condicion_simple | condicion_multiple;

condicion_simple: expresion comparador expresion | operacion_between | operacion_inlist;

condicion_multiple: condicion_simple AND condicion_simple | condicion_simple OR condicion_simple | NOT condicion_simple;

comparador: OP_COMPARACION_DISTINTO | OP_COMPARACION_MAYOR_A | OP_COMPARACION_MAYOR_IGUAL_A | OP_COMPARACION_MENOR_A 
            | OP_COMPARACION_MENOR_IGUAL_A | OP_COMPARACION_IGUAL {printf("Comparador OK\n");};

operacion_between: BETWEEN P_A ID COMA C_A expresion PUNTOCOMA expresion C_C P_C {printf("between OK\n");};

operacion_inlist: INLIST P_A ID COMA C_A lista_expresiones C_C P_C {printf("Inlist OK\n");};

lista_expresiones: lista_expresiones PUNTOCOMA expresion | expresion;

asignacion: ID ASIG {printf("Asignacion ID:%s \n", $<str_val>1);} asignable;
      
asignable: expresion {printf("Num OK\n");}| CADENA{printf("STR:%s \n", $<str_val>1);insertar_STRING_en_Tabla($<str_val>1);};

salida:  WRITE CADENA | WRITE ID;

entrada: READ ID {printf("entrada OK\n");};

iteracion: WHILE {printf("While OK\n");} condicion THEN lista_sentencias ENDWHILE {printf("iteracion OK\n");};







    
expresion:
         termino
   |expresion OP_RESTA termino {printf("Resta OK\n");}
       |expresion OP_SUMA termino  {printf("Suma OK\n");}

   ;

termino: 
       factor
       |termino OP_MUL factor  {printf("Multiplicación OK\n");}
       |termino OP_DIV factor  {printf("División OK\n");}
       ;

factor: 
      ID {;printf("ID en FACTOR es: %s \n", $<str_val>$);}
      | ENTERO {;printf("ENTERO en FACTOR es: %d \n", $<int_val>$);insertar_ENTERO_en_Tabla($<int_val>$);}
      | REAL {printf("REAL en FACTOR es: %f \n", $<float_val>$);insertar_REAL_en_Tabla($<float_val>$);}
      |P_A expresion P_C  
    ;

%%
int main(int argc,char *argv[])
{
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
		TOStop++;
	}
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