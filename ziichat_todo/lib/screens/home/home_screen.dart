import 'package:flutter/material.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:ziichat_todo/screens/buttons/add_item.dart';
import '../folder/folder_detail.dart';
import '../folder/folder_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final danhSachDanhMuc =
        dataFolder.map((item) => item.category).toSet().toList();
    final paddingNotch = MediaQuery.of(context).padding.top;
    final paddingBottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () => {},
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                GridView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final category = danhSachDanhMuc[index];
                    final taskCount = dataFolder
                        .where((item) => item.category == category)
                        .length;
                    final totalTask = dataFolder.length;
                    return _folderItem(
                      context,
                      index: index,
                      category: category,
                      taskCount: taskCount,
                      totalTaskCount: totalTask,
                    );
                  },
                  itemCount: danhSachDanhMuc.length,
                ),
              ],
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
    return Card(
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.grey[200]!,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const TodoDetail(),
                  settings: RouteSettings(arguments: category)));
        },
        child: Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: 12,
            children: [
              Icon(Icons.ballot, size: 32, color: primaryColor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    category == "all"
                        ? '$totalTaskCount tasks'
                        : '$taskCount task',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
