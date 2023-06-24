import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todo_app/redux/actions/todos_actions.dart';
import 'package:todo_app/redux/middleware/app_middleware.dart';
import 'package:todo_app/redux/reducers/app_reducer.dart';
import 'package:todo_app/redux/states/app_state.dart';
import 'package:todo_app/views/pages/todos_list_page.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.initialize(), middleware: appMiddleware);

  runApp(MyApp(store: store));

  store.dispatch(const TodosLoadAction());
}

class MyApp extends StatelessWidget {
  const MyApp({key, required this.store}) : super(key: key);
  final Store<AppState> store;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screen_width = MediaQuery.of(context).size.width;
    final screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text(
          'Main Page',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // 中央ではなく上部から始める
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                fixedSize: Size(screen_width * 0.7, screen_height * 0.05),
              ),
              child: Text('Tween Staggered Page'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TodosListPage()));
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
