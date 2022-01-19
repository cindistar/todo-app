import 'package:enum_to_string/enum_to_string.dart';

enum PriorityLevel { low, medium, high }

class Todo {
  final int? id;
  final String name;
  final DateTime date;
  final PriorityLevel priorityLevel;
  final bool completed;
  final String description;

  Todo({
    this.id,
    required this.name,
    required this.date,
    required this.priorityLevel,
    required this.completed,
    required this.description,
  });

  Todo.empty(
      {this.id,
      this.name = '',
      this.completed = false,
      this.description = '',
      this.priorityLevel = PriorityLevel.low, 
      date
      })
      // ignore: unnecessary_this, prefer_if_null_operators
      : this.date = ( date != null ? date : DateTime.now());

  Todo copyWith({
    int? id,
    String? name,
    DateTime? date,
    PriorityLevel? priorityLevel,
    bool? completed,
    String? description,
  }) {
    return Todo(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      priorityLevel: priorityLevel ?? this.priorityLevel,
      completed: completed ?? this.completed,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'priority_level': EnumToString.convertToString(priorityLevel),
      'completed': completed ? 1 : 0,
      'description': description,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int,
      name: map['name'] as String,
      date: DateTime.parse(map['date'] as String),
      priorityLevel: EnumToString.fromString(
        PriorityLevel.values,
        map['priority_level'] as String,
      )!,
      completed: map['completed'] as int == 1,
      description: map['description'] as String,
    );
  }
}