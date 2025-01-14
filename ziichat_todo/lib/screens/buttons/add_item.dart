import 'package:flutter/material.dart';
import 'package:ziichat_todo/utils/bottom_sheet_util.dart';

class AddItemButton extends StatelessWidget {
  const AddItemButton(
      {super.key,
      this.paddingNotch = 0,
      this.paddingBottom = 0,
      required this.getCurrentCategory});

  final double paddingNotch;
  final double paddingBottom;
  final String getCurrentCategory;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        BottomSheetUtil.showCreateTodoItemBottomSheet(
            context: context,
            paddingNotch: paddingNotch,
            paddingBottom: paddingBottom,
            showCurrentCategory: getCurrentCategory);
      },
      child: Icon(Icons.add),
    );
  }
}
