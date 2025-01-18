import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:ziichat_todo/data/folder_data.dart';
import 'package:ziichat_todo/screens/buttons/add_item.dart';
import 'package:ziichat_todo/screens/home/home_screen.dart';
import 'package:ziichat_todo/screens/item/todo_detail_screen.dart';
import 'package:ziichat_todo/component/shimmer_effect.dart';
import 'folder_item.dart';

class ItemsTodoDetail extends StatefulWidget {
  const ItemsTodoDetail({super.key, required this.currentCategory});
  final String currentCategory;
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

class _ItemsTodoDetailState extends State<ItemsTodoDetail> {
  late final List<TodoItemData> listToDo;
  late final List<TodoItemData> listToDoAll;
  late int totals;
  Set<int> selectedItems = {};
  bool isLoading = true;
  final currentDate = DateTime.now();
  List<String> sortList = [
    "Alphabetically",
    "Oldest",
    "Latest",
  ];
  String currentSort = "";
  late List<ItemStatus> listStatus = [ItemStatus.all];
  List<TodoItemData> sortByStatus = [...dataFolder];

  String currentStatus = statusToReadableString(ItemStatus.all);
  String categoryToDelete = "";
  late final TextEditingController newCategory;

  final folderNames =
      dataFolder.map((item) => item.category.toLowerCase()).toSet().toList();

  @override
  void initState() {
    super.initState();

    setState(() {
      listToDo = dataFolder
          .where((toDo) => toDo.category == widget.currentCategory)
          .toList();
      listToDoAll = List.from(dataFolder);
      totals = dataFolder.length;

      listStatus.addAll(dataFolder
          .map((item) => item.status)
          .toSet()
          .where((status) => status != ItemStatus.all)
          .toList());
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        isLoading = false;
      });
    });

    categoryToDelete = widget.currentCategory;
    newCategory = TextEditingController(text: widget.currentCategory);
  }

  void handleUpdateFolders() {
    setState(() {
      sortByStatus = widget.currentCategory == "All"
          ? dataFolder
              .where((toDo) =>
                  statusToReadableString(toDo.status) == currentStatus)
              .toList()
          : dataFolder
              .where((toDo) =>
                  (widget.currentCategory != "All"
                      ? toDo.category == widget.currentCategory
                      : true) &&
                  statusToReadableString(toDo.status) == currentStatus)
              .toList();
    });
  }

  void handleEditFolder(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Column(
          spacing: 12,
          children: [
            Text('Edit Folder'),
            CupertinoTextField(
              controller: newCategory,
              placeholder: 'Enter new folder name',
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
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              if (folderNames.contains(newCategory.text.toLowerCase())) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text('Info'),
                    content: Text('Folder name exists'),
                    actions: <Widget>[
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  ),
                );
              } else {
                setState(() {
                  final updatedData = dataFolder.map((item) {
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

                  dataFolder.clear();
                  dataFolder.addAll(updatedData);

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemsTodoDetail(
                        currentCategory: newCategory.text,
                      ),
                    ),
                  );
                  Navigator.of(context).pop();
                });
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void handleDeleteFolder(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('You want to delete this folder'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              setState(() {
                dataFolder
                    .removeWhere((item) => item.category == categoryToDelete);
              });
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final paddingNotch = MediaQuery.of(context).padding.top;
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    final sortedList = (widget.currentCategory == "All"
        ? listToDoAll
        : listToDo)
      ..sort((a, b) {
        if (currentSort == "Alphabetically") {
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        } else if (currentSort == "Latest") {
          return DateTime.parse(a.createdTime)
              .difference(currentDate)
              .inDays
              .abs()
              .compareTo((DateTime.parse(b.createdTime).difference(currentDate))
                  .inDays
                  .abs());
        } else if (currentSort == "Oldest") {
          return DateTime.parse(a.createdTime)
              .compareTo(DateTime.parse(b.createdTime));
        }
        return 0;
      });

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          widget.currentCategory == "All"
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
                      child: Text('Edit Folder'),
                    ),
                    if (listToDo.isEmpty)
                      PopupMenuItem<ActionInFolder>(
                        value: ActionInFolder.deleteFolder,
                        child: Text('Delete Folder'),
                      )
                  ],
                ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
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
                      fontWeight: FontWeight.w500),
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
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(top: 32, bottom: 64),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (listToDo.length > 1 ||
                          widget.currentCategory == "All")
                        _innerSort(),
                      _innerSortByStatus(),
                      _innerListTodoItem(sortedList),
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

  Column _innerListTodoItem(List<TodoItemData> sortedList) {
    return Column(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.currentCategory == "All"
          ? List.generate(
              currentStatus == "All" ? listToDoAll.length : sortByStatus.length,
              (index) {
              final todoItem = currentStatus == "All"
                  ? listToDoAll[index]
                  : sortByStatus[index];
              return isLoading
                  ? ShimmerLoading(
                      isLoading: isLoading,
                      child: TodoItemCard(
                        index: index,
                        todoItem: todoItem,
                        isSelected: selectedItems.contains(index),
                        onSelected: (selectedIndex) {},
                      ),
                    )
                  : TodoItemCard(
                      index: index,
                      todoItem: todoItem,
                      updateNameFolder: newCategory.text,
                      isSelected: selectedItems.contains(index),
                      onSelected: (selectedIndex) {
                        setState(
                          () {
                            if (selectedItems.contains(selectedIndex)) {
                              selectedItems.remove(selectedIndex);
                            } else {
                              selectedItems.add(selectedIndex);
                            }
                          },
                        );
                      },
                    );
            })
          : List.generate(
              currentStatus == "All" ? listToDo.length : sortByStatus.length,
              (index) {
                final todoItem = currentStatus == "All"
                    ? listToDo[index]
                    : sortByStatus[index];

                return isLoading
                    ? ShimmerLoading(
                        isLoading: isLoading,
                        child: TodoItemCard(
                          index: index,
                          todoItem: todoItem,
                          isSelected: selectedItems.contains(index),
                          onSelected: (selectedIndex) {},
                        ),
                      )
                    : TodoItemCard(
                        index: index,
                        todoItem: todoItem,
                        updateNameFolder: newCategory.text,
                        isSelected: selectedItems.contains(index),
                        onSelected: (selectedIndex) {
                          setState(
                            () {
                              if (selectedItems.contains(selectedIndex)) {
                                selectedItems.remove(selectedIndex);
                              } else {
                                selectedItems.add(selectedIndex);
                              }
                            },
                          );
                        },
                      );
              },
            ),
    );
  }

  SizedBox _innerSort() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sortList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: index == 0 ? 6 : 6),
            child: ChoiceChip(
              showCheckmark: false,
              label: Text(sortList[index]),
              selected: currentSort == sortList[index],
              onSelected: (value) {
                setState(() {
                  currentSort = sortList[index];
                });
              },
            ),
          );
        },
      ),
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
                handleUpdateFolders();
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
  final updateNameFolder;

  const TodoItemCard({
    super.key,
    required this.index,
    required this.todoItem,
    required this.isSelected,
    required this.onSelected,
    this.updateNameFolder = "",
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.4,
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () => {
          onSelected(index),
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TodoDetailScreen(
                  idTodo: todoItem.idTodo,
                  initStatus: todoItem.status,
                  initCategory: todoItem.category,
                );
              },
            ),
          ),
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 12,
            children: [
              Icon(
                isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 24,
                color: isSelected ? primaryColor : Colors.grey,
              ),
              Expanded(
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
                          color: isSelected ? primaryColor : Colors.black),
                    ),
                    Row(
                      children: [
                        Text(
                          updateNameFolder.isNotEmpty
                              ? '$updateNameFolder - '
                              : '${todoItem.category} - ',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          todoItem.editedTime.isEmpty
                              ? DateFormat('yyyy MMM dd, HH:MM')
                                  .format(DateTime.parse(todoItem.createdTime))
                              : DateFormat('yyyy MMM dd, HH:MM')
                                  .format(DateTime.parse(todoItem.editedTime)),
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
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: statusColor(todoItem.status), // border color
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
