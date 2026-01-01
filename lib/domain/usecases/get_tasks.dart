import '../entities/task.dart';
import '../repositories/task_repo.dart';

class GetTasks {
  final TaskRepository repository;
  GetTasks(this.repository);

  Future<List<Task>> call() {
    return repository.getTasks();
  }
}
