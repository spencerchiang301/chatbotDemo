import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class UserData {
  String? name;
  String? email;
  String? password;
  DateTime? createdDate;
  String? timestamp;
  String? responseResult;
  String? responseStatus;

  UserData({
    this.name,
    this.email,
    this.password,
    this.createdDate,
    this.timestamp,
    this.responseResult,
    this.responseStatus,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    createdDate = json['createdDate'];
    timestamp = json['timestamp'];
    responseResult = json['responseResult'];
    responseStatus = json['responseStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['createdDate'] = this.createdDate;
    data['timestamp'] = this.timestamp;
    data['responseResult'] = this.responseResult;
    data['responseStatus'] = this.responseStatus;
    return data;
  }
}