import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/tasks.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    try {
      const url = 'https://dummyjson.com/todos';
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);
      final List<dynamic> tasksData = responseData['todos'];
      _tasks = tasksData.map((taskData) => Task.fromJson(taskData)).toList();
      notifyListeners();
      print('successfully fetched');
    } catch (error) {
      print('Error fetching tasks: $error');
      throw error; // Propagate the error to handle it in the UI
    }
  }

  Future<void> addTask(String task) async {
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
      // You can handle the response data if needed
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateTask(Task updatedTask) async {
    try {
      final response = await http.put(
        Uri.parse('https://dummyjson.com/todos/${updatedTask.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'todo': updatedTask.todo,
          'completed': updatedTask.completed,
          'userId': updatedTask.userId,
        }),
      );
      final responseData = json.decode(response.body);
      // You can handle the response data if needed
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateTaskCompletion(int taskId, bool completed) async {
    try {
      final response = await http.put(
        Uri.parse('https://dummyjson.com/todos/$taskId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'completed': completed}),
      );
      final responseData = json.decode(response.body);
      // You can handle the response data if needed
    } catch (error) {
      throw error;
    }
  }
  Future<void> deleteTask(int taskId, BuildContext context) async {
    try {
      final url = 'https://dummyjson.com/todos/$taskId';
      await http.delete(Uri.parse(url));
      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task deleted successfully.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (error) {
      throw error;
    }
  }

}
