%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include "y.tab.h"
int yylval;
int yystopparser=0;
FILE  *yyin;
char *yyltext;
char *yytext;

%}
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

bloque_declaracion: DECVAR lista_declaraciones ENDDEC { printf("bloque_declaracion OK\n");};

lista_declaraciones: lista_declaraciones declaracion
					| declaracion;

declaracion: lista_ids DOSPUNTOS tipo_variable { printf("Declaracion OK\n");};

lista_ids: lista_ids COMA ID {printf("lista_ids OK\n");}
			| ID {printf("ID OK\n");};

tipo_variable: FLOAT | STRING | INTEGER {printf("Tipo variable OK\n");};

lista_sentencias: sentencia lista_sentencias | sentencia {printf("sentencia OK\n");};

sentencia: iteracion | decision | asignacion | entrada | salida {printf("salida OK\n");};

decision: IF condicion THEN lista_sentencias ENDIF {printf("desicion OK\n");};

condicion: P_A evaluable P_C {printf("condicion OK\n");};

evaluable: condicion_simple | condicion_multiple;

condicion_simple: expresion comparador expresion | operacion_between | operacion_inlist;

condicion_multiple: condicion_simple AND condicion_simple | condicion_simple OR condicion_simple | NOT condicion_simple;

comparador: OP_COMPARACION_MAYOR_A | OP_COMPARACION_MAYOR_IGUAL_A | OP_COMPARACION_MENOR_A 
            | OP_COMPARACION_MENOR_IGUAL_A | OP_COMPARACION_IGUAL {printf("Comparador OK\n");};

operacion_between: BETWEEN P_A ID COMA LL_A expresion PUNTOCOMA expresion LL_C P_C {printf("Between OK\n");};

operacion_inlist: INLIST P_A ID COMA LL_A lista_expresiones LL_C P_C {printf("Inlist OK\n");};

lista_expresiones: expresion PUNTOCOMA expresion | lista_expresiones PUNTOCOMA expresion;

asignacion: ID ASIG expresion {printf("Asignacion OK\n");};

salida:  WRITE CADENA | WRITE ID;

entrada: READ ID {printf("entrada OK\n");};

iteracion: WHILE condicion THEN lista_sentencias ENDWHILE {printf("While OK\n");};







    
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
      ID 
      | ENTERO {$1 = yylval ;printf("ENTERO es: %d\n", yylval);}
      | REAL {$1 = yylval ;printf("REAL es: %d\n", yylval);}
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