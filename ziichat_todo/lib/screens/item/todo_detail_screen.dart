import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:ziichat_todo/data/folder_data.dart';
import 'package:ziichat_todo/screens/folder/folder_item.dart';

class TodoDetailScreen extends StatefulWidget {
  const TodoDetailScreen({
    super.key,
    required this.idTodo,
    required this.initStatus,
    required this.initCategory,
  });

  final String idTodo;
  final String initStatus;
  final String initCategory;

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late String? categorySelected = "All";
  late String? statusSelected = "To Do";
  bool edited = false;
  final folders = dataFolder.map((item) => item.category).toSet().toList();
  late TodoItemData todoDetailData;

  final status = dataFolder.map((item) => item.status).toSet().toList();
  late TextEditingController newTitle;

  @override
  void initState() {
    statusSelected = widget.initStatus;
    categorySelected = widget.initCategory;
    edited;
    super.initState();
    todoDetailData =
        dataFolder.where((item) => item.idTodo == widget.idTodo).toList().first;
    newTitle = TextEditingController(text: todoDetailData.title);
  }

  void _handleDeleteTodo(String id) {
    dataFolder.removeWhere((item) {
      return item.idTodo == id;
    });
  }

  void _handleEditTodo({
    required TodoItemData currentTodo,
    String? title,
    String? category,
    String? createdTime,
    ItemStatus? status,
    String? note,
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
              createdTime: dataFolder[index].createdTime,
              status: status ?? dataFolder[index].status,
              note: note ?? dataFolder[index].note);
        });
      } else {
        print('id not found');
      }

      print('sucess');
      print(todoDetailData.title);
    } catch (e) {
      print("Error in editTodoItem: $e");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => {
            Navigator.pop(context),
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
                      "Todo detail",
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
                Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: newTitle,
                      readOnly: edited == true ? false : true,
                      cursorColor: primaryColor,
                      // initialValue: todoDetailData.title,
                      decoration: InputDecoration(
                        labelText: "Title",
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
                          return 'Name task is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      readOnly: true,
                      initialValue: todoDetailData.createdTime,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                        labelText: "Date",
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name task is required';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      readOnly: edited == true ? false : true,
                      initialValue: todoDetailData.note,
                      cursorColor: primaryColor,
                      decoration: InputDecoration(
                        labelText: "Note",
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Name task is required';
                        }
                        return null;
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        Text("Status",
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
                                color: statusSelected ==
                                        statusToReadableString(item)
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              checkmarkColor:
                                  statusSelected == statusToReadableString(item)
                                      ? Colors.white
                                      : Colors.grey,
                              selectedColor: statusColor(item),
                              selected: statusSelected ==
                                  statusToReadableString(item),
                              onSelected: (value) {
                                setState(() {
                                  edited == true
                                      ? statusSelected =
                                          statusToReadableString(item)
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
                        Text("Category",
                            style: TextStyle(
                                color: Color(0xff727272),
                                fontWeight: FontWeight.w500)),
                        Wrap(
                          spacing: 8.0,
                          children: folders.map((item) {
                            return ChoiceChip(
                              label: Text(item),
                              selected: categorySelected == item,
                              labelStyle: TextStyle(
                                color: Colors.black87,
                              ),
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
                Row(
                  spacing: 12,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          print('onPressed');
                          _handleEditTodo(
                            title: newTitle.text,
                            currentTodo: todoDetailData,
                          );
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
                          "Save changes",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showCupertinoDialog<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: const Text('Delete todo'),
                              content: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Yor\' are going to delete the ',
                                  style: TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: todoDetailData.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(text: ' todo. Are you sure?'),
                                  ],
                                ),
                              ),
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No'),
                                ),
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    _handleDeleteTodo(todoDetailData.idTodo);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                        style:
                            IconButton.styleFrom(backgroundColor: Colors.red),
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                        )),
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
