import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziichat_todo/data/folder_data.dart';
import 'dart:convert';

enum ItemStatus { todo, progressing, pending, done, all }

class TodoItemData {
  final String idTodo;
  final String title;
  final int task;
  final String category;
  final bool isDefault;
  final String createdTime;
  final String editedTime;
  final String categorySlug;
  final ItemStatus status;
  final String note;

  const TodoItemData({
    required this.idTodo,
    required this.title,
    this.category = 'All',
    this.createdTime = '',
    this.editedTime = '',
    this.task = 0,
    this.status = ItemStatus.todo,
    this.note = '',
    this.isDefault = false,
    this.categorySlug = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'idTodo': idTodo,
      'title': title,
      'category': category,
      'createdTime': createdTime,
      'status': status.toString(),
      'note': note,
    };
  }

  factory TodoItemData.fromJson(Map<String, dynamic> json) {
    return TodoItemData(
      idTodo: json['idTodo'],
      title: json['title'],
      category: json['category'],
      status:
          ItemStatus.values.firstWhere((e) => e.toString() == json['status']),
      createdTime: json['createdTime'],
      editedTime: json['editedTime'],
    );
  }

  static Future<void> saveTodoItem(TodoItemData newTodoItem) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> todoList = prefs.getStringList('todoItems') ?? [];
    todoList.add(jsonEncode(newTodoItem.toJson()));
    await prefs.setStringList('todoItems', todoList);
    print(todoList.length);
    print(todoList.join('\n'));
  }

  static Future<List<TodoItemData>> loadTodoItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList('todoItems');

    if (jsonList != null) {
      return jsonList
          .map((jsonString) => TodoItemData.fromJson(json.decode(jsonString)))
          .toList();
    } else {
      return [];
    }
  }

  static Future<void> onCreateTodoItem(String formatDate, String nameTodo,
      String categoryTodo, String noteTodo) async {
    try {
      var random = Random();
      final idTodoRandom = 'todo-${random.nextInt(100)}';
      final newTodoItemData = TodoItemData(
        idTodo: idTodoRandom,
        title: nameTodo,
        createdTime: formatDate,
        category: categoryTodo,
        note: noteTodo,
      );
      dataFolder.add(newTodoItemData);
      await saveTodoItem(newTodoItemData);

      print("Todo item created successfully.");
    } catch (error) {
      print("Error creating todo item: $error");
    }
  }

  static void onDeleteTodoItem(String idTodo) async {
    try {
      final todoItemIndex =
          dataFolder.indexWhere((item) => item.idTodo == idTodo);
      if (todoItemIndex != -1) {
        dataFolder.removeAt(todoItemIndex);
        print("Deleted id: $idTodo");
      }
    } catch (error) {
      print("Error");
    }
  }
}

String statusToReadableString(ItemStatus status) {
  switch (status) {
    case ItemStatus.all:
      return 'All';
    case ItemStatus.todo:
      return 'To Do';
    case ItemStatus.progressing:
      return 'In Progress';
    case ItemStatus.pending:
      return 'Pending';
    case ItemStatus.done:
      return 'Done';
  }
}

String capitalizeEachWord(String text) {
  return text.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1);
  }).join(' ');
}

Color statusColor(ItemStatus status) {
  switch (status) {
    case ItemStatus.all:
      return Colors.black;
    case ItemStatus.todo:
      return Colors.blue;
    case ItemStatus.progressing:
      return Colors.orange;
    case ItemStatus.pending:
      return Colors.grey;
    case ItemStatus.done:
      return Colors.green;
  }
}
