%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"

void mostrarError(char *);
int validarLongitud(int);

FILE  *yyin;
char auxS[100];

#define LIM_REAL 2147483647
#define LIM_INT 32768
#define LIM_STR 30
#define LIM_ID 30
%}
%option noyywrap  
%option yylineno 

DIGITO					[0-9]
LETRA					[a-zA-Z]
ID						{LETRA}({LETRA}|{DIGITO}|_)*
COMENTARIO_INICIO 		"-/"
COMENTARIO_FIN 			"/-"
COMENTARIOS				\-\/([^"\/\-"|"\-\/"]|\n)*\/\-
COMENTARIOS_ANIDADOS	\-\/([^"\/\-"|"\-\/"]|\n)*{COMENTARIOS}*([^"\/\-"|"\-\/"]|\n)*\/\-


REAL					(\-)?{DIGITO}*"."{DIGITO}+|{DIGITO}+"."
ENTERO					(\-)?{DIGITO}+
CADENA					\"[^"\n]*\"
%%

"="						{return ASIG;}
"=="					{return OP_COMPARACION_IGUAL;}
"!="					{return OP_COMPARACION_DISTINTO;}
"+"						{return OP_SUMA;}
"-"						{return OP_RESTA;}
"*"						{return OP_MUL;}
"/"						{return OP_DIV;}
"\("						{return P_A;}
"\)"						{return P_C;}
";"						{return PUNTOCOMA;}             
":"         			{return DOSPUNTOS;}
","         			{return COMA;}
"{"         			{return LL_A;}
"}"         			{return LL_C;}
"["         			{return C_A;}
"]"         			{return C_C;}
"-/"        			{return COMENTARIO_INICIO;}
"/-"        			{return COMENTARIO_FIN; }
">" 					{return OP_COMPARACION_MAYOR_A; } 
">=" 					{return OP_COMPARACION_MAYOR_IGUAL_A; } 
"<" 					{return OP_COMPARACION_MENOR_A; } 
"<=" 					{return OP_COMPARACION_MENOR_IGUAL_A; } 
			
"BETWEEN"   			{return BETWEEN;}
"IF"   					{return IF;}
"THEN"   				{return THEN;}
"ELSE"   				{return ELSE;}
"ENDIF"   				{return ENDIF;}
"WHILE"   				{return WHILE;}
"ENDWHILE"				{return ENDWHILE;}
"INLIST"   				{return INLIST;}
"AND"   				{return AND;}
"OR"   					{return OR;}
"NOT"					{return NOT;}
"DECVAR"   				{return DECVAR;}
"ENDDEC"   				{return ENDDEC;}
"FLOAT"   				{return FLOAT;}
"STRING"   				{return STRING;}
"INTEGER"   			{return INTEGER;}
"WRITE"   				{return WRITE;}
"READ"   				{return READ;}

{ID}		{	sprintf(auxS,"%s", yytext);
				if(validarLongitud(ID) == 0) 
	 				mostrarError(yytext);
				yylval.str_val=auxS;
				return ID;
			}

{REAL} 		{	if(validarLongitud(REAL) == 0) 
	 				mostrarError(yytext);
	 			sscanf(yytext,"%lf",&(yylval.float_val));
				return REAL;
			}

{ENTERO}	{ 	if(validarLongitud(ENTERO) == 0) 
	 				mostrarError(yytext);
	 			sscanf(yytext,"%d",&(yylval.int_val));
				return ENTERO;
			}

{CADENA} 	{	if(validarLongitud(CADENA) == 0) 
	 				mostrarError(yytext);
				sprintf(auxS,"%s", yytext);
				yylval.str_val=auxS; 
				return CADENA;
			}



{COMENTARIOS}
{COMENTARIOS_ANIDADOS}
"\n"      		
"\r"
"\r\n"
"\t"
" "

.    {		printf("Caracter invalido!");
			exit(1);}

%%

int validarLongitud(int tipo){
	int entero;
	int real;
	switch(tipo){
		case ENTERO:
			sscanf(yytext,"%d",&entero);
			if(entero >= -LIM_INT && entero <= LIM_INT-1)
				return 1;
			return 0;
			break;
		case CADENA:
			if(strlen(yytext) <= LIM_STR) 
				return 1;
			return 0;
			break;
		case REAL:
			sscanf(yytext,"%lf",&real);
			if(real >= -LIM_REAL && real <= LIM_REAL-1)
				return 1;
			return 0;
			break;
		case ID:
			if(strlen(yytext) <= LIM_ID)
				return 1;
			return 0;
			break;
	}
	return 0;
}



