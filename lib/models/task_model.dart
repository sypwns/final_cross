class StudyTask {
   int? id;
   String title;
   String description;
   DateTime deadline;
   String priority;
   bool isCompleted;
   DateTime createdAt;

  StudyTask({
    this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
    required this.isCompleted,
    required this.createdAt,
  });

  StudyTask copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? deadline,
    String? priority,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return StudyTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline.toIso8601String(),
      'priority': priority,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory StudyTask.fromMap(Map<String, dynamic> map) {
    return StudyTask(
      id: map['id'] as int?,
      title: map['title'] as String,
      description: map['description'] as String,
      deadline: DateTime.parse(map['deadline'] as String),
      priority: map['priority'] as String,
      isCompleted: (map['isCompleted'] as int) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
