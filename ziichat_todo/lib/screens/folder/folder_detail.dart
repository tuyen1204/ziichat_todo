import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:ziichat_todo/data/folder_data.dart';
import 'package:ziichat_todo/screens/buttons/add_item.dart';
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
  String currentSort = "Alphabetically";
  String choiceCategory = "All";
  late final List<TodoItemData> filteredFolders;

  @override
  void initState() {
    super.initState();

    setState(() {
      listToDo = dataFolder
          .where((toDo) => toDo.category == widget.currentCategory)
          .toList();
      listToDoAll = List.from(dataFolder);
      totals = dataFolder.length;
      choiceCategory;
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _handleUpdateFolders() {
    filteredFolders = choiceCategory == "All"
        ? List.from(dataFolder)
        : filteredFolders
            .where((toDo) => toDo.category == choiceCategory)
            .toList();
    print("$choiceCategory choice");
    print("${filteredFolders.length} length");
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

    final allFolder = dataFolder.map((item) => item.category).toSet().toList();

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => {},
          )
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
                  choiceCategory == ""
                      ? choiceCategory
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
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: sortList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: index == 0 ? 12 : 6),
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
                        ),
                      if (widget.currentCategory == "All")
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: allFolder.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: index == 0 ? 12 : 6),
                                child: ChoiceChip(
                                  showCheckmark: false,
                                  label: Text(allFolder[index]),
                                  selected: choiceCategory == allFolder[index],
                                  onSelected: (value) {
                                    setState(() {
                                      choiceCategory = allFolder[index];
                                      _handleUpdateFolders();
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      Column(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          sortedList.length,
                          (index) {
                            final todoItem = widget.currentCategory == "All"
                                ? listToDoAll[index]
                                : listToDo[index];
                            return choiceCategory != "All"
                                ? ShimmerLoading(
                                    isLoading: isLoading,
                                    child: TodoItemCard(
                                      index: index,
                                      todoItem: filteredFolders[index],
                                      isSelected: selectedItems.contains(index),
                                      onSelected: (selectedIndex) {
                                        setState(() {
                                          if (selectedItems
                                              .contains(selectedIndex)) {
                                            selectedItems.remove(selectedIndex);
                                          } else {
                                            selectedItems.add(selectedIndex);
                                          }
                                        });
                                      },
                                    ),
                                  )
                                : isLoading
                                    ? ShimmerLoading(
                                        isLoading: isLoading,
                                        child: TodoItemCard(
                                          index: index,
                                          todoItem: todoItem,
                                          isSelected:
                                              selectedItems.contains(index),
                                          onSelected: (selectedIndex) {
                                            setState(() {
                                              if (selectedItems
                                                  .contains(selectedIndex)) {
                                                selectedItems
                                                    .remove(selectedIndex);
                                              } else {
                                                selectedItems
                                                    .add(selectedIndex);
                                              }
                                            });
                                          },
                                        ),
                                      )
                                    : TodoItemCard(
                                        index: index,
                                        todoItem: todoItem,
                                        isSelected:
                                            selectedItems.contains(index),
                                        onSelected: (selectedIndex) {
                                          setState(
                                            () {
                                              if (selectedItems
                                                  .contains(selectedIndex)) {
                                                selectedItems
                                                    .remove(selectedIndex);
                                              } else {
                                                selectedItems
                                                    .add(selectedIndex);
                                              }
                                            },
                                          );
                                        },
                                      );
                          },
                        ),
                      ),
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
}

class TodoItemCard extends StatelessWidget {
  final int index;
  final TodoItemData todoItem;
  final bool isSelected;
  final ValueChanged<int> onSelected;

  const TodoItemCard({
    super.key,
    required this.index,
    required this.todoItem,
    required this.isSelected,
    required this.onSelected,
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
                          '${todoItem.category} - ',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          DateFormat('yyyy MMM dd, HH:MM')
                              .format(DateTime.parse(todoItem.createdTime)),
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.black45,
                              fontWeight: FontWeight.w500),
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
