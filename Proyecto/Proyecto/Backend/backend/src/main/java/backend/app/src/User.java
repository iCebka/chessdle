package backend.app.src;

import java.io.*;
import java.util.*;

public class User {

    private String username;
    private String password;
    private String bio;
    private ArrayList<String> favs; // list of boardgames saved to favourites
    private ArrayList<String> discovered;
    private File info;
    private PrintWriter out;
    private Scanner scan;

    // creates a user
    User(String user, String pass) throws IOException {
        username = user;
        password = pass;
        favs = new ArrayList<>();
        discovered = new ArrayList<>();
        checkData(); // checks if the information exists already otherwise creates it
    }

    // creates a default user without any favourites list or saved information
    User(){
        username = "username";
        password = "admin123";
    }


    public String getUsername(){ return username; }

    public String getPassword(){ return password; }

    public String changeUsername(String name){
        if(!Objects.equals(name, "")){
            username = name;
            System.out.println("Username successfully changed.");
        } else System.out.println("Error changing username");

        return username;
    }

    public String changePassword(String pass){
        if(!Objects.equals(pass, "")) {
            password = pass;
            System.out.println("Password successfully changed.");
        } else System.out.println("Error changing password.");
        return password;
    }

    public String changeBio(String biography) throws FileNotFoundException{
        bio = biography;
        saveInfo();
        return bio;
    }

    public String getBio(){ return bio; }

    private void checkData() throws IOException{

        if(username.equals("username")) return; // does not anything if the default user is set up
        
        info = new File("Backend/backend/src/main/java/backend/app/users/" + username + ".txt");
        if(info.createNewFile()){
            System.out.println("User successfully created.");
            bio = "Add a biography...";
            saveInfo();
        } else {
            System.out.println("Loading user info...");
            loadUserInfo();
        }
    }

    public void loadUserInfo() throws FileNotFoundException {
        scan = new Scanner(info);
        String[] favStrings = {};
        String[] disStrings = {};
        if(scan.hasNextLine()){ bio = scan.nextLine(); }
        if(scan.hasNextLine())
            favStrings = scan.nextLine().split(",");
        for(String s : favStrings) favs.add(s);

        if(scan.hasNextLine())
            disStrings = scan.nextLine().split(",");
        for(String s : disStrings) discovered.add(s);
    }

    public void saveInfo() throws FileNotFoundException {
        out = new PrintWriter("Backend/backend/src/main/java/backend/app/users/" + username + ".txt");
        out.println(bio);
        for(String s : favs) 
            if(!s.isEmpty())
                out.print(s + ",");
        out.println();

        for(String s : discovered)
            if(!s.isEmpty())
                out.print(s + ",");

        out.close();
    }

    public Opening addToFav(Opening op) throws FileNotFoundException{
        favs.add(op.getKeyName());
        saveInfo();
        return op;
    }

    public void removeFromFav(Opening op) throws FileNotFoundException{
        if(favs.contains(op.getKeyName())) favs.remove(op.getKeyName());
        else System.out.println("Error!");
        saveInfo();
    }

    public void addToDiscovered(Opening op) throws FileNotFoundException{
        if(discovered.contains(op.getKeyName())) return; // cannot discover the same opening twice
        discovered.add(op.getKeyName());
        saveInfo();
    }

    public List<String> getDiscovered(){
        List<String> discList = new ArrayList<>();
        for(String s : discovered) discList.add(s);
        return discList;
    }

    public List<String> getFavs(){
        List<String> favsList = new ArrayList<>();
        for(String s : favs) favsList.add(s);
        return favsList;
    }

    public boolean isFav(Opening op){
        return favs.contains(op.getKeyName());
    }

}
