import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final bool isCenter;
  const GradientText(
    this.text, {
    required this.fontSize,
    this.isCenter = false,
    super.key,
    this.gradientColors,
  });

  final String text;
  final double fontSize;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: gradientColors ??
          [
            Color(0xFFFFE102),
            Color(0xFFFCA400),
          ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Stack(
      children: [
        Text(
          text,
          textAlign: isCenter ? TextAlign.center : null,
          style: TextStyle(
            fontSize: fontSize,
            shadows: [
              Shadow(
                offset: Offset(0, -2), // Смещение тени
                color: Color(0xFFFE7D00), // Цвет тени с прозрачностью
                blurRadius: 0,
              ),
            ],
            fontWeight: FontWeight.w400,
            fontFamily: 'Font',
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 5
              ..color = Color(0xFFCF6100),
          ),
        ),
        Text(
          text,
          textAlign: isCenter ? TextAlign.center : null,
          style: TextStyle(
            color: Colors.transparent,
            fontSize: fontSize,
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0), // Смещение тени
                color: Color(0x0), // Цвет тени с прозрачностью
                blurRadius: 4,
              ),
            ],
            fontFamily: 'Font',
          ),
        ),
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => gradient.createShader(
            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
          ),
          child: Text(
            text,
            textAlign: isCenter ? TextAlign.center : null,
            style: TextStyle(
              fontSize: fontSize,
              shadows: [
                Shadow(
                  offset: Offset(2.0, 2.0), // Смещение тени
                  color: Color(0x0), // Цвет тени с прозрачностью
                  blurRadius: 4,
                ),
              ],
              fontFamily: 'Font',
            ),
          ),
        ),
      ],
    );
  }
}

