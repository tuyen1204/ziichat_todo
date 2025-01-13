import 'package:flutter/foundation.dart';

class TodoItemDta {
  final String title;
  final int task;
  final String category;
  final bool isDefault;
  final String time;
  final String categorySlug;

  const TodoItemDta({
    required this.title,
    this.category = '',
    this.time = '',
    this.task = 0,
    this.isDefault = false,
    required this.categorySlug,
  });
}

List<TodoItemDta> dataFolder = [
  TodoItemDta(
    title: "Todo 4",
    category: "All",
    categorySlug: "all",
    time: "10:00",
    isDefault: true,
  ),
  TodoItemDta(
    title: "Todo 1",
    category: "Work",
    categorySlug: "work",
    time: "10:00",
  ),
  TodoItemDta(
    title: "Todo 2",
    category: "Music",
    categorySlug: "music",
    time: "13:00",
  ),
  TodoItemDta(
    title: "Todo 3",
    category: "Music",
    categorySlug: "music",
    time: "11:00",
  ),
];
