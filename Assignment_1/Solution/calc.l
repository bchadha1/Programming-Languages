%{
#include<math.h>
#include <stdio.h>
#include "calc.tab.h"

%}

digit	([0-9])
alphabet  ([a-z][a-zA-Z0-9]) 

%%

"println"       {       return(TOK_PRINTLN);}


{digit}+	      { yylval.int_val = atoi(yytext); return (TOK_NUM);}
		
{alphabet}+     { sscanf(yytext, %s, yylval.string); return (TOK_STRING);}


";"	{	return(TOK_SEMICOLON);	}

"+"	{	return(TOK_ADD);	}
"-"	{	return(TOK_SUB);	}
"*"	{	return(TOK_MUL);	}
"/"	{	return(TOK_DIV);	}
"="       {         return(TOK_EQU);    }

"main()"  {         return(TOK_MAIN);   }
"int"     {         return(TOK_INT);    }
"float"   {         return(TOK_FLOAT);  } 


"{"       {   return(TOK_OCBRAC);      }
"}"       {   return(TOK_CCBRAC);      }

"("       {   return(TOK_ORBRAC);      }
")"       {   return(TOK_CRBRAC);      }



{digit}+"."{digit}+  {sscanf(yytext, "%d", &yylval.floatVal);  return TOK_FLOATNUMS; }


[ \n] 	{}

.	{printf("Invalid character '%c', ignored\n", 
			yytext[0]);
	}

%%


