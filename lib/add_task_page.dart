import 'package:flutter/material.dart';
import 'package:mytodo/task_item.dart';

class AddTaskPage extends StatefulWidget {
  final Function(TaskItemModel) onTaskAdded;

  AddTaskPage({required this.onTaskAdded});

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController _taskController = TextEditingController();
  Color _selectedColor = Colors.blue;
  Duration _selectedDuration = const Duration(minutes: 15);
  TimeOfDay? _selectedCompletionTime;

  final List<Color> _presetColors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.blue,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(labelText: 'New Task'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _openColorPicker();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
              ),
              child: const Text('Select Color'),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                const Text('Select Duration: '),
                DropdownButton<Duration>(
                  value: _selectedDuration,
                  items: const [
                    DropdownMenuItem(
                      value: Duration(minutes: 15),
                      child: Text('15 Minutes'),
                    ),
                    DropdownMenuItem(
                      value: Duration(minutes: 30),
                      child: Text('30 Minutes'),
                    ),
                    DropdownMenuItem(
                      value: Duration(hours: 1),
                      child: Text('1 Hour'),
                    ),
                    DropdownMenuItem(
                      value: Duration(hours: 2),
                      child: Text('2 Hours'),
                    ),
                    DropdownMenuItem(
                      value: Duration(hours: 4),
                      child: Text('4 Hours'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedDuration = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            InkWell(
              onTap: () {
                _selectCompletionTime();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time),
                    const SizedBox(width: 8.0),
                    Text(
                      _selectedCompletionTime != null
                          ? _selectedCompletionTime!.format(context)
                          : 'Select Completion Time',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addTask();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
              ),
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  void _addTask() {
    String newTask = _taskController.text;

    if (newTask.isNotEmpty) {
      TaskItemModel taskItem = TaskItemModel(
        task: newTask,
        color: _selectedColor,
        timestamp: DateTime.now(),
        isCompleted: false,
        completedBackgroundColor: Colors.transparent,
        duration: _selectedDuration,
        completionTime: _selectedCompletionTime != null
            ? _selectedCompletionTime!.format(context)
            : '', // Boş string veya seçilen completion time
      );

      widget.onTaskAdded(taskItem);
      Navigator.pop(context); // Sayfayı kapat
    }
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _presetColors
                  .map(
                    (color) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 30,
                    height: 30,
                    color: color,
                  ),
                ),
              )
                  .toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectCompletionTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedCompletionTime = pickedTime;
      });
    }
  }
}
