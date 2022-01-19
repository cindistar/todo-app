import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubit/cubit/todo_cubit.dart';
import 'package:todo_app/extensions.dart/string_extension.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/screens/add_todo_list_screen.dart';

class TodoTile extends StatelessWidget {
  final VoidCallback updateTodos;
  final Todo todo;

    const TodoTile({Key? key, 
    required this.updateTodos,
    required this.todo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final completedTextDecoration =
        !todo.completed ? TextDecoration.none : TextDecoration.lineThrough;
    return ListTile(
      key: Key(todo.id.toString()),
      title: Text(
        todo.name,
        style: TextStyle(
          fontSize: 19,
          color: Colors.black,
          fontWeight: FontWeight.w500,
          decoration: completedTextDecoration,
        ),
      ),
      subtitle: Row(
        children: [
          Text(
            '${DateFormat.MMMMEEEEd().format(todo.date)} • ',
            style: TextStyle(
              fontSize: 18,
              height: 1.3,
              decoration: completedTextDecoration,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 2.5,
              horizontal: 8.0,
            ),
            decoration: BoxDecoration(
              color: _getColor(),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(5, 7),
                  blurRadius: 4.0,
                ),
              ],
            ),
            child: Text(
              EnumToString.convertToString(todo.priorityLevel).capitalize(),
              style: TextStyle(
                color: !todo.completed ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                decoration: completedTextDecoration,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      trailing: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          return Checkbox(
            value: todo.completed,
            activeColor: _getColor(),
            onChanged: (value) {
              BlocProvider.of<TodoCubit>(context)
                  .updateTodo(todo.copyWith(completed: value));
              updateTodos();
            },
          );
        },
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => AddTodoScreen(
            updateTodos: updateTodos,
            todo: todo,
          ),
        ),
      ),
    );
  }

  Color _getColor() {
    switch (todo.priorityLevel) {
      case PriorityLevel.low:
        return Colors.green;
      case PriorityLevel.medium:
        return Colors.orange[600]!;
      case PriorityLevel.high:
        return Colors.red[400]!;
    }
  }
}