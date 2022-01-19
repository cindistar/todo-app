import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit/todo_cubit.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/screens/add_todo_list_screen.dart';
import 'package:todo_app/widgets/todo_tile.dart';
import 'package:todo_app/widgets/todos_overview.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _getTodos();
  }

  Future<void> _getTodos() async {
    final todos = await BlocProvider.of<TodoCubit>(context).getTodos();
    if (mounted) {
      setState(() => _todos = todos as List<Todo>);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          itemCount: 1 + _todos.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) return TodosOverview(todos: _todos);
            final todo = _todos[index - 1];
            return BlocBuilder<TodoCubit, TodoState>(
              builder: (context, state) {
                if (state is TodoLoaded) {
                  return TodoTile(
                    updateTodos: _getTodos,
                    todo: todo,
                  );
                } else if (state is TodoError) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                return const CircularProgressIndicator();
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => AddTodoScreen(updateTodos: _getTodos),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}