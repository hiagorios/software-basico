package montador;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
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
    // NAME | VALUE
    private HashMap<String, String> dataTable = new HashMap<>();
    // NAME | ILC
    private HashMap<String, Long> varTable = new HashMap<>();

    private List<String> lines = new ArrayList<>();

    private static Long ilc;

    private String lastLabel;

    public static void main(String[] args) {
        Assembler asb = new Assembler();
        ilc = (long) 0;
        asb.readOPCodes("OPCodes.txt");
        asb.firstPass("cyclicHanoi.asm");
        asb.secondPass("cyclicHanoi.asm");
        asb.writeFile("output.o");
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
                            addData(line, reader);
                        } else {
                            if (isLabel(line)) {
                                addLabel(line);
                            } else if (isConstant(line)) {
                                addConstant(line);
                            } else if (isVariable(line)) {
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
                        String changed = "";
                        for (int i = 0; i < args.length; i++) {
                            if (args[i].contains("[")) {
                                //removing brackets
                                args[i] = args[i].substring(1, args[i].length() - 1);
                            }
                            // check if instruction references a local label
                            if (args[i].contains(".")) {
                                // if so, search lastLabel + local in labelsTable
                                changed = line.replaceFirst(args[i], labelTable.get(lastLabel + args[i]).toString());
                            } else if (labelTable.containsKey(args[i])) {
                                changed = line.replaceFirst(args[i], labelTable.get(args[i]).toString());
                            } else if (constTable.containsKey(args[i])) {
                                changed = line.replaceFirst(args[i], constTable.get(args[i]).toString());
                            } else if (varTable.containsKey(args[i])) {
                                changed = line.replaceFirst(args[i], varTable.get(args[i]).toString());
                            } else if (dataTable.containsKey(args[i])) {
                                changed = line.replaceFirst(args[i], dataTable.get(args[i]));
                            }
                        }
                        changed = (changed.length() > 0) ? changed : line;
                        lines.add(opcodeTable.get(line)[0]);
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

            List<String> pairs = new ArrayList<>();
            
            //Reading initial default code
            pairs.addAll(readDefaultCode("default_inicial.txt"));

            for (String line : lines) {
                pairs.addAll(Arrays.asList(line.split(" ")));
            }

            //Reading final default code
            pairs.addAll(readDefaultCode("default_final.txt"));
            
            // Write file
            int i = 0;
            while (pairs.size() >= i + 15) {
                // writing full blocks
                writer.println(pairs.get(i) + pairs.get(i + 1) + " "
                        + pairs.get(i + 2) + pairs.get(i + 3) + " "
                        + pairs.get(i + 4) + pairs.get(i + 5) + " "
                        + pairs.get(i + 6) + pairs.get(i + 7) + " "
                        + pairs.get(i + 8) + pairs.get(i + 9) + " "
                        + pairs.get(i + 10) + pairs.get(i + 11) + " "
                        + pairs.get(i + 12) + pairs.get(i + 13) + " "
                        + pairs.get(i + 14) + pairs.get(i + 15));
                i += 16;
            }

            writer.close();
        } catch (FileNotFoundException ex) {
            System.out.println("Could not create the file " + name);
            System.exit(-1);
        }
    }

    public List<String> readDefaultCode(String path) {
        Scanner reader;
        try {
            reader = new Scanner(new FileReader("src/montador/" + path));
            List<String> lines = new ArrayList<>();
            while (reader.hasNextLine()) {
                for (String str : reader.nextLine().split(" ")){
                    if (str.length() == 4){
                        lines.add(str.substring(0, 2));
                        lines.add(str.substring(2, 4));
                    } else {
                        lines.add(str);
                    }
                }
            }
            reader.close();
            return lines;
        } catch (FileNotFoundException e) {
            System.out.println("Default code not found.");
            System.exit(0);
        }
        return null;
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

    public void addData(String line, Scanner reader) {
        if (line.contains("'")) {
            dataTable.put(line.split(" ")[0], line.split("'")[1] + "0");
            ilc += line.split("'")[1].length() + 1; //we add 1 because of the 0 at the end of string
        } else {
            // treat dbs with label
            if (line.contains("outputMovimento:")) {
                line = line.concat(removeIdentation(reader.nextLine()));
                String[] s = line.split("db");
                dataTable.put(s[0].split(":")[0], s[1].split("\"")[1]);
                ilc += s[1].split("\"")[1].length();
            } else if (line.contains("origem:")) {
                line = line.concat(removeIdentation(reader.nextLine()));
                String[] s = line.split("db");
                dataTable.put(s[0].split(":")[0], " " + s[2].split("\"")[1]);
                ilc += s[2].split("\"")[1].length() + 1;
            } else if (line.contains("destino:")) {
                String[] s = line.split("db");
                dataTable.put(s[0].split(":")[0], s[1].split("\"")[1] + "0");
                ilc += s[1].split("\"")[1].length() + 1;
            }
        }
    }

    public void addVariable(String line) {
        // resb
        String[] s = line.split(" ");
        varTable.put(s[0], ilc);
        ilc += Long.parseLong(s[2]);
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
        //separating mnemonic from args
        line = line.substring(getMnemonic(line).length() + 1);
        List<String> args = new ArrayList<>();
        for (String arg : line.split(",")) {
            for (String cleanArg : arg.split(" ")) {
                if (!cleanArg.isEmpty()) {
                    args.add(cleanArg);
                }
            }
        }
        return args.toArray(new String[0]);
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
