%{
    int count = 0;
%}

digit [0-9]
letter [a-zA-Z]
eof [;]
operator [+|-|=|/|*|%]

%%

bool|int|float|char { printf("\n<keyword , %s >",yytext);}
{letter}({letter}|{digit})* { printf("< id %d , %s >",++count,yytext);}
{eof} { printf("\n punctuation %s",yytext);}
{operator} { printf("\n<opertor , %s >",yytext);}
{digit}({digit})* { printf("\n<number , %s >",yytext);}


%%


int yywrap()
{return 1;}
int main(int argc, char **argv) 
{

    FILE *f1;
    f1 = fopen("sample.c","r");
    yyin = f1;
    yylex();
    printf("Total number of identifier : %d",count);
    return 0;

}
