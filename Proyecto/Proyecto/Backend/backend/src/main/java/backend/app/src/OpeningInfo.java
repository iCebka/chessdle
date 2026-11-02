package backend.app.src;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.Scanner;

public class OpeningInfo {

    private static String opDir = "Backend/backend/src/main/java/backend/app/files/openings_sheet.csv";
    public static String repoDir = "Backend/backend/src/main/java/backend/app/files/repository.txt";
    private String title; //  the actual full title of the opening
    private String overview; // overview of the opening
    private String moves; // the moves that gets you to the opening
    private String author; // the author of the opening
    private File file;
    private Scanner scan;

    OpeningInfo(String moves){
        this.moves = moves;
        loadFromOp(moves);
        loadFromRepo(moves);
    }

    // to load from the openings_sheet.csv file
    private void loadFromOp(String moves){
        file = new File(opDir);
        try { scan = new Scanner(file); }
        catch (FileNotFoundException e) {
            System.out.println("Error Loading Opening File: " + moves);
            throw new RuntimeException(e);
        }

        // loads the main information of the opening
        while (scan.hasNextLine()){
            String[] data = scan.nextLine().split(",");
            if (data[data.length - 1].trim().equals(moves)){
                for(int i = 1; i < data.length - 1; i++){
                    title = data[i].trim();
                }
                break;
            }
        }
    }

    // to load from the repository.txt file
    private void loadFromRepo(String moves){
        file = new File(repoDir);
        try { scan = new Scanner(file); }
        catch (FileNotFoundException e) {
            System.out.println("Error Loading Opening File: " + moves);
            throw new RuntimeException(e);
        }

        while (scan.hasNextLine()){
            String[] data = scan.nextLine().split(",");
            if (data[3].equals(moves)){
                author = data[2];
                overview = "";
                for(int i = 4; i < data.length; i++)
                    overview += data[i];
                
                break;
            }
        }
    }


    public String getOverview(){ return overview; }

    public String getTitle(){ return title; }

    public String getMoves(){ return moves; }

    public String getAuthor(){ return author; }

}
