import jflex.exceptions.SilentExit;

import java.nio.file.Paths;

public class Principal {

    public static void main(String[] args) {
        // Código utilizado para gerar a classe Java com o analisador léxico.
        String rootPath = Paths.get("").toAbsolutePath(). toString();
        String subPath = "/src/main/jflex/";

        String file = rootPath + subPath + "main.flex";

        try {
            jflex.Main.generate(new String[] { file });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
