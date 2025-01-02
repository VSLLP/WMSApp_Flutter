import 'package:epicor/core_packages.dart';

import 'package:http/http.dart' as http;

class AuthDelegate {
  getEmployeeDetailAsync(body, apiUrl) async {
    HttpOverrides.global = MyHttpOverrides();
    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSApp_UserDetails(${body['Company']})/?pr_UserID=${body['UserId']}");
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('${body['UserId']}:${body['Password']}'))}';
    Map<String, String> requestHeaders = {
      'Accept': '*/*',
      'Authorization': basicAuth,
    };
    var response = await http.get(
      url,
      headers: requestHeaders,
    );
    return json.decode(response.body);
  }

  plantPatchAsync(body) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");
    Uri url = Uri.parse(
        "$apiUrl/Erp.BO.UserFileSvc/UserComps(${body['UserId']},${body['Company']})");
    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$userId:$password'))}';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': basicAuth,
    };
    var payload = {"CurPlant": body['SelectedPlant']};
    var response = await http.patch(
      url,
      headers: requestHeaders,
      body: json.encode(payload),
    );
    return response.body;
  }

  pathUserComps(body) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    // String userId = await sharedPref.getString("userName");
    // String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse("$apiUrl/Ice.BO.UserFileSvc/UserComps(WMSID,$company)");

    String basicAuth = 'Basic ${base64Encode(utf8.encode('WMSID:WMSpass'))}';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': basicAuth,
    };
    var payload = {"CurPlant": body['SelectedPlant']};
    var response = await http.patch(
      url,
      headers: requestHeaders,
      body: json.encode(payload),
    );
    return response.body;
  }

  getMenuAsync(String company) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    Uri url = Uri.parse("$apiUrl/BaqSvc/VS_WMS_Details($company)");
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
