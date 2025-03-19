import 'package:cluckmazing_recipe/src/main/bloc/app_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      builder: (context, state) {
        if (state is! AppLoaded) {
          return const Center(child: CupertinoActivityIndicator());
        }

        return const Placeholder();
      },
    );
  }
}
