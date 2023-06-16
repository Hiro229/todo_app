import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/todos/todo.dart';
import '../widgets/dialogs/todo_add_dialog.dart';

class TodosListPage extends StatefulWidget {
  const TodosListPage({Key? key}) : super(key: key);

  @override
  _TodosListPageState createState() => _TodosListPageState();
}

class _TodosListPageState extends State<TodosListPage> {
  // todoを入れる箱
  final List<Todo> _todos = <Todo>[];

  @override
  // BuildContextは、ウィジェットの位置や状態を管理するためのオブジェクト
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todoアプリ'),
      ),
      //スクロール可能なWidget
      body: ListView.builder(
        // リストのindex番目の要素として表示する
        itemBuilder: (context, index) {
          final todo = _todos[index];
          // 指定された方向にスライドしてウィジェットを削除できるようにするウィジェット
          return Dismissible(
            child: Card(
              child: ListTile(
                title: Text(todo.name),
                // タップした時の処理
                onTap: () {
                  setState(() {
                    // isCompletedを反対にしたものを入れる
                    // newが省略されている
                    _todos[index] =
                        Todo(isCompleted: !todo.isCompleted, name: todo.name);
                  });
                },
                // タイルの末尾に表示するウィジェット
                // 達成できたら緑のチェックをカードの末尾に表示
                trailing: todo.isCompleted
                    ? const Icon(
                        Icons.done,
                        color: Colors.green,
                      )
                    : null,
              ),
              // 達成したらカードの背景を緑にする
              color: todo.isCompleted ? Colors.greenAccent : null,
            ),
            // リストの中のウィジェットを一意に識別するためのキーです。
            key: ObjectKey(todo),
            // 削除するかどうかを確認する関数
            confirmDismiss: (direction) async {
              // アプリの現在の内容の上にMaterialデザインのダイアログを表示するための関数
              return await showDialog(
                context: context,
                builder: (context) {
                  // Material Designのアラートダイアログを作成するためのメソッド
                  return AlertDialog(
                    title: const Text('確認'),
                    content: const Text('削除しますか'),
                    actions: [
                      SimpleDialogOption(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('はい'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('いいえ'),
                      ),
                    ],
                  );
                },
              );
            },
            // 横にスワイプされたとき
            onDismissed: (direction) {
              setState(() {
                // indexで指定した項目を削除する
                _todos.removeAt(index);
              });
            },
          );
        },
        itemCount: _todos.length,
      ),
      // Todoの追加ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTodoAddDialog(
              context: context,
              onAdd: (name) {
                setState(() {
                  // insertはListクラスが持つメソッドで、リストの指定した位置に要素を挿入するメソッド
                  // Todoは自分で定義したクラスで、nameという文字列を持つオブジェクト
                  // Todo(name: name)はnameという文字列を引数にしてTodoオブジェクトを作成する式
                  // つまり、この式は_todosの最初の位置に新しいTodoオブジェクトを挿入するという意味
                  _todos.insert(0, Todo(name: name));
                });
              });
        },
        // tooltipは、ボタンに長押ししたときに表示されるテキスト
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
