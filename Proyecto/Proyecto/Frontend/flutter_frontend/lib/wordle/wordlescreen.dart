
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/gui/loginpage.dart';
import 'package:flutter_frontend/gui/myapp.dart';
import 'package:flutter_frontend/wordle/teclado.dart';
import 'package:flutter_frontend/wordle/letter.dart';
import 'package:flutter_frontend/wordle/word.dart';
import 'package:flutter_frontend/wordle/wordle_board.dart';
import '../gui/main.dart';
import '../gui/myhomepage.dart';
import '../gui/discoverpage.dart';

enum GameStage { jugando, probando, perdido, ganado }

class WordleScreen extends StatefulWidget {
  const WordleScreen({Key? key, required this.word}) : super(key: key);

  final String word;

  @override
  _WordleScreenState createState() => _WordleScreenState();
}

class _WordleScreenState extends State<WordleScreen> {
  GameStage _gameStatus = GameStage.jugando;

  static const Color correctColor = Color.fromARGB(255, 3, 166, 221);

  late Word _solution;



  @override
  void initState() {
    super.initState();
    _solution = Word.fromString(widget.word);
  }

  final List<Word> _board = List.generate(
      6, (_) => Word(letters: List.generate(5, (_) => Letter.empty())));

  final List<List<GlobalKey<FlipCardState>>> _flipCardKeys = List.generate(
      6, (_) => List.generate(5, (_) => GlobalKey<FlipCardState>()));

  int _currentWordIndex = 0;

  Word? get _currentWord =>
      _currentWordIndex < _board.length ? _board[_currentWordIndex] : null;

  final Set<Letter> _keyboardLetters = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyHomePage())),
              }
            ),
            title: const Text(
              'CHESSDLE',
              style: TextStyle(
                  fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 4),
            )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Board(board: _board, flipCardKeys: _flipCardKeys),
            const SizedBox(height: 20),
            Keyboard(
                onTecla: _onTecla,
                onEnter: _onEnter,
                onDelete: _onDelete,
                letters: _keyboardLetters),
          ],
        ));
  }

  void _onTecla(String val) {
    if (_gameStatus == GameStage.jugando) {
      setState(() {
        _currentWord?.addLetter(val);
      });
    }
  }

  void _onDelete() {
    if (_gameStatus == GameStage.jugando) {
      setState(() {
        _currentWord?.removeLetter();
      });
    }
  }

  Future<void> _onEnter() async {
    if (_gameStatus == GameStage.jugando &&
        _currentWord != null &&
        !_currentWord!.letters.contains(Letter.empty())) {
      _gameStatus = GameStage.probando;

      for (var i = 0; i < _currentWord!.letters.length; i++) {
        final currentWordLetter = _currentWord!.letters[i];
        final currentSolutionLetter = _solution.letters[i];

        setState(() {
          if (currentWordLetter == currentSolutionLetter) {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.correct);
          } else if (_solution.letters.contains(currentWordLetter)) {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.inWord);
          } else {
            _currentWord!.letters[i] =
                currentWordLetter.copyWith(status: LetterStatus.notInWord);
          }
        });

        final letter = _keyboardLetters.firstWhere(
            (e) => e.val == currentWordLetter.val,
            orElse: () => Letter.empty());
        if (letter.status != LetterStatus.correct) {
          _keyboardLetters.removeWhere((e) => e.val == currentWordLetter.val);
          _keyboardLetters.add(_currentWord!.letters[i]);
        }

        await Future.delayed(
          const Duration(milliseconds: 150),
          () => _flipCardKeys[_currentWordIndex][i].currentState?.toggleCard(),
        );
      }
      _checkIfWinOrLoss();
    }
  }

  void _checkIfWinOrLoss() {
    if (_currentWord!.wordString == _solution.wordString) {
      _gameStatus = GameStage.ganado;
      //RestClient.discoverOpening(widget.word);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: correctColor,
          content:
              const Text('New Chess Opening Discovered!', style: TextStyle(color: Colors.white)),
          action: SnackBarAction(
              onPressed: () => { 
                if(MyApp.getUsername() == 'username')	{
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage(),)),
                } else {
                  RestClient.discoverOpening(widget.word),
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DiscoverPage(),)), 
                  }
              },
              textColor: Colors.white, label: 'Check it Out'),
        ),
      );
    } else if (_currentWordIndex + 1 >= _board.length) {
      _gameStatus = GameStage.perdido;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.none,
          duration: const Duration(days: 1),
          backgroundColor: Color.fromARGB(255, 203, 5, 5),
          content: const Text('You lost! Good luck next time!',
              style: TextStyle(color: Colors.white)),
          action: SnackBarAction(
              onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyHomePage(),)),
              textColor: Colors.white, label: 'Try Again'),
        ),
      );
    } else {
      _gameStatus = GameStage.jugando;
    }
    _currentWordIndex += 1;
  }
}
