%{
#include <stdio.h>
char *token_names[] = {"ID", "CTE", "PROG", "VAR", "COD", "FIN", "LEER", "ESC", "DEF", "ASIG"};
%defines "parser.h"
%output "parser.c"
%}

%token ID CTE PROG VAR COD FIN LEER ESC DEF ASIG
%define api.value.type {char *}
%left '-' '+'
%left '*' '/'
%precedence NEG
%%
estructura : %PROG VAR definicion COD sentencias FIN;

definicion : DEF variables;
variables : ID '.' definicion
		  | ID '.';
		
sentencias : lectura | escritura | asignacion;

lectura : LEER '(' listaIdentificadores ')' '.'
		| LEER '(' listaIdentificadores ')' '.' sentencias
		;
escritura : ESC '(' listaExpresiones ')' '.'
		  | ESC '(' listaExpresiones ')' '.' sentencias
		;
asignacion : ID ASIG expresion '.'
			| ID ASIG expresion '.' sentencias
		;
listaIdentificadores : ID | ID ',' listaIdentificadores;
listaExpresiones : expresion | expresion ',' listaExpresiones;

expresion: termino | expresion '+' termino | expresion '-' termino;
termino: inversion | termino '*' inversion | termino '/' inversion;
inversion: primaria | '-' primaria %prec NEG;
primaria: ID | CTE | '(' expresion ')';
%%

