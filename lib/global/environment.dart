import 'dart:io';

class Environment {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.100.154:3000/api' // Cambiar por la ip de tu servidor
      : 'http://localhost:3000/api';
  static String socketUrl = Platform.isAndroid
      ? 'http://192.168.100.154:3000'  // Cambiar por la ip de tu servidor
      : 'http://localhost:3000';
}

