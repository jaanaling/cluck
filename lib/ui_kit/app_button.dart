import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final ButtonColors color;
  final VoidCallback? onPressed;
  final Widget child;
  final Size? fixedSize;
  final List<Color>? gradientColors;
  final double elevation;
  final double? borderRadius;
  const AppButton({
    super.key,
    required this.color,
    this.onPressed,
    required this.child,
    this.fixedSize,
    this.gradientColors,
    this.elevation = 0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return gradientColors == null
        ? DecoratedBox(
          decoration: BoxDecoration(
            boxShadow:
                elevation != 0
                    ? [
                      BoxShadow(
                        color: Colors.black26.withOpacity(0.1),
                        offset: Offset(0, 4),
                        blurRadius: 2.0,
                      ),
                    ]
                    : null,
            borderRadius: BorderRadius.circular(borderRadius ?? 32),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color.color,
              elevation: 0,
              padding: EdgeInsets.zero,
              fixedSize: fixedSize,
              disabledBackgroundColor: color.color,
              textStyle: TextStyle(fontFamily: 'mexe'),
              overlayColor: Color(0xFF4B0000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 32),
              ),
            ),
            onPressed: onPressed,
            child: child,
          ),
        )
        : Container(
          width: fixedSize?.width,
          height: fixedSize?.height,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26.withOpacity(0.1),
                offset: Offset(0, 4),
                blurRadius: 2.0,
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors!,
            ),
            borderRadius: BorderRadius.circular(borderRadius ?? 32),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              padding: EdgeInsets.zero,
              fixedSize: fixedSize,
              textStyle: TextStyle(fontFamily: 'mexe'),
              overlayColor: Color(0xFF4B0000),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius ?? 32),
              ),
            ),
            onPressed: onPressed,
            child: child,
          ),
        );
  }
}

enum ButtonColors {
  yellow(color: Color(0xFFFDC662)),
  white(color: Color(0xFFFFFFFF)),
  red(color: Color(0xFFCD4646));

  final Color color;

  const ButtonColors({required this.color});
}
