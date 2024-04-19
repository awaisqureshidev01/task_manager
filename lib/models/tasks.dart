class Task {
  final int id;
  final String todo;
  bool completed;
  final int userId;

  Task({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  Task copyWith({
    int? id,
    String? todo,
    bool? completed,
    int? userId,
  }) {
    return Task(
      id: id ?? this.id,
      todo: todo ?? this.todo,
      completed: completed ?? this.completed,
      userId: userId ?? this.userId,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'],
      userId: json['userId'],
    );
  }

  // Method to toggle task completion status
  void toggleCompletion() {
    completed = !completed;
  }
}
