package backend.app.src;

import java.io.*;
import java.util.*;

public class AppController {

    // private static String opDir = "src/main/java/backend/app/files/openings_sheet.csv"; // currently not used
    public static String repoDir = "Backend/backend/src/main/java/backend/app/files/repository.txt";
    private static String credDir = "Backend/backend/src/main/java/backend/app/files/credentials.txt";
    private static String logDir = "Backend/backend/src/main/java/backend/app/files/logged.txt";

    private static final File credentials = new File(credDir);
    // private static final File openings = new File(opDir); // currently not used
    private static final File available = new File(repoDir);

    private static Scanner scan;
    private static PrintWriter out;
    private static User loggedUser = new User();

    // the list of all available openings in the app by the moves
    private static final HashMap<String, Opening> repo = new HashMap<>();

    // the list of all available openings by keywords-moves pair in the app
    private static final HashMap<String, String> keywords = new HashMap<>();

    // all the user's login information hashed just in case
    private static final HashMap<String, String> loginInfo = new HashMap<>();

    // all of users' information loaded in the app
    private static final HashMap<String, User> users = new HashMap<>();

    public static Map<String, String> getUsers() {
        return loginInfo;
    }

    // to load all the available board game names
    public static void loadOpenings() throws FileNotFoundException {
        
        // load all the available openings by their key word
        scan = new Scanner(available);
        while (scan.hasNextLine()) {
            String[] data = scan.nextLine().split(",");
            keywords.put(data[1], data[3]); // saves the opening by its keyword for the scrabble game and the moves
        }

        for(String s : keywords.values()) {
            repo.put(s, new Opening(s)); // saves the opening by its moves (they are unique)
        }

        scan.close();
    }

    // it loads all already created users from the database
    public static void loadUsers() throws IOException {

        String[] logged;

        scan = new Scanner(credentials);

        while (scan.hasNextLine()) {
            String line = scan.nextLine();
            String user = line.split(",")[0];
            String pass = line.split(",")[1];
            loginInfo.put(user, pass);
        }

        scan.close();

        // to load the users from the credentials file
        for (Map.Entry<String, String> e : loginInfo.entrySet())
            users.put(e.getKey(), new User(e.getKey(), e.getValue()));

        // loads the last logged user
        scan = new Scanner(new File(logDir));

        if (scan.hasNextLine()) {
            logged = scan.nextLine().split(",");
            if (logged[0].equals("username"))
                loggedUser = new User(); // default user
            else
                loggedUser = new User(logged[0], logged[1]); // real logged user
        }

        scan.close();
    }

    public static List<String> getKeys(){
        List<String> keys = new ArrayList<>();
        for (String key : keywords.keySet())
            keys.add(key);

        return keys;
    }

    public static User getUser(String name) {
        return users.get(name);
    }

    // to handle the creation of a new user account
    public static User createUser(String name, String pass) throws IOException {
        loggedUser = new User(name, pass);
        loginInfo.put(name, pass);

        out = new PrintWriter(credDir);

        // to update the credentials text file every time a user is created
        for (Map.Entry<String, String> e : loginInfo.entrySet()) {
            out.println(e.getKey() + "," + e.getValue());
        }
        out.close();
        return loggedUser;
    }

    // to validate information of username and password in the database
    public static boolean signedIn(String username, String password) {
        return loginInfo.containsKey(username) && loginInfo.get(username).equals(password);
    }

    // to check if the username is available
    public static boolean checkUsername(String username, String password) {
        return !loginInfo.containsKey(username) && password.length() > 0;
    }

    // returns the searched board game by the moves
    public static Opening getOpening(String moves) {
        return repo.get(moves);
    }

    // returns the searched board game by the key name (for the scrabble game)
    public static Opening getOpeningByKeyword(String keyword) {
        return repo.get(keywords.get(keyword));
    }

    public static User handleLogin(String name, String pass) throws IOException {
        if (signedIn(name, pass)) {
            loggedUser = new User(name, pass);

            // updates the logged user in the logged.txt file
            out = new PrintWriter(logDir);
            out.println(name + "," + pass);
            out.close();

            System.out.println("Welcome back, " + name + "!");
        } else {
            loggedUser = new User();
            System.out.println("Invalid credential! Default user set up.");
        }
        return loggedUser;
    }

    // to log out the current user
    public static void logOut() throws FileNotFoundException {

        out = new PrintWriter(logDir);
        out.println("username,admin123");
        out.close();

        loggedUser = new User();
    }

    // to handle the creation of a new user
    public static User handleSignup(String name, String pass) throws IOException {
        if (!loginInfo.containsKey(name)) {
            loggedUser = createUser(name, pass);
        } else {
            System.out.println("Username already taken! Try again");
            loggedUser = new User();
        }

        return loggedUser;
    }

    public static User getLoggedUser() {
        return loggedUser;
    }

    public static String changeUsername(String name) throws FileNotFoundException {
        if (!loginInfo.containsKey(name)) {
            String updated = loggedUser.changeUsername(name); // the method checks that the username is not empty

            loginInfo.remove(loggedUser.getUsername()); // removes the old username from the credentials
            loginInfo.put(updated, loggedUser.getPassword()); // puts the new username in the credentials

            out = new PrintWriter(credDir);

            // to update the credentials text file every time a user is created
            for (Map.Entry<String, String> e : loginInfo.entrySet()) {
                out.println(e.getKey() + "," + e.getValue());
            }
            out.close();
        }
        return loggedUser.getUsername();
    }

    public static String changePassword(String pass) throws FileNotFoundException {

        String updated = loggedUser.changePassword(pass); // the method checks that the password is not empty

        loginInfo.put(loggedUser.getUsername(), updated);

        out = new PrintWriter(credDir);

        // to update the credentials text file every time a user is created
        for (Map.Entry<String, String> e : loginInfo.entrySet()) {
            out.println(e.getKey() + "," + e.getValue());
        }
        out.close();
        return loggedUser.getUsername();
    }

    public static List<String> getOpenings() {
        List<String> games = new ArrayList<>();
        for (Opening op : repo.values())
            games.add(op.getKeyName());

        return games;
    }

    // get the ID from a given opening
    public static String getId(String nameOp) {
        return repo.get(nameOp).getId();
    }

    // *****MAIN METHOD FOR DEBUGGING PURPOSES*****
    /*public static void main(String[] args) throws IOException {
        loadUsers();
        loadOpenings();
        // String username;
        // String password;

        //loggedUser = handleLogin("atik421", "1234");

        //loggedUser.addToFav(AppController.getOpeningByKeyword("King"));

        // System.out.println(loggedUser.getBio());

        // loggedUser.changeBio("I do not care");

        // System.out.println(loggedUser.getBio());
        // loggedUser.addToFav(getGame("Twilight Imperium"));

        // input = new Scanner(System.in);

        // System.out.println("----Log in----");
        // System.out.print("Username: ");
        // username = input.nextLine();
        // System.out.print("Password: ");
        // password = input.nextLine();

        // System.out.println("Available Games: ");
        // showGames();

        // System.out.println("Information: ");

        // System.out.println("Components: ");

        // for(int i = 0; i < 10; i++)
        // System.out.println(repo.get("Twilight
        // Imperium").getRules().getComponents()[i]);

        // System.out.println("Actions: ");
    }*/
}
