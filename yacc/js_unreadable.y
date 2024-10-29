                /* DECLARATIONS */
%{
/* insertion de code verbatim en entête de tous les fichiers C généré par LEX ou YACC */

#include <stdlib.h>
#include <string.h>

// #define PTR_STACK_LEN 500

// void* ptr_stack[PTR_STACK_LEN] = {};
// size_t ptr_stack_size = 0;

int yylex();
void yyerror(const char *s);

int makeNum ()
{
  static int n = 0;
  return ++n;
}

// /**
//  * Ajoute un pointeur à la pile
//  */
// void ptr_stack_add(void *ptr) {
//     ptr_stack[ptr_stack_size++] = ptr;
// }

// /**
//  * dépile le pointeur
//  */
// void *ptr_stack_pop() {
//     return ptr_stack[--ptr_stack_size];
// }

// /**
//  * free la tête de la pile
//  */
// void ptr_stack_pop_free() {
//     free(ptr_stack_pop());
// }

// void ptr_stack_free_all() {
//     while (ptr_stack_size > 0) {
//         ptr_stack_pop_free();
//     }
// }

/**
 * concatène str1 et str2, et retourne
 * la concaténation qui à était alloué avec malloc
 * //et placer dans la pile
 */
char *concat(char *str1, char *str2) {
    int len1 = strlen(str1);
    int len2 = strlen(str2);
    char *strdest = malloc((len1+len2+1)*sizeof(char));
    //ptr_stack_add(strdest);
    strcpy(strdest, str1);
    strcat(strdest, str2);
    return strdest;
}

/**
 * concatène les trois arguments
 * le 1er et le 3ème argument sont free
 * le retour doit être free
 */
char *concat_mid(char *exp1, char *op, char*exp2) {
    char *inter = concat(exp1, op);
    char *result = concat(inter, exp2);
    free(exp1);
    free(exp2);
    free(inter);
    return result;
}

/**
 * concatène les deux arguments
 * le 2ème argument est free
 * le retour doit être free
 */
char *concat_left(char *op, char *exp) {
    char *result = concat(op, exp);
    free(exp);
    return result;
}

 /**
 * concatène les deux arguments
 * le 1er argument est free
 * le retour doit être free
 */
char *concat_right(char *exp, char *op) {
    char *result = concat(exp, op);
    free(exp);
    return result;
}

/**
 * concatène les trois arguments
 * le 2ème argument est free
 * le retour doit être free
 */
char *concat_around(char* left, char *exp, char* right) {
    char *inter = concat(left, exp);
    char *result = concat(inter, right);
    free(inter);
    free(exp);
    return result;
}

/**
 * concatène les deux arguments
 * les deux arguments sont free
 * le retour doit être free
 */
char *concat_two(char *exp1, char *exp2) {
    char *result = concat(exp1, exp2);
    free(exp1);
    free(exp2);
    return result;
}

struct unit {};

struct nlist { /* table entry: */
    struct nlist *next; /* next entry in chain */
    char *key; /* defined key */
    int val; /* replacement text */
};

#define HASHSIZE 101
static struct nlist *symbols[HASHSIZE]; /* pointer table */

/* hash: form hash value for string s */
unsigned hash(char *s)
{
    unsigned hashval;
    for (hashval = 0; *s != '\0'; s++)
      hashval = *s + 31 * hashval;
    return hashval % HASHSIZE;
}

/* lookup: cherche s dans la table de hachage*/
struct nlist *lookup(char *key)
{
    struct nlist *np;
    for (np = symbols[hash(key)]; np != NULL; np = np->next)
        if (strcmp(key, np->key) == 0)
          return np; /* trouvé */
    return NULL; /* pas trouvé*/
}

/* Ajoute une entrée à la table de hachage */
struct nlist *addKeyValue(char *key, int val)
{
    struct nlist *np;
    unsigned hashval;
    if ((np = lookup(key)) == NULL) { /*  key n'est pas dans la table */
        np = (struct nlist *) malloc(sizeof(*np));
        if (np == NULL || (np->key = strdup(key)) == NULL)
          return NULL;
        hashval = hash(key);
        np->next = symbols[hashval];
        symbols[hashval] = np;
    } 
    np->val = val;
    return np;
}

/*  Cherche s dans la table des symboles, et renvoie le registre associé 
    ou -1 si s n'est pas dans la table */
int getRegister(char* key){
  struct nlist *np;
  if ((np = lookup(key)) == NULL) 
    return -1;
  else
    return np -> val;
}
 
%}

%union {
    char *string_value;
    //int int_value;  
}

/* TOKENS */

//%token <int_value> CST
%token <string_value> ID ID_CLSP ID_CLS ID_LET CST STR

%token LET CONST CMM SMC TDOTS QUESTION
LB RB LP RP LH RH
CLASS CONSTRUCTOR STATIC THIS NEW // pas encore implémenté
FUNCTION RETURN CONTINUE BREAK FCT_ARROW
EQ PLUS_PLUS MINUS_MINUS PLUS_EQ MINUS_EQ MULT_EQ POW_EQ DIV_EQ OR_EQ AND_EQ
XOR_EQ BOR_EQ BAND_EQ LSHIFT_EQ RSHIFT_EQ
BEQ BBEQ NEQ NNEQ GT LT GE LE NEG
PLUS MINUS MULT POW DIV OR AND XOR BOR BAND LSHIFT RSHIFT
IF ELSE FOR SWITCH CASE WHILE DO
INSTANCEOF

%left EQ PLUS_EQ MINUS_EQ POW_EQ MULT_EQ DIV_EQ PERC_EQ LSHIFT_EQ RSHIFT_EQ
AND_EQ XOR_EQ OR_EQ BAND_EQ BOR_EQ QUESTION TDOTS FCT_ARROW

%left BOR
%left BAND
%left OR
%left XOR
%left AND

%left BEQ NEQ BBEQ NNEQ
%left LT LE GT GE INSTANCEOF
%left RSHIFT LSHIFT

%left PLUS MINUS
%left MULT DIV PERC
%left POW

%right NEG

%left PLUS_PLUS MINUS_MINUS

%left LP LH

%type <string_value> exp multi_exp id fct_call tab_call tab_def affect eq let
fct_def proper_fct_def args_def args return loop if else for
for_p1 for_p2 for_p3 inst smc_inst inst_suite while do_while
// switch
%type <no_value> axiome

/* START SYMBOL */
%start axiome

/* INSERTIONS DE CODE *VERBATIM* */
%{ 
#include <stdio.h>
#include <ctype.h>
  
%}

%% 

/* GRAMAIRES ET ACTIONS SEMANTIQUES */

axiome : axiome inst {printf("%s\n", $2); free($2);}
       | inst {printf("%s\n", $1); free($1);}

inst : smc_inst {$$ = $1;}
     | proper_fct_def {$$ = $1;}
     | loop {$$ = $1;}
//     | class {}

smc_inst : exp SMC {$$ = concat_right($1, ";");}
         | let SMC {$$ = concat_right($1, ";");}
         | return SMC {$$ = concat_right($1, ";");}
         | CONTINUE SMC {$$ = strdup("continue;");}
         | BREAK SMC {$$ = strdup("break;");}

inst_suite : inst_suite inst {$$ = concat_two($1, $2);}
           | inst {$$ = $1;}

exp : affect {$$ = $1;}
    | id {$$ = $1;}
    | CST {$$ = $1;}
    | STR {$$ = $1;};
    | fct_call {$$ = $1;}
    | fct_def {$$ = $1;}
    | tab_call {$$ = $1;}
    | tab_def {$$ = $1;}
    | multi_exp {$$ = $1;}

multi_exp : exp PLUS exp {$$ = concat_mid($1, "+", $3);}
          | exp MINUS exp {$$ = concat_mid($1, "-", $3);}
          | exp MULT exp {$$ = concat_mid($1, "*", $3);}
          | exp POW exp {$$ = concat_mid($1, "**", $3);}
          | exp DIV exp {$$ = concat_mid($1, "/", $3);}
          | exp OR exp {$$ = concat_mid($1, "|", $3);}
          | exp AND exp {$$ = concat_mid($1, "&", $3);}
          | exp XOR exp {$$ = concat_mid($1, "^", $3);}
          | exp BOR exp {$$ = concat_mid($1, "||", $3);}
          | exp BAND exp {$$ = concat_mid($1, "&&", $3);}
          | exp LSHIFT exp {$$ = concat_mid($1, "<<", $3);}
          | exp RSHIFT exp {$$ = concat_mid($1, ">>", $3);}
          | exp BEQ exp {$$ = concat_mid($1, " == ", $3);}
          | exp BBEQ exp {$$ = concat_mid($1, " === ", $3);}
          | exp NEQ exp {$$ = concat_mid($1, " != ", $3);}
          | exp NNEQ exp {$$ = concat_mid($1, " !== ", $3);}
          | exp GT exp {$$ = concat_mid($1, " > ", $3);}
          | exp LT exp {$$ = concat_mid($1, " < ", $3);}
          | exp GE exp {$$ = concat_mid($1, " >= ", $3);}
          | exp LE exp {$$ = concat_mid($1, " <= ", $3);}
          | exp INSTANCEOF exp {$$ = concat_mid($1, " instanceof ", $3);}
          | exp PERC exp {$$ = concat_mid($1, "%", $3);}
          | NEG exp {$$ = concat_left("!", $2);}
          | MINUS exp {$$ = concat_left("-", $2);} %prec NEG
          | PLUS exp {$$ = concat_left("+", $2);} %prec NEG
          | LP multi_exp RP {$$ = concat_around("(", $2, ")");}
          | exp QUESTION exp TDOTS exp {
    char *inter1 = concat($1, "? ");
    char *inter2 = concat(inter1, $3);
    char *inter3 = concat(inter2, ": ");
    char *result = concat(inter3, $5);
    free(inter1);
    free(inter2);
    free(inter3);
    free($1);
    free($3);
    free($5);
    $$ = result;
 }

id : ID_LET {$$ = $1;}
   | THIS {$$ = strdup("this");}
   | id ID_CLS {$$ = concat_two($1, $2);}
   | id ID_CLSP {$$ = concat_two($1, $2);}

fct_call : id LP args RP {
    char *args = concat_around("(", $3, ")");
    $$ = concat_two($1, args);
 }
         | fct_call LP args RP {
    char *args = concat_around("(", $3, ")");
    $$ = concat_two($1, args);
 }

tab_call : exp LH exp RH {
    char *index = concat_around("[", $3, "]");
    $$ = concat_two($1, index);
 }

tab_def : LH args RH {$$ = concat_around("[", $2, "]");}

affect : id eq exp {$$ = concat_two($1, concat_two($2, $3));} %prec EQ
       | id PLUS_PLUS {$$ = concat_right($1, "++");}
       | PLUS_PLUS id {$$ = concat_left("++", $2);}  %prec NEG
       | id MINUS_MINUS {$$ = concat_right($1, "--");}
       | MINUS_MINUS id {$$ = concat_left("--", $2);} %prec NEG

eq : EQ {$$ = strdup(" = ");}
   | PLUS_EQ {$$ = strdup(" += ");}
   | MINUS_EQ {$$ = strdup(" -= ");}
   | MULT_EQ {$$ = strdup(" *= ");}
   | POW_EQ {$$ = strdup(" **= ");}
   | DIV_EQ {$$ = strdup(" /= ");}
   | OR_EQ {$$ = strdup(" |= ");}
   | PERC_EQ {$$ = strdup(" %= ");}
   | AND_EQ {$$ = strdup(" &= ");}
   | XOR_EQ {$$ = strdup(" ^= ");}
   | BOR_EQ {$$ = strdup(" ||= ");}
   | BAND_EQ {$$ = strdup(" &&= ");}
   | LSHIFT_EQ {$$ = strdup(" <<= ");}
   | RSHIFT_EQ {$$ = strdup(" >>= ");}

let : LET ID_LET {$$ = concat_left("let ", $2);}
    | LET ID_LET EQ exp {$$ = concat_left("let ", concat_mid($2, " = ", $4));}
    | CONST ID_LET {$$ = concat_left("const ", $2);}
    | CONST ID_LET EQ exp {$$ = concat_left("const ", concat_mid($2, " = ", $4));}

fct_def : FUNCTION LP args_def RP LB inst_suite RB {
    char *args = concat_around("(", $3, ")");
    char *content = concat_around(" {", $6, "}");
    char *head = concat_left("function", args);
    $$ = concat_two(head, content);
}
        | LP args_def RP FCT_ARROW LB inst_suite RB {
    char *args = concat_around("(", $2, ")");
    char *content = concat_around("{", $6, "}");
    $$ = concat_mid(args, " => ", content);
}
        | LP args_def RP FCT_ARROW exp {
    char *args = concat_around("(", $2, ")");
    char *arrow_exp = concat_left(" => ", $5);
    $$ = concat_two(args, arrow_exp);
}
//        | proper_fct_def {}

proper_fct_def : FUNCTION ID_LET LP args_def RP LB inst_suite RB {
    char *args = concat_around("(", $4, ")");
    char *content = concat_around(" {", $7, "}");
    char *head = concat_left("function ", $2);
    $$ = concat_two(head, concat_two(args, content));
}

args_def : ID_LET CMM args_def {$$ = concat_mid($1, ", ", $3);}
         | ID_LET {$$ = $1;}
         | {$$ = strdup("");}

args : exp CMM args {$$ = concat_mid($1, ", ", $3);}
     | exp {$$ = $1;}
     | {$$ = strdup("");}

return : RETURN exp {$$ = concat_left("return ", $2);}

loop : if {$$ = $1;}
     | for {$$ = $1;}
//     | switch {}
     | while {$$ = $1;}
     | do_while {$$ = $1;}

if : IF LP exp RP LB inst_suite RB else {
    char *cond = concat_around("(", $3, ")");
    char *content = concat_around(" {", $6, "}");
    $$ = concat_left("if ", concat_two(cond, concat_two(content, $8)));
}
   | IF LP exp RP smc_inst else {
   char *cond = concat_around("(", $3, ") ");
   char *back = concat_two($5, $6);
   $$ = concat_left("if ", concat_two(cond, back));
}

else : ELSE LB inst_suite RB {}
     | ELSE smc_inst {$$ = concat_left("else ", $2);}
     | {$$ = strdup("");}

for : FOR LP for_p1 SMC for_p2 SMC for_p3 RP LB inst_suite RB {
    char *p1 = concat_around("(", $3, "; ");
    char *p2 = concat_right($5, "; ");
    char *p3 = concat_right($7, ")");
    char *parts = concat_two(p1, concat_two(p2, p3));
    char *content = concat_around(" {", $10, "}");
    $$ = concat_left("for ", concat_two(parts, content));
}

for_p1 : let {$$ = $1;}
       | affect {$$ = $1;}
       | {$$ = strdup("");}

for_p2 : exp {$$ = $1;}
       | {$$ = strdup("");}

for_p3 : affect {$$ = $1;}
       | {$$ = strdup("");}

while : WHILE LP exp RP LB inst_suite RB {
    char *cond = concat_around("(", $3, ")");
    char *content = concat_around(" {", $6, "}");
    $$ =  concat_left("while ", concat_two(cond, content));
}

do_while : DO LB inst_suite RB WHILE LP exp RP {
    char *content = concat_around("{", $3, "} ");
    char *do_part = concat_left("do ", content);
    char *cond = concat_around("(", $7, ")");
    char *while_part = concat_left("while ", cond);
    $$ = concat_two(do_part, while_part);
}

%%
/* CODE C */

void yyerror(const char*s)
{
  fprintf(stderr,"%s\n",s);
}

#include "lex.yy.c"
int main() {
    //yydebug = 1;
  yyparse();
  //ptr_stack_free_all();
  return 1;
}
