import 'package:epicor/core_packages.dart';

import 'package:http/http.dart' as http;

class CustomerShipmentDelegate {
  getCustomerShipmentList() async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");
    String plant = await sharedPref.getString("userPlant");

    // Uri url = Uri.parse("$apiUrl/BaqSvc/VS_TFtest($company)?pr_Plant=$plant");
    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_OpenShipment($company)?pr_Plant=$plant");
    // Uri url = Uri.parse(
    //     "$apiUrl/BaqSvc/VSAPP_TransferShipmentHead($company)?pr_Plant=$plant");
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
