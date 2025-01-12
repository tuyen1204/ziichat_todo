import 'dart:math';

import 'package:flutter/foundation.dart';

enum ItemStatus { todo, inprogress, pending, done }

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

  static void onCreateTodoItem(String formatDate, String nameTodo) async {
    try {
      var random = Random();
      final idTodoRandom = 'todo-${random.nextInt(100)}';
      final newTodoItemData = TodoItemData(
          idTodo: idTodoRandom,
          title: nameTodo,
          createdTime: formatDate,
          category: "Work");
      dataFolder.add(newTodoItemData);
      print("success");
    } catch (error) {
      print(error);
    }
  }
}

List<TodoItemData> dataFolder = [
  TodoItemData(
    idTodo: "todo-4",
    title: "Todo 4",
    category: "All",
    categorySlug: "all",
    createdTime: "10:00",
    isDefault: true,
  ),
  TodoItemData(
    idTodo: "todo-1",
    title: "Todo 1",
    category: "Work",
    categorySlug: "work",
    createdTime: "10:00",
  ),
  TodoItemData(
    idTodo: "todo-2",
    title: "Todo 2",
    category: "Music",
    categorySlug: "music",
    createdTime: "13:00",
  ),
  TodoItemData(
    idTodo: "todo-3",
    title: "Todo 3",
    category: "Music",
    categorySlug: "music",
    createdTime: "11:00",
  ),
];
