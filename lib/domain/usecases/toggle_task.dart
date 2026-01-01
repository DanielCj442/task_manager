import '../entities/task.dart';
import '../repositories/task_repo.dart';

class ToggleTask {
  final TaskRepository repository;
  ToggleTask(this.repository);

  Future<Task> call(String id) {
    return repository.toggleTask(id);
  }
}