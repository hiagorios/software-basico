package montador;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Scanner;

/**
 * @author Hiago Rios Cordeiro
 * @author João Henrique dos Santos Queiroz
 */
public class Assembler {

    private static HashMap<Integer, String> hashmap = new HashMap<>();
    private static List<String> lines = new ArrayList<>();

    public static void main(String[] args) {
        Assembler asb = new Assembler();
        asb.readSource("cyclicHanoi.asm");
        asb.writeFile("output.txt");
    }

    public void readSource(String path) {
        Scanner reader;
        try {
            reader = new Scanner(new FileReader("src/montador/" + path));
            Boolean cont = true;
            while (cont) {
                if (reader.hasNextLine()) {
                    String line = removeComments(reader.nextLine());
                    line = removeIdentation(line);
                    if (line != null && !line.isEmpty()) {
                        if (isInclude(line)) {
                            readSource(getIncludeFile(line));
                        } else {
                            lines.add(line);
                        }
                    }
                } else {
                    cont = false;
                    reader.close();
                }
            }
        } catch (FileNotFoundException e) {
            System.out.println("Source file not found: " + path);
            System.exit(0);
        }
    }

    public void readOPCodes(String path) {
        Scanner reader;
        try {
            reader = new Scanner(new FileReader("src/montador/" + path));
            while (reader.hasNextLine()) {
                String line = reader.nextLine();

                lines.add(line);
            }
            reader.close();
        } catch (FileNotFoundException e) {
            System.out.println("OP Codes table not found.");
            System.exit(0);
        }
    }

    public boolean isInclude(String line) {
        // Testar
        return line.contains("%include");
    }

    public boolean isLabel(String line) {
        //Testar
        return !line.contains("_") && line.contains(":");
    }

    public String removeComments(String line) {
        //Testar
        return line.split(";")[0];
    }

    public String removeIdentation(String line) {
        // Testar
        return line.trim().replaceAll(" +", " ");
    }

    public String getIncludeFile(String line) {
        // Testar
        return line.split("'")[1].split("'")[0];
    }

    public void writeFile(String name) {
        try {
            PrintWriter writer = new PrintWriter(new File("src/montador/" + name));
            for (String line : lines) {
                writer.println(line);
            }
            writer.close();
        } catch (FileNotFoundException ex) {
            System.out.println("Could not create the file " + name);
            System.exit(-1);
        }
    }
}
