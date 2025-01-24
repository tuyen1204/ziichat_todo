import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:ziichat_todo/data/folder_data.dart';
import 'package:ziichat_todo/i18n/app_localizations.dart';
import 'package:ziichat_todo/screens/folder/folder_detail.dart';
import 'package:ziichat_todo/screens/folder/folder_item.dart';

class TodoDetailScreen extends StatefulWidget {
  const TodoDetailScreen({
    super.key,
    required this.idTodo,
    required this.initStatus,
    required this.initCategory,
    required this.onLanguageChanged,
  });

  final String idTodo;
  final ItemStatus initStatus;
  final String initCategory;
  final Function(Locale) onLanguageChanged;

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late String? categorySelected = "All";
  late ItemStatus? statusSelected = ItemStatus.done;
  bool edited = false;
  late TodoItemData todoDetailData;
  late TextEditingController newTitle;
  late TextEditingController newNote;
  final currentDate = DateTime.now();
  String formattedDateNow = '';
  late AppLocalizations localizations = AppLocalizations.of(context)!;

  final status = dataFolder.map((item) => item.status).toSet().toList();
  final dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');
  final formKey = GlobalKey<FormState>();
  late List<TodoItemData> _dataFolderInShare = [];
  late List<String> categoryList = [];

  @override
  void initState() {
    _loadTodos();

    statusSelected = widget.initStatus;
    categorySelected = widget.initCategory;
    edited;

    super.initState();
    todoDetailData =
        dataFolder.where((item) => item.idTodo == widget.idTodo).toList().first;
    newTitle = TextEditingController(text: todoDetailData.title);
    newNote = TextEditingController(text: todoDetailData.note);

    _updateTime();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        localizations = AppLocalizations.of(context)!;
      });
    });
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('todo_data');

    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);

      setState(
        () {
          _dataFolderInShare =
              jsonList.map((item) => TodoItemData.fromJson(item)).toList();

          categoryList =
              _dataFolderInShare.map((item) => item.category).toSet().toList();
        },
      );
    } else {
      setState(() {
        _dataFolderInShare = dataFolder;
      });

      _saveTodos();
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonList =
        _dataFolderInShare.map((item) => item.toJson()).toList();
    String jsonString = jsonEncode(jsonList);
    await prefs.setString('todo_data', jsonString);
  }

  void _handleDeleteTodo(
      String id, BuildContext context, String itemInCategory) {
    String fullText = localizations.translate(
      'youDeleteTodo',
      args: {'itemTodoName': todoDetailData.title},
    );

    final usernamePlaceholder = todoDetailData.title;
    final usernameStart = fullText.indexOf(usernamePlaceholder);
    final usernameEnd = usernameStart + usernamePlaceholder.length;
    final textBeforeUsername = fullText.substring(0, usernameStart);
    final textAfterUsername = fullText.substring(usernameEnd);

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(localizations.translate('deleteFolder')),
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: textBeforeUsername,
            style: TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: usernamePlaceholder,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(text: textAfterUsername),
            ],
          ),
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(localizations.translate('no')),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              dataFolder.removeWhere((item) {
                return item.idTodo == id;
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) {
                        return ItemsTodoDetail(
                          currentCategory: itemInCategory,
                          onLanguageChanged: (locale) {},
                        );
                      },
                      settings: RouteSettings(arguments: itemInCategory)));
            },
            child: Text(localizations.translate('yes')),
          ),
        ],
      ),
    );
  }

  void _handleEditTodo({
    required TodoItemData currentTodo,
    String? title,
    String? category,
    ItemStatus? status,
    String? note,
    String? createdTime,
  }) {
    try {
      final index =
          dataFolder.indexWhere((item) => item.idTodo == widget.idTodo);
      if (index != -1) {
        setState(() {
          dataFolder[index] = TodoItemData(
            idTodo: dataFolder[index].idTodo,
            title: title ?? dataFolder[index].title,
            category: category ?? dataFolder[index].category,
            status: status ?? dataFolder[index].status,
            createdTime: dataFolder[index].createdTime,
            note: note ?? dataFolder[index].note,
            editedTime: formattedDateNow.toString(),
          );
        });

        showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              Future.delayed(Duration(milliseconds: 1000), () {
                Navigator.of(context).pop();
              });
              return CupertinoAlertDialog(
                title: Text(localizations.translate('todoUpdateSuccessfully')),
                actions: <CupertinoDialogAction>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      localizations.translate('close'),
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              );
            });
      } else {
        print('ID Todo not found');
      }
      print('Success');
    } catch (e) {
      return;
    }
  }

  void _updateTime() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        DateTime now = DateTime.now();
        formattedDateNow = dateTimeFormat.format(now);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) {
                      return ItemsTodoDetail(
                        currentCategory: categorySelected.toString(),
                        onLanguageChanged: (locale) {},
                      );
                    },
                    settings: RouteSettings(arguments: categorySelected))),
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      localizations.translate('todoDetail'),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    IconButton(
                      style: IconButton.styleFrom(
                          backgroundColor: edited == true
                              ? primaryColor
                              : primaryColor.withValues(alpha: 0.15)),
                      icon: Icon(
                        Icons.edit_outlined,
                        color: edited == true ? Colors.white : primaryColor,
                        size: 20,
                      ),
                      onPressed: () => {
                        setState(() {
                          edited = !edited;
                        })
                      },
                    )
                  ],
                ),
                Form(
                  key: formKey,
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: newTitle,
                        readOnly: edited == true ? false : true,
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
                            return localizations.translate('newTaskRequired');
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        readOnly: true,
                        initialValue: dateTimeFormat
                            .format(DateTime.parse(todoDetailData.createdTime)),
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
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                      ),
                      if (todoDetailData.editedTime.isNotEmpty)
                        TextFormField(
                          readOnly: true,
                          initialValue: todoDetailData.editedTime,
                          cursorColor: primaryColor,
                          decoration: InputDecoration(
                            labelText: localizations.translate('editedDate'),
                            labelStyle: TextStyle(color: Colors.grey),
                            alignLabelWithHint: true,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: primaryColor),
                            ),
                          ),
                          keyboardType: TextInputType.multiline,
                          onTapOutside: (event) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                        ),
                      TextFormField(
                        controller: newNote,
                        readOnly: edited == true ? false : true,
                        cursorColor: primaryColor,
                        decoration: InputDecoration(
                          labelText: localizations.translate('note'),
                          labelStyle: TextStyle(color: Colors.grey),
                          contentPadding:
                              EdgeInsets.only(bottom: defaultPadding),
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
                                labelStyle: TextStyle(
                                  color: statusSelected == item
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                                checkmarkColor: statusSelected == item
                                    ? Colors.white
                                    : Colors.grey,
                                selectedColor: statusColor(item),
                                selected: statusSelected == item,
                                showCheckmark: false,
                                onSelected: (value) {
                                  setState(() {
                                    edited == true
                                        ? statusSelected = item
                                        : null;
                                  });
                                },
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
                                showCheckmark: false,
                                onSelected: (value) {
                                  setState(() {
                                    edited == true
                                        ? categorySelected = item
                                        : null;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Row(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            _handleEditTodo(
                              title: newTitle.text,
                              currentTodo: todoDetailData,
                              note: newNote.text,
                              status: statusSelected,
                              category: categorySelected,
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: edited == true
                              ? WidgetStatePropertyAll(primaryColor)
                              : WidgetStatePropertyAll(Colors.grey),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                        ),
                        child: Text(
                          localizations.translate('saveChanges'),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _handleDeleteTodo(todoDetailData.idTodo,
                          context, todoDetailData.category),
                      style: IconButton.styleFrom(backgroundColor: Colors.red),
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
