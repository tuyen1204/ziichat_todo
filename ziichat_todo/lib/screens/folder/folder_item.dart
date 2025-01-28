import 'package:flutter/material.dart';

enum ItemStatus { todo, progressing, pending, done, all }

class TodoItemData {
  final String idTodo;
  final String title;
  final int task;
  final String category;
  final String categoryCreateTime;
  final bool isDefault;
  final String createdTime;
  final String editedTime;
  final String categorySlug;
  final ItemStatus status;
  final String note;

  @override
  String toString() {
    return 'TodoItemData(idTodo: $idTodo, title: $title, category: $category,categoryCreateTime: $categoryCreateTime, createdTime: $createdTime, status: $status)';
  }

  const TodoItemData({
    required this.idTodo,
    required this.title,
    this.category = 'All',
    this.categoryCreateTime = '',
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
      'categoryCreateTime': categoryCreateTime,
      'createdTime': createdTime,
      'status': status.index,
    };
  }

  factory TodoItemData.fromJson(Map<String, dynamic> json) {
    return TodoItemData(
      idTodo: json['idTodo'],
      title: json['title'],
      category: json['category'],
      categoryCreateTime: json['categoryCreateTime'],
      createdTime: json['createdTime'],
      status: ItemStatus.values[json['status']],
    );
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
