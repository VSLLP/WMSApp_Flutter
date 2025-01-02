import 'package:epicor/core_packages.dart';

import 'package:http/http.dart' as http;

class TransferDelegate {
  checkFirst() async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse("$apiUrl/BaqSvc/VSApp_ResticTFShipEntry($company)");
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

  getTansferShipList() async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");
    String plant = await sharedPref.getString("userPlant");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_TransferShipmentHead($company)?pr_Plant=$plant");
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

  getIssueMaterialList() async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String plant = await sharedPref.getString("userPlant");

    Uri url =
        Uri.parse("$apiUrl/BaqSvc/VSAPP_IssueMaterialHeader/?PlantName=$plant");
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

  getTansferReceiptList() async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");
    String plant = await sharedPref.getString("userPlant");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSApp_TranShipReceiptHead($company)?pr_Plant=$plant");
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

  getDocType() async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    Uri url =
        Uri.parse("$apiUrl/BaqSvc/VSApp_TranDocType?pr_TrandocType=TOrderShip");
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

  getShipType() async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse("$apiUrl/BaqSvc/VSApp_TransferShipmentType($company)");
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

  getShipVia() async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    Uri url = Uri.parse("$apiUrl/BaqSvc/VSAPP_TShipmentShipVia");
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

  getTransferShipmentDtl(orderNum) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String plant = await sharedPref.getString("userPlant");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_TransferShipmentDtl/?pr_Plant=$plant&pr_TFOrderNum=$orderNum");
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

  postTransOrderShips(body) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    Uri url = Uri.parse("$apiUrl/Erp.BO.TransOrderShipSvc/TransOrderShips");

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

  postTransferShipmentDtl(body) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    Uri url = Uri.parse("$apiUrl/Erp.BO.TransOrderShipSvc/Update");

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

  getBinAsync(String partNum, String wcode) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String plant = await sharedPref.getString("userPlant");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_GetPartBin(CTEMP1)?pr_Plant=$plant&pr_PartNum=$partNum&pr_Warehse=$wcode");
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

  getLots(String partNum, String whe, String bin) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String plant = await sharedPref.getString("userPlant");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_issueMiscDetail/?PartNum=$partNum&Warehousecode=$whe&BinNum=$bin&Plant=$plant");
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

  patchRecvItem(body, packnum) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    // String userId = await sharedPref.getString("userName");
    // String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse(
        "$apiUrl/Erp.BO.TransOrderReceiptSvc/PlantTrans($company,$packnum)");

    String basicAuth = 'Basic ${base64Encode(utf8.encode('WMSID:WMSpass'))}';
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': '*/*',
      'Authorization': basicAuth,
    };

    var response = await http.patch(
      url,
      headers: requestHeaders,
      body: body,
    );
    return response;
  }

  patchTransOrderShips(body, packnum) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");

    Uri url = Uri.parse(
        "$apiUrl/Erp.BO.TransOrderShipSvc/TransOrderShips($company,$packnum)");

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
      body: body,
    );
    return response;
  }

  getTansferReceiptItems(String packnum) async {
    HttpOverrides.global = MyHttpOverrides();
    String apiUrl = await sharedPref.getString("userUrl");
    String userId = await sharedPref.getString("userName");
    String password = await sharedPref.getString("userPass");

    String company = await sharedPref.getString("userCompnay");
    String plant = await sharedPref.getString("userPlant");

    Uri url = Uri.parse(
        "$apiUrl/BaqSvc/VSAPP_TransferShipReceiptDtl($company)?Plant=$plant&PackNum=$packnum");
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
