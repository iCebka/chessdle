import 'package:flutter/material.dart';
import 'package:flutter_frontend/wordle/letter.dart';

const _teclas = [
    ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
    ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
    ['ENTER', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'DEL']
];

class Keyboard extends StatelessWidget {
    const Keyboard({
        Key? key,
        required this.onTecla,
        required this.onDelete,
        required this.onEnter,
        required this.letters
    }) : super(key: key);

    final void Function(String) onTecla;

    final VoidCallback onDelete;
    final VoidCallback onEnter;
    
    final Set<Letter> letters;

    @override
    Widget build(BuildContext context) {
        return Column(
            children: _teclas
            .map(
                (keyRow) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: keyRow.map(
                        (letter) {
                            if (letter == 'DEL') {
                                return _KeyBoardButton.delete(onTap: onDelete);
                            } else if (letter == 'ENTER') {
                                return _KeyBoardButton.enter(onTap: onEnter);
                            } 
                            final letterKey = letters.firstWhere(
                                (e) => e.val == letter,
                                orElse: () => Letter.empty()
                            );

                            return _KeyBoardButton(
                                onTap: () => onTecla(letter),
                                letter: letter,
                                backgroundColor: letterKey != List.empty() 
                                    ? letterKey.backgroundColor 
                                    : Colors.grey
                            );
                        },
                    ).toList(),
                ),
            )
            .toList()
        );
    }
}

class _KeyBoardButton extends StatelessWidget {
    const _KeyBoardButton({
        Key? key,
        this.height = 48,
        this.width= 30,
        required this.onTap,
        required this.backgroundColor,
        required this.letter,
    }) : super(key: key);

    factory _KeyBoardButton.delete({
        required VoidCallback onTap
    }) =>
        _KeyBoardButton(
            width: 56,
            onTap: onTap,
            backgroundColor: Color.fromARGB(255, 184, 237, 255),
            letter: 'DEL'
        );

    factory _KeyBoardButton.enter({
        required VoidCallback onTap
    }) =>
        _KeyBoardButton(
            width: 56,
            onTap: onTap,
            backgroundColor: Color.fromARGB(255, 184, 237, 255),
            letter: 'ENTER'
        );

    final double height;
    final double width;

    final VoidCallback onTap;

    final Color backgroundColor;

    final String letter;
    


    @override
    Widget build(BuildContext context) {
        return Padding(
            padding: const EdgeInsets.symmetric(
                vertical: 3.0,
                horizontal: 2.0
            ),
            child: Material(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(4),
                child: InkWell(
                    onTap: onTap,
                    child: Container(
                        height: height,
                        width: width,
                        alignment: Alignment.center,
                        child: Text(
                            letter,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}