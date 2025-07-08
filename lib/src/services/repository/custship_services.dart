import 'package:epicor/core_packages.dart';

import 'package:http/http.dart' as http;

class CustShipDelegate {
  getOpenShipment() async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String plant = await sharedPref.getString("userPlant");
    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_OpenShipment($company)?pr_Plant=$plant");
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

  getOpenShipmentByCustomer(String custnum) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String plant = await sharedPref.getString("userPlant");
    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_OpenSOToShip($company)?pr_custnum=$custnum&pr_Plant=$plant");
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

  getTransDoc() async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    Uri url =
        Uri.parse("$apiUrl/BaqSvc/VSApp_TranDocType?pr_TrandocType=PackSlip");
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

  getCustByName(String query) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_Customer($company)/?pr_CustName=$query&%24top=200");
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

  getOpenShipmentItems(String ordnum) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");
    String plant = await sharedPref.getString("userPlant");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_OpenSO($company)/?pr_plant=$plant&pr_Ordernum=$ordnum");
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

  getGetPart(String partNum) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String plant = await sharedPref.getString("userPlant");
    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_GetPart($company)/?pr_PartNum=$partNum&pr_Plant=$plant");
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

  getSerialAvail(String partNum, String whe, String bin) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String plant = await sharedPref.getString("userPlant");
    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_SerialNoAvail($company)/?pr_Plant=$plant&pr_PartNum=$partNum&pr_Warehse=$whe&pr_Bin=$bin");
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

  patchSerialUpdate(String partNum, String serialNum) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse(
        "$apiUrl/Erp.BO.SerialNoSvc/SerialNoes($company, $partNum, $serialNum)");

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$userId:$password'))}';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': basicAuth,
    };

    var response = await http.patch(
      url,
      headers: requestHeaders,
    );
    return response;
  }

  patchSerialNoAdd(body, String partNum, String serialNum) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse(
        "$apiUrl/Erp.BO.SerialNoSvc/SerialNoes($company,$partNum,$serialNum)");

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$userId:$password'))}';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': basicAuth,
    };

    var response = await http.patch(
      url,
      headers: requestHeaders,
      body: json.encode(body),
    );
    return response;
  }

  patchSerial(body, String partNum, String serialNum) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse(
        "$apiUrl/Erp.BO.SerialNoSvc/SerialNoes($company,$partNum,$serialNum)");

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$userId:$password'))}';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': basicAuth,
    };

    var response = await http.patch(
      url,
      headers: requestHeaders,
      body: json.encode(body),
    );
    return response;
  }

  createShipHead(body) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    Uri url = Uri.parse("$apiUrl/Erp.BO.CustShipSvc/CustShips");

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
      body: json.encode(body),
    );
    return response;
  }

  submitShipment(body) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    Uri url = Uri.parse("$apiUrl/Erp.BO.CustShipSvc/Update");

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
      body: json.encode(body),
    );
    return response;
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
