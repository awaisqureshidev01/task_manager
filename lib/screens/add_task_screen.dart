import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addTask(BuildContext context) async {
    final task = _taskController.text.trim();
    if (task.isEmpty) {
      // Show error message if task is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a task.'),
          backgroundColor: Colors.red.withOpacity(0.8),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Set loading state
    setState(() {
      _isLoading = true;
    });

    // API request to add task
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/todos/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'todo': task,
          'completed': false,
          'userId': 5,
        }),
      );
      final responseData = json.decode(response.body);
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task added successfully.'),
          backgroundColor: Colors.green.withOpacity(0.8),
          duration: Duration(seconds: 2),
        ),
      );
      // Clear input field after adding task
      _taskController.clear();
    } catch (error) {
      // Show error message if API request fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding task: $error'),
          backgroundColor: Colors.red.withOpacity(0.8),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      // Reset loading state
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Add Task',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _taskController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Task',
                  labelStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none, // Remove border
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _addTask(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.indigo,
              ),
              child: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : const Text(
                'Add Task',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
