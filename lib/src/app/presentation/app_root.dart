import 'package:cluckmazing_recipe/src/main/bloc/app_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../../../routes/go_router_config.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc()..add(LoadDataEvent()),
      child: CupertinoApp.router(
        theme: const CupertinoThemeData(
          brightness: Brightness.light,

          textTheme: CupertinoTextThemeData(
            textStyle: TextStyle(
              color: Color(0xFF4B0000),
              fontSize: 17,
              fontFamily: 'mexe',
            ),
          ),
        ),
        color: Color(0xFF4B0000),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: buildGoRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
