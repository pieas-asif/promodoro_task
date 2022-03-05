import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _todoTextController = TextEditingController();
  List<String> todos = [
    "Do a task",
    "Make it clickable",
    "Make it editable",
  ];

  @override
  void dispose() {
    Hive.close();
    _todoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0xFF264444),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
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
                                "- Work Hard",
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (String todo in todos) Text(todo),
                        ],
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
                              todos.add(_todoTextController.value.text);
                              _todoTextController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ),
                        onSubmitted: (value) {
                          todos.add(value);
                          _todoTextController.clear();
                          setState(() {});
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
