import 'package:epicor/core_packages.dart';

import 'package:http/http.dart' as http;

class NonConfDelegate {
  getAvailableWarehouse(String serialNum) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String plant = await sharedPref.getString("userPlant");
    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_getAvailableWarehouse($company)?pr_Company=$company&pr_Plant=$plant&pr_SerialNo=$serialNum");
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$userId:$password'))}';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': basicAuth,
    };

    var response = await http.get(
      url,
      headers: requestHeaders,
    );
    return json.decode(response.body);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
