import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tasks.dart';
import '../providers/task_provider.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  TaskListItem(this.task);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.todo),
      trailing: PopupMenuButton<String>(
        itemBuilder: (context) => <PopupMenuEntry<String>>[ // Explicitly specify the type parameter
          PopupMenuItem(
            value: 'edit',
            child: Text('Edit'),
          ),
          PopupMenuItem(
            value: 'delete',
            child: Text('Delete'),
          ),
        ],
        onSelected: (String value) { // Explicitly specify the type of value
          if (value == 'edit') {
            Navigator.of(context).pushNamed('/edit_task', arguments: task);
          } else if (value == 'delete') {
            _deleteTask(context, task.id);
          }
        },
      ),

      onTap: () {
        task.toggleCompletion();
        Provider.of<TaskProvider>(context, listen: false)
            .updateTaskCompletion(task.id, task.completed);
      },
      leading: Checkbox(
        value: task.completed,
        onChanged: (value) {
          task.toggleCompletion();
          Provider.of<TaskProvider>(context, listen: false)
              .updateTaskCompletion(task.id, task.completed);
        },
      ),
    );
  }

  void _deleteTask(BuildContext context, int taskId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<TaskProvider>(context, listen: false)
                    .deleteTask(taskId, context);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
