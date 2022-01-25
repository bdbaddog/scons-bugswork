%{
    #include "./test.yy.hh"
%}

%option c++

%%

. { return yy::parser::token::X; }
