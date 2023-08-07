import 'package:flutter/material.dart';
import 'package:flutter_application_1/task.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TO-DO List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
          labelMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
      ),
      home: const MyHomePage(title: 'TO-DO List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();
  List<Task> tasks = [];

  bool isModifying = false;
  int modifyingIndex = 0;
  double percent = 0.0;

  String getToday() {
    DateTime now = DateTime.now();
    String strToday;
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    strToday = formatter.format(now);
    return strToday;
  }

  void updatePercent() {
    if (tasks.isEmpty) {
      percent = 0.0;
    } else {
      var completeTaskCnt = 0;
      for (var i = 0; i < tasks.length; i++) {
        if (tasks[i].isComplete) {
          completeTaskCnt += 1;
        }
      }
      percent = completeTaskCnt / tasks.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        // 스크롤 화면으로
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(getToday()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: _textController,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_textController.text == '') {
                          return;
                        } else {
                          isModifying
                              ? setState(() {
                                  // 수정
                                  tasks[modifyingIndex].work =
                                      _textController.text;
                                  tasks[modifyingIndex].isComplete = false;
                                  _textController.clear();
                                  modifyingIndex = 0;
                                  isModifying = false;
                                })
                              : setState(
                                  // 추가
                                  () {
                                    var task = Task(_textController.text);
                                    tasks.add(task);
                                    _textController.clear();
                                  },
                                );
                          updatePercent();
                        }
                      },
                      child: isModifying ? const Text("수정") : const Text("추가"),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 50,
                      lineHeight: 14.0,
                      percent: percent,
                    ),
                  ],
                ),
              ),
              for (var i = 0; i < tasks.length; i++)
                Row(
                  children: [
                    Flexible(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.zero),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            tasks[i].isComplete =
                                !tasks[i].isComplete; // bool 값을 반전시킴(toggle시킴)
                            updatePercent();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              tasks[i].isComplete
                                  ? const Icon(Icons.check_box_rounded)
                                  : const Icon(
                                      Icons.check_box_outline_blank_rounded),
                              Text(
                                tasks[i].work,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium, // context로 상위 위젯의 정보를 가져옴
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: isModifying
                          ? null
                          : () {
                              setState(() {
                                isModifying = true;
                                _textController.text = tasks[i].work;
                                modifyingIndex = i;
                              });
                            },
                      child: const Text("수정"),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          // setState없으면 저장해도 바로 적용이 안됨, setState해야 렌더링에 바로 적용됨
                          tasks.remove(tasks[i]);
                          updatePercent();
                        });
                      },
                      child: const Text("삭제"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
