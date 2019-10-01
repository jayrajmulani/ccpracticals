/*Parser Definition for Variable Symbol Table*/
%{
	/*Definition Section*/
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>

	//Structure to hold symbol table entry
	typedef struct variable{
		char name[63];
		char type[63];
		int value;
		struct variable *next;
	}variable;

	//Array of Symbol Entries
	variable *symbolTable[1000];

	int hashCalc(unsigned char *str);
	int insert(char* name, char* type);
	variable* search(char* input);
	void display();
	void freeTable();
	void init();

%}

%union 
{
	int i;
	float f;
	char c;
	char *string;
}

//Tokens
%token INT FLOAT CHAR DOUBLE SEMICOLON COMMA END EQUAL PLUS MINUS MUL DIV LEFT RIGHT
%token <string> ID
%token <i> INT_VAL
%token <f> FLOAT_VAL
%token <c> CHAR_VAL
%type <i> ID5
%type <i> EVAL


%left PLUS MINUS
%left MUL DIV


/*Rule Section*/
%%

VarDec : 
	| VarDec Start
	;

Start : INT ID1 SEMICOLON {display();}
	| FLOAT ID2 SEMICOLON {display();}
	| CHAR ID3 SEMICOLON {display();}
	| DOUBLE ID4 SEMICOLON {display();}
	| ID EQUAL EVAL SEMICOLON {set(strdup($1),$3);}
;


ID1 :ID1 COMMA ID{insert(strdup($3),strdup("int"));}
	|ID{insert(strdup($1),strdup("int"));}
;
ID2 :ID2 COMMA ID{insert(strdup($3),strdup("float"));}
	|ID{insert(strdup($1),strdup("float"));}
;
ID3 :ID3 COMMA ID{insert(strdup($3),strdup("char"));}
	|ID{insert(strdup($1),strdup("char"));}
;
ID4 :ID4 COMMA ID{insert(strdup($3),strdup("double"));}
	|ID{insert(strdup($1),strdup("double"));}
;
EVAL : EVAL PLUS EVAL {$$ = $1 + $3; printf("\nUpdated value = %d\n",$$);}
	| EVAL MINUS EVAL {$$ = $1 - $3; printf("\nUpdated value = %d\n",$$);}
	| EVAL MUL EVAL {$$ = $1 * $3;printf("\nUpdated value = %d\n",$$);}
	| EVAL DIV EVAL {$$ = $1 / $3;printf("\nUpdated value = %d\n",$$);}
	| LEFT EVAL RIGHT {$$ = $2;}
	| ID5{$$=$1;}
;
 ID5: ID{variable *v1=search($1);$$=v1->value;} | INT_VAL{$$=$1;}
 ;
%%

//Hashing function - DJB2 Algorithm
int hashCalc(unsigned char *str)
{
	unsigned long hash = 5381;
	int c;
	while (c = *str++)
    	hash = ((hash << 5) + hash) + c; /* hash * 33 + c */
	return hash % 1000;
}

//Insert into Hashtable
int insert(char* name, char* type)
{
	//Check for duplicates before insert
	variable* result = search(name);
	if(result == NULL)
	{
		//Allocate Memory
		variable* new = (variable*) malloc(sizeof(variable));
		strcpy(new->name,name);
		strcpy(new->type,type);
		new->next=NULL;
		//Calculate hash
		int hash = hashCalc(new->name);
		//printf("\nInsertingHash of %s is %d\n",new->name,hash);

		//Insert in Symbol Table
		if(symbolTable[hash] == NULL)
		{
			//Array position is empty, add there only
			symbolTable[hash] = new;
		}
		else
		{
			new->next = symbolTable[hash];
			symbolTable[hash] = new;
		}
		return 1;
	}
	else
	{
		//Check which kind of duplicate
		if(strcmp(result->name,name) == 0)
		{
			if(strcmp(result->type,type) == 0)
			{
				printf("Redeclaration of Variable");
				return 0;
			}	
			else
			{
				printf("Multiple Declaration of Variable");
				return 0;
			}
		}
	}
	
}

//Search Hashtable
variable* search(char* input)
{
	int hash = hashCalc(input);
	//printf("\nSearchingHash of %s is %d\n",input,hash);
	if(symbolTable[hash] != NULL)
	{
		if(symbolTable[hash]->next == NULL)
		{
			//Only one entry here
			if(!strcmp(symbolTable[hash]->name,input)) return symbolTable[hash];
		}
		else
		{
			//Chained entry - Linear Search required
			variable* temp = symbolTable[hash];
			while(temp != NULL)
			{
				if(strcmp(temp->name,input) == 0)
					return temp;
				else
					temp = temp->next;
			}
		}
	}
	return NULL;
}


//Display HashTable
void display()
{
	printf("\n%10s %10s %10s\n","Name","Type","Value");
	int i = 0;
	for(i = 0;i < 1000;i++)
	{
		//Skip if Empty entry
		if(symbolTable[i] == NULL)
		{
			continue;
		}
		//Chained Entries
		else if(symbolTable[i]->next != NULL)
		{
			variable* temp = symbolTable[i];
			while(temp != NULL)
			{
				printf("%10s %10s %10d\n",temp->name,temp->type,temp->value);
				temp = temp->next;
			}
		}
		//Single Entry
		else
		{
			printf("%10s %10s %10d\n",symbolTable[i]->name,symbolTable[i]->type,symbolTable[i]->value);
		}
	}
}

void freeTable()
{
	int i = 0;
	for(i = 0;i < 1000;i++)
	{
		//Skip if Empty entry
		if(symbolTable[i] == NULL)
		{
			continue;
		}
		//Chained Entries
		else if(symbolTable[i]->next != NULL)
		{
			variable* temp = symbolTable[i];
			variable* freeVar;
			while(temp != NULL)
			{
				freeVar = temp;
				temp = temp->next;
				free(freeVar);
			}
		}
		//Single Entry
		else
		{
			free(symbolTable[i]);
		}
	}
}

void init()
{
	int i = 0;
	for(i = 0;i < 1000;i++)
	{
		symbolTable[i] = NULL;
	}
}

//Error Handling
void yyerror(const char *str)
{
	printf("\nSyntax Error - Freeing Symbol Table\n");
	freeTable();
}

//Wrap
int yywrap()
{
	return 1;
}

void main()
{
    init();	
	yyparse();
}

void set(char *name,int value){
	variable *v1 = search(name);
	v1->value = value;
	printf("Value of %s = %d\n",v1->name,v1->value);
}
