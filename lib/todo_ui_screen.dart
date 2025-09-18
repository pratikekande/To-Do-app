import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/database.dart';
import 'package:to_do_app/todo_model.dart';

class TodoUiScreen extends StatefulWidget {
  const TodoUiScreen({super.key});

  @override
  State<TodoUiScreen> createState() => _TodoUiScreenState();
}

class _TodoUiScreenState extends State<TodoUiScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  List<TodoModel> todoCardsList = [];

  List<Color> colorList = [
    Color.fromRGBO(250, 232, 232, 1),
    Color.fromRGBO(232, 237, 250, 1),
    Color.fromRGBO(250, 249, 232, 1),
    Color.fromRGBO(250, 232, 250, 1),
  ];

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    List<Map> cardList = await TodoDatabase().getTodoItem();
    log("CARD LIST: $cardList");
    for (var element in cardList) {
      todoCardsList.add(
        TodoModel(
          date: element['date'],
          description: element['description'],
          title: element['title'],
          id: element['id'],
        ),
      );
    }
    setState(() {});
  }

  void clearController() {
    titleController.clear();
    descriptionController.clear();
    dateController.clear();
  }

  void submit(bool doEdit, [TodoModel? obj]) {
    if (titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        dateController.text.isNotEmpty) {
      if (doEdit) {
        obj!.title = titleController.text;
        obj.description = descriptionController.text;
        obj.date = dateController.text;

        Map<String, dynamic> mapObj = {
          'title': obj.title,
          'description': obj.description,
          'date': obj.date,
          'id': obj.id,
        };
        TodoDatabase().updateTodoItem(mapObj);
      } else {
        todoCardsList.add(
          TodoModel(
            date: dateController.text,
            title: titleController.text,
            description: descriptionController.text,
          ),
        );

        Map<String, dynamic> dataMap = {
          'title': titleController.text,
          'description': descriptionController.text,
          'date': dateController.text,
        };

        TodoDatabase().insertTodoItem(dataMap);
      }

      clearController();
      Navigator.of(context).pop();
      setState(() {});
    }
  }

  showBottomsheet(bool doEdit, [TodoModel? obj]) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add Todo Task",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 10),

              Text(
                "Title",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Enter title",
                ),
              ),

              SizedBox(height: 10),

              Text(
                "Description",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 10),

              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Enter Description",
                ),
              ),

              SizedBox(height: 10),
              Text(
                "Date",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),


                                              //////////////////////////////////////////////////////////
              SizedBox(height: 10),
              TextField(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2026),
                  );

                  String strDate = DateFormat.yMMMd().format(pickedDate!);

                  dateController.text = strDate;
                },

                controller: dateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Select Date",
                  suffixIcon: Icon(Icons.calendar_month),
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (doEdit == true) {
                    submit(true, obj);
                  } else {
                    submit(false);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    Color.fromRGBO(2, 167, 177, 1),
                  ),
                ),

                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log("---IN BUILD---");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Todo App",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(2, 167, 177, 1),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.builder(
          itemCount: todoCardsList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: colorList[index % colorList.length],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.asset(
                                "assets/todo.jpg",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          SizedBox(width: 10),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  todoCardsList[index].title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),

                                Text(
                                  todoCardsList[index].description,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          Text(
                            todoCardsList[index].date,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              titleController.text = todoCardsList[index].title;
                              descriptionController.text =
                                  todoCardsList[index].description;
                              dateController.text = todoCardsList[index].date;

                              showBottomsheet(true, todoCardsList[index]);
                            },

                            child: Icon(
                              Icons.edit,
                              color: Color.fromRGBO(2, 167, 177, 1),
                            ),
                          ),

                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              int id = todoCardsList[index].id;

                              todoCardsList.removeAt(index);
                              TodoDatabase().deleteTodoItem(id);
                              setState(() {});
                            },

                            child: Icon(
                              Icons.delete,
                              color: Color.fromRGBO(2, 167, 177, 1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20), // Space between cards
              ],
            );
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomsheet(false);
        },

        backgroundColor: Color.fromRGBO(2, 167, 177, 1),
        child: Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }
}
