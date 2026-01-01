import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/tasks/task_bloc.dart';
import '../blocs/tasks/task_event.dart';
import '../blocs/tasks/task_state.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Task'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Task title',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context
                  .read<TaskBloc>()
                  .add(AddTask(controller.text));
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutRequested());
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return const Center(child: Text('No tasks yet'));
            }

            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (_, index) {
                final task = state.tasks[index];
                return ListTile(
                  title: Text(
                    task.title,
                    style: TextStyle(
                      decoration: task.completed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  trailing: Checkbox(
                    value: task.completed,
                    onChanged: (_) {
                      context
                          .read<TaskBloc>()
                          .add(ToggleTaskRequested(task.id));
                    },
                  ),
                );
              },
            );
          }

          if (state is TaskError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
