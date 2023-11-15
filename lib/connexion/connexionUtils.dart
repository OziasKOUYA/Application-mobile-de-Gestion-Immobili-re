import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InternetConnectivity{
 static Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    // Vérification supplémentaire à l'aide de internet_connection_checker
    bool isConnected = await InternetConnectionChecker().hasConnection;
    return isConnected;
  } else {
    return false; // L'appareil n'est pas connecté à Internet.
  }
}
}