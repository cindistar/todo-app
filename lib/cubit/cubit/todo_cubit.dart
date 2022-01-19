import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/database_service.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final DatabaseService dataService;

  TodoCubit(this.dataService) : super(TodoLoaded(todos: const[]));

  Future<List> getTodos() async {
    try {
      emit(TodoLoaded(todos: const[]));
      return await dataService.getAllTodos();
    } catch (e) {
      emit(TodoError('$e'));
      throw Exception;
    }
  }

  Future insertTodo(Todo todo) async {
    await dataService.insert(todo);
    getTodos();
  }

  Future updateTodo(Todo todo) async {
    await dataService.update(todo);
    getTodos();
  }

  Future deleteTodo(int id) async {
    await dataService.delete(id);
  }
}
