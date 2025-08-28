import 'dart:convert';

class ItemModel {
  final int id;
  final String title;
  final String description;
  final String status;
  final DateTime createdDate;

  ItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdDate,
  });

  ItemModel copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    DateTime? createdDate,
  }) {
    return ItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdDate: createdDate ?? this.createdDate,
    );
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
      title: map['title'] ?? '',
      description: map['description'] ?? map['body'] ?? '',
      status: map['status'] ?? 'pending',
      createdDate: DateTime.tryParse(map['createdDate'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) => ItemModel.fromMap(json.decode(source));
}
