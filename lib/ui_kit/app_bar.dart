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
      decoration: BoxDecoration(
        color: Color(0xFF97c480),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
              color: Colors.black26.withOpacity(0.08), offset: Offset(0, 4), blurRadius: 8.0)
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          top: MediaQuery.of(context).padding.top + 10,
          bottom: 12,
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
                      asset: IconProvider.back.buildImageUrl(),
                      width: 52,
                      height: 52,
                    ),
                  ),
                ),
              ),
            widgets,
          ],
        ),
      ),
    );
  }
}
