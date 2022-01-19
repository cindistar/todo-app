import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/cubit/cubit/todo_cubit.dart';
import 'package:todo_app/extensions.dart/string_extension.dart';
import 'package:todo_app/models/todo_model.dart';

class AddTodoScreen extends StatefulWidget {
  final VoidCallback updateTodos;
  final Todo? todo;

   const AddTodoScreen({Key? key, 
    required this.updateTodos,
    this.todo,
  }) : super(key: key);

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _descriptionController;

  Todo? _todo;

  TodoCubit? bloc;

  bool get _isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      _todo = widget.todo;
    } else {
      _todo = Todo.empty();
    }

    _nameController = TextEditingController(text: _todo!.name);
    _dateController =
        TextEditingController(text: DateFormat.MMMMEEEEd().format(_todo!.date));
    _descriptionController = TextEditingController(text: _todo!.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!_isEditing ? 'Add Todo' : 'Update Todo',),
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 40.0,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (name) =>
                          name!.trim().isEmpty ? 'Please enter a name' : null,
                      onSaved: (name) => _todo = _todo!.copyWith(name: name),
                    ),
                    const SizedBox(height: 32.0),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(labelText: 'Date'),
                      onTap: _handleDatePicker,
                    ),
                    const SizedBox(height: 32.0),
                    DropdownButtonFormField<PriorityLevel>(
                      value: _todo!.priorityLevel,
                      icon: const Icon(Icons.arrow_drop_down_circle),
                      iconSize: 30,
                      iconEnabledColor: Theme.of(context).primaryColor,
                      items: PriorityLevel.values
                          .map((priorityLevel) => DropdownMenuItem(
                                value: priorityLevel,
                                child: Text(
                                  EnumToString.convertToString(priorityLevel)
                                      .capitalize(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ))
                          .toList(),
                      style: const TextStyle(
                        fontSize: 50,
                      ),
                      decoration: const InputDecoration(
                        label: Text(
                          'Priority Level',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      onChanged: (priorityLevel) => setState(() => _todo =
                          _todo!.copyWith(priorityLevel: priorityLevel)),
                    ),
                    TextFormField(
                      maxLines: 5,
                      controller: _descriptionController,
                      style: const TextStyle(fontSize: 20),
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (description) => description!.trim().isEmpty
                          ? 'Please write a description'
                          : null,
                      onSaved: (description) =>
                          _todo = _todo!.copyWith(description: description),
                    ),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        primary: !_isEditing ? Colors.green : Colors.orange,
                        minimumSize: const Size.fromHeight(45.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        !_isEditing ? 'Add' : 'Save',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    if (_isEditing)
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<TodoCubit>(context)
                              .deleteTodo(_todo!.id!);
                          widget.updateTodos();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(45.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _handleDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _todo!.date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      _dateController.text = DateFormat.MMMMEEEEd().format(date);
      setState(() => _todo = _todo!.copyWith(date: date));
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (!_isEditing) {
        BlocProvider.of<TodoCubit>(context).insertTodo(_todo!);
      } else {
        BlocProvider.of<TodoCubit>(context).updateTodo(_todo!);
      }
      widget.updateTodos();
      Navigator.of(context).pop();
    }
  }
}