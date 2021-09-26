import jflex.exceptions.SilentExit;

import java.io.File;
import java.nio.file.Paths;

public class Principal {

    public static void main(String[] args) {
        String rootPath = Paths.get("").toAbsolutePath(). toString();
        String subPath = "/src/main/jflex/";

        String file = rootPath + subPath + "main.flex";
        String entrada = rootPath + subPath + "entrada.txt";

        File sourceCode = new File(file);

        try {
            jflex.Main.generate(new String[] { file });
        } catch (SilentExit e) {
            e.printStackTrace();
        }
    }

}
