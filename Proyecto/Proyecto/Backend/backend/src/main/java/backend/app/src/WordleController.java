package backend.app.src;

import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;

public class WordleController {
    private WordleController(){}

    private static List<String> wordsList;// the list of available words for the wordle game
    private static String word; // the word to guess
    private static int attempt; // the number of attempts

    public static void loadWords(){
        wordsList = AppController.getKeys();
    }

    public static List<String> getWordsList(){
        return wordsList;
    }

    public static String getRandomWord(){
        return wordsList.get((int)(Math.random() * (wordsList.size() - 1)));
    }

    public static List<Integer> checkLetters(String s){
        List<Integer> res = new ArrayList<>();
        for(int i = 0; i < 5; i++){
            if(s.charAt(i) == word.charAt(i)){
                res.add(2);
            } else if(word.contains(s.charAt(i) + "")){
                res.add(1);
            } else {
                res.add(0);
            }
        }
        return res;
    }

    public static int getAttempt(){
        return attempt;
    }

    public static boolean checkEnd(String s){
        return s.equals(word);
    }

    public static void startGame(){
        // to start the game
        word = getRandomWord();
        attempt = 0;
    }

    public static String getCurrentWord(){
        return word;
    }

    public static void main(String[] args) throws FileNotFoundException {
        AppController.loadOpenings();
        WordleController.loadWords();
        WordleController.startGame();
    }
}
