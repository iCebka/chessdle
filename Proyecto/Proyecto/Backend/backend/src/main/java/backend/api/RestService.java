package backend.api;

// java imports
import java.util.*;
import java.io.FileNotFoundException;
import java.io.IOException;

import backend.app.src.AppController; // the controller for the backend classes
import backend.app.src.Opening; // the class for the boardgames
import backend.app.src.WordleController;

// default Springboot imports
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@CrossOrigin() // esta línea de aquí casi arruina toda mi existencia (no estoy exagerando)
@RestController
public class RestService {

	@GetMapping(value = "/test", produces = "application/json")
	public String checkConnection() {
		return "Wagner me la come";
	}

	@GetMapping("/error")
	public String showError() {
		return "Error somewhere!";
	}

	@GetMapping("/getLoggedUsername")
	public String getLoggedUsername() {
		return AppController.getLoggedUser().getUsername();
	}

	@GetMapping(value = "/getBiography", produces = "application/json")
	public String getBiography(@RequestParam String user) {
		return AppController.getUser(user).getBio();
	}

	@GetMapping(value = "/setBiography", produces = "application/json")
	public String setBiography(@RequestParam String bio) throws FileNotFoundException {
		return AppController.getLoggedUser().changeBio(bio);
	}

	@GetMapping(value = "/getOpenings", produces = "application/json")
	public List<String> getOpenings() {
		return AppController.getOpenings();
	}

	// gets the boardgame object as a whole of the specified game
	@GetMapping(value = "/getOpening", produces = "application/json")
	public Opening getOpening(@RequestParam String opName) {
		return AppController.getOpeningByKeyword(opName);
	}

	@GetMapping(value = "/getVariations", produces = "application/json")
	public Map<String, String> getVariations(@RequestParam String opName) {
		return AppController.getOpeningByKeyword(opName).getVariations();
	}
	

    // gets the full title of the opening
	@GetMapping(value = "/getFullTitle", produces = "application/json")
	public String getFullTitle(@RequestParam String opName) {
		return AppController.getOpeningByKeyword(opName).getInfo().getTitle();
	}

	@GetMapping(value = "/getOverview", produces = "application/json")
	public String getOverview(@RequestParam String opName) {
		return AppController.getOpeningByKeyword(opName).getInfo().getOverview();
	}

	// get the list of all available turn actions of a game
	@GetMapping(value = "/getMoves", produces = "application/json")
	public String getMoves(@RequestParam String opName) {
		return AppController.getOpeningByKeyword(opName).getInfo().getMoves();
	}

	// get the author of the given opening
	@GetMapping(value = "/getAuthor", produces = "application/json")
	public String getAuthor(@RequestParam String opName) {
		return AppController.getOpeningByKeyword(opName).getInfo().getAuthor();
	}

    // get all the users of the app
	@GetMapping(value = "/getUsers", produces = "application/json")
	public Map<String, String> getUsers() {
		return AppController.getUsers();
	}

    // validates that the user's information is correct
	@GetMapping(value = "/validateUser", produces = "application/json")
	public boolean validateUser(@RequestParam String name, @RequestParam String pass) {
		return AppController.signedIn(name, pass);
	}

    // checks if the username is available
	@GetMapping("/checkUsername")
	public boolean checkUsername(@RequestParam String name, @RequestParam String pass) {
		return AppController.checkUsername(name, pass);
	}

    // takes care of the process of creating a new user
	@GetMapping(value = "/handleSignup", produces = "application/json")
	public String handleSignup(@RequestParam String name, @RequestParam String pass) throws IOException {
		return AppController.handleSignup(name, pass).getUsername();
	}

    // takes care of the process of signing in
	@GetMapping(value = "/handleLogin", produces = "application/json")
	public String handleLogin(@RequestParam String name, @RequestParam String pass) throws IOException {
		return AppController.handleLogin(name, pass).getUsername();
	}

    // logs out the current user
	@GetMapping("/logout")
	public void getMethodName() throws FileNotFoundException {
		AppController.logOut();
	}

	@GetMapping("/getFavs")
	public List<String> getFavs(@RequestParam String user) {
		return AppController.getLoggedUser().getFavs();
	}

    // adds the opening to the user's favourites
	@GetMapping(value = "/addToFav", produces = "application/json")
	public void addToFav(@RequestParam String opName) throws FileNotFoundException {
		AppController.getLoggedUser().addToFav(AppController.getOpeningByKeyword(opName));
	}

    // removes the opening from the user's favourites
	@GetMapping("/removeFromFav")
	public void removeFromFav(@RequestParam String opName) throws FileNotFoundException {
		AppController.getLoggedUser().removeFromFav(AppController.getOpeningByKeyword(opName));
	}

    // checks if the opening is already in the user's favourites
	@GetMapping("/isFav")
	public boolean isFav(@RequestParam String opName) {
		return AppController.getLoggedUser().isFav(AppController.getOpeningByKeyword(opName));
	}

	@GetMapping("/getDiscovered")
	public List<String> getDiscovered() {
		return AppController.getLoggedUser().getDiscovered();
	}
	

	@GetMapping("/discover")
	public void discover(@RequestParam String opName) throws FileNotFoundException {
		AppController.getLoggedUser().addToDiscovered(AppController.getOpeningByKeyword(opName));
	}


	// ****** WORDLE API ******

	@GetMapping(value = "/startGame", produces = "application/json")
	public void startGame() {
		WordleController.startGame();
	}

	@GetMapping(value = "/getWords", produces = "application/json")
	public List<String> getWords() {
		return WordleController.getWordsList();
	}

	@GetMapping(value = "/getCurrentWord", produces = "application/json")
	public String getCurrentWord() {
		return WordleController.getCurrentWord();
	}

	@GetMapping(value = "/checkLetters", produces = "application/json")
	public List<Integer> checkLetters(@RequestParam String s) {
		return WordleController.checkLetters(s);
	}

	@GetMapping(value = "/checkEnd", produces = "application/json")
	public boolean checkEnd(@RequestParam String s) {
		return WordleController.checkEnd(s);
	}
}
