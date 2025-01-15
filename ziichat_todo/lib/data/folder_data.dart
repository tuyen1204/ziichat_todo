import 'package:ziichat_todo/screens/folder/folder_item.dart';

List<TodoItemData> dataFolder = [
  TodoItemData(
    idTodo: "todo-4",
    title: "Todo 4",
    category: "All",
    createdTime: "10:00",
    isDefault: true,
    status: ItemStatus.done,
  ),
  TodoItemData(
    idTodo: "todo-1",
    title:
        "[Research]: Flutter documentation - Assets, Navigation, Routing (cnt)",
    category: "Work",
    createdTime: "10:00",
    status: ItemStatus.progressing,
    note: "Lorem ipsum dolor sit amet, consectet",
  ),
  TodoItemData(
    idTodo: "todo-2",
    title: "Todo 2",
    category: "Music",
    createdTime: "13:00",
    status: ItemStatus.progressing,
  ),
  TodoItemData(
    idTodo: "todo-3",
    title: "Todo 3",
    category: "Music",
    createdTime: "11:00",
    status: ItemStatus.todo,
  ),
  TodoItemData(
    idTodo: "todo-5",
    title: "Todo 5",
    category: "Travel",
    createdTime: "11:00",
    status: ItemStatus.done,
  ),
  TodoItemData(
    idTodo: "todo-6",
    title: "Todo 6 ne",
    category: "Code",
    createdTime: "11:00",
    note: "Note 1234567",
    status: ItemStatus.todo,
  ),
  TodoItemData(
    idTodo: "todo-7",
    title: "Todo 7 ne",
    category: "Code",
    createdTime: "11:00",
    note: "Note 1234567",
    status: ItemStatus.progressing,
  ),
];
