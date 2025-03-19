import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../src/core/utils/icon_provider.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      textAlign: TextAlign.center,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.white.withOpacity(0.54)],
        ),
      ),
    );
  }
}
