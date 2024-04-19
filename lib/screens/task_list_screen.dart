import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/screens/add_task_screen.dart';
import '../providers/task_provider.dart';
import '../widgets/task_list_item.dart';
class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: const Text('Tasks',style: TextStyle(color: Colors.white,fontSize: 18),),),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          final tasks = taskProvider.tasks;
          if (tasks.isEmpty) {
            return const Center(
              child: Text('No tasks available.',style: TextStyle(color: Colors.white),),
            );
          } else {
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskListItem(tasks[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_)=>  AddTaskScreen()));
        },
        child: Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}
