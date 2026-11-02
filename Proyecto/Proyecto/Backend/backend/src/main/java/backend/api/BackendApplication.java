package backend.api;

import java.io.IOException;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import backend.app.src.AppController;
import backend.app.src.WordleController;

@SpringBootApplication
public class BackendApplication {

	public static void main(String[] args) throws IOException {
		AppController.loadUsers(); // loads all the users from the database at the start of the app
		AppController.loadOpenings(); // loads all the openigns from the database at the start of the app
		WordleController.loadWords(); // loads all the words for the wordle game at the start of the app
		SpringApplication.run(BackendApplication.class, args); // starts the application
	}

}
