import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repo.dart';
import '../datasources/remote/task_remote_ds.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remote;

  TaskRepositoryImpl(this.remote);

  @override
  Future<List<Task>> getTasks() => remote.getTasks();

  @override
  Future<Task> createTask(String title) => remote.createTask(title);

  @override
  Future<Task> toggleTask(String id) => remote.toggleTask(id);
}
