import 'package:flutter/material.dart';

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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: SizedBox(
                  width: 36,
                  height: 5,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  )),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 1,
                      ),
                    ),
                    Text(
                      "New Task",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.close,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
