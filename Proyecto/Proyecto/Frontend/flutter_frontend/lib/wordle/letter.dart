import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

enum LetterStatus { initial, notInWord, inWord, correct}

class Letter extends Equatable {
    const Letter({
        required this.val,
        this.status = LetterStatus.initial,
    });

    static const Color correctColor = Color(0xFF538D4E);
    static const Color inWordColor = Color (0xFFB49F3A);
    static const Color notInWordColor = Color(0xFF3A3A3C);

    factory Letter.empty() => const Letter(val: '');

    final String val;
    final LetterStatus status;

    Color get backgroundColor {
        switch (status) {
            case LetterStatus.initial:
                return Colors.transparent;
            case LetterStatus.notInWord:
                return notInWordColor;
            case LetterStatus.inWord:
                return inWordColor;
            case LetterStatus.correct:
                return correctColor;
        }
    }

    Color get borderColor {
        switch (status) {
            case LetterStatus.initial:
                return Colors.grey;
            default:
                return Colors.transparent;
        }
    }

    Letter copyWith({
        String? val,
        LetterStatus? status
    }) {
        return Letter(
            val: val ?? this.val,
            status: status ?? this.status
        );
    }

    @override
    List<Object> get props => [val];
}