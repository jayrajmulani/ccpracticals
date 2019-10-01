%{
	/* Definition Section*/
	/*Lex Definition for Variables*/
	#include "y.tab.h"
%}

identifier [a-zA-Z_][a-zA-Z0-9_]*
int_identifier [0-9]+
float_identifier  [0-9]+\.[0-9]+
char_identifier \'[.]\'
%%

"if" {return IF;}

"for" {return FOR;}

"while" {return WHILE;}

"else" {return ELSE;}

"do" {return DO;}

"int" {return INT;}

"float" {return FLOAT;}

"char" {return CHAR;}

"double" {return DOUBLE;}

{identifier} {yylval.string=strdup(yytext);
				return ID;}
{int_identifier} {yylval.i=atoi(yytext); 
					return INT_VAL;}
{float_identifier} {yylval.f=atof(yytext); 
					return FLOAT_VAL;}
{char_identifier} {yylval.c=yytext[1]; 
					return CHAR_VAL;}

; return SEMICOLON;

, return COMMA;

= return EQUAL;

\+ return PLUS;

\- return MINUS;

\* return MUL;

\/ return DIV;

"(" return LEFT;

")" return RIGHT;

"<" return LESS;

">" return GREATER;

"!" return NOT;

"&&" return AND;

"||" return OR;

"{" return CL;

"}" return CR;

"<=" return LESSEQ;

">=" return GREATEREQ;

"!=" return NOTEQ;

"==" return EQEQ;

\n                      /* ignore end of line */;
[ \t]+                  /* ignore whitespace */;

%%
