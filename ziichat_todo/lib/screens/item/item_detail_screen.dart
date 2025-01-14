import 'package:flutter/material.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:ziichat_todo/data/folder_data.dart';
import 'package:ziichat_todo/screens/folder/folder_item.dart';

class ItemDetailScreen extends StatefulWidget {
  const ItemDetailScreen({
    super.key,
    required this.nameTodo,
    required this.dateCreated,
    required this.category,
    this.note = "",
    required this.status,
  });
  final String nameTodo;
  final String dateCreated;
  final String category;
  final String note;
  final ItemStatus status;

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  late String? categorySelected = "All";

  @override
  void initState() {
    super.initState();
    categorySelected = widget.category;
  }

  @override
  Widget build(BuildContext context) {
    final folders = dataFolder.map((item) => item.category).toSet().toList();
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
                      initialValue: widget.nameTodo,
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
                      initialValue: widget.dateCreated,
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
                      initialValue: widget.note,
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
                    TextButton(
                      onPressed: () => {},
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
                        "Save changes",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
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
