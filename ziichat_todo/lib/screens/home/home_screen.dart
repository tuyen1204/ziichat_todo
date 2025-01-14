import 'package:flutter/material.dart';
import 'package:ziichat_todo/component/title_section_large.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:ziichat_todo/data/folder_data.dart';
import 'package:ziichat_todo/screens/folder/folder_detail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final folders = dataFolder.map((item) => item.category).toSet().toList();
    final totalTask = dataFolder.length;
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'ZiiChat Todo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ],
        ),
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
                  child: TitleSectionLarge(title: "Folders"),
                ),
                SizedBox(height: defaultPadding),
                SizedBox(
                  width: double.infinity,
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: folders.length,
                    itemBuilder: (context, index) {
                      final category = folders[index];
                      final taskCount = dataFolder
                          .where((item) => item.category == category)
                          .length;
                      return _folderItem(context,
                          index: index,
                          category: category,
                          taskCount: taskCount,
                          totalTaskCount: totalTask,
                          length: folders.length);
                    },
                  ),
                ),
                SizedBox(height: 32),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: TitleSectionLarge(title: "Processing tasks"),
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
      required int totalTaskCount,
      required int length}) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 180,
        minWidth: 180,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: index == length - 1 ? 16 : 0,
        ),
        child: Card(
          elevation: 0,
          color: Color(0xffE0EBDD),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 12,
                children: [
                  Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff99D7DB),
                      ),
                      child:
                          Icon(Icons.list_alt, size: 32, color: Colors.white)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
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
}
