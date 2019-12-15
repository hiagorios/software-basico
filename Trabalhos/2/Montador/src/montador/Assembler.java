package montador;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Scanner;

/**
 * @author Hiago Rios Cordeiro
 * @author João Henrique dos Santos Queiroz
 */
public class Assembler {

    private HashMap<Integer, String> hashmap = new HashMap<>();
    private List<String> lines = new ArrayList<>();
    private List<String>

    public static void main(String[] args) {
        Assembler asb = new Assembler();
        asb.readSource("cyclicHanoi.asm");
    }

    public void readSource(String path) {
        Scanner reader;
        try {
            reader = new Scanner(new FileReader(path));
            while (reader.hasNextLine()) {
                lines.add(reader.nextLine());
            }
            reader.close();
        } catch (FileNotFoundException e) {
            System.out.println("Source file not found.");
            System.exit(0);
        }
    }

    public void readOPCodes(String path) {
        Scanner reader;
        try {
            reader = new Scanner(new FileReader(path));
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

    public boolean isLabel(String line) {
        //Testar
        return !line.contains("_") && line.contains(":");
    }

    public String removeComment(String line) {
        //Testar
        return line.split(";")[0];
    }

}
