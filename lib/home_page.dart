import 'package:flutter/material.dart';
import 'package:mytodo/edit_task.dart';
import 'add_task_page.dart';
import 'task_item.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TaskItemModel> _taskList = []; // Değişiklik burada

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      appBar: AppBar(
        title: const Text('My Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _taskList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onDoubleTap: () {
                      _toggleTaskCompletion(index);
                    },
                    onLongPress: () {
                      _openEditTaskPage(index);
                    },
                    child: TaskItem(taskItem: _taskList[index], onDelete: () {
                      _deleteTask(index);
                    }),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskPage(
                      onTaskAdded: _addTask,
                    ),
                  ),
                );
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }

  void _addTask(TaskItemModel taskItem) {
    setState(() {
      _taskList.add(taskItem);
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _taskList.removeAt(index);
    });
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _taskList[index] = TaskItemModel(
        task: _taskList[index].task,
        color: _taskList[index].color,
        timestamp: _taskList[index].timestamp,
        isCompleted: !_taskList[index].isCompleted,
        completedBackgroundColor: _taskList[index].isCompleted
            ? Colors.transparent
            : Colors.green,
        duration: _taskList[index].duration,
        completionTime: _taskList[index].completionTime,
      );
    });
  }

  void _openEditTaskPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskPage(
          taskItem: _taskList[index],
          onTaskUpdated: (updatedTaskItem) {
            _updateTask(index, updatedTaskItem);
          },
        ),
      ),
    );
  }

  void _updateTask(int index, TaskItemModel updatedTaskItem) {
    setState(() {
      _taskList[index] = updatedTaskItem;
    });
  }

}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomePage(),
    );
  }
}
