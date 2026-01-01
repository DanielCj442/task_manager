import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final String title;

  AddTask(this.title);

  @override
  List<Object?> get props => [title];
}

class ToggleTaskRequested extends TaskEvent {
  final String taskId;

  ToggleTaskRequested(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
