alpha_first [a-zA-Z_]
alpha [a-zA-Z0-9_]
digit [0-9_]
hexa [0-9a-fA-F]

%x COMMENT

%option yylineno

%%

"/*" {BEGIN(COMMENT);}
<COMMENT>"*/" {BEGIN(INITIAL);}
<COMMENT>\n {;}
<COMMENT>. {;}

"//".* {;}

"let" {return(LET);}
"const" {return(CONST);}
"," {return(CMM);}
";" {return(SMC);}
"." {return(DOT);}
":" {return(TDOTS);}
"?" {return(QUESTION);}

"{" {return(LB);}
"}" {return(RB);}
"(" {return(LP);}
")" {return(RP);}
"[" {return(LH);}
"]" {return(RH);}
%{//"\"" {return(QUOTE);}%}
%{//"'" {return(SQUOTE);}*/%}

"class" {return(CLASS);}
"constructor" {return(CONSTRUCTOR);}
"static" {return(STATIC);}
"this" {return(THIS);}
"new" {return(NEW);}

"null" {return(NUL);}
"undefined" {return(UNDEFINED);}

"function" {return(FUNCTION);}
"return" {return(RETURN);}
"continue" {return(CONTINUE);}
"beak" {return(BREAK);}
"=>" {return(FCT_ARROW);}

"=" {return(EQ);}
"++" {return(PLUS_PLUS);}
"--" {return(MINUS_MINUS);}
"+=" {return(PLUS_EQ);}
"-=" {return(MINUS_EQ);}
"**=" {return(POW_EQ);}
"*=" {return(MULT_EQ);}
"/=" {return(DIV_EQ);}
"%=" {return(PERC_EQ);}
"|=" {return(OR_EQ);}
"&=" {return(AND_EQ);}
"^=" {return(XOR_EQ);}
"||=" {return(BOR_EQ);}
"&&=" {return(BAND_EQ);}
"<<=" {return(LSHIFT_EQ);}
">>=" {return(RSHIFT_EQ);}

"==" {return(BEQ);}
"===" {return(BBEQ);}
"!=" {return(NEQ);}
"!==" {return(NNEQ);}
">" {return(GT);}
"<" {return(LT);}
">=" {return(GE);}
"<=" {return(LE);}
"instanceof" {return(INSTANCEOF);}

"+" {return(PLUS);}
"-" {return(MINUS);}
"**" {return(POW);}
"*" {return(MULT);}
"/" {return(DIV);}
"|" {return(OR);}
"%" {return(PERC);}
"&" {return(AND);}
"^" {return(XOR);}
"||" {return(BOR);}
"&&" {return(BAND);}
"!" {return(NEG);}
"<<" {return(LSHIFT);}
">>" {return(RSHIFT);}

"if" {return(IF);}
"else" {return(ELSE);}
"for" {return(FOR);}
"switch" {return(SWITCH);}
"case" {return(CASE);}
"default" {return(DEFAULT);}
"while" {return(WHILE);}
"do" {return(DO);}

[ \t]* {;}
[\n] {;}

(["][^"]*["])|(['][^']*[']) {yylval.string_value = strdup(yytext); /*ptr_stack_add(yylval.string_value);*/ return(STR);}
#{alpha_first}{alpha}* {yylval.string_value = strdup(yytext); /*ptr_stack_add(yylval.string_value);*/ return(ID_PRIV);}
{alpha_first}{alpha}* {yylval.string_value = strdup(yytext); /*ptr_stack_add(yylval.string_value);*/ return(ID);}
({digit}+)|({digit}*)\.({digit}+)|(0x{hexa}+)|({digit}+)n {yylval.string_value = strdup(yytext); /*ptr_stack_add(yylval.string_value);*/ return(CST);}
