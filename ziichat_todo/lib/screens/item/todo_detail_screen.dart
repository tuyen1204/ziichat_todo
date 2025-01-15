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
    required this.onDeleteTodoItem,
  });

  final String idTodo;
  final String initStatus;
  final String initCategory;
  final void Function(String id) onDeleteTodoItem;

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late String? categorySelected = "All";
  late String? statusSelected = "To Do";

  @override
  void initState() {
    statusSelected = widget.initStatus;
    categorySelected = widget.initCategory;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final folders = dataFolder.map((item) => item.category).toSet().toList();
    final todoDetailData =
        dataFolder.where((item) => item.idTodo == widget.idTodo).toList().first;
    final status = dataFolder.map((item) => item.status).toSet().toList();

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
                          backgroundColor:
                              primaryColor.withValues(alpha: 0.15)),
                      icon: Icon(
                        Icons.edit_outlined,
                        color: primaryColor,
                        size: 20,
                      ),
                      onPressed: () => {},
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    TextFormField(
                      cursorColor: primaryColor,
                      initialValue: todoDetailData.title,
                      decoration: InputDecoration(
                        labelText: "Title",
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
                                  statusSelected = statusToReadableString(item);
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
                                  categorySelected = item;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => {},
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(primaryColor),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              // minimumSize: WidgetStatePropertyAll(
                              //     Size(MediaQuery.of(context).size.width, 48)),
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
                              widget.onDeleteTodoItem(todoDetailData.idTodo);
                              // Navigator.pop(context);
                            },
                            style: IconButton.styleFrom(
                                backgroundColor: Colors.red),
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                            )),
                      ],
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
