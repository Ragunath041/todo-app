import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List todoList = [];
  String singlevalue = "";
  // List <Map<String,dynamic>> todoList = [];
  late TextEditingController textController;

  @override
  void initState(){
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose(){
    textController.dispose();
    super.dispose();
  }

  addString(content) {
    setState(() {
      singlevalue = content;
    });
  }

  addList() {
    setState(() {
      todoList.add({"value": singlevalue});
    });
  }

  deleteItem(index) {
    setState(() {
      todoList.removeAt(index);
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
        // leading: IconButton(
        //   icon: const Icon(Icons.menu),
        //   onPressed: () {},
        // ),
        // elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              flex: 90,
              child: ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: const Color.fromARGB(255, 194, 206, 254),
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
                                flex: 80,
                                child: Text(
                                  todoList[index]['value'].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 20,
                                 child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: const Color.fromARGB(255, 226, 9, 9),
                                  child: TextButton(
                                    onPressed: () => deleteItem(index),
                                    child: const Align(
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    );
                  }),
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
                              )),
                        ),
                      ),
                    ),
                    const Expanded(
                        flex: 3,
                        child: SizedBox(
                          width: 5,
                        )),
                    Expanded(
                        flex: 27,
                        child: ElevatedButton(
                          onPressed: () {
                            addList();
                            textController.clear();
                          },
                          child: Container(
                              height: 15,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: const Text("Add")),
                        )),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
