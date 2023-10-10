import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart';
import 'package:leancode_contracts/leancode_contracts.dart';
import 'package:leancode_pipe/leancode_pipe.dart';
import 'package:leancode_pipe_example/projects_screen/bloc/projects_cubit.dart';
import 'package:leancode_pipe_example/projects_screen/projects_screen.dart';
import 'package:provider/provider.dart';

class App extends HookWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          Provider(
            create: (context) => Cqrs(
              Client(),
              Uri.parse('https://exampleapp.test.lncd.pl/api/'),
            ),
          ),
          Provider(
            create: (context) => PipeClient(
              pipeUrl: 'https://exampleapp.test.lncd.pl/leanpipe',
              tokenFactory: () async => 'token',
            ),
          ),
        ],
        child: BlocProvider(
          create: (context) =>
              ProjectsCubit(cqrs: context.read())..fetchProjects(),
          lazy: false,
          child: HomeScreen(),
        ),
      ),
    );
  }
}

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ProjectsScreen();
  }
}
