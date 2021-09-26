# Tradutores - Analisador Léxico utilizando JFlex.
- Aluno: Hedo Eccker da Silva Júnior
- Turma/Ano: Tradutores (Noturno, Terça-Feira) /2021-02
<br /> <br />
Neste repositório, encontra-se implementado um analisador léxico para a linguagem C, escrito utilizando Java com a biblioteca JFlex.

## Instruções para execução.
- Adicionar o JAR da biblioteca JFlex como dependência do projeto.
- Executar a classe `Principal.java`. A execução deverá ter uma saída no console semelhante a essa:

```
Reading "/Users/hedo/dev/uni/tradutores/src/main/jflex/main.flex"
Constructing NFA : 414 states in NFA
Converting NFA to DFA : 
............................................................................................................................................
142 states before minimization, 94 states in minimized DFA
Old file "/Users/hedo/dev/uni/tradutores/src/main/jflex/AnalisadorLexico.java" saved as "/Users/hedo/dev/uni/tradutores/src/main/jflex/AnalisadorLexico.java~"
Writing code to "/Users/hedo/dev/uni/tradutores/src/main/jflex/AnalisadorLexico.java"

Process finished with exit code 0
```
Após a execução, será gerado um arquivo chamado `AnalisadorLexico.java` na pasta `jflex`.
- Entrar na pasta jflex e, por meio do terminal, executar o seguinte comando:
`java AnalisadorLexico.java entrada.txt`

Isso fará com que o resultado da análise léxica seja exibido no console.
```
[reserved_word, void][id, CalculoMedia][l_paren, (]
[r_paren, )]
[l_bracket, {]
[reserved_word, float][id, NotaDaP1, scope = 1][comma, ,]
[id, NotaDaP2, scope = 1][semicolon, ;]
[reserved_word, float][id, Media, scope = 1][semicolon, ;]
[id, clrscr, scope = 1][l_paren, (]
[r_paren, )]
...
```
