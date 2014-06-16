%lex
%%

"'"                   return 'SINGLE_QUOTE';
";"                   return 'SEMICOLON';
"="                   return '=';
"\""                  return 'DOUBLE_QUOTE';
<<EOF>>               return 'EOF';
[A-Za-z_]\w+          return 'VALID_VARIABLE_NAME';

/lex
%%

expressions
    : pairs
      {return "[ "+$$+" ]";}
    ;

pairs
    : pair SEMICOLON pairs
        {$$ = $1+", "+$3;}
    | pair SEMICOLON EOF
        {$$ = $1;}
    | pair EOF
        {$$ = $1;}
    ;

pair
    : VALID_VARIABLE_NAME '=' QUOTED_STRING
        {$$ = "{ "+"\""+$1+"\""+": "+"\""+$3+"\""+" }";}
    | VALID_VARIABLE_NAME '=' VALID_VARIABLE_NAME
        {$$ = "{ "+"\""+$1+"\""+": "+"\""+$3+"\""+" }";}
    ;

QUOTED_STRING
    : SINGLE_QUOTE VALID_VARIABLE_NAME SINGLE_QUOTE
      {$$ = $2;}
    | DOUBLE_QUOTE VALID_VARIABLE_NAME DOUBLE_QUOTE
      {$$ = $2;}
    ;
