# ziichat_todo

A new Flutter project.

Phrase 1 -------------------
Create, Edit, Delete FOLDER item.
Create, Edit, Delete TODO item.

    * FOLDER item
        luôn có 1 folder default, trường hợp tạo TODO item nhưng không chọn Folder sẽ đưa vào folder mặc định này
        todo app có thể thêm sửa xoá folder (trừ folder mặc định)
        mỗi folder có thể có nhiều todo item
        chỉ có thể xoá folder rỗng

    * TODO item
        mỗi todo item cần ghi được thời gian nhập vào, chỉnh sửa, và thể hiện đang ở folder nào
        có trạng thái (todo, inprogress, pending, done) và note (optional)
        có thể di chuyển sang folder khác
        có ghi lại thời gian edit cuối cùng


    Done:
        - Data: Create data of Folder

        - Screen Home
            + UI List Folder
            + Get data Folder
            + Handle navigation to folder detail page

        - Screen Folder detail
            + UI folder detail
            + Get data item in folder

Phrase 2 -------------------
Lưu data ở SharedPreferences
Cho phép sort theo trạng thái và thời gian edit
i18n
Pagination:
mỗi trang chỉ hiển thị (n) item
hiển thị skeleton khi vuốt chuyển trang khác

Phrase 3 -------------------
Run được trên desktop (responsive)
Có thể import / export file excel
Có file import mẫu
Cho export file theo 2 cách
Export tất cả TODO item được chọn
Export theo FOLDER được chọn

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
