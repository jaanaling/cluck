import 'package:cluckmazing_recipe/src/core/utils/app_icon.dart';
import 'package:cluckmazing_recipe/src/core/utils/icon_provider.dart';
import 'package:cluckmazing_recipe/src/core/utils/size_utils.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBarWidget extends StatelessWidget {
  final Widget widgets;
  final bool hasBackButton;

  const AppBarWidget({
    super.key,
    required this.widgets,
    this.hasBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFF9633FF), Color(0xFF6B08E0)],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 0,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: SizedBox(
        width: getWidth(context, percent: 1),
        child: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: MediaQuery.of(context).padding.top +10,
            bottom: 12
          ),
          child: Row(
            children: [
              if (hasBackButton)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32),
                      onTap: () {
                        context.pop();
                      },
                      child: AppIcon(
                        asset: IconProvider.arrow.buildImageUrl(),
                        width: 50,
                        height: 43,
                      ),
                    ),
                  ),
                ),
              widgets,
            ],
          ),
        ),
      ),
    );
  }
}
