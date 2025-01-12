import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:intl/intl.dart';
import 'package:ziichat_todo/screens/folder/folder_item.dart';

class BottomSheetCreateTodoItem extends StatefulWidget {
  const BottomSheetCreateTodoItem({super.key, required this.paddingBottom});
  final double paddingBottom;

  @override
  State<BottomSheetCreateTodoItem> createState() =>
      _BottomSheetCreateTodoItemState();
}

class _BottomSheetCreateTodoItemState extends State<BottomSheetCreateTodoItem> {
  final formKey = GlobalKey<FormState>();
  final currentDate = DateTime.now();
  final nameTodo = TextEditingController();
  final editedTodo = TextEditingController();
  final noteTodo = TextEditingController();
  final listTodoItem = dataFolder;

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM dd yyyy, HH:MM').format(currentDate);

    return Padding(
      padding: EdgeInsets.only(bottom: widget.paddingBottom),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 0),
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
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    spacing: 20,
                    children: [
                      TextFormField(
                        controller: nameTodo,
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                          labelText: "What are you planning?",
                          labelStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.zero,
                          alignLabelWithHint: true,
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: primaryColor),
                          ),
                        ),
                        minLines: 6,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              icon: Icon(CupertinoIcons.bell),
                              hintText: formattedDate,
                            ),
                            readOnly: true,
                            onSaved: (String? value) {},
                          ),
                          TextFormField(
                            controller: noteTodo,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              icon: Icon(CupertinoIcons.conversation_bubble),
                              hintText: "Add Note",
                            ),
                            onSaved: (String? value) {},
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              icon: Icon(CupertinoIcons.tags),
                              hintText: "Category",
                            ),
                            readOnly: true,
                            onSaved: (String? value) {},
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () {
                    // formKey.currentState?.save();
                    TodoItemData.onCreateTodoItem(formattedDate, nameTodo.text);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(primaryColor),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    minimumSize:
                        WidgetStatePropertyAll(Size(double.infinity, 48)),
                  ),
                  child: Text(
                    "Create",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
