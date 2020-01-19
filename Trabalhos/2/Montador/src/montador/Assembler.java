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

    // INSTRUCAO | OPCODEHEXA | COMPRIMENTO
    private HashMap<String, String[]> opcodeTable = new HashMap<>();
    // ROTULO | ILC
    private HashMap<String, Long> labelTable = new HashMap<>();
    // CONSTANT | VALUE
    private HashMap<String, Long> constTable = new HashMap<>();

    private List<String> lines = new ArrayList<>();

    private static Long ilc;

    private String lastLabel;

    public static void main(String[] args) {
        Assembler asb = new Assembler();
        ilc = (long) 0;
        asb.readOPCodes("OPCodes.txt");
        asb.firstPass("cyclicHanoi.asm");
        asb.secondPass("cyclicHanoi.asm");
        asb.writeFile("output.txt");
    }

    public void firstPass(String path) {
        Scanner reader;
        boolean isSectionData = false;
        try {
            reader = new Scanner(new FileReader("src/montador/" + path));
            while (reader.hasNextLine()) {
                String line = removeComments(reader.nextLine());
                line = removeIdentation(line);
                if (line != null && !line.isEmpty() && !line.contains("global _start")) {
                    if (line.contains("section")) {
                        isSectionData = line.contains("data");
                    } else if (isInclude(line)) {
                        firstPass(getIncludeFile(line));
                    } else {
                        if (isSectionData) {
                            // tratar os db que usam label
                            // ler as proximas linhas até achar o NULL
                            // TODO
                        } else {
                            if (isLabel(line)) {
                                addLabel(line);
                            } else if (isConstant(line)) {
                                addConstant(line);
                            } else if (isVariable(line)) {
                                // TODO
                                addVariable(line);
                            } else {
                                // is instruction
                                ilc += getInstructionSize(line);
                            }
                        }
                    }
                }
            }
            reader.close();
        } catch (FileNotFoundException e) {
            System.out.println("Source file not found: " + path);
            System.exit(0);
        }
    }

    public void secondPass(String path) {
        Scanner reader;
        boolean isSectionData = false;
        try {
            reader = new Scanner(new FileReader("src/montador/" + path));
            while (reader.hasNextLine()) {
                String line = removeComments(reader.nextLine());
                line = removeIdentation(line);
                if (line != null && !line.isEmpty() && !line.contains("global _start")) {
                    if (line.contains("section")) {
                        isSectionData = line.contains("data");
                    } else if (isInclude(line)) {
                        secondPass(getIncludeFile(line));
                    } else if (isLabel(line)) {
                        if (!line.contains(".")) {
                            lastLabel = line.substring(0, line.length() - 1);
                        }
                    } else if (!isSectionData && !isConstant(line) && !isVariable(line)) {
                        // Is instruction
                        // Modify and write line
                        String[] args = getArgs(line);
                        String changedLine = "";
                        for (int i = 0; i < args.length; i++) {
                            // check if instruction reference a local label
                            if (args[i].contains(".")) {
                                // if so, search lastLabel + local in labelsTable
                                changedLine = line.replaceFirst(args[i], labelTable.get(lastLabel + args[i]).toString());
                            } else if (labelTable.containsKey(args[i])) {
                                changedLine = line.replaceFirst(args[i], labelTable.get(args[i]).toString());
                            } else if (constTable.containsKey(args[i])) {
                                changedLine = line.replaceFirst(args[i], constTable.get(args[i]).toString());
                            }
                        }
                        changedLine = (changedLine.length() > 0) ? changedLine : line;
                        lines.add(opcodeTable.get(line)[0] + "\t\t" + changedLine);
                        // TODO  
                    }
                }
            }
            reader.close();
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
                String[] array = line.split("\\|");
                String[] aux = {array[1].trim(), array[2].trim()};
                opcodeTable.put(array[0].trim(), aux);
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

    public void addConstant(String line) {
        String[] aux = line.split("equ");
        constTable.put(aux[0].trim(), Long.parseLong(aux[1].trim()));
    }

    public void addLabel(String line) {
        if (!line.contains(".")) {
            lastLabel = line.substring(0, line.length() - 1);
            labelTable.put(lastLabel, ilc);
        } else {
            labelTable.put(lastLabel + line.substring(0, line.length() - 1), ilc);
        }
    }

    public void addVariable(String line) {
        // TODO
        // tem que alocar memoria
    }

    public int getInstructionSize(String line) {
        return Integer.parseInt(opcodeTable.get(line)[1]);
    }

    public String getInstructionHexa(String line) {
        return opcodeTable.get(line)[0];
    }

    public String getMnemonic(String line) {
        return line.split(" ")[0];
    }

    public String[] getArgs(String line) {
        if (getMnemonic(line).equals(line)) {
            // instruction has no args
            return new String[0];
        }
        String [] args = line.substring(getMnemonic(line).length() + 1).split(","); //separating mnemonic from
        for (int i = 0; i < args.length; i++){
            args[i] = args[i].trim();
        }
        return args;
    }

    public int getRegValue(String reg) throws Exception {
        switch (reg) {
            case "eax":
                return 0;
            case "ebx":
                return 3;
            case "ecx":
                return 1;
            case "edx":
                return 2;
            case "ebp":
                return 5;
            case "esp":
                return 4;
            case "esi":
                return 6;
            case "edi":
                return 7;
            case "al":
                return 0;
            case "bl":
                return 3;
            default:
                throw new Exception("Register doesnt exist");
        }
    }

    public boolean isLabel(String line) {
        return line.contains(":");
    }

    public boolean isData(String line) {
        return line.contains("db");
    }

    public boolean isVariable(String line) {
        return line.contains("resb");
    }

    public boolean isConstant(String line) {
        return line.contains("equ");
    }

    public boolean isInclude(String line) {
        return line.contains("%include");
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
}
