import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:promodoro_task/model/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _todoTextController = TextEditingController();

  void insertIntoDatabase(String task) async {
    Todo todo = Todo()..task = task;
    Box<Todo> box = Hive.box<Todo>("todos");
    box.add(todo);
  }

  void updateTask(Todo todo) {
    todo.done = !todo.done;
    todo.save();
  }

  @override
  void dispose() {
    Hive.close();
    _todoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF264444),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  WindowTitleBarBox(
                    child: Row(
                      children: [
                        CloseWindowButton(),
                        MinimizeWindowButton(),
                        MaximizeWindowButton(),
                        Expanded(
                          child: MoveWindow(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: const [
                            AutoSizeText(
                              "25:00",
                              style: TextStyle(
                                fontSize: 96.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              // maxFontSize: 74.0,
                              minFontSize: 24.0,
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              " Work Hard",
                              style: TextStyle(
                                fontSize: 24.0,
                                // fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              // maxFontSize: 74.0,
                              minFontSize: 12.0,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {},
                    child: const Text(
                      "Start",
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Color(0xFF264444),
                      ),
                    ),
                    color: Colors.white,
                    height: 45,
                    minWidth: double.infinity,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WindowTitleBarBox(
                    child: Row(
                      children: [
                        Expanded(
                          child: MoveWindow(),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Todos",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ValueListenableBuilder<Box<Todo>>(
                      valueListenable: Hive.box<Todo>("todos").listenable(),
                      builder: (context, box, _) {
                        List<Todo> todos = box.values.toList().cast<Todo>();
                        return todoListView(todos);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: TextField(
                      controller: _todoTextController,
                      decoration: InputDecoration(
                        labelText: "Add a new todo",
                        isDense: true,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            insertIntoDatabase(_todoTextController.value.text);
                            _todoTextController.clear();
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ),
                      onSubmitted: (value) {
                        insertIntoDatabase(value);
                        _todoTextController.clear();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget todoListView(List<Todo> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: todos[index].done
              ? const Icon(FeatherIcons.checkCircle)
              : const Icon(FeatherIcons.circle),
          title: Text(
            todos[index].task,
            style: TextStyle(
              decoration: todos[index].done
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
          trailing: PopupMenuButton(
            icon: const Icon(FeatherIcons.moreVertical),
            itemBuilder: (BuildContext context) => <PopupMenuEntry>[
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(FeatherIcons.delete),
                  title: Text('Delete'),
                ),
              ),
            ],
          ),
          onTap: () => updateTask(todos[index]),
        );
      },
    );
  }
}
