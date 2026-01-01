import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/data/repositories_impl/task_repo_impl.dart';
import 'package:task_manager/domain/usecases/logout.dart';

import 'data/datasources/local/auth_local_ds.dart';
import 'data/datasources/remote/auth_remote_ds.dart';
import 'data/datasources/remote/task_remote_ds.dart';
import 'data/network/auth_interceptor.dart';
import 'data/repositories_impl/auth_repo_impl.dart';
import 'domain/usecases/create_task.dart';
import 'domain/usecases/get_current_user.dart';
import 'domain/usecases/get_tasks.dart';
import 'domain/usecases/login.dart';
import 'domain/usecases/toggle_task.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/auth/auth_event.dart';
import 'presentation/blocs/auth/auth_state.dart';
import 'presentation/blocs/tasks/task_bloc.dart';
import 'presentation/blocs/tasks/task_event.dart';
import 'presentation/views/login_view.dart';
import 'presentation/views/task_list_view.dart';

late final AuthBloc authBloc;

void main() {
  final dio = Dio(
    BaseOptions(baseUrl: 'http://localhost:3000'),
  );

  final authLocal = AuthLocalDataSource();

  dio.interceptors.add(
    AuthInterceptor(
      local: authLocal,
      onUnauthorized: () {
        authBloc.add(LogoutRequested());
      },
    ),
  );

  
  final authRepository = AuthRepositoryImpl(
    AuthRemoteDataSource(dio),
    authLocal,
  );

  authBloc = AuthBloc(
    Login(authRepository),
    GetCurrentUser(authRepository),
    Logout(authRepository),
  )..add(CheckAuthStatus());

  
  final taskRepository = TaskRepositoryImpl(TaskRemoteDataSource(dio));

  runApp(
    BlocProvider.value(
      value: authBloc,
      child: MyApp(taskRepository: taskRepository,),
    ),
  );
}

class MyApp extends StatelessWidget {
  final TaskRepositoryImpl taskRepository;
  const MyApp({super.key, required this.taskRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return BlocProvider(
              create: (_) => TaskBloc(
                GetTasks(taskRepository),
                CreateTask(taskRepository),
                ToggleTask(taskRepository),
              )..add(LoadTasks()),
              child: const TaskListView(),
            );
          }

          if (state is AuthUnauthenticated || state is AuthInitial) {
            return const LoginView();
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
