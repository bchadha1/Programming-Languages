%{
#include <stdio.h>
#include<stdlib.h>
#include<string.h>
#include<symbolTable.h>

int yylex();
int yyerror(char *s);
int k=0;
%}

%token TOK_SEMICOLON TOK_ADD TOK_SUB TOK_MUL TOK_DIV TOK_PRINTLN TOK_MAIN TOK_INT TOK_FLOAT TOK_EQU
%token  TOK_OCBRAC TOK_CCBRAC TOK_ORBRAC  TOK_CRBRAC

%union{
        int int_val;
        float float_val;
        char  string[20]; 

        int varType;

      // struct symtable sym[100]; 
       struct symtable *symp;
}


/* %code requires{

	struct symtable{

		char variableName[50];
		int variableType;
		int intValue;
		float floatValue;
	};

}*/

%token <symp> TOK_STRING
%token <symp> expr
%token <int_val> TOK_NUM
%token <float_val> TOK_FLOATNUMS

%left TOK_ADD TOK_SUB
%left TOK_MUL TOK_DIV

%%

prog:
      TOK_MAIN TOK_ORBRAC stmts TOK_CRBRAC
      | TOK_MAIN TOK_ORBRAC stmts TOK_CRBRAC TOK_OCBRAC stmts TOK_CCBRAC
;

stmts: | stmt TOK_SEMICOLON stmts 
;

stmt: 
	TOK_STRING TOK_EQU expr
	{
		int i=0;
		while(i<=k){
		if(strcmp(sym[i].variableName, $2->variableName)==0){
		
			if(sym[i].variableType==0)
			{		
			   sym[i].intValue = $3->intValue;
			   break;	

			} 

			else
			{
				sym[i].floatValue =$3->floatValue;
			          break;
			}

		i++;		
		}
	      }

	    if(i>k){
                    printf("ERROR IN TYPE");
            
	      }

	}

	| TOK_PRINTLN TOK_STRING

	{
		int i=0;
		while(i<=k){
		if(strcmp(sym[i].variableName, $2->variableName)==0) {
			if(sym[i].variableType == 0) 
			{
			    printf("VALUE IS: %d \n",sym[i].intValue);
			    break;	
			}

			else if(sym[i].variableType == 1) {
			   printf("VALUE IS: %f \n",sym[i].floatValue);
			   break;
			} 

			}
		
		}

		if(i>k)	{ 
		  printf("ERROR");
	          }

	}
	
;

vars:  | var TOK_SEMICOLON vars
;

var:  |
	TOK_INT TOK_STRING
	{ 
		strcpy(sym[k].variableName, $2->variableName);
		sym[k].variableType=0;
		sym[k].intValue=0;
		k++;
	}

	| TOK_FLOAT TOK_STRING
	{
		strcpy(sym[k].variableName, $2->variableName);
		sym[k].variableType=0;
		sym[k].floatValue=0;
		k++;

	}
;
         

expr_stmt:
	   expr TOK_SEMICOLON
	   | TOK_PRINTLN expr TOK_SEMICOLON 
		{
			fprintf(stdout, "the value is %d\n", $2);
		} 
;

expr: 
	expr TOK_ADD expr
	  {
                 if($1->vartype != $3->vartype){
                                printf("TYPE ERROR");
                                return -1;
                                }
                        else
                           {     if($1->variableType == 1){
                                        $$->floatValue = $1->floatValue + $3->floatValue;
                                        $$->variableType = 1;
                                }
                                else{
                                        $$->intValue = $1->intValue + $3->intValue;
                                        $$->variableType = 0;
                                }
		}
	  }  
	| expr TOK_SUB expr
	  {		
		if($1->variableType != $3->variableType){
                                printf("TYPE ERROR");
                                return -1;
                                }
                        else{     if($1->variableType == 1){
                                        $$->floatValue = $1->floatValue - $3->floatValue;
                                        $$->variableType = 1;
                                }
                                else{
                                        $$->intValue = $1->intValue - $3->intValue;
                                        $$->variableType = 0;
                                }
	            	    }
	  }
	| expr TOK_MUL expr
	  {
                 if($1->vartype != $3->vartype){
                                printf("TYPE ERROR");
                                return -1;
                                }
                        else
                           {     if($1->variableType == 1){
                                        $$->floatValue = $1->floatValue * $3->floatValue;
                                        $$->variableType = 1;
                                }
                                else{
                                        $$->intValue = $1->intValue * $3->intValue;
                                        $$->variableType = 0;
                                }
		}
	  }
	| expr TOK_DIV expr
	  {
                 if($1->vartype != $3->vartype){
                                printf("TYPE ERROR");
                                return -1;
                                }
                        else
                           {     if($1->variableType == 1){
                                        $$->floatValue = $1->floatValue / $3->floatValue;
                                        $$->variableType = 1;
                                }
                                else{
                                        $$->intValue = $1->intValue / $3->intValue;
                                        $$->variableType = 0;
                                }
		}
	  }    
	| TOK_NUM
	  { 	
		$$->intValue=$1;
		$$->variableType= 0;
	  }
	| TOK_FLOATNUMS
	  {
		$$->floatValue=$1;
		$$->variableType= 1;
	  }

         | TOK_STRING
	{
       		int i=0;
		while(i<k){
		if(strcmp(sym[i].variableName, $1->variableName) ==0 && (sym[i].variableType == $1->variableType))
		{
			if(sym[i].variableType == 0) 
			{
			$$->intValue = sym[i].intValue;
			break;			
			} else { 
			$$->floatValue = sym[i].floatValue;
			break;
			}
		} else {
		printf("VARIABLE NOT DECLARED: %s ", $1->varname);
			}
	  	} 
	}
	
;


%%

int yyerror(char *s)
{
	printf("syntax error\n");
	return 0;
}

int main()
{
   yyparse();
   return 0;
}
