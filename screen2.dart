import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import DateFormat

enum RepeatOption { None, Daily, Weekly, Monthly }

enum Importance { Low, Medium, High }

class Task {
  String title;
  bool finish;
  DateTime? dateTime; // Added DateTime parameter
  RepeatOption repeatOption; // Added repeat option
  Importance importance; // Added importance option
  Task({
    required this.title,
    this.finish = false,
    this.dateTime,
    this.repeatOption = RepeatOption.None,
    this.importance = Importance.Medium,
  });
}

class Screen2 extends StatefulWidget {
  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  List<Task> tasks = [];
  TextEditingController taskController = TextEditingController();
  TextEditingController dateTimeController =
      TextEditingController(); // Controller for date and time
  RepeatOption selectedRepeatOption = RepeatOption.None;
  Importance selectedImportance = Importance.Medium;

  void addTask(String titles, DateTime? dateTime, RepeatOption repeatOption,
      Importance importance) {
    setState(() {
      if (repeatOption == RepeatOption.None) {
        tasks.add(Task(
            title: titles,
            dateTime: dateTime,
            repeatOption: repeatOption,
            importance: importance));
      } else {
        // Add one initial task
        tasks.add(Task(
            title: titles,
            dateTime: dateTime,
            repeatOption: repeatOption,
            importance: importance));

        // Add two additional tasks with incremented dates based on repeat frequency
        for (int i = 1; i <= 2; i++) {
          DateTime? newDateTime;
          switch (repeatOption) {
            case RepeatOption.Daily:
              newDateTime = dateTime!.add(Duration(days: i));
              break;
            case RepeatOption.Weekly:
              newDateTime = dateTime!.add(Duration(days: i * 7));
              break;
            case RepeatOption.Monthly:
              newDateTime =
                  DateTime(dateTime!.year, dateTime.month + i, dateTime.day);
              break;
            default:
              newDateTime = null;
          }
          tasks.add(Task(
            title: titles,
            dateTime: newDateTime,
            repeatOption: repeatOption,
            importance: importance,
          ));
        }
      }

      taskController.clear();
      dateTimeController.clear();
      tasks.sort((a, b) {
        if (a.dateTime == null || b.dateTime == null) {
          return 0;
        }
        final now = DateTime.now();
        final differenceA = a.dateTime!.difference(now).abs();
        final differenceB = b.dateTime!.difference(now).abs();
        return differenceA.compareTo(differenceB);
      });
    });
  }

  void editTask(int index, String newTitle) {
    setState(() {
      tasks[index].title = newTitle;
    });
  }

  void editTaskItem(BuildContext context, int index) {
    TextEditingController _editController =
        TextEditingController(text: tasks[index].title);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: _editController,
            decoration: InputDecoration(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                editTask(index, _editController.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            )
          ],
        );
      },
    );
  }

  Future<DateTime?> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? timePicked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (timePicked != null) {
        return DateTime(picked.year, picked.month, picked.day, timePicked.hour,
            timePicked.minute);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ArNa to do list'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: taskController,
                    decoration: InputDecoration(
                        labelText: 'Enter task',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            final DateTime? pickedDateTime =
                                await _selectDateTime(context);
                            if (taskController.text.isNotEmpty &&
                                pickedDateTime != null) {
                              _selectImportance(context, pickedDateTime);
                            }
                          },
                        )),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _selectImportance(context, null);
                      }
                    },
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  Color taskColor = tasks[index].importance == Importance.High
                      ? Colors.yellow
                      : Colors.blue;
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tasks[index].title,
                          style: TextStyle(color: taskColor),
                        ),
                        if (tasks[index].dateTime != null)
                          Text(
                            DateFormat('yyyy/MM/dd HH:mm').format(
                              tasks[index].dateTime!,
                            ), // Format date and time
                          ),
                        Text('Repeat: ${tasks[index].repeatOption}'),
                        Text('Importance: ${tasks[index].importance}'),
                      ],
                    ),
                    onTap: () {
                      editTaskItem(context, index);
                    },
                    trailing: Checkbox(
                      value: tasks[index].finish,
                      onChanged: (value) {
                        setState(() {
                          tasks[index].finish = value ?? false;
                        });
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _selectImportance(BuildContext context, DateTime? pickedDateTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Importance Level'),
          content: DropdownButton<Importance>(
            value: selectedImportance,
            onChanged: (newValue) {
              setState(() {
                selectedImportance = newValue!;
              });
              _selectRepeatOption(context, pickedDateTime);
            },
            items: Importance.values
                .map<DropdownMenuItem<Importance>>((importance) {
              return DropdownMenuItem<Importance>(
                value: importance,
                child: Text(importance.toString().split('.').last),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _selectRepeatOption(BuildContext context, DateTime? pickedDateTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Repeat Option'),
          content: DropdownButton<RepeatOption>(
            value: selectedRepeatOption,
            onChanged: (newValue) {
              setState(() {
                selectedRepeatOption = newValue!;
              });
              addTask(taskController.text, pickedDateTime, selectedRepeatOption,
                  selectedImportance);
            },
            items: RepeatOption.values
                .map<DropdownMenuItem<RepeatOption>>((option) {
              return DropdownMenuItem<RepeatOption>(
                value: option,
                child: Text(option.toString().split('.').last),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
