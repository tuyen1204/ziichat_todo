import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ziichat_todo/component/title_section_large.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:ziichat_todo/data/folder_data.dart';
import 'package:ziichat_todo/i18n/app_localizations.dart';
import 'package:ziichat_todo/screens/folder/folder_detail.dart';
import 'package:ziichat_todo/screens/folder/folder_item.dart';
import 'package:ziichat_todo/screens/item/todo_detail_screen.dart';
import 'package:ziichat_todo/component/shimmer_effect.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onLanguageChanged});
  final Function(Locale) onLanguageChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;

  List<String> languagesOption = [
    "en",
    "vi",
  ];

  late String langSelected = "";
  late List<TodoItemData> _dataFolderInShare = [];
  late List<String> folderNames = [];
  late List<String> folders = [];
  final int totalTask = 0;
  final currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _loadTodos();

    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('todo_data');
    List<dynamic> jsonList = jsonDecode(jsonString!);

    if (jsonList.isNotEmpty) {
      setState(
        () {
          _dataFolderInShare =
              jsonList.map((item) => TodoItemData.fromJson(item)).toList();

          folderNames = _dataFolderInShare
              .map((item) => item.category.toLowerCase())
              .toSet()
              .toList();

          folders =
              _dataFolderInShare.map((item) => item.category).toSet().toList();
        },
      );
    } else {
      setState(
        () {
          _dataFolderInShare = [...dataFolder];
          folderNames = _dataFolderInShare
              .map((item) => item.category.toLowerCase())
              .toSet()
              .toList();
        },
      );
    }
    await _saveTodos();
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString =
        jsonEncode(_dataFolderInShare.map((item) => item.toJson()).toList());
    await prefs.setString('todo_data', jsonString);
  }

  @override
  Widget build(BuildContext context) {
    for (var item in _dataFolderInShare) {
      print(item.toString());
    }

    final processingFolders = _dataFolderInShare
        .where((item) => item.status == ItemStatus.progressing)
        .toList()
      ..sort((a, b) => DateTime.parse(a.createdTime)
          .difference(currentDate)
          .inDays
          .abs()
          .compareTo((DateTime.parse(b.createdTime).difference(currentDate))
              .inDays
              .abs()));

    final localizations = AppLocalizations.of(context)!;
    late final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'ZiiChat Todo',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
        ),
        actions: [
          Wrap(
            spacing: 8.0,
            children: languagesOption.map((index) {
              return ChoiceChip(
                label: Text(index.toUpperCase()),
                showCheckmark: false,
                selected: currentLocale.toString() == index,
                onSelected: (value) {
                  setState(() {
                    langSelected = index;
                  });
                  widget.onLanguageChanged(Locale(langSelected));
                },
              );
            }).toList(),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: TitleSectionLarge(
                      title: localizations.translate('folders')),
                ),
                SizedBox(height: defaultPadding),
                SizedBox(
                  width: double.infinity,
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: folders.length + 1,
                    itemBuilder: (context, index) {
                      folders.sort(
                        (a, b) {
                          if (a == "All") return -1;
                          if (b == "All") return 1;
                          if (a == "Other") return -1;
                          if (b == "Other") return 1;

                          return a.compareTo(b);
                        },
                      );

                      if (index == 0) {
                        final allTask = _dataFolderInShare
                            .where((item) => (item.title.isNotEmpty))
                            .length;
                        return isLoading
                            ? ShimmerLoading(
                                isLoading: isLoading,
                                child: _innerFolderItem(
                                    context, index, "All", 1, allTask, folders),
                              )
                            : _innerFolderItem(
                                context, index, "All", 1, allTask, folders);
                      } else {
                        final category = folders[index - 1];
                        final taskCount = _dataFolderInShare
                            .where((item) => (item.category == category &&
                                item.title.isNotEmpty))
                            .length;
                        return isLoading
                            ? ShimmerLoading(
                                isLoading: isLoading,
                                child: _innerFolderItem(context, index,
                                    category, taskCount, totalTask, folders),
                              )
                            : _innerFolderItem(context, index, category,
                                taskCount, totalTask, folders);
                      }
                    },
                  ),
                ),
                SizedBox(height: 32),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: TitleSectionLarge(
                      title: localizations.translate('processingTasks')),
                ),
                SizedBox(height: defaultPadding),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: processingFolders.length,
                  itemBuilder: (context, index) {
                    return isLoading
                        ? ShimmerLoading(
                            isLoading: isLoading,
                            child: _innerTodoItem(context, index,
                                currentLocale.toString(), processingFolders))
                        : _innerTodoItem(context, index,
                            currentLocale.toString(), processingFolders);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _floatingNewFolder(context),
    );
  }

  FloatingActionButton _floatingNewFolder(BuildContext context) {
    late final TextEditingController newFolder = TextEditingController();

    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Column(
              spacing: 12,
              children: [
                Text(AppLocalizations.of(context)!.translate('newFolder')),
                CupertinoTextField(
                  controller: newFolder,
                  placeholder: AppLocalizations.of(context)!
                      .translate('enterNewFolderName'),
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
                  final trimmedFolderName = newFolder.text.toLowerCase().trim();
                  final idFolderName =
                      newFolder.text.toLowerCase().trim().replaceAll(' ', '-');
                  if (trimmedFolderName.isEmpty) {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: Text(
                            AppLocalizations.of(context)!.translate('info')),
                        content: Text(AppLocalizations.of(context)!
                            .translate('newFolderRequired')),
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
                  } else if (folderNames.contains(trimmedFolderName)) {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) => CupertinoAlertDialog(
                        title: Text(
                            AppLocalizations.of(context)!.translate('info')),
                        content: Text(AppLocalizations.of(context)!
                            .translate('folderNameExists')),
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
                    _dataFolderInShare.add(
                      TodoItemData(
                        idTodo: 'new-id-$idFolderName',
                        title: '',
                        category: trimmedFolderName,
                        createdTime: DateTime.now().toString(),
                        categoryCreateTime: DateTime.now().toString(),
                        status: ItemStatus.todo,
                      ),
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ItemsTodoDetail(
                            currentCategory:
                                capitalizeEachWord(trimmedFolderName),
                            onLanguageChanged: (locale) =>
                                langSelected.toString(),
                          );
                        },
                        settings: RouteSettings(
                          arguments: capitalizeEachWord(trimmedFolderName),
                        ),
                      ),
                    );
                  }
                  _saveTodos();
                },
                child: Text(
                  AppLocalizations.of(context)!.translate('addNew'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _folderItem(BuildContext context,
      {required int index,
      required String category,
      required int taskCount,
      required int totalTaskCount,
      required int length}) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: index == length ? 12 : 0,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 170,
          minWidth: 170,
        ),
        child: Card(
          elevation: 1,
          color: Colors.white,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            splashColor: Colors.grey[200]!,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) {
                        return ItemsTodoDetail(
                          currentCategory: category,
                          onLanguageChanged: (locale) =>
                              langSelected.toString(),
                        );
                      },
                      settings: RouteSettings(arguments: category)));
            },
            child: Container(
              padding: EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12,
                children: [
                  Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff99D7DB),
                      ),
                      child:
                          Icon(Icons.list_alt, size: 32, color: Colors.white)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalizeEachWord(category),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        category == "All"
                            ? '$totalTaskCount tasks'
                            : '$taskCount task',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff727272)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _innerFolderItem(BuildContext context, int index, String category,
      int taskCount, int totalTask, List<String> folders) {
    return _folderItem(context,
        index: index,
        category: category,
        taskCount: taskCount,
        totalTaskCount: totalTask,
        length: folders.length);
  }

  SizedBox _todoItem(BuildContext context,
      {required int index,
      required String idTodo,
      required String nameTodo,
      required String date,
      required ItemStatus status,
      required String category,
      String? currentLocale}) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Card(
          elevation: 1,
          color: Colors.white,
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return TodoDetailScreen(
                        idTodo: idTodo,
                        initStatus: status,
                        initCategory: category,
                        onLanguageChanged: (locale) {
                          currentLocale.toString();
                        });
                  },
                ),
              ),
            },
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nameTodo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '$category • ${DateFormat('yyyy MMM dd, HH:MM').format(DateTime.parse(date))}',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff727272)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _innerTodoItem(BuildContext context, int index, String currentLocale,
      Iterable<TodoItemData> processingFolders) {
    return _todoItem(context,
        index: index,
        idTodo: processingFolders.elementAt(index).idTodo,
        nameTodo: processingFolders.elementAt(index).title,
        date: processingFolders.elementAt(index).createdTime,
        status: processingFolders.elementAt(index).status,
        category: processingFolders.elementAt(index).category,
        currentLocale: currentLocale);
  }
}
