%%

%public
%class AnalisadorLexico
%standalone
%unicode

%{
    public static void imprimeCaractere(String caractere) {
        switch (caractere) {
            case "=":
                System.out.println("[equal, =]");
                break;
            case "(":
                System.out.println("[l_paren, (]");
                break;
            case ")":
                System.out.println("[r_paren, )]");
                break;
            case "{":
                System.out.println("[l_bracket, {]");
                break;
            case "}":
                System.out.println("[r_bracket, }]");
                break;
            case ",":
                System.out.println("[comma, ,]");
                break;
            case ";":
                System.out.println("[semicolon, ;]");
                break;
            case "&":
                System.out.println("[ampersand, &]");
                break;
            case "[":
                System.out.println("[l_braces, []");
                break;
            case "]":
                System.out.println("[r_braces, ]]");
                break;
        }
    }
%}

//Valores simples
Digito = [0-9]
Identificador = [a-zA-Z][a-zA-Z0-9]*
Texto = (\"[^\"]*\")

// Includes e palavras reservadas
Includes = "#include <stdio.h>" | "#include <conio.h>"
TiposDeValor = "void" | "float" | "int" | "string" | "int *"
Null = "null" | "NULL"
Condicionais = "if" | "else" | "switch" | "case"
Repeticao = "do" | "while" | "for"
Return = "return"
Break = "break"

PalavrasReservadas = {TiposDeValor} | {Null} | {Condicionais} | {Repeticao} | {Break} | {Return}

// Operadores
OperadoresMatematicos = "+" | "-" | "*" | "/" | "%"
OperadoresLogicos = "||" | "&&"
OperadoresRelacionais = "<" | "<=" | "==" | "!=" | ">=" | ">"

//Outros Caracteres e comentários
OutrosCaracteres = "(" | ")" | "{" | "}" | "," | ";" | "=" | "&"
QuebraDeLinha = \r|\n|\r\n
EspacoEmBranco = {QuebraDeLinha} | [ \t\f]
CaractereDeEntrada = [^\r\n]
ComentarioTradicional = "/*" [^*] ~"*/" | "/*" "*"+ "/"
ComentarioFimDeLinha = "//" {CaractereDeEntrada}* {QuebraDeLinha}?
Comentario = {ComentarioTradicional} | {ComentarioFimDeLinha}

%%

{OutrosCaracteres} { imprimeCaractere(yytext()); }
{QuebraDeLinha} | {EspacoEmBranco} | {Comentario} | {Includes} { /* ignorar */ }
{Texto} { System.out.printf("[string_literal, %s]", yytext()); }
{PalavrasReservadas} { System.out.printf("[reserved_word, %s]", yytext()); }
{OperadoresLogicos} { System.out.printf("[logic_op, %s]", yytext()); }
{OperadoresRelacionais} { System.out.printf("[relational_op, %s]", yytext()); }
{OperadoresMatematicos} { System.out.printf("[arith_op, %s]", yytext()); }
{Identificador} { System.out.printf("[id, %s]", yytext()); }
{Digito}+ | {Digito}.{Digito}+ { System.out.printf("[num, %s]", yytext()); }

// Outros caracteres (erro)
[^] { System.out.println("Caractere inválido: <" + yytext() + ">"); }
