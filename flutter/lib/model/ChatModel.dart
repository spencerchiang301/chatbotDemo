import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class ChatData{
  String? queryString;
  String? responseStatus;
  String? responseResult;
  List<RestaurantData>? restaurantData;

  ChatData({
    this.queryString,
    this.responseStatus,
    this.responseResult,
    this.restaurantData,
  });

  ChatData.fromJson(Map<String, dynamic> json) {
    queryString = json['queryString'];
    responseStatus = json['responseStatus'];
    responseResult = json['responseResult'];
    if (json['restaurantData'] != null) {
      restaurantData = (json['restaurantData'] as List)
          .map((item) => RestaurantData.fromJson(item))
          .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['queryString'] = this.queryString;
    data['responseStatus'] = this.responseStatus;
    data['responseResult'] = this.responseResult;
    data['restaurantData'] = this.restaurantData;
    return data;
  }
}

class RestaurantData {
  String? name;
  String? menu;
  String? reason;
  String? phone;
  String? address;

  RestaurantData({
    this.name,
    this.menu,
    this.reason,
    this.phone,
    this.address,
  });

  RestaurantData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    menu = json['menu'];
    reason = json['reason'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['menu'] = this.menu;
    data['reason'] = this.reason;
    data['phone'] = this.phone;
    data['address'] = this.address;
    return data;
  }
}