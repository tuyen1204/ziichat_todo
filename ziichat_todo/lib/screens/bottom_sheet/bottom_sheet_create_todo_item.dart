import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ziichat_todo/component/title_section_large.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:intl/intl.dart';
import 'package:ziichat_todo/data/folder_data.dart';
import 'package:ziichat_todo/screens/folder/folder_item.dart';

class BottomSheetCreateTodoItem extends StatefulWidget {
  const BottomSheetCreateTodoItem(
      {super.key,
      required this.paddingBottom,
      required this.showCurrentCategory});
  final double paddingBottom;
  final String showCurrentCategory;

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
  final categoryList = dataFolder.map((data) => data.category).toList().toSet();
  late String? categoryTodo;
  String? selectedCategory;
  TextEditingController choiceCategory = TextEditingController();

  @override
  void initState() {
    super.initState();
    categoryTodo = widget.showCurrentCategory;
    selectedCategory = categoryTodo;
    choiceCategory.text = selectedCategory!;
  }

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
                TitleSectionLarge(
                  title: "New task",
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.grey[100]),
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name task is required';
                          }
                          return null;
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            style: TextStyle(fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              prefixIcon: Icon(CupertinoIcons.bell),
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
                              prefixIcon:
                                  Icon(CupertinoIcons.conversation_bubble),
                              hintText: "Add Note",
                            ),
                            onSaved: (String? value) {},
                          ),
                          TextFormField(
                            controller: choiceCategory,
                            style: TextStyle(fontWeight: FontWeight.w600),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              prefixIcon: Icon(CupertinoIcons.tags),
                              suffixIcon: Icon(
                                CupertinoIcons.arrowtriangle_down_circle_fill,
                                color: primaryColor,
                                size: 14,
                              ),
                            ),
                            readOnly: true,
                            onSaved: (String? value) {},
                          ),
                          DropdownMenu<String>(
                            initialSelection: widget.showCurrentCategory,
                            width: MediaQuery.of(context).size.width,
                            onSelected: (String? value) {
                              setState(() {
                                categoryTodo = value;
                                selectedCategory = value;
                                choiceCategory.text = value!;
                              });
                            },
                            hintText: widget.showCurrentCategory,
                            inputDecorationTheme: InputDecorationTheme(
                              isDense: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              constraints: BoxConstraints.tightFor(
                                  width: MediaQuery.of(context).size.width,
                                  height: 48), //
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            dropdownMenuEntries:
                                categoryList.map((String value) {
                              return DropdownMenuEntry<String>(
                                value: value,
                                label: value,
                                leadingIcon: Icon(Icons.import_contacts),
                              );
                            }).toList(),
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
                  onPressed: () => {
                    if (formKey.currentState!.validate())
                      {
                        TodoItemData.onCreateTodoItem(
                            formattedDate, nameTodo.text, categoryTodo!),
                        setState(() {}),
                        Navigator.pop(context),
                      }
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
