import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_app/redux/redux.dart';

import '../../models/models.dart';
import '../../views/views.dart';

// class TodosListPage extends StatefulWidget {
//   const TodosListPage({Key? key}) : super(key: key);
//
//   @override
//   _TodosListPageState createState() => _TodosListPageState();
// }

// class _TodosListPageState extends StatefulWidget {
class TodosListPage extends StatelessWidget {
  const TodosListPage({key}) : super(key: key);

  @override
  // BuildContextは、ウィジェットの位置や状態を管理するためのオブジェクト
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redux Todoアプリ'),
      ),
      //スクロール可能なWidget
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromStore(store),
        builder: (context, viewModel) {
          final todos = viewModel.todos;
          return ListView.builder(
            // リストのindex番目の要素として表示する
            itemBuilder: (context, index) {
              final todo = todos[index];
              // 指定された方向にスライドしてウィジェットを削除できるようにするウィジェット
              return Dismissible(
                key: ObjectKey(todo),
                onDismissed: (direction) {
                  viewModel.deleteAt(index);
                },
                child: Card(
                  // 達成したらカードの背景を緑にする
                  color: todo.isCompleted ? Colors.greenAccent : null,
                  child: ListTile(
                    title: Text(todo.name),
                    // タップした時の処理
                    onTap: () {
                      viewModel.toggleComplete(index);
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
                ),
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
              );
            },
            itemCount: todos.length,
          );
        },
      ),
      // Todoの追加ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showTodoAddDialog(context: context);
        },
        // tooltipは、ボタンに長押ししたときに表示されるテキスト
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ViewModel {
  _ViewModel.fromStore(Store<AppState> store)
      : _store = store,
        todos = store.state.todosState.todos;

  final List<Todo> todos;
  final Store<AppState> _store;

  @override
  // ignore: hash_and_equals
  bool operator ==(other) {
    if (other is _ViewModel) {
      if (other.todos == todos) {
        return true;
      }
      if (other.todos.length != todos.length) {
        return false;
      }
      for (var index = 0; index < todos.length; index++) {
        if (other.todos[index] != todos[index]) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  void deleteAt(int index) {
    _store.dispatch(TodoDeleteAction(todos[index].id));
  }

  void toggleComplete(int index) {
    _store.dispatch(TodoToggleCompletionAction(todos[index].id));
  }
}
