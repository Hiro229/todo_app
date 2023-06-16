import 'package:flutter/material.dart';

// 状態を持たないウィジェットを作成するための基底クラス
class TodoAddDialog extends StatelessWidget {
  const TodoAddDialog(
      // keyは、ウィジェットの一意性や再利用性を管理するためのオブジェクト
      {required this.onAdd,
      required this.textEditingController,
      Key? key})
      : super(key: key);

  final ValueChanged<String> onAdd;
  final TextEditingController textEditingController;

  // AlertDialogは、タイトルとコンテンツとアクションを持つダイアログウィジェット
  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('TODO'),
        // ダイアログの内容
        // TextFieldは、ユーザーがテキストを入力できるウィジェット
        content: TextField(
          // ダイアログが表示されたときにテキストフィールドにフォーカスが移す
          autofocus: true,
          controller: textEditingController,
          // InputDecorationは、ヒントテキストやアイコンなどを設定できるオブジェクト
          decoration: const InputDecoration(hintText: 'やること'),
        ),
        actions: [
          // TextButtonは、背景色がなくてテキストだけがあるボタンウィジェット
          TextButton(
            child: const Text('キャンセル'),
            onPressed: () {
              // 現在の画面からダイアログ画面を削除するメソッド
              Navigator.of(context).pop();
            },
          ),
          // ElevatedButtonは、背景色がありてテキストもあるボタンウィジェット
          ElevatedButton(
            child: const Text('入力する'),
            onPressed: () {
              onAdd(textEditingController.value.text);
              Navigator.of(context).pop();
            },
          ),
        ],
      );
}

Future<T?> showTodoAddDialog<T>(
        {required BuildContext context, required ValueChanged<String> onAdd}) =>
    showDialog<T>(
      context: context,
      // ダイアログの外側をタップしても閉じれない
      barrierDismissible: false,
      // ダイアログの内容を作成する
      builder: (context) => TodoAddDialog(
        // テキストフィールドの値や状態を管理するオブジェクト
        // 空のTextEditingControllerを作成
        textEditingController: TextEditingController(),
        onAdd: onAdd,
      ),
    );
