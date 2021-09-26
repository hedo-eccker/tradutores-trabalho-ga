import java.util.HashMap;
import java.util.ArrayList;

%%

%public
%class AnalisadorLexico
%standalone
%unicode

%{
        public static int escopoAtual = 0;
        public static boolean declaracaoEmAndamento = false;
        public static boolean aberturaDeFuncao = false;
        public static boolean aberturaDeEscopoDeRepeticao = false;
        public static HashMap<Integer, ArrayList<String>> variaveisPorEscopo = new HashMap<>();

        public static void incrementarEscopo() {
            // Incrementa o escopo. Caso não tenha uma lista de IDs para o escopo, cria uma vazia.
            escopoAtual++;

            if (variaveisPorEscopo.get(escopoAtual) == null) {
                variaveisPorEscopo.put(escopoAtual, new ArrayList<>());
            }
        }

        public static void decrementarEscopo() {
            // Decrementa o escopo e remove a lista de IDs referentes a ele.
            variaveisPorEscopo.remove(escopoAtual--);
        }

        public static void exibirComEscopo(String id) {
            // Verifica se é uma possível declaração em andamento (quando a última palavra analisada foi um tipo de dados).
            if (declaracaoEmAndamento) {
                declaracaoEmAndamento = false;

                // Se ainda não houver nenhuma variável de escopo, fica implícito que é uma abertura de função.
                // Neste caso, apenas exibe o ID da função normalmente.
                if (variaveisPorEscopo.get(escopoAtual) == null) {
                    aberturaDeFuncao = true;
                    System.out.printf("[id, %s]", id);
                    return;
                }

                // Caso já exista uma lista de IDs para o escopo atual, adiciona o ID na lista caso ele ainda não esteja.
                // isso somente se for uma declaração.
                if (!variaveisPorEscopo.get(escopoAtual).contains(id)) {
                    variaveisPorEscopo.get(escopoAtual).add(id);
                    System.out.printf("[id, %s, scope = %d]", id, escopoAtual);
                    return;
                }
            }

            // Caso não seja uma declaração, procura nos escopos, de dentro pra fora, pela referência mais recente do ID específico.
            for (int i = variaveisPorEscopo.keySet().size(); i >= 0; i--) {
                if (variaveisPorEscopo.get(i) != null && variaveisPorEscopo.get(i).contains(id)) {
                    System.out.printf("[id, %s, scope = %d]", id, i);
                    return;
                }
            }

            // Caso seja apenas a exibição de um id (como uma chamada de função), exibe o id com o escopo em que ele é chamado.
            System.out.printf("[id, %s, scope = %d]", id, escopoAtual);
        }

        public static void imprimeCaractere(String caractere) {
            // Imprime os caracteres específicos.
            switch (caractere) {
                case "=":
                    System.out.println("[equal, =]");
                    break;
                case "(":
                    System.out.println("[l_paren, (]");
                    // Para preservar a contagem de escopo, essa lógica permite com que seja verificado se está sendo aberta uma função ou uma estrutura de repetição, de forma que
                    // o seu escopo deve começar na abertura de parênteses.
                    if (aberturaDeFuncao || aberturaDeEscopoDeRepeticao) {
                        incrementarEscopo();
                    }
                    break;
                case ")":
                    System.out.println("[r_paren, )]");
                    break;
                case "{":
                    System.out.println("[l_bracket, {]");
                    // Caso seja uma abertura de função ou de repetição, não abre outro escopo, pois é o mesmo que foi aberto junto com o parêntese esquerdo.
                    if (!aberturaDeFuncao && !aberturaDeEscopoDeRepeticao) {
                        incrementarEscopo();
                    } else if(aberturaDeFuncao) {
                        aberturaDeFuncao = false;
                    } else if(aberturaDeEscopoDeRepeticao) {
                        aberturaDeEscopoDeRepeticao = false;
                    }
                    break;
                case "}":
                    // O fechamento de escopo sempre acontece com }, independente se foi aberto com ( ou {.
                    System.out.println("[r_bracket, }]");
                    decrementarEscopo();
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
PalavrasReservadas = {TiposDeValor} | {Null} | {Condicionais} | {Repeticao} | "return" | "break"

// Operadores
OperadoresMatematicos = "+" | "-" | "*" | "/" | "%"
OperadoresLogicos = "||" | "&&"
OperadoresRelacionais = "<" | "<=" | "==" | "!=" | ">=" | ">"

//Outros Caracteres e comentários
OutrosCaracteres = "(" | ")" | "{" | "}" | "," | ";" | "=" | "&" | "[" | "]"
QuebraDeLinha = \r|\n|\r\n
EspacoEmBranco = {QuebraDeLinha} | [ \t\f]
CaractereDeEntrada = [^\r\n]
ComentarioTradicional = "/*" [^*] ~"*/" | "/*" "*"+ "/"
ComentarioFimDeLinha = "//" {CaractereDeEntrada}* {QuebraDeLinha}?
Comentario = {ComentarioTradicional} | {ComentarioFimDeLinha}

%%

{OutrosCaracteres} { imprimeCaractere(yytext()); }
{QuebraDeLinha} | {EspacoEmBranco} | {Comentario} | {Includes} { /* ignorar */ }
{Texto} { System.out.printf("[string_literal, %s]", yytext());  }
{TiposDeValor} { System.out.printf("[reserved_word, %s]", yytext()); declaracaoEmAndamento = true; }
{Repeticao} { System.out.printf("[reserved_word, %s]", yytext()); aberturaDeEscopoDeRepeticao = true; }
{PalavrasReservadas} { System.out.printf("[reserved_word, %s]", yytext());  }
{OperadoresLogicos} { System.out.printf("[logic_op, %s]", yytext());  }
{OperadoresRelacionais} { System.out.printf("[relational_op, %s]", yytext()); }
{OperadoresMatematicos} { System.out.printf("[arith_op, %s]", yytext()); }
{Identificador} { exibirComEscopo(yytext()); }
{Digito}+ | {Digito}.{Digito}+ { System.out.printf("[num, %s]", yytext()); }

// Outros caracteres (erro)
[^] { System.out.println("Caractere inválido: <" + yytext() + ">"); }
