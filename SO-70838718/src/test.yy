%language "c++"

%code {
    int yylex(int*);
}

%token X

%%

everything: X {}
