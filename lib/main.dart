import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> todoList = [];
  List<Map<String, dynamic>> completedList = [];
  String singleValue = "";
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  addString(content) {
    setState(() {
      singleValue = content;
    });
  }

  // addList() {
  //   if (singleValue.isNotEmpty) {
  //     setState(() {
  //       todoList.add({"value": singleValue, "completed": false});
  //       textController.clear();
  //     });
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Your Task is Empty, Please Enter the Tasks......'),
  //       ),
  //     );
  //   }
  // }

  addList() {
  if (singleValue.isNotEmpty) {
    setState(() {
      todoList.add({"value": singleValue, "completed": false});
      textController.clear();  // Clear the input field after adding the task
    });
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Your Task is Empty, Please Enter the Tasks......'),
      ),
    );
  }
}


  completeTask(index) {
    setState(() {
      todoList[index]['completed'] = true;
      completedList.add(todoList[index]);
      todoList.removeAt(index);
    });
  }

  deleteItem(index, isCompleted) {
    setState(() {
      if (isCompleted) {
        completedList.removeAt(index);
      } else {
        todoList.removeAt(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "To-Do App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        toolbarHeight: 75,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              flex: 90,
              child: ListView.builder(
                itemCount: todoList.length + completedList.length,
                itemBuilder: (context, index) {
                  if (index < todoList.length) {
                    return buildTaskCard(index, todoList);
                  } else {
                    return buildTaskCard(index - todoList.length, completedList, isCompleted: true);
                  }
                },
              ),
            ),
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: 70,
                    child: SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: textController,
                        onChanged: (content) {
                          addString(content);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          fillColor: const Color.fromARGB(255, 248, 248, 249),
                          filled: true,
                          labelText: 'Task....',
                          labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 118, 122, 159),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    flex: 3,
                    child: SizedBox(
                      width: 5,
                    ),
                  ),
                  Expanded(
                    flex: 27,
                    child: ElevatedButton(
                      onPressed: () {
                        addList();
                      },
                      child: Container(
                        height: 15,
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const Text("Add"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTaskCard(int index, List<Map<String, dynamic>> taskList, {bool isCompleted = false}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: isCompleted ? Colors.greenAccent : const Color.fromARGB(255, 216, 229, 243),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: Checkbox(
                  value: taskList[index]['completed'],
                  onChanged: (value) {
                    if (isCompleted) {
                      // Handle unchecking completed tasks (move back to todoList)
                      setState(() {
                        taskList[index]['completed'] = false;
                        todoList.add(taskList[index]);
                        completedList.removeAt(index);
                      });
                    } else {
                      // Handle checking todo tasks (move to completedList)
                      completeTask(index);
                    }
                  },
                ),
              ),
              Expanded(
                flex: 70,
                child: Text(
                  taskList[index]['value'].toString(),
                  style: TextStyle(
                    color: isCompleted ? Colors.white : const Color.fromARGB(255, 37, 95, 243),
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
              ),
              Expanded(
                flex: 20,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: isCompleted ? Colors.white : const Color.fromARGB(255, 226, 9, 9),
                  child: TextButton(
                    onPressed: () {
                      if (isCompleted) {
                        deleteItem(index, true);
                      } else {
                        completeTask(index);
                      }
                    },
                    child: const Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
