import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ziichat_todo/data/folder_data.dart';

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

  static void onCreateTodoItem(String formatDate, String nameTodo,
      String categoryTodo, String noteTodo) async {
    try {
      var random = Random();
      final idTodoRandom = 'todo-${random.nextInt(100)}';
      final newTodoItemData = TodoItemData(
          idTodo: idTodoRandom,
          title: nameTodo,
          createdTime: formatDate,
          category: categoryTodo,
          note: noteTodo);
      dataFolder.add(newTodoItemData);
      print("success");
    } catch (error) {
      print(error);
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
