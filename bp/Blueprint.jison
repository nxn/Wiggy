%lex
%%

\s+                         /* Ignore whitespace */
\d+\b                       return 'NUMBER'
[a-zA-Z_$][0-9a-zA-Z_$]*\b  return 'IDENT'
"|"                         return '|'
"*"                         return '*'
"["                         return '['
"]"                         return ']'
"-"                         return '-'
<<EOF>>                     return 'EOF'

/lex

%start blueprint

%% /* Blueprint Grammar */

blueprint
  : rowlist EOF
  ;

rowlist
  : row
  | row rowlist
  ;

row
  : '|' margin itemlist margin '|'
  ;

itemlist
  : item
  | itemlist margin item
  ;

item
  : '[' IDENT size ']'
  ;

margin
  : /* empty */
  | pixels
  ;

pixels
  : NUMBER
  | '*'
  ;

size
  : /* empty */
  | pixels
  | hspan
  | vspan
  | pixels pixels
  | pixels hspan
  | pixels vspan
  | hspan pixels
  | vspan pixels
  | hspan vspan
  | vspan hspan
  ;

hspan
  : NUMBER '-' pixels
  ;

vspan
  : NUMBER '|' pixels
  ;
