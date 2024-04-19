import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tasks.dart';
import '../providers/task_provider.dart';

class EditTaskScreen extends StatefulWidget {
  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _taskController;
  late Task _task;

  @override
  void initState() {
    _taskController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_taskController.text.isEmpty) {
      _task = ModalRoute.of(context)!.settings.arguments as Task;
      _taskController.text = _task.todo;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Task'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _editTask(context),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _editTask(BuildContext context) async {
    final updatedTask = _task.copyWith(todo: _taskController.text);
    await Provider.of<TaskProvider>(context, listen: false).updateTask(updatedTask);
    Navigator.of(context).pop();
  }

}
