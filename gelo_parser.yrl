Nonterminals Functions Function Statements Statement Expression Param Params Comps Comp If Else ElseIf ElseIfs comp math1 math2 assign.
Terminals '+' '-' '*' '/' ';' '=' '(' ')' '{' '}' ',' '.' eq integer id lt gt function 'if' neq leq geq else name echo string concat list get 'and' 'or' ext spawn send recv.
Rootsymbol Functions.

Left 100 math1.
Left 200 math2.
Left 50 assign.	

Functions -> Function : ['$1'].
Functions -> Function Functions : ['$1'|'$2'].

Function -> function name '(' Params ')' '{' Statements '}' : {function, unwrap('$2'), '$4', '$7'}.
Function -> function name '(' ')' '{' Statements '}' : {function, unwrap('$2'), [], '$6'}.

Statements -> Statement : ['$1'].
Statements -> Statement Statements : ['$1'|'$2'].
Statement -> Expression ';' : '$1'.
Statement -> Expression Expression ';' : ['$1'|'$2'].
Statement -> If : '$1'.

Params -> Param : ['$1'].
Params -> Param ',' Params : ['$1'|'$3'].
Param -> Expression : '$1'.

If  -> 'if' '(' Comps ')' '{' Statements '}' : {ifs, '$3', '$6'}.
If -> 'if' '(' Comps ')' '{' Statements '}' Else : {ifs, '$3', '$6', '$8'}.
If -> 'if' '(' Comps ')' '{' Statements '}' ElseIfs : {ifs, '$3', '$6', '$8'}.

ElseIfs -> ElseIf : ['$1'].
ElseIfs -> ElseIf ElseIfs : ['$1'|'$2'].
ElseIf -> else 'if' '(' Comps ')' '{' Statements '}' : {elseif, '$4', '$7'}.

Else -> else '{' Statements '}' : {else, [], '$3'}.

Comps -> Comp : ['$1'].
Comps -> Comp Comps : ['$1'|'$2'].
Comp -> Expression comp Expression : {'$2', '$1', '$3'}.
Comp -> Comp 'and' Comp : {'$1', 'and', '$3'}.
Comp -> Comp 'or' Comp : {'$1', 'or', '$3'}.

Expression -> ext send '(' Expression ',' Expression ')' : {bang, '$4', '$6'}.
Expression -> ext recv '(' ')' '{' Statements '}' : {recv, '$6'}.
Expression -> '(' Expression ')' '{' Statements '}' : {recvopt, '$2', '$5'}.
Expression -> '{' Params '}' : {tuple, '$2'}.
Expression -> ext spawn '(' Params ')' : {spawn, '$4'}.
Expression -> ext name '.' name '(' Params ')' : {ext, '$2', '$4', '$6'}.
Expression -> Expression '.' get '(' Expression ')' : {get, '$1', '$5'}.
Expression -> list '(' Params ')' : {list, '$3'}.
Expression -> list '(' ')' : {list, []}.
Expression -> Expression concat Expression : {string, concat, '$1', '$3'}.
Expression -> string : {string, unwrap('$1')}.
Expression -> Expression assign Statement : {'$2', '$1', '$3'}.
Expression -> Expression assign Expression : {'$2', '$1', '$3'}.
Expression -> Expression math1 Expression : {'$2', '$1', '$3'}.
Expression -> Expression math2 Expression : {'$2', '$1', '$3'}.
Expression -> integer : {integer, list_to_integer(unwrap('$1'))}.
Expression -> id : {variable, unwrap('$1')}.
Expression -> name '(' Params ')' : {call, unwrap('$1'), '$3'}.
Expression -> name '(' ')' : {call, unwrap('$1'), []}.
Expression -> name : {atom, unwrap('$1')}.
Expression -> echo Expression : {echo, '$2'}.

comp -> lt : lt.
comp -> gt : gt.
comp -> eq : eq.
comp -> neq : neq.
comp -> leq : leq.
comp -> geq : geq.
assign -> '=' : assign.
math1 -> '+' : add.
math1 -> '-' : subtract.
math2 -> '*' : multiply.
math2 -> '/' : divide.

Erlang code.

-export([tokens/1]).

unwrap({_,_,Value}) -> Value.
tokens(Tokens) ->
    {ok, AST} = parse(Tokens),
    AST.

