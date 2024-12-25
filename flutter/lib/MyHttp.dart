import 'dart:io';
import 'package:choaidemo/model/ChatModel.dart';
import 'package:choaidemo/model/UserModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MyHttp {

  Dio dio = Dio();

  String url_host = "http://43.206.212.243:10000";

  Future<UserData?> RegisterUser(String name, String password, String email) async {
    UserData userData = UserData();
    userData.name = name;
    userData.password = password;
    userData.email = email;
    String uri = "$url_host/registerUser";
    Response response;
    UserData? retrieveUserData;
    try {
      response = await dio.post(uri,
          options: Options(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
          data: userData.toJson());
      if (response.statusCode == HttpStatus.ok) {
        retrieveUserData = UserData.fromJson(response.data);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return retrieveUserData;
  }

  Future<UserData?> AuthenticateUser(String email, String password) async {
    UserData userData = UserData();
    userData.password = password;
    userData.email = email;
    String uri = "$url_host/authenticateUser";
    Response response;
    UserData? retrieveUserData;
    try {
      response = await dio.post(uri,
          options: Options(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
          data: userData.toJson());
      if (response.statusCode == HttpStatus.ok) {
        retrieveUserData = UserData.fromJson(response.data);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return retrieveUserData;
  }

  Future<ChatData?> SearchResult(String queryString) async {
    ChatData chatData = ChatData();
    chatData.queryString = queryString;
    String uri = "$url_host/chatbot";
    Response response;
    ChatData? retrieveChatData;
    try {
      response = await dio.post(uri,
          options: Options(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
          ),
          data: chatData.toJson());
      if (response.statusCode == HttpStatus.ok) {
        retrieveChatData = ChatData.fromJson(response.data);
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return retrieveChatData;
  }

}
