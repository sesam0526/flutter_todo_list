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

  String getToday() {
    DateTime now = DateTime.now();
    String strToday;
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    strToday = formatter.format(now);
    return strToday;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
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
                        setState(() {
                          var task = Task(_textController.text);
                          tasks.add(task);
                          _textController.clear();
                        });
                      }
                    },
                    child: const Text("Add"),
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
                    percent: 0.3,
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
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check_box_outline_blank_rounded),
                            Text(tasks[i].work),
                          ],
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("수정"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        // setState없으면 저장해도 바로 적용이 안됨, setState해야 렌더링에 바로 적용됨
                        tasks.remove(tasks[i]);
                      });
                    },
                    child: const Text("삭제"),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
