import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  final double textSize;
  final Color textColor;
  final FontWeight textWeight;
  final TextAlign textAlign;

  const TitleText(
      {Key? key,
      required this.text,
      required this.textSize,
      required this.textColor,
      required this.textWeight,
      required this.textAlign})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      animatedTexts: [
        TypewriterAnimatedText(
          text,
          textStyle: TextStyle(
            fontFamily: 'Agne',
            fontSize: textSize,
            color: textColor,
            fontWeight: textWeight,
          ),
          textAlign: textAlign,
          speed: const Duration(milliseconds: 300),
        ),
      ],
      totalRepeatCount: 1,
    );
  }
}
