class ToDo {
  String? id;
  String? userId;
  int? serialNumber;
  String? title;
  String? description;
  bool? completed;
  DateTime? createdAt;
  DateTime? updatedAt;

  ToDo({
    this.id,
    this.userId,
    this.serialNumber,
    this.title,
    this.description,
    this.completed,
    this.createdAt,
    this.updatedAt,
  });

  ToDo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    serialNumber = json['serialNumber'];
    title = json['title'];
    description = json['description'];
    completed = json['completed'];
    createdAt = DateTime.parse(json['createdAt']);
    updatedAt = DateTime.parse(json['updatedAt']);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'serialNumber': serialNumber,
    'title': title,
    'description': description,
    'completed': completed,
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  ToDo copyWith({
    String? id,
    String? userId,
    int? serialNumber,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ToDo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serialNumber: serialNumber ?? this.serialNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
