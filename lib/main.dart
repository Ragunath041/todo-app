import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color.fromARGB(229, 238, 248, 252),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class Task {
  String value;
  bool completed;
  DateTime date;

  Task({
    required this.value,
    required this.completed,
    required this.date,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController textController;
  List<Task> todoList = [];
  
  get completedList => null;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  addTask(String content, DateTime date) {
    if (content.isNotEmpty) {
      setState(() {
        todoList.add(Task(value: content, completed: false, date: date));
        textController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your Task is Empty, Please Enter the Task...'),
        ),
      );
    }
  }

  List<Task> getCompletedTasks() {
    return todoList.where((task) => task.completed).toList();
  }

  List<Task> getIncompleteTasks() {
    return todoList.where((task) => !task.completed).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('To Do App'),
      //   backgroundColor: Color.fromARGB(255, 251, 252, 253),
      // ),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
                backgroundColor: const Color.fromARGB(229, 238, 248, 252),
                bottom: TabBar(
                  
                  labelColor: const Color.fromARGB(255, 8, 0, 0),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(191),
                    border: Border.all(
                      color: const Color.fromARGB(255, 251, 65, 65), // Outline color
                      width: 1, // Outline width
                    ),
                  ),
                  tabs: const [
                    Tab(text: 'Incomplete'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),

          body: TabBarView(
            children: [
              _buildTaskList(getIncompleteTasks()),
              _buildTaskList(getCompletedTasks(), isCompleted: true),
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
                      onChanged: (content) {},
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
                          DateTime today = DateTime.now();
                          addTask(textController.text, today);
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
            shape: const CircleBorder(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: const BottomAppBar(
            color: Color.fromARGB(255, 255, 255, 255),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.task),
                Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, {bool isCompleted = false}) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskCard(index, tasks, isCompleted: isCompleted);
      },
    );
  }

  Widget _buildTaskCard(int index, List<Task> tasks, {bool isCompleted = false}) {
    return Card(
      color: isCompleted ? const Color.fromARGB(229, 238, 248, 252) : const Color.fromARGB(229, 238, 248, 252),
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        title: Row(
          children: [
            Checkbox(
              value: tasks[index].completed,
              onChanged: (value) {
                setState(() {
                  tasks[index].completed = value ?? false;
                });
              },
            ),
            Expanded(
              child: Text(
                tasks[index].value,
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
                  _deleteItem(index, true);
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

  void _deleteItem(int index, bool isCompleted) {
    setState(() {
      if (isCompleted) {
        todoList.removeAt(index);
      } else {
        completedList.removeAt(index);
      }
    });
  }
}
