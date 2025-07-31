class DailyTaskSubmitModel {
  final int taskId;
  final String doneTime;
  final String remarks;

  DailyTaskSubmitModel({
    required this.taskId,
    required this.doneTime,
    required this.remarks,
  });

  factory DailyTaskSubmitModel.fromMap(Map<String, dynamic> map) {
    return DailyTaskSubmitModel(
      taskId: map['task_id'],
      doneTime: map['done_time'],
      remarks: map['remarks'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'task_id': taskId,
      'done_time': doneTime,
      'remarks': remarks,
    };
  }
}
