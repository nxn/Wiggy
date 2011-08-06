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

%start BLUEPRINT

%% /* Blueprint Grammar */

BLUEPRINT
  : ROWLIST EOF
  ;

ROWLIST
  : ROW
  | ROW ROWLIST
  ;

ROW
  : '|' MARGIN ITEMLIST MARGIN '|'
  ;

ITEMLIST
  : ITEM
  | ITEMLIST MARGIN ITEM
  ;

ITEM
  : '[' IDENT SIZE ']'
  ;

MARGIN
  : PIXELS
  |
  ;

PIXELS
  : NUMBER
  | '*'
  ;

SIZE
  : PIXELS
  | HSPAN
  | VSPAN
  | PIXELS PIXELS
  | PIXELS HSPAN
  | PIXELS VSPAN
  | HSPAN  PIXELS
  | VSPAN  PIXELS
  | HSPAN  VSPAN
  | VSPAN  HSPAN
  |
  ;

HSPAN
  : NUMBER '-' PIXELS
  ;

VSPAN
  : NUMBER '|' PIXELS
  ;
