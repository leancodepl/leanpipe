import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_pipe_example/data/contracts.dart';
import 'package:leancode_pipe_example/projects_screen/bloc/projects_cubit.dart';

class ProjectsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProjectsCubit, List<ProjectDTO>>(
        builder: (context, projects) {
          return SafeArea(
            child: Column(
              children: [
                Text('List of projects'),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount: projects.length,
                    itemBuilder: (context, index) => ListTile(
                      tileColor: Colors.grey,
                      title: Text(projects[index].name),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
