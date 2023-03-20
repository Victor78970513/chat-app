import 'dart:io';

class Enviroment {
  static String apiUrl = Platform.isAndroid
      // ? 'http://localhost:3000/api'
      //172.21.96.1    192.168.0.14
      ? 'http://192.168.0.14:3000/api'
      : 'http://10.0.2.2:3000/api';

  static String socektUrl = Platform.isAndroid
      // : 'http://localhost:3000';
      ? 'http://192.168.0.14:3000'
      : 'http://10.0.2.2:3000';
}
