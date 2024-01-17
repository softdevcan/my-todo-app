import 'package:flutter/material.dart';
import 'package:mytodo/task_item.dart';

class EditTaskPage extends StatefulWidget {
  final TaskItemModel taskItem;
  final Function(TaskItemModel) onTaskUpdated;

  EditTaskPage({required this.taskItem, required this.onTaskUpdated});

  @override
  _EditTaskPageState createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  late TextEditingController _taskController;
  late Color _selectedColor;
  late Duration _selectedDuration;
  late TimeOfDay _selectedCompletionTime;

  final List<Color> _presetColors = [
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();

    _taskController = TextEditingController(text: widget.taskItem.task);
    _selectedColor = widget.taskItem.color;
    _selectedDuration = widget.taskItem.duration;

    if (widget.taskItem.completionTime != null &&
        widget.taskItem.completionTime.isNotEmpty) {
      List<String> timeComponents = widget.taskItem.completionTime.split(":");

      if (timeComponents.length == 2) {
        int hour = int.tryParse(timeComponents[0]) ?? 0;
        int minute = int.tryParse(timeComponents[1]) ?? 0;

        _selectedCompletionTime = TimeOfDay(hour: hour, minute: minute);
      } else {
        // Hatalı completionTime formatı durumunda yapılacak işlemler
        // Örneğin varsayılan bir değer kullanabilir veya hata mesajı gösterebilirsiniz.
      }
    } else {
      // completionTime boş veya null durumunda yapılacak işlemler
      // Örneğin varsayılan bir değer kullanabilir veya hata mesajı gösterebilirsiniz.
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _updateTask();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(labelText: 'Task Name'),
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
                      _selectedCompletionTime.format(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateTask() {
    String updatedTask = _taskController.text;

    if (updatedTask.isNotEmpty) {
      TaskItemModel updatedTaskItem = TaskItemModel(
        task: updatedTask,
        color: _selectedColor,
        timestamp: widget.taskItem.timestamp,
        isCompleted: widget.taskItem.isCompleted,
        completedBackgroundColor: widget.taskItem.completedBackgroundColor,
        duration: _selectedDuration,
        completionTime: _selectedCompletionTime.format(context),
      );

      widget.onTaskUpdated(updatedTaskItem);
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
      initialTime: _selectedCompletionTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedCompletionTime = pickedTime;
      });
    }
  }
}


