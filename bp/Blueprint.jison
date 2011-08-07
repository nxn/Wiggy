%lex
%%

\s+                         /* Ignore whitespace */
\d+                         return 'NUMBER'
[a-zA-Z_$][0-9a-zA-Z_$]*\b  return 'IDENT'
\-\-\-*                     return 'DASHES' /* Make sure these tokens are in */
'-'                         return '-'      /* the correct order             */
":"                         return ':'
"|"                         return '|'
"["                         return '['
"]"                         return ']'
"*"                         return '*'
<<EOF>>                     return 'EOF'

/lex

%start blueprint

%% /* Blueprint Grammar */

blueprint
  : rowlist EOF
  ; 

rowlist
  : row
  | rowlist row
  ;

row
  : '|' margin itemlist margin '|'
  | spacer
  ;

/* * * * * * * * * * * * * * * * * * * * * * * * * *\
 * Allows the pixel value to appear anywhere on    * 
 * the line as long as it is surrounded by one or  * 
 * more dashes on each side.                       * 
\* * * * * * * * * * * * * * * * * * * * * * * * * */
spacer                    
  : '-'    pixels '-'     
  | '-'    pixels DASHES  
  | DASHES pixels '-'     
  | DASHES pixels DASHES  
  ;

itemlist
  : item
  | itemlist margin item
  ;

item
  : '[' IDENT dimensions ']'
  ;

dimensions
  : /* empty */
  | span   ':' span
  | span   ':' pixels
  | pixels ':' pixels
  | pixels ':' span
  | pixels ':'
  | span   ':'
  | ':' pixels
  | ':' span
  ;

span
  : NUMBER '-' pixels
  ;

margin
  : /* empty */
  | pixels
  ;

pixels
  : NUMBER
  | '*'
  ;
