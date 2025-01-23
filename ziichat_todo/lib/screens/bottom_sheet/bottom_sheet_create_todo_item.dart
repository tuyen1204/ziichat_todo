import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziichat_todo/component/title_section_large.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:intl/intl.dart';
import 'package:ziichat_todo/data/folder_data.dart';
import 'package:ziichat_todo/i18n/app_localizations.dart';
import 'package:ziichat_todo/screens/folder/folder_detail.dart';
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

  late String? categorySelected =
      categoryTodo == "All" ? "Other" : categoryTodo;
  late String? statusSelected = "To Do";

  late AppLocalizations localizations = AppLocalizations.of(context)!;

  static Future<void> onCreateTodoItem(String formatDate, String nameTodo,
      String categoryTodo, String noteTodo) async {
    try {
      var random = Random();
      final idTodoRandom = 'todo-new-${random.nextInt(100)}';
      final newTodoItemData = TodoItemData(
        idTodo: idTodoRandom,
        title: nameTodo,
        createdTime: formatDate,
        category: categoryTodo,
        note: noteTodo,
      );
      dataFolder.add(newTodoItemData);
      print("Todo item created successfully.");
    } catch (error) {
      print("Error creating todo item: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    categoryTodo = widget.showCurrentCategory;
    selectedCategory = categoryTodo;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        localizations = AppLocalizations.of(context)!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM dd yyyy, HH:MM').format(currentDate);
    final status = dataFolder.map((item) => item.status).toSet().toList();
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
                  title: localizations.translate('newTask'),
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 250),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        spacing: 16,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: nameTodo,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              labelText: localizations.translate('title'),
                              labelStyle: TextStyle(color: Colors.grey),
                              alignLabelWithHint: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                            minLines: 4,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localizations
                                    .translate('newTaskRequired');
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            initialValue: formattedDate,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              labelText: localizations.translate('createdDate'),
                              labelStyle: TextStyle(color: Colors.grey),
                              alignLabelWithHint: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                            keyboardType: TextInputType.multiline,
                          ),
                          TextFormField(
                            controller: noteTodo,
                            cursorColor: primaryColor,
                            decoration: InputDecoration(
                              labelText: localizations.translate('note'),
                              labelStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.zero,
                              alignLabelWithHint: true,
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: primaryColor),
                              ),
                            ),
                            minLines: 4,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onTapOutside: (event) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Text(localizations.translate('status'),
                                  style: TextStyle(
                                      color: Color(0xff727272),
                                      fontWeight: FontWeight.w500)),
                              Wrap(
                                spacing: 8.0,
                                children: status.map((item) {
                                  return ChoiceChip(
                                    label: Text(
                                      statusToReadableString(item),
                                    ),
                                    selected: statusSelected ==
                                        statusToReadableString(item),
                                    onSelected: (value) {},
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8,
                            children: [
                              Text(localizations.translate('category'),
                                  style: TextStyle(
                                      color: Color(0xff727272),
                                      fontWeight: FontWeight.w500)),
                              Wrap(
                                spacing: 8.0,
                                children: categoryList.map((item) {
                                  return ChoiceChip(
                                    label: Text(item),
                                    selected: categorySelected == item,
                                    labelStyle: TextStyle(
                                      color: Colors.black87,
                                    ),
                                    onSelected: (value) {
                                      setState(() {
                                        categorySelected = item;
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
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
                        onCreateTodoItem(currentDate.toString(), nameTodo.text,
                            categorySelected!, noteTodo.text),
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemsTodoDetail(
                              currentCategory: categorySelected!,
                              onLanguageChanged: (local) {},
                            ),
                          ),
                        ),
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
                    localizations.translate('create'),
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
