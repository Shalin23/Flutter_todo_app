import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool activateCancelButton = false;
  List<List<String>> toDos = [
    ["Brush", "7.30 AM", "true"],
    ["Meditation", "7.35 AM", "true"],
    ["Breakfast", "7.45 AM", "true"],
    ["Tuition", "8.30 PM", "true"],
    ["Assignments", "11.15 pM", "true"]
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.tealAccent[100],
        body: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    "assets/images/task-list1.png",
                    fit: BoxFit.fill,
                  )),
            ),
            const Positioned(
              child: Text(
                "To Do List",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              top: 35,
              left: 20,
            ),
            DraggableScrollableSheet(builder:
                (BuildContext context, ScrollController scrollController) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                      itemCount: toDos.length,
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(toDos[index][0]),
                            subtitle: Text(toDos[index][1]),
                            isThreeLine: true,
                            onLongPress: () {
                              activateCancelButton = true;
                              setState(() {});
                            },
                            leading: activateCancelButton
                                ? IconButton(
                                    onPressed: () {
                                      toDos.remove(toDos[index]);
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.cancel),
                                    color: Colors.grey,
                                  )
                                : (toDos[index][2] == "true"
                                    ? IconButton(
                                        onPressed: () {
                                          toDos[index][2] = "false";
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.check_circle),
                                        color: Colors.green,
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          toDos[index][2] = "true";
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.circle_outlined),
                                        color: Colors.grey,
                                      )
                                    ),
                          ),
                        );
                      }),
                ],
              );
            }),
            Positioned(
              child: FloatingActionButton(
                child: activateCancelButton
                    ? const Icon(Icons.done)
                    : const Icon(Icons.add),
                onPressed: () {
                  if (activateCancelButton) {
                    activateCancelButton = false;
                  } else {
                    _showMyDialog();
                  }
                  setState(() {});
                },
                backgroundColor: activateCancelButton? Colors.grey: Colors.green,
              ),
              bottom: 15,
              right: 20,
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController _todo = TextEditingController();
  final TextEditingController _time = TextEditingController();

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                    controller: _todo,
                    decoration: const InputDecoration(hintText: "ToDo")),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _time,
                  decoration: const InputDecoration(hintText: "Time "),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                _todo.text = "";
                _time.text = "";
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add ToDo'),
              onPressed: () {
                toDos.add([_todo.text, _time.text, "false"]);
                _todo.text = "";
                _time.text = "";
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }
}
