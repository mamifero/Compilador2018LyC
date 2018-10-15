%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
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
    char ren   [31];
    int longitud;
};

struct tablaDeSimbolo TOS[100];
   	
	
char * buscarEnTOS(int);
int insertarTOS();
void mostrarTOS();

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

program: programa { printf("Compilacion OK\n");};

programa: bloque_declaracion lista_sentencias { printf("programa OK\n");};

bloque_declaracion: DECVAR lista_declaraciones ENDDEC { printf("Declaraciones OK\n");};

lista_declaraciones: lista_declaraciones declaracion
          | declaracion;

declaracion: lista_ids {printf("lista_ids OK\n");} DOSPUNTOS tipo_variable { printf("Declaracion OK\n");};

lista_ids: lista_ids COMA ID  {;printf("ID en DECVAR es: %s\n", $<str_val>$);}
      | ID {;printf("ID en DECVAR es: %s\n", $<str_val>$);};

tipo_variable: FLOAT | STRING | INTEGER;

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
      
asignable: expresion {printf("Num OK\n");}| CADENA{printf("STR:%s \n", $<str_val>1);};

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
      | numero_entero {;printf("ENTERO en FACTOR es: %d \n", $<int_val>$);}
      | numero_real {printf("REAL en FACTOR es: %f \n", $<float_val>$);}
      |P_A expresion P_C  
    ;

numero_real: REAL | OP_RESTA REAL;

numero_entero: ENTERO | OP_RESTA ENTERO;

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

int insertarTOS()
{
	int i,j,x=0;
    int ii=0;
    char aux[100];
    char auxStr[100];

    if (NroToken==CTE_STR)
    {
        strcpy(auxStr," ");

        for (j=0;j< strlen(token);j++)
        {
            if(token[j]!='"')
            {
                auxStr[x]= token[j];
                x++;
            }
        }

        auxStr[strlen(token)-2]='\0';
    }


    for (i=0; i<TOStop;  i++)
    {
        if (NroToken==ID)
        {
            if (strcmp(TOS[i].nombre,token)==0)
                return i;
        }
        else if (NroToken==CTE_STR)
        {
            if (strcmp(TOS[i].valor,auxStr)==0)
                return i;
        }
        else
        {
            if (strcmp(TOS[i].valor,token)==0)
                return i;
        }
    }

  	switch (NroToken)
    {
        case ID:
            strcat(aux, token);
            strcpy(TOS[TOStop].nombre,token);
            strcpy(TOS[TOStop].tipo,"ID" );
            TOStop++;
        break;
        case CTE_ENT:
            strcpy(aux,"_");
            strcat(aux, token);
            strcpy(TOS[TOStop].nombre, aux);
            strcpy(TOS[TOStop].tipo,"CTE_ENT");
            strcpy(TOS[TOStop].valor, token);
   			TOStop++;
		break;
        case CTE_REAL:
            strcpy(aux,"_");
            strcat(aux, token);
            strcpy(TOS[TOStop].nombre,aux);
            strcpy(TOS[TOStop].tipo,"CTE_REAL");
            strcpy(TOS[TOStop].valor, token);
   			TOStop++;
		break;
       	case CTE_STR:
            strcpy(aux,"_");
            strcat(aux, auxStr);
            strcpy(TOS[TOStop].nombre, aux);
            strcpy(TOS[TOStop].tipo,"CTE_STR" );
            strcpy(TOS[TOStop].valor, auxStr);
            TOS[TOStop].longitud = (strlen(auxStr));
            TOStop++;
        break;
    }

    return TOStop-1;
}

void mostrarTOS()
{
    int i;

    fprintf(tos,"\n------------------------------ TABLA DE  SIMBOLOS ------------------------------\n");

    fprintf(tos,"Nro\t | Nombre\t\t\t | Tipo\t | Valor\t | Longitud \n");
    for (i=0; i<TOStop; i++)
    {
        fprintf(tos,"%d     \t | %s     \t\t\t | %s     \t | %s \t | %d \n",i,TOS[i].nombre, TOS[i].tipo, TOS[i].valor, TOS[i].longitud);
    }

    fprintf(tos,"\n------------------------------ TABLA DE  SIMBOLOS ------------------------------\n");
}


char * buscarEnTOS(int index)
{
    return TOS[index].nombre;
}