import 'package:flutter/material.dart';

class FolderData {
  final String title;
  final int task;
  final String iconName;
  final String category;

  const FolderData({
    required this.title,
    required this.task,
    required this.iconName,
    this.category = '',
  });
}

List<FolderData> dataList = [
  FolderData(
    title: "Work",
    task: 10,
    iconName: "work",
    category: "work",
  ),
  FolderData(
    title: "Music",
    task: 3,
    iconName: "music",
    category: "music",
  ),
  FolderData(
    title: "Travel",
    task: 5,
    iconName: "travel",
    category: "music",
  ),
];
