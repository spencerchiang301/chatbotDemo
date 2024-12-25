import './MyChatBot.dart';
import './MyReservation.dart';
import './MyLogin.dart';
import './MyRegister.dart';
import './MyResetPassword.dart';
import './MyReservationSummary.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class MyRoute {
  static const String login = "/login";
  static const String main = "/";
  static const String reservation = "/reservation";
  static const String register = "/register";
  static const String resetPassword = "/reset-password";
  static const String reservationSummary = "/reservation-summary";
  static const String chatbot = "/chatbot";

  static final List<GetPage> getPages = [
    GetPage(name: login, page: () => MyLogin()),
    GetPage(name: main, page: () => MyLogin()),
    GetPage(name: reservation, page: () => MyReservation()),
    GetPage(name: register, page: () => MyRegister()),
    GetPage(name: resetPassword, page: () => MyResetPassword()),
    GetPage(name: reservationSummary, page: () => MyReservationSummary()),
    GetPage(name: chatbot, page: () => MyChatbot()),
  ];
}
