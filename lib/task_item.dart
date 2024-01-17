import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final TaskItemModel taskItem;
  final VoidCallback onDelete;

  const TaskItem({required this.taskItem, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Köşe yuvarlama
        color: taskItem.isCompleted
            ? Colors.green
            : Colors.blueGrey, // Gri renk eklendi
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Kenar boşlukları
      padding: const EdgeInsets.all(16.0), // İçerik boşluğu
      child: ListTile(
        leading: CircleAvatar(
          radius: 15,
          backgroundColor: taskItem.color,
        ),
        title: taskItem.isCompleted
            ? Text(
          taskItem.task,
          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
          ),
        )
            : Text(taskItem.task),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duration: ${taskItem.duration.inMinutes} minutes'),
            Text('Completion Time: ${taskItem.completionTime}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

class TaskItemModel {
  final String task;
  final Color color;
  final DateTime timestamp;
  final bool isCompleted;
  final Color? completedBackgroundColor; // Nullable Color eklendi
  final Duration duration;
  final String completionTime;

  TaskItemModel({
    required this.task,
    required this.color,
    required this.timestamp,
    required this.isCompleted,
    this.completedBackgroundColor, // Nullable Color eklendi
    required this.duration,
    required this.completionTime,
  });
}
