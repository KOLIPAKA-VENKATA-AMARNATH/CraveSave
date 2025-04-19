import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseModel {
  String id;
  DateTime createdAt;

  BaseModel({required this.id, required this.createdAt});

  Map<String, dynamic> toMap();

  factory BaseModel.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }
}
