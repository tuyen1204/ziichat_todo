import 'package:flutter/material.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:ziichat_todo/data/color_pallet.dart';
import 'package:ziichat_todo/data/folder_data.dart';
import '../folder/folder_detail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final folders = dataFolder.map((item) => item.category).toSet().toList();
    final colorFolder =
        inputColorItems.map((item) => item.category).toSet().toList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => {},
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                spacing: defaultPadding,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lists',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(folders.length, (index) {
                        final category = folders[index];
                        final categoryStyle = colorFolder[index];
                        final taskCount = dataFolder
                            .where((item) => item.category == category)
                            .length;
                        final colorCategory =
                            colorFolder.where((item) => item == categoryStyle);
                        final totalTask = dataFolder.length;
                        // print(category);
                        // print(colorCategory);
                        return _folderItem(
                          context,
                          index: index,
                          category: category,
                          taskCount: taskCount,
                          totalTaskCount: totalTask,
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // floatingActionButton: AddItemButton(
      //   paddingNotch: paddingNotch,
      //   paddingBottom: paddingBottom,
      // ),
    );
  }

  Widget _folderItem(BuildContext context,
      {required int index,
      required String category,
      required int taskCount,
      required int totalTaskCount}) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0.5,
        color: Colors.white,
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          splashColor: Colors.grey[200]!,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) {
                      return TodoDetail(
                        currentCategory: category,
                      );
                    },
                    settings: RouteSettings(arguments: category)));
          },
          child: Container(
            padding: EdgeInsets.all(defaultPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 16,
              children: [
                Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xff99D7DB),
                    ),
                    child: Icon(Icons.list_alt, size: 32, color: Colors.white)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        category == "All"
                            ? '$totalTaskCount tasks'
                            : '$taskCount task',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_vert_outlined),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
