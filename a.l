%{
#include<stdio.h>
%}
%%
[0-9] {printf("%s is a number\n",yytext);}
[a-zA-Z0-9_]* {printf("%s is a string\n",yytext);}
%%
int main()
{
yylex();
return 0;
}
