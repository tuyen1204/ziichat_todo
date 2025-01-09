class FolderItem {
  final String title;
  final int task;
  final String iconName;
  final String category;
  final bool isDefault;

  const FolderItem({
    required this.title,
    required this.iconName,
    this.category = '',
    this.task = 0,
    this.isDefault = false,
  });
}
