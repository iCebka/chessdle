package backend.app.src;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class Opening {

    private static String dir = "Backend/backend/src/main/java/backend/app/files/repository.txt";
    private static String opDir = "Backend/backend/src/main/java/backend/app/files/openings_sheet.csv";
    private static File file = new File(dir);
    private static File opFile = new File(opDir);

    private String keyName; // the name of the opening in the data base
    private OpeningInfo info; // the information class of the opening
    private Map<String, String> variations; // the variations of the opening
    private String id;

    Opening(String moves) {
        variations = new HashMap<>();
        loadName(moves);
        loadVariations();
        info = new OpeningInfo(moves);
    }

    private void loadName(String moves){
        try (Scanner scan = new Scanner(file)) {
            while (scan.hasNextLine()) {
                String[] data = scan.nextLine().split(",");
                if (data[3].equals(moves)) {
                    keyName = data[1];
                    id = data[0];
                    break;
                } 
            }
        } catch (FileNotFoundException e) { e.printStackTrace(); }
    }
    
    public void loadVariations(){
        int i = 0;
        try (Scanner scan = new Scanner(opFile)) {
            while (scan.hasNextLine() && i < 1) {
                String[] data = scan.nextLine().split(",");
                if (data[0].trim().equals(id)) {
                    String title = "";

                    for(int j = 1; j < data.length - 1; j++){ title += data[j].trim(); }

                    variations.put(data[data.length - 1], title); // saves the moves-name pair of the variations
                    i++; // only saves the 10 first variations encountered in the file
                } 
            }
        } catch (FileNotFoundException e) { e.printStackTrace(); }
    }

    public Map<String, String> getVariations(){ return variations; }

    public String getKeyName(){ return keyName; }

    public OpeningInfo getInfo(){ return info; }

    public String getId(){ return id; }

    public void setId(String id){ this.id = id; }

}
