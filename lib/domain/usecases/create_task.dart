import '../entities/task.dart';
import '../repositories/task_repo.dart';

class CreateTask {
  final TaskRepository repository;
  CreateTask(this.repository);

  Future<Task> call(String title) {
    return repository.createTask(title);
  }
}
