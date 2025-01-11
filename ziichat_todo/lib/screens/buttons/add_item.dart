import 'package:flutter/material.dart';
import 'package:ziichat_todo/utils/bottom_sheet_util.dart';

class AddItemButton extends StatelessWidget {
  const AddItemButton({
    super.key,
    this.paddingNotch = 0,
  });

  final double paddingNotch;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        BottomSheetUtil.showCreateTodoItemBottomSheet(
            context: context, paddingNotch: paddingNotch);
      },
      child: Icon(Icons.add),
    );
  }
}
