import 'dart:math';
import 'package:ziichat_todo/data/folder_data.dart';

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

  static void onCreateTodoItem(
      String formatDate, String nameTodo, String categoryTodo) async {
    try {
      var random = Random();
      final idTodoRandom = 'todo-${random.nextInt(100)}';
      final newTodoItemData = TodoItemData(
          idTodo: idTodoRandom,
          title: nameTodo,
          createdTime: formatDate,
          category: categoryTodo);
      dataFolder.add(newTodoItemData);
      print("success");
    } catch (error) {
      print(error);
    }
  }
}
