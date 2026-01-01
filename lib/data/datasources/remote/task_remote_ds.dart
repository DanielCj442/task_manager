import 'package:dio/dio.dart';

import '../../models/task_model.dart';

class TaskRemoteDataSource {
  final Dio dio;

  TaskRemoteDataSource(this.dio);

  Future<List<TaskModel>> getTasks() async {
    final response = await dio.get('/tasks');
    return (response.data as List)
        .map((e) => TaskModel.fromJson(e))
        .toList();
  }

  Future<TaskModel> createTask(String title) async {
    final response = await dio.post('/tasks', data: {'title': title});
    return TaskModel.fromJson(response.data);
  }

  Future<TaskModel> toggleTask(String id) async {
    final response = await dio.patch('/tasks/$id/toggle');
    return TaskModel.fromJson(response.data);
  }
}
