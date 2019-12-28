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

/*
Steps:
First pass:
Reads the entire source file, looking only for label definitions
Then the labels have values assigned to them, according to the LC, and are placed in the symbol table
No instructions are assembled in this pass
Second pass:
The source file is read again, this time the instructions are assembled using
the symbol table and the opcodes table
 */
public class Assembler {

    private static HashMap<Integer, String> hashmap = new HashMap<>();
    private static List<String> lines = new ArrayList<>();

    public static void main(String[] args) {
        Assembler asb = new Assembler();
        //asb.readSource("cyclicHanoi.asm");
        //asb.writeFile("output.txt");

        String test = "mov eax, ebx";
        System.out.println(asb.getInstructionSize(test));
        /*
        for (String s : asb.getArgs(test)) {
            System.out.println(s);
        }
        */
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

                // something.add(line);
            }
            reader.close();
        } catch (FileNotFoundException e) {
            System.out.println("OP Codes table not found.");
            System.exit(0);
        }
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

    public boolean isInclude(String line) {
        return line.contains("%include");
    }

    public boolean isLabel(String line) {
        //Testar
        return line.contains(":"); // && !line.contains("_");
    }

    public String removeComments(String line) {
        return line.split(";")[0];
    }

    public String removeIdentation(String line) {
        return line.trim().replaceAll(" +", " ");
    }

    public String getIncludeFile(String line) {
        return line.split("'")[1].split("'")[0];
    }

    public int getInstructionSize(String line) {
        String[] args = getArgs(line);
        return 1 + (args.length > 0 ? args.length : 0);
    }

    public String getMnemonic(String line) {
        return line.split(" ")[0];
    }

    public String[] getArgs(String line) {
        if (getMnemonic(line).equals(line)) {
            // instruction has no args
            return new String[0];
        }
        String args = line.substring(getMnemonic(line).length() + 1); //separating mnemonic from
        return args.split(", ");
    }
}
