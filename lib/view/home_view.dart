import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:promodoro_task/model/constants.dart';
import 'package:promodoro_task/model/todo.dart';
import 'package:soundpool/soundpool.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _todoTextController = TextEditingController();
  final Soundpool _soundpool = Soundpool.fromOptions();
  Timer? _timer;
  int? soundId;
  int? alarmTimer;
  late int iterator;
  late int timerStage;
  late String displayTimer;
  late String displayMessage;
  late Color timerColor;
  bool startButton = true;

  @override
  void initState() {
    super.initState();
    iterator = 1;
    timerStage = 1;
    setAlarmTimer();
    fetchSoundId();
  }

  setAlarmTimer() {
    setState(() {
      switch (timerStage) {
        case 1:
          alarmTimer = 25 * 60;
          displayTimer = "25:00";
          displayMessage = "Work hard";
          timerColor = PresetColors.primaryWork;
          break;
        case 2:
          alarmTimer = 5 * 60;
          displayTimer = "05:00";
          displayMessage = "Take a break";
          timerColor = PresetColors.primaryShortBreak;
          break;
        case 3:
          alarmTimer = 10 * 60;
          displayTimer = "15:00";
          displayMessage = "Take a walk or exercise";
          timerColor = PresetColors.primaryLongBreak;
          break;
        default:
          alarmTimer = 5;
      }
    });
  }

  handleButtonPress() {
    if (startButton) {
      iterator++;
      if (iterator > 5) {
        timerStage = 3;
        iterator = 0;
      } else {
        if (iterator % 2 == 0) {
          timerStage = 2;
        } else {
          timerStage = 1;
        }
      }
      startButton = false;
      setState(() {});
      startTimer();
    } else {
      if (_timer != null) {
        _timer?.cancel();
        startButton = true;
        setState(() {});
      }
    }
  }

  startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      alarmTimer = alarmTimer! - 1;
      int temp = alarmTimer! % 60;
      String minute = (alarmTimer! ~/ 60).toString();
      String second = temp.toString();

      setState(() {
        displayTimer =
            "${minute.length < 2 ? "0" : ""}$minute:${second.length < 2 ? "0" : ""}$second";
      });
      if (alarmTimer == 0) {
        if (soundId != null) await _soundpool.play(soundId!);
        _timer?.cancel();
        startButton = true;
        setAlarmTimer();
        setState(() {});
      }
    });
  }

  fetchSoundId() async {
    int id = await rootBundle
        .load("assets/sounds/beep.m4a")
        .then((ByteData soundData) {
      return _soundpool.load(soundData);
    });
    setState(() => soundId = id);
  }

  void insertIntoDatabase(String task) async {
    Todo todo = Todo()..task = task;
    Box<Todo> box = Hive.box<Todo>("todos");
    box.add(todo);
  }

  void updateTask(Todo todo) {
    todo.done = !todo.done;
    todo.save();
  }

  void deleteTask(Todo todo) {
    todo.delete();
  }

  @override
  void dispose() {
    Hive.close();
    _todoTextController.dispose();
    _soundpool.dispose();
    _timer?.cancel();
    soundId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PresetColors.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timer Side
          Expanded(
            flex: 2,
            child: AnimatedContainer(
              color: timerColor,
              padding: const EdgeInsets.all(20.0),
              duration: const Duration(milliseconds: 500),
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
                          children: [
                            AutoSizeText(
                              displayTimer,
                              style: const TextStyle(
                                fontSize: 96.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              // maxFontSize: 74.0,
                              minFontSize: 24.0,
                              maxLines: 1,
                            ),
                            AutoSizeText(
                              " $displayMessage",
                              style: const TextStyle(
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
                    onPressed: handleButtonPress,
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
          // Todo Side
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
              PopupMenuItem(
                child: ListTile(
                  leading: const Icon(FeatherIcons.delete),
                  title: const Text('Delete'),
                  onTap: () {
                    Navigator.pop(context);
                    deleteTask(todos[index]);
                  },
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
