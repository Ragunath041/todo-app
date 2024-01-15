import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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

  addList() {
    if (singleValue.isNotEmpty) {
      setState(() {
        todoList.add({"value": singleValue, "completed": false});
        textController.clear();
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "To Do App",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 210, 186, 139),
          toolbarHeight: 75, 
          bottom: const TabBar(
            labelColor: Colors.white, // Set the label (text) color
            tabs: [
              Tab(text: 'Incomplete'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 246, 242, 230),
        
        body: TabBarView(
          children: [
            buildTaskList(todoList),
            buildTaskList(completedList, isCompleted: true),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add a new task'),
                  content: TextField(
                    controller: textController,
                    onChanged: (content) {
                      addString(content);
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        addList();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Add'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget buildTaskList(List<Map<String, dynamic>> taskList, {bool isCompleted = false}) {
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        return buildTaskCard(index, taskList, isCompleted: isCompleted);
      },
    );
  }

  Widget buildTaskCard(int index, List<Map<String, dynamic>> taskList, {bool isCompleted = false}) {
    return Card(
      color: isCompleted ? const Color.fromARGB(255, 190, 255, 224) : const Color(0xFFFAEED1),
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        title: Row(
          children: [
            Checkbox(
              value: taskList[index]['completed'],
              onChanged: (value) {
                if (isCompleted) {
                  setState(() {
                    taskList[index]['completed'] = false;
                    todoList.add(taskList[index]);
                    completedList.removeAt(index);
                  });
                } else {
                  completeTask(index);
                }
              },
            ),
            Expanded(
              child: Text(
                taskList[index]['value'].toString(),
                style: TextStyle(
                  color: isCompleted ? const Color.fromARGB(255, 16, 1, 1) : const Color.fromARGB(255, 1, 13, 13),
                  fontWeight: FontWeight.bold,
                  decoration: isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
        trailing: isCompleted
            ? IconButton(
                onPressed: () {
                  deleteItem(index, true);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 255, 123, 114),
                ),
              )
            : null,
      ),
    );
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
}



// #C4DFDF
// #D2E9E9
// #E3F4F4
// #F8F6F4