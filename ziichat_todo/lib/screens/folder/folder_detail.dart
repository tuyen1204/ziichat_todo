import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:ziichat_todo/data/folder_data.dart';
import 'package:ziichat_todo/i18n/app_localizations.dart';
import 'package:ziichat_todo/screens/buttons/add_item.dart';
import 'package:ziichat_todo/screens/home/home_screen.dart';
import 'package:ziichat_todo/screens/item/todo_detail_screen.dart';
import 'package:ziichat_todo/component/shimmer_effect.dart';
import 'folder_item.dart';

class ItemsTodoDetail extends StatefulWidget {
  const ItemsTodoDetail(
      {super.key,
      required this.currentCategory,
      required this.onLanguageChanged});
  final String currentCategory;
  final Function(Locale) onLanguageChanged;

  @override
  State<ItemsTodoDetail> createState() => _ItemsTodoDetailState();
}

class TodoItem {
  final String title;
  final String time;
  final String? category;
  final ItemStatus status;

  const TodoItem({
    required this.title,
    this.time = '',
    this.category = '',
    required this.status,
  });
}

enum ActionInFolder { deleteFolder, editNameFolder }

enum ActionSort { latest, oldest, alpha }

class _ItemsTodoDetailState extends State<ItemsTodoDetail> {
  late List<TodoItemData> listToDo = [];
  late List<TodoItemData> listToDoAll = [];
  late final List<TodoItemData> listToDoIsNotItem;
  final int totals = 0;
  Set<int> selectedItems = {};
  bool isLoading = true;
  final currentDate = DateTime.now();

  Map<ActionSort, String> sortListDropdown = {
    ActionSort.latest: "Latest",
    ActionSort.oldest: "Oldest",
    ActionSort.alpha: "Alphabetically",
  };

  ActionSort? currentSort = ActionSort.latest;

  late List<ItemStatus> listStatus = [ItemStatus.all];

  String currentStatus = statusToReadableString(ItemStatus.all);
  String categoryToDelete = "";
  late final TextEditingController newCategory;

  late DateFormat dateTimeFormat;

  late List<TodoItemData> _dataFolderInShare = [];
  late List<String> folderNames = [];
  late List<TodoItemData> sortByStatus = [];

  @override
  void initState() {
    super.initState();

    _loadTodos();

    setState(
      () {
        dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');
      },
    );

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        isLoading = false;
      });
    });

    categoryToDelete = widget.currentCategory;
    newCategory = TextEditingController(text: widget.currentCategory);
  }

  List<String> idsToRemove = [];

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('todo_data');

    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);

      setState(
        () {
          _dataFolderInShare =
              jsonList.map((item) => TodoItemData.fromJson(item)).toList();

          folderNames = dataFolder
              .map((item) => item.category.toLowerCase())
              .toSet()
              .toList();

          sortByStatus = _dataFolderInShare;

          listToDo = _dataFolderInShare
              .where((toDo) => (toDo.category == widget.currentCategory &&
                  toDo.title.isNotEmpty))
              .toList();

          listToDoAll = _dataFolderInShare
              .where((toDo) => toDo.title.isNotEmpty)
              .toList();

          listToDoIsNotItem = _dataFolderInShare
              .where((toDo) => toDo.category == widget.currentCategory)
              .toList();

          listStatus.addAll(_dataFolderInShare
              .map((item) => item.status)
              .toSet()
              .where((status) => status != ItemStatus.all)
              .toList());
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

  void handleStatusFilter() {
    setState(
      () {
        sortByStatus = widget.currentCategory == "All"
            ? _dataFolderInShare
                .where((toDo) =>
                    statusToReadableString(toDo.status) == currentStatus &&
                    toDo.title.isNotEmpty)
                .toList()
            : _dataFolderInShare
                .where((toDo) =>
                    ((widget.currentCategory != "All"
                            ? toDo.category == widget.currentCategory
                            : true) &&
                        statusToReadableString(toDo.status) == currentStatus) &&
                    toDo.title.isNotEmpty)
                .toList();
      },
    );
  }

  void handleEditFolder(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Column(
          spacing: 12,
          children: [
            Text(AppLocalizations.of(context)!.translate('editFolder')),
            CupertinoTextField(
              controller: newCategory,
              placeholder:
                  AppLocalizations.of(context)!.translate('enterNewFolderName'),
              padding: EdgeInsets.all(12),
            ),
          ],
        ),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.translate('cancel')),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              if (folderNames.contains(newCategory.text.toLowerCase().trim())) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title:
                        Text(AppLocalizations.of(context)!.translate('info')),
                    content: Text(AppLocalizations.of(context)!
                        .translate('folderNameExists')),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ItemsTodoDetail(
                                currentCategory: newCategory.text,
                                onLanguageChanged: widget.onLanguageChanged,
                              ),
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  ),
                );
              } else {
                setState(() {
                  final updatedData = _dataFolderInShare.map((item) {
                    if (item.category == widget.currentCategory) {
                      return TodoItemData(
                        idTodo: item.idTodo,
                        title: item.title,
                        category: newCategory.text,
                        status: item.status,
                        createdTime: item.createdTime,
                        editedTime: item.editedTime,
                      );
                    }
                    return item;
                  }).toList();

                  _dataFolderInShare.clear();
                  _dataFolderInShare.addAll(updatedData);
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemsTodoDetail(
                        currentCategory: newCategory.text,
                        onLanguageChanged: widget.onLanguageChanged,
                      ),
                    ),
                  );
                });
              }
            },
            child: Text(AppLocalizations.of(context)!.translate('save')),
          ),
        ],
      ),
    );
  }

  void handleDeleteFolder(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(AppLocalizations.of(context)!.translate('youDeleteFolder')),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.translate('no')),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              setState(() {
                _dataFolderInShare
                    .removeWhere((item) => item.category == categoryToDelete);
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    onLanguageChanged: (locale) {},
                  ),
                ),
              );
            },
            child: Text(AppLocalizations.of(context)!.translate('yes')),
          ),
        ],
      ),
    );
  }

  void _handleManyTodo(String id, BuildContext context, String itemInCategory) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
            "${AppLocalizations.of(context)!.translate('delete')} ${selectedItems.length} ${AppLocalizations.of(context)!.translate('todoSelected')}"),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(AppLocalizations.of(context)!.translate('no')),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              _dataFolderInShare
                  .removeWhere((item) => idsToRemove.contains(item.idTodo));
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
            child: Text(AppLocalizations.of(context)!.translate('yes')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paddingNotch = MediaQuery.of(context).padding.top;
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    int totals = listToDoAll.length;
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            if (listToDoIsNotItem.isEmpty && widget.currentCategory != "All") {
              final newTodoItemData = TodoItemData(
                  idTodo: "",
                  title: "",
                  createdTime: "formatDate",
                  category: widget.currentCategory,
                  note: "noteTodo");
              _dataFolderInShare.add(newTodoItemData);
            }
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(onLanguageChanged: (locale) {}),
              ),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        actions: [
          SizedBox(width: 16),
          widget.currentCategory == "All" || widget.currentCategory == "Other"
              ? SizedBox()
              : PopupMenuButton<ActionInFolder>(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (ActionInFolder item) {
                    switch (item) {
                      case ActionInFolder.deleteFolder:
                        handleDeleteFolder(context);
                        break;

                      case ActionInFolder.editNameFolder:
                        handleEditFolder(context);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<ActionInFolder>>[
                    PopupMenuItem<ActionInFolder>(
                      value: ActionInFolder.editNameFolder,
                      child: Text(AppLocalizations.of(context)!
                          .translate('editFolder')),
                    ),
                    if (listToDo.isEmpty)
                      PopupMenuItem<ActionInFolder>(
                        value: ActionInFolder.deleteFolder,
                        child: Text(AppLocalizations.of(context)!
                            .translate('deleteFolder')),
                      )
                  ],
                ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(Icons.ballot, size: 32, color: primaryColor),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  newCategory.text.isNotEmpty
                      ? newCategory.text
                      : widget.currentCategory,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  widget.currentCategory == "All"
                      ? '$totals tasks'
                      : '${listToDo.length} task',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.only(
                  left: defaultPadding, right: defaultPadding, bottom: 48),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 64),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (listToDo.length > 1 ||
                          widget.currentCategory == "All")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  icon: Icon(
                                    selectedItems.length ==
                                                sortByStatus.length &&
                                            selectedItems.length > 1
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: selectedItems.length ==
                                                sortByStatus.length &&
                                            selectedItems.length > 1
                                        ? primaryColor
                                        : Colors.grey,
                                  ),
                                  onPressed: () {
                                    if (selectedItems.length ==
                                        sortByStatus.length) {
                                      setState(() {
                                        selectedItems.clear();
                                      });
                                    } else {
                                      setState(() {
                                        selectedItems = List.generate(
                                                sortByStatus.length, (i) => i)
                                            .toSet();
                                        for (var item in selectedItems) {
                                          idsToRemove
                                              .add(sortByStatus[item].idTodo);
                                        }
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                sortByStatus.isEmpty || selectedItems.isEmpty
                                    ? null
                                    : _handleManyTodo(
                                        sortByStatus[selectedItems.first]
                                            .idTodo,
                                        context,
                                        widget.currentCategory);
                              },
                              child: Text(
                                  "${AppLocalizations.of(context)!.translate('delete')} ${selectedItems.length} ${AppLocalizations.of(context)!.translate('todoSelected')}"),
                            ),
                            PopupMenuButton<ActionSort>(
                              iconColor: Colors.black87,
                              icon: Icon(Icons.filter_alt_outlined),
                              onSelected: (ActionSort item) {
                                setState(() {
                                  currentSort = item;
                                });

                                switch (item) {
                                  case ActionSort.latest:
                                    setState(
                                      () {
                                        sortByStatus.sort(
                                          (a, b) {
                                            return DateTime.parse(a.createdTime)
                                                .difference(currentDate)
                                                .inDays
                                                .abs()
                                                .compareTo((DateTime.parse(
                                                            b.createdTime)
                                                        .difference(
                                                            currentDate))
                                                    .inDays
                                                    .abs());
                                          },
                                        );
                                      },
                                    );
                                    break;

                                  case ActionSort.oldest:
                                    setState(
                                      () {
                                        sortByStatus.sort(
                                          (a, b) {
                                            return DateTime.parse(a.createdTime)
                                                .compareTo(DateTime.parse(
                                                    b.createdTime));
                                          },
                                        );
                                      },
                                    );
                                    break;

                                  case ActionSort.alpha:
                                    sortByStatus.sort(
                                      (a, b) {
                                        return a.title
                                            .toLowerCase()
                                            .compareTo(b.title.toLowerCase());
                                      },
                                    );
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  ...sortListDropdown.entries.map((entry) {
                                    return PopupMenuItem<ActionSort>(
                                      value: entry.key,
                                      labelTextStyle: WidgetStatePropertyAll(
                                        TextStyle(
                                            fontFamily: 'Barlow',
                                            fontWeight: FontWeight.w600,
                                            color: currentSort == entry.key
                                                ? primaryColor
                                                : Colors.black54),
                                      ),
                                      child: Text(
                                        entry.value,
                                      ),
                                    );
                                  }),
                                ];
                              },
                            ),
                          ],
                        ),
                      SizedBox(height: 8),
                      if (listToDo.length > 1 ||
                          widget.currentCategory == "All")
                        _innerSortByStatus(),
                      _innerListTodoItem(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AddItemButton(
        paddingNotch: paddingNotch,
        paddingBottom: paddingBottom,
        getCurrentCategory: widget.currentCategory,
      ),
    );
  }

  Column _innerListTodoItem() {
    sortByStatus = widget.currentCategory == "All"
        ? (currentStatus == "All" ? listToDoAll : sortByStatus)
        : (currentStatus == "All" ? listToDo : sortByStatus);

    return Column(
      children: [
        sortByStatus.isEmpty
            ? SizedBox(
                width: double.infinity,
                height: 100,
                child: Center(
                    child: Text(
                  "Nothing",
                  style: TextStyle(fontWeight: FontWeight.w600),
                )),
              )
            : SizedBox(
                height: 400,
                child: ListView.builder(
                    itemCount: sortByStatus.length,
                    itemBuilder: (context, index) {
                      final todoItem = sortByStatus[index];
                      return isLoading
                          ? ShimmerLoading(
                              isLoading: isLoading,
                              child: _buildTodoItemCard(index, todoItem),
                            )
                          : _buildTodoItemCard(index, todoItem);
                    }),
              ),
      ],
    );
  }

  Widget _buildTodoItemCard(int index, TodoItemData todoItem) {
    return TodoItemCard(
      index: index,
      todoItem: todoItem,
      updateNameFolder: newCategory.text,
      isSelected: selectedItems.contains(index),
      onSelected: (selectedIndex) {
        setState(
          () {
            if (selectedItems.contains(selectedIndex)) {
              selectedItems.remove(selectedIndex);
              idsToRemove.remove(todoItem.idTodo);
            } else {
              selectedItems.add(selectedIndex);
              idsToRemove.add(todoItem.idTodo);
            }
          },
        );
      },
    );
  }

  SizedBox _innerSortByStatus() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listStatus.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: index == 0 ? 6 : 6),
            child: ChoiceChip(
              showCheckmark: false,
              label: Text(statusToReadableString(listStatus[index])),
              selected:
                  currentStatus == statusToReadableString(listStatus[index]),
              onSelected: (value) {
                setState(() {
                  currentStatus = statusToReadableString(listStatus[index]);
                });

                handleStatusFilter();
              },
            ),
          );
        },
      ),
    );
  }
}

class TodoItemCard extends StatelessWidget {
  final int index;
  final TodoItemData todoItem;
  final bool isSelected;
  final ValueChanged<int> onSelected;
  final String? updateNameFolder;
  const TodoItemCard(
      {super.key,
      required this.index,
      required this.todoItem,
      required this.isSelected,
      required this.onSelected,
      this.updateNameFolder = ""});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey[200]!)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              spacing: 12,
              children: [
                InkWell(
                  onTap: () => {
                    onSelected(index),
                  },
                  child: Icon(
                    isSelected
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    size: 24,
                    color: isSelected ? primaryColor : Colors.grey,
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TodoDetailScreen(
                                idTodo: todoItem.idTodo,
                                initStatus: todoItem.status,
                                initCategory: updateNameFolder.toString(),
                                onLanguageChanged: (locale) {});
                          },
                        ),
                      ),
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todoItem.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black),
                        ),
                        Row(
                          children: [
                            Text(
                              '${todoItem.category} • ',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              todoItem.editedTime.isEmpty
                                  ? DateFormat('yyyy-MM-dd HH:mm').format(
                                      DateTime.parse(todoItem.createdTime))
                                  : DateFormat('yyyy-MM-dd HH:mm').format(
                                      DateTime.parse(todoItem.editedTime)),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(width: 4),
                            if (todoItem.editedTime.isNotEmpty)
                              Icon(
                                Icons.edit,
                                size: 12,
                                color: Colors.grey,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: statusColor(todoItem.status),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
