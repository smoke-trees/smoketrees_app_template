import 'dart:convert';

class AppSettings {
  DateTime? updatedAt;
  DateTime? createdAt;
  String? id;
  String? name;
  dynamic value;
  String? type;
  bool? isPublic;

  AppSettings({
    this.updatedAt,
    this.createdAt,
    this.id,
    this.name,
    this.value,
    this.type,
    this.isPublic,
  });

  AppSettings copyWith({
    DateTime? updatedAt,
    DateTime? createdAt,
    String? id,
    String? name,
    bool? value,
    String? type,
    bool? isPublic,
  }) => AppSettings(
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
    id: id ?? this.id,
    name: name ?? this.name,
    value: value ?? this.value,
    type: type ?? this.type,
    isPublic: isPublic ?? this.isPublic,
  );

  factory AppSettings.fromJson(String str) =>
      AppSettings.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AppSettings.fromMap(Map<String, dynamic> json) => AppSettings(
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
    id: json["id"],
    name: json["name"],
    value: json["value"],
    type: json["type"],
    isPublic: json["isPublic"],
  );

  Map<String, dynamic> toMap() => {
    "updatedAt": updatedAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
    "id": id,
    "name": name,
    "value": value,
    "type": type,
    "isPublic": isPublic,
  };
}
