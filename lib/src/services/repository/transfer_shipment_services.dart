import 'package:epicor/core_packages.dart';

import 'package:http/http.dart' as http;

class TransferShipmentDelegate {
  getTfShipmentDtlGrid(String packNum) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String plant = await sharedPref.getString("userPlant");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_TfShipmentDtlGrid?pr_Plant=$plant&Pr_PackNum=$packNum");
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

  postTransShipOrder(body) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    Uri url = Uri.parse("$apiUrl/Ice.BO.UD16Svc/Update");

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$userId:$password'))}';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': basicAuth,
    };

    var response = await http.post(
      url,
      headers: requestHeaders,
      body: body,
    );
    return response;
  }

  getTraditionalQRData(String qrCode) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");
    String company = await sharedPref.getString("userCompnay");
    String plant = await sharedPref.getString("userPlant");

    Uri url = Uri.parse("$apiUrl/BaqSvc/VSAPP_OPScan($company)?pr_QR=$qrCode");
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

  getDataFromPCID(String pcid) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");
    String company = await sharedPref.getString("userCompnay");
    String plant = await sharedPref.getString("userPlant");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_PCIDQR($company)?pr_company=$company&pr_pcid=$pcid&pr_plant=$plant");
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

  deleteStagging(body) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    Uri url = Uri.parse("$apiUrl/Ice.BO.UD16Svc/DeleteByID");

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$userId:$password'))}';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': basicAuth,
    };

    var response = await http.post(
      url,
      headers: requestHeaders,
      body: body,
    );
    return response;
  }

  getSerialStatus(String partnum, String serNum) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");
    String company = await sharedPref.getString("userCompnay");
    String plant = await sharedPref.getString("userPlant");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_SerialNoStatus($company)?pr_PartNum=$partnum&pr_SrNo=$serNum");
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
