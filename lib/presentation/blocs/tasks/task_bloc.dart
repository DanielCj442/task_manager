import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_tasks.dart';
import '../../../domain/usecases/create_task.dart';
import '../../../domain/usecases/toggle_task.dart';

import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetTasks getTasks;
  final CreateTask createTask;
  final ToggleTask toggleTask;

  TaskBloc(
    this.getTasks,
    this.createTask,
    this.toggleTask,
  ) : super(TaskInitial()) {
    
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<ToggleTaskRequested>(_onToggleTask);
  }

  Future<void> _onLoadTasks(
    LoadTasks event,
    Emitter<TaskState> emit,
  ) async {
    emit(TaskLoading());
    try {
      final tasks = await getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onAddTask(
    AddTask event,
    Emitter<TaskState> emit,
  ) async {
    if (state is! TaskLoaded) return;

    final currentTasks = List.of((state as TaskLoaded).tasks);

    try {
      final newTask = await createTask(event.title);
      currentTasks.add(newTask);
      emit(TaskLoaded(currentTasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleTask(
    ToggleTaskRequested event,
    Emitter<TaskState> emit,
  ) async {
    if (state is! TaskLoaded) return;

    final currentTasks = List.of((state as TaskLoaded).tasks);

    try {
      final updatedTask = await toggleTask(event.taskId);
      final index =
          currentTasks.indexWhere((t) => t.id == updatedTask.id);
      currentTasks[index] = updatedTask;
      emit(TaskLoaded(currentTasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
