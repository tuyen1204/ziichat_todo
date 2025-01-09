import 'package:flutter/material.dart';
import 'package:ziichat_todo/constants.dart';
import 'folder/folder_detail.dart';
import 'folder/folder_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
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
                  itemBuilder: (context, index) => _folderItem(
                    context,
                    index: index,
                    folderItem: dataFolder[index],
                  ),
                  itemCount: dataFolder.length,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your logic here
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _folderItem(BuildContext context,
      {required int index, required FolderItem folderItem}) {
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
                  settings: RouteSettings(arguments: folderItem)));
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
                    folderItem.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    folderItem.isDefault == false
                        ? '${folderItem.task.toString()} task'
                        : '${dataFolder.fold(0, (sum, item) => sum + item.task)} task',
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

List<FolderItem> dataFolder = [
  FolderItem(
    title: "All",
    iconName: "All",
    category: "All",
    isDefault: true,
  ),
  FolderItem(
    title: "Work",
    task: 10,
    iconName: "work",
    category: "work",
  ),
  FolderItem(
    title: "Music",
    task: 3,
    iconName: "music",
    category: "music",
  ),
  FolderItem(
    title: "Travel",
    task: 5,
    iconName: "travel",
    category: "music",
  ),
];
