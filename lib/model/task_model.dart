class TaskModel {
  // Fields of the Task model
  int id;
  String taskName;
  DateTime dueDate;
  String assign;
  String status;

  // Constructor for the Task class
  TaskModel({
    required this.id,
    required this.taskName,
    required this.dueDate,
    required this.assign,
    required this.status,
  });

  // Factory constructor to create a Task from a JSON object
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      taskName: json['taskName'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      assign: json['assign'] as String,
      status: json['status'] as String,
    );
  }

  // Method to convert a Task object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskName': taskName,
      'dueDate': dueDate.toIso8601String(),
      'assign': assign,
      'status': status,
    };
  }

  @override
  String toString() {
    return 'Task{id: $id, taskName: $taskName, dueDate: $dueDate, assign: $assign, status: $status}';
  }
}
