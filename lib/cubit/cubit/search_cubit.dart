import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/services/database_service.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  DatabaseService dataService;
  String query;

  SearchCubit(this.dataService, {required this.query}) : super(SearchLoading());

  SearchState get initialState => SearchLoading();

  Future<List<Todo>> searchTodos(String query) async {
    try {
      List<Todo> todos = await dataService.getAllTodos();
      emit(SearchLoaded(todos: todos));
      return todos;
    } catch (e) {
      emit(SearchError('$e'));
      throw Exception('Error ocurred');
    }
  }
}
