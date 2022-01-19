part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Todo> todos;

  SearchLoaded({required this.todos});
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}