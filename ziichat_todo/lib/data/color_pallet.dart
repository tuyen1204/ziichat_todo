final List<ColorItem> inputColorItems = [
  ColorItem(category: 'All', hexColor: '#FF5733'),
  ColorItem(category: 'Work', hexColor: '#33FF57'),
  ColorItem(category: 'Music', hexColor: '#5733FF'),
];

class ColorItem {
  final String category;
  final String hexColor;

  const ColorItem({
    required this.category,
    required this.hexColor,
  });
}
