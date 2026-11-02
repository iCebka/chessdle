import 'package:flutter/material.dart';
import 'package:flutter_frontend/wordle/letter.dart';


class BoardSquare extends StatelessWidget {
    const BoardSquare({
        Key? key,
        required this.letter,
    }) : super(key: key);

    final Letter letter;

    @override
    Widget build(BuildContext context) {
        return Container(
            margin: const EdgeInsets.all(4),
            height: 60,
            width: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: letter.backgroundColor,
                border: Border.all(color: letter.borderColor),
                borderRadius: BorderRadius.circular(4)
            ),
            child: Text(
                letter.val,
                style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold
                ),
            )
        );
    }
}