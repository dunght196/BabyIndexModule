
import 'package:babyindexmodule/model/child.dart';

class ChildResponse {
  final List<Child> data;

  ChildResponse(this.data);

  ChildResponse.fromJson(Map<String, dynamic> json)
      : data = (json["data"] as List).map((child) => Child.fromJson(child)).toList();
}