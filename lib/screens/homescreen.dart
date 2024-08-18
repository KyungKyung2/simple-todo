import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/add_task.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> todoList = [];

  void addTodo({required String todoText}) {
    if (todoList.contains(todoText)) {
      // todoList에서 중복을 확인
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Already exists"),
            content: Text("This task already exists."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close"),
              ),
            ],
          );
        },
      );
      return;
    }
    setState(() {
      todoList.insert(0, todoText);
    });
    writeLocalData();
    Navigator.pop(context);
  }

  void writeLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('todoList', todoList);
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      todoList = (prefs.getStringList('todoList') ?? []).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Kyungwon"),
              accountEmail: Text("lkw081312@gmail.com"),
              currentAccountPicture: CircleAvatar(),
            ),
            ListTile(
              onTap: () {
                launchUrl(
                  Uri.parse("https://www.instagram.com/l.kyung1/"),
                );
              },
              leading: Icon(Icons.add_a_photo_outlined),
              title: Text("About me"),
            ),
            ListTile(
              onTap: () {
                launchUrl(
                  Uri.parse("http://www.gmail.com"),
                );
              },
              leading: Icon(Icons.mail_outline_outlined),
              title: Text("About me"),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.account_tree_outlined),
              title: Text("Share"),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("TODO App"),
        centerTitle: true,
      ),
      body: (todoList.isEmpty)
          ? Center(
        child: Text(
          "No items on the list",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      )
          : ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            background: Container(
              color: Colors.red,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.check),
                  ),
                ],
              ),
            ),
            onDismissed: (direction) {
              setState(() {
                todoList.removeAt(index);
              });
              writeLocalData();
            },
            child: ListTile(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            todoList.removeAt(index);
                          });
                          writeLocalData();
                          Navigator.pop(context);
                        },
                        child: Text("Task done!"),
                      ),
                    );
                  },
                );
              },
              title: Text(todoList[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: MediaQuery
                    .of(context)
                    .viewInsets,
                child: Container(
                  height: 250,
                  child: AddTask(
                    addTodo: addTodo,
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white,),
      ),
    );
  }
}
