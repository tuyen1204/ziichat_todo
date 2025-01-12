import 'package:flutter/material.dart';
import 'package:ziichat_todo/screens/bottom_sheet/bottom_sheet_create_todo_item.dart';

class BottomSheetUtil {
  static void showDefaultBottomSheet({
    required BuildContext context,
    required Widget child,
    bool enableDrag = true,
    bool isDismissible = true,
    bool isScrollControlled = true,
    VoidCallback? onClose,
    bool noPadding = false,
    BoxConstraints? constraints,
  }) {
    final navigationBarHeight = MediaQuery.of(context).viewPadding.bottom;

    showModalBottomSheet<String>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      constraints: constraints,
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(bottom: navigationBarHeight),
            child: child);
      },
    ).then((onValue) {
      if (onClose != null) {
        onClose();
      }
    });
  }

  static void showCreateTodoItemBottomSheet({
    required BuildContext context,
    bool enableDrag = true,
    bool isDismissible = true,
    VoidCallback? onClose,
    required double paddingNotch,
    required double paddingBottom,
  }) {
    final innerBottomSheet =
        (MediaQuery.of(context).size.height - paddingNotch) /
            MediaQuery.of(context).size.height;

    showDefaultBottomSheet(
      context: context,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      onClose: onClose,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: FractionallySizedBox(
          heightFactor: innerBottomSheet,
          child: BottomSheetCreateTodoItem(
            paddingBottom: paddingBottom,
          ),
        ),
      ),
    );
  }
}
