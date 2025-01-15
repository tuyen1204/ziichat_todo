import 'package:flutter/material.dart';
import 'package:ziichat_todo/component/title_section_large.dart';
import 'package:ziichat_todo/constants.dart';
import 'package:ziichat_todo/data/folder_data.dart';
import 'package:ziichat_todo/screens/folder/folder_detail.dart';
import 'package:ziichat_todo/screens/folder/folder_item.dart';
import 'package:ziichat_todo/screens/item/todo_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final folders = dataFolder.map((item) => item.category).toSet().toList();
    final processingFolders =
        dataFolder.where((item) => item.status == ItemStatus.progressing);
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
                  height: 180,
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
                SizedBox(height: defaultPadding),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: processingFolders.length,
                  itemBuilder: (context, index) {
                    return _todoItem(context,
                        index: index,
                        idTodo: processingFolders.elementAt(index).idTodo,
                        nameTodo: processingFolders.elementAt(index).title,
                        date: processingFolders.elementAt(index).createdTime,
                        status: statusToReadableString(
                            processingFolders.elementAt(index).status),
                        category: processingFolders.elementAt(index).category);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _todoItem(BuildContext context,
      {required int index,
      required String idTodo,
      required String nameTodo,
      required String date,
      required String status,
      required String category}) {
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
                      onDeleteTodoItem: (id) {},
                    );
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
                    date,
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

  Widget _folderItem(BuildContext context,
      {required int index,
      required String category,
      required int taskCount,
      required int totalTaskCount,
      required int length}) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: index == length - 1 ? 12 : 0,
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
