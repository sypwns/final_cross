class StudyNote {
  final int? id;
  final String title;
  final String content;
  final DateTime updatedAt;

  StudyNote({this.id, required this.title, required this.content, required this.updatedAt});

  StudyNote copyWith({int? id, String? title, String? content, DateTime? updatedAt}) {
    return StudyNote(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'content': content,
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory StudyNote.fromMap(Map<String, dynamic> map) => StudyNote(
        id: map['id'] as int?,
        title: map['title'] as String,
        content: map['content'] as String,
        updatedAt: DateTime.parse(map['updatedAt'] as String),
      );
}
