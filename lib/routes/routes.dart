import 'package:flutter/material.dart';
import 'package:chat_app/screens/screens.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'users': (_) => UsersScreen(),
  'chat': (_) => ChatScreen(),
  'login': (_) => LoginScreen(),
  'register': (_) => RegisterScreen(),
  'loading': (_) => LoadingScreen(),
};
