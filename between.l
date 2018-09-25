%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>

#include "y.tab.h"
FILE  *yyin;
char auxS[100];
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


REAL					{DIGITO}*"."{DIGITO}+|{DIGITO}+"."
ENTERO					{DIGITO}+
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

{ID}		{sprintf(auxS,"%s", yytext);yylval.str_val=auxS; return ID;}
{REAL} 		{yylval.float_val = atof(yytext); return REAL;}
{ENTERO}	{yylval.int_val = atoi(yytext); return ENTERO;}
{CADENA} 	{sprintf(auxS,"%s", yytext);yylval.str_val=auxS; return CADENA;}

{COMENTARIOS}
{COMENTARIOS_ANIDADOS}
"\n"      		
"\t"		



