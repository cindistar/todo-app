part of 'todo_cubit.dart';

@immutable
abstract class TodoState {}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {
 TodoLoading();
}

class TodoLoaded extends TodoState {
  final List<Todo> todos;

   TodoLoaded({required this.todos});
}

class TodoError extends TodoState {
  final String message;

  TodoError(this.message);
}