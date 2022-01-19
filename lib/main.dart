import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/cubit/cubit/todo_cubit.dart';
import 'package:todo_app/screens/todo_list_screen.dart';
import 'package:todo_app/services/database_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
     
        create: (context) => TodoCubit(DatabaseService.instance),
      
      child: MaterialApp(
        title: 'Flutter SQFLite Todos',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.red),
        home: const TodoListScreen(),
      ),
    );
  }
}
