import 'package:epicor/core_packages.dart';
import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/tfShipE/screen_transfer_ship_items.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ScreenTransferShipEntry extends StatefulWidget {
  final dynamic item;
  const ScreenTransferShipEntry({
    super.key,
    required this.item,
  });

  @override
  State<ScreenTransferShipEntry> createState() =>
      _ScreenTransferShipEntryState();
}

class _ScreenTransferShipEntryState extends State<ScreenTransferShipEntry> {
  var txtOrdNum = TextEditingController();
  var txtDocType = TextEditingController();
  var txtShipType = TextEditingController();
  var txtShipVia = TextEditingController();

  List<dynamic> docTypes = [];
  List<dynamic> shipTypes = [];
  List<dynamic> shipVia = [];
  List<dynamic> packList = [];

  String packNum = "";
  String docTypeID = "";
  String company = "";

  bool isLoading = true;
  bool isSubmit = false;

  @override
  void initState() {
    super.initState();
    loadData();
    loadSavedPackNum();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenNetwork(
        child: Scaffold(
          backgroundColor: AppColors.colorWhite,
          body: ScreenBackground(
            isLoading: isLoading,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(
                    height: 22,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: 30,
                              height: 30,
                              child: Center(
                                child: Icon(
                                  Icons.keyboard_backspace_rounded,
                                  size: 28,
                                  color: AppColors.colorBlack,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Transfer Shipment Header',
                            style: TextStyles.getBold(
                              22,
                              color: AppColors.colorWhite,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Transfer Order Num: ",
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtOrdNum,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Order num",
                                      hintStyle: TextStyles.getRegularScund(
                                        14,
                                        color: AppColors.colorGray600,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 0,
                                      ),
                                      counterText: "",
                                    ),
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter order num";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Document Type: ",
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtDocType,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Document type",
                                      hintStyle: TextStyles.getRegularScund(
                                        14,
                                        color: AppColors.colorGray600,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 0,
                                      ),
                                      counterText: "",
                                    ),
                                    onTap: () {
                                      choseDocType();
                                    },
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select document type.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Shipment Type: ",
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtShipType,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Shipment type",
                                      hintStyle: TextStyles.getRegularScund(
                                        14,
                                        color: AppColors.colorGray600,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 0,
                                      ),
                                      counterText: "",
                                    ),
                                    onTap: () {
                                      choseShipType();
                                    },
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select shipment type.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Shipment Via: ",
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtShipVia,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Shipment via",
                                      hintStyle: TextStyles.getRegularScund(
                                        14,
                                        color: AppColors.colorGray600,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 0,
                                      ),
                                      counterText: "",
                                    ),
                                    onTap: () {
                                      choseShipVia();
                                    },
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select shipment via.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (!isSubmit) {
                                  submit();
                                }
                              },
                              child: Container(
                                height: 38,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.colorAssent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.colorTansprent40,
                                      blurRadius: 2,
                                      offset: const Offset(-2, -2),
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: isSubmit
                                      ? Lottie.asset(
                                          'assets/anim/anim-btnLoading.json',
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: Text(
                                            'Submit',
                                            style: TextStyles.getBold(
                                              16,
                                              color: AppColors.colorWhite,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!isSubmit) {
                                  ship();
                                }
                              },
                              child: Container(
                                height: 38,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.colorAssent,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.colorTansprent40,
                                      blurRadius: 2,
                                      offset: const Offset(-2, -2),
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: isSubmit
                                      ? Lottie.asset(
                                          'assets/anim/anim-btnLoading.json',
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: Text(
                                            'Shipped',
                                            style: TextStyles.getBold(
                                              16,
                                              color: AppColors.colorWhite,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: Text(
                              "Packslips For Order Number: ${txtOrdNum.text}"),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: packList.isNotEmpty
                                ? packList.map((pack) {
                                    return GestureDetector(
                                      onTap: () async {
                                        // Use the clicked pack number instead of packNum variable
                                        var itemP = {
                                          "orderNum": widget.item['orderNum'],
                                          "packNum":
                                              pack, // Use pack from map callback
                                          'transferShipNo':
                                              widget.item['transferShipNo'],
                                        };

                                        // Save clicked pack number to shared preferences
                                        await sharedPref.setString(
                                            "currentPackNum", pack.toString());

                                        if (!mounted) return;

                                        // Show snackbar before navigation
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Container(
                                              margin: const EdgeInsets.all(10),
                                              child: Text(
                                                  "You clicked pack slip no: $pack"),
                                            ),
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );

                                        // Navigate after showing snackbar
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ScreenTransferShipItems(
                                              item: itemP,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, top: 5),
                                        child: Text(
                                          pack.toString(),
                                          style: const TextStyle(
                                              fontSize: 16, color: Colors.blue),
                                        ),
                                      ),
                                    );
                                  }).toList()
                                : [
                                    const Text(
                                      "No data available",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red),
                                    ),
                                  ],
                          ),
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  loadSavedPackNum() async {
    String? savedPackNum = await sharedPref.getString("currentPackNum");
    if (savedPackNum != null && savedPackNum.isNotEmpty) {
      setState(() {
        packNum = savedPackNum;
      });
      print("Loaded saved PackNum: $packNum"); // Debug print
    }
  }

  // loadData() async {
  //   txtOrdNum.text = widget.item['TFOrdHed_TFOrdNum'];
  //   company = await sharedPref.getString("userCompnay");
  //   String apiUrl = await sharedPref.getString("userUrl");
  //   String userId = await sharedPref.getString("userName");
  //   String password = await sharedPref.getString("userPass");
  //   String plant = await sharedPref.getString("userPlant");

  //   var resA = await transferServices.getDocType();
  //   docTypes.clear();
  //   docTypes = resA['value'];

  //   var resB = await transferServices.getShipType();
  //   shipTypes.clear();
  //   shipTypes = resB['value'];

  //   var resC = await transferServices.getShipVia();
  //   shipVia.clear();
  //   shipVia = resC['value'];

  //   // https://epicor.ceasefire.asia/CFILPilot/api/v1/BaqSvc/VSApp_tfEntryPackslips?
  //   Uri url = Uri.parse(
  //       "$apiUrl/BaqSvc/VSApp_tfEntryPackslips?TFOrderNum=${txtOrdNum.text}");

  //   String basicAuth =
  //       'Basic ${base64Encode(utf8.encode('$userId:$password'))}';
  //   Map<String, String> requestHeaders = {
  //     'Content-type': 'application/json',
  //     'Accept': '*/*',
  //     'Authorization': basicAuth,
  //   };

  //   var response = await http.get(
  //     url,
  //     headers: requestHeaders,
  //   );
  //   print(response.body);
  //   // return json.decode(response.body);

  //   // packList.add("");

  //   var jsonResponse = json.decode(response.body);

  //   // Check if 'value' exists and is a list
  //   if (jsonResponse['value'] != null && jsonResponse['value'] is List) {
  //     // Iterate through the list and extract TFShipDtl_PackNum
  //     for (var item in jsonResponse['value']) {
  //       if (item['TFShipDtl_PackNum'] != null) {
  //         packList.add(item['TFShipDtl_PackNum']);
  //       }
  //     }
  //   }

  //   setState(() {
  //     isLoading = false;
  //   });
  // }
  // loadData() async {
  //   try {
  //     // Initialize text field and shared preferences
  //     txtOrdNum.text = widget.item['TFOrdHed_TFOrdNum'];

  //     company = await sharedPref.getString("userCompnay");
  //     String apiUrl = await sharedPref.getString("userUrl");
  //     String userId = await sharedPref.getString("userName");
  //     String password = await sharedPref.getString("userPass");
  //     String plant = await sharedPref.getString("userPlant");

  //     // Fetch document types, ship types, and ship vias
  //     var resA = await transferServices.getDocType();
  //     docTypes = resA['value'] ?? [];

  //     var resB = await transferServices.getShipType();
  //     shipTypes = resB['value'] ?? [];

  //     var resC = await transferServices.getShipVia();
  //     shipVia = resC['value'] ?? [];

  //     // Construct the API URL
  //     Uri url = Uri.parse(
  //         "$apiUrl/BaqSvc/VSApp_tfEntryPackslips?TFOrderNum=${widget.item['TFOrdHed_TFOrdNum']}");

  //     // Set up Basic Auth header
  //     String basicAuth =
  //         'Basic ${base64Encode(utf8.encode('$userId:$password'))}';
  //     Map<String, String> requestHeaders = {
  //       'Content-type': 'application/json',
  //       'Accept': '*/*',
  //       'Authorization': basicAuth,
  //     };

  //     // Perform the GET request
  //     var response = await http.get(url, headers: requestHeaders);
  //     print("Response Status: ${response.statusCode}");
  //     print("Response Body: ${response.body}");

  //     if (response.statusCode == 200) {
  //       // Parse the JSON response
  //       var jsonResponse = json.decode(response.body);

  //       // Check if 'value' exists and is a list
  //       if (jsonResponse['value'] != null && jsonResponse['value'] is List) {
  //         // Iterate through the list and extract TFShipDtl_PackNum
  //         for (var item in jsonResponse['value']) {
  //           if (item['TFShipDtl_PackNum'] != null) {
  //             packList.add(item['TFShipDtl_PackNum']);
  //           }
  //         }
  //         print("Pack List: $packList");
  //       }
  //     } else {
  //       print("Failed to fetch data: ${response.reasonPhrase}");
  //     }
  //   } catch (e) {
  //     // Handle errors gracefully
  //     print("Error occurred: $e");
  //   } finally {
  //     // Update the UI state
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
  loadData() async {
    try {
      // Initialize text field and shared preferences
      // print(widget.item);
      // txtOrdNum.text = widget.item['TFOrdHed_TFOrdNum'] ?? '';
      txtOrdNum.text = widget.item['orderNum'] ?? '';

      company = await sharedPref.getString("userCompnay") ?? '';
      String apiUrl = await sharedPref.getString("userUrl") ?? '';
      String userId = await sharedPref.getString("userName") ?? '';
      String password = await sharedPref.getString("userPass") ?? '';

      // Validate critical fields
      if (apiUrl.isEmpty ||
          userId.isEmpty ||
          password.isEmpty ||
          company.isEmpty) {
        throw Exception("Required configuration values are missing.");
      }

      // Fetch document types, ship types, and ship vias
      var resA = await transferServices.getDocType();
      docTypes = resA['value'] ?? [];

      var resB = await transferServices.getShipType();
      shipTypes = resB['value'] ?? [];

      var resC = await transferServices.getShipVia();
      shipVia = resC['value'] ?? [];

      // Construct the API URL
      Uri url = Uri.parse(
          "$apiUrl/BaqSvc/VSApp_tfEntryPackslips?TFOrderNum=${widget.item['orderNum']}");

      // Set up Basic Auth header
      String basicAuth =
          'Basic ${base64Encode(utf8.encode('$userId:$password'))}';
      Map<String, String> requestHeaders = {
        'Content-type': 'application/json',
        'Accept': '*/*',
        'Authorization': basicAuth,
      };

      // Perform the GET request
      var response = await http.get(url, headers: requestHeaders);
      // print("Response Status: ${response.statusCode}");
      // print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Parse the JSON response
        var jsonResponse = json.decode(response.body);

        // Check if 'value' exists and is a list
        if (jsonResponse['value'] != null && jsonResponse['value'] is List) {
          // Iterate through the list and extract TFShipDtl_PackNum
          for (var item in jsonResponse['value']) {
            if (item['TFShipDtl_PackNum'] != null) {
              packList.add(item['TFShipDtl_PackNum']);
            }
          }
          // print("Pack List: $packList");
        }
      } else {
        // print("Failed to fetch data: ${response.reasonPhrase}");
      }
    } catch (e) {
      // Handle errors gracefully
      // print("Error occurred: $e");
    } finally {
      // Update the UI state
      setState(() {
        isLoading = false;
      });
    }
  }

  choseDocType() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Document Type",
                  style: TextStyles.getBold(18),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.colorGray100,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SizedBox(
                    child: docTypes.isEmpty
                        ? Container(
                            color: Colors.transparent,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "No document type found.",
                                  style: TextStyles.getRegularScund(
                                    16,
                                    color: AppColors.colorGray600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: docTypes.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  txtDocType.text = docTypes[index]
                                      ["TranDocType_Description"];
                                  docTypeID = docTypes[index]
                                      ["TranDocType_TranDocTypeID"];
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        docTypes[index]
                                            ["TranDocType_Description"],
                                        style: TextStyles.getRegularScund(
                                          16,
                                          color: AppColors.colorGray600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.colorGray100,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        child: Text(
                          "Cancel",
                          style: TextStyles.getBold(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  choseShipType() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Ship Type",
                  style: TextStyles.getBold(18),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.colorGray100,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SizedBox(
                    child: docTypes.isEmpty
                        ? Container(
                            color: Colors.transparent,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "No ship type found.",
                                  style: TextStyles.getRegularScund(
                                    16,
                                    color: AppColors.colorGray600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: shipTypes.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  txtShipType.text =
                                      shipTypes[index]["UDCodes_CodeDesc"];
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shipTypes[index]["UDCodes_CodeDesc"],
                                        style: TextStyles.getRegularScund(
                                          16,
                                          color: AppColors.colorGray600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.colorGray100,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        child: Text(
                          "Cancel",
                          style: TextStyles.getBold(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  choseShipVia() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Ship Via",
                  style: TextStyles.getBold(18),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.colorGray100,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SizedBox(
                    child: shipVia.isEmpty
                        ? Container(
                            color: Colors.transparent,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "No ship via found.",
                                  style: TextStyles.getRegularScund(
                                    16,
                                    color: AppColors.colorGray600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: shipVia.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  txtShipVia.text =
                                      shipVia[index]["ShipVia_ShipViaCode"];
                                  Navigator.of(context).pop();
                                  setState(() {});
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 0,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        shipVia[index]["ShipVia_ShipViaCode"],
                                        style: TextStyles.getRegularScund(
                                          16,
                                          color: AppColors.colorGray600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.colorGray100,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        child: Text(
                          "Cancel",
                          style: TextStyles.getBold(14),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ship() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });

  //     if (txtDocType.text.isEmpty) {
  //       throw Exception("Please select document type.");
  //     }
  //     if (txtShipType.text.isEmpty) {
  //       throw Exception("Please select ship type.");
  //     }
  //     if (txtShipVia.text.isEmpty) {
  //       throw Exception("Please select ship vai method.");
  //     }

  //     var body = {
  //       "Company": company,
  //       "PackNum": packNum,
  //       "ShipDate": DateTime.now().toIso8601String(),
  //       "Shipped": true,
  //       "RowMod": "U"
  //     };

  //     print(company);
  //     print(packNum);

  //     Response res = await transferServices.patchTransOrderShips(
  //       json.encode(body),
  //       packNum,
  //     );
  //     if (res.statusCode == 204) {
  //       showSucess(
  //         'Success: ',
  //         "Shipment line created successfully.",
  //       );
  //     } else {
  //       showError(
  //         'Error',
  //         json.decode(res.body)['ErrorMessage'],
  //       );
  //     }
  //   } catch (ex) {
  //     showError('Error', ex.toString());
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  // submit() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     if (txtDocType.text.isEmpty) {
  //       throw Exception("Please select document type.");
  //     }
  //     if (txtShipType.text.isEmpty) {
  //       throw Exception("Please select ship type.");
  //     }
  //     if (txtShipVia.text.isEmpty) {
  //       throw Exception("Please select ship vai method.");
  //     }
  //     var body = {
  //       "Company": company,
  //       "TranDocTypeID": docTypeID,
  //       "ShortChar04": txtShipType.text,
  //       "ShipDate": DateTime.now().toIso8601String(),
  //       "RowMod": "A"
  //     };
  //     var res = await transferServices.postTransOrderShips(json.encode(body));

  //     if (res.body != null) {
  //       var payload = json.decode(res.body);
  //       packNum = payload['PackNum'].toString();
  //       var item = {
  //         "orderNum": widget.item['TFOrdHed_TFOrdNum'],
  //         "packNum": payload['PackNum'].toString(),
  //         'transferShipNo': widget.item['TFOrdHed_Character01'],
  //       };
  //       if (!mounted) return;
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => ScreenTransferShipItems(
  //             item: item,
  //           ),
  //         ),
  //       );
  //     }
  //   } catch (ex) {
  //     showError('Error', ex.toString());
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  ship() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (txtDocType.text.isEmpty) {
        throw Exception("Please select document type.");
      }
      if (txtShipType.text.isEmpty) {
        throw Exception("Please select ship type.");
      }
      if (txtShipVia.text.isEmpty) {
        throw Exception("Please select ship vai method.");
      }

      // Check if packNum is available
      String? currentPackNum = await sharedPref.getString("currentPackNum");
      if (packNum.isEmpty && currentPackNum != null) {
        packNum = currentPackNum;
      }

      if (packNum.isEmpty) {
        throw Exception(
            "No valid PackNum found. Please submit the form first.");
      }

      // print("Shipping with PackNum: $packNum");

      var body = {
        "Company": company,
        "PackNum": packNum,
        "ShipDate": DateTime.now().toIso8601String(),
        "Shipped": true,
        "RowMod": "U"
      };

      // print("Company: $company");
      // print("PackNum: $packNum");

      Response res = await transferServices.patchTransOrderShips(
        json.encode(body),
        packNum,
      );

      if (res.statusCode == 204) {
        // Clear the saved packNum by setting it to empty string
        await sharedPref.setString("currentPackNum", "");

        showSucess(
          'Success: ',
          "Shipment line created successfully.",
        );
      } else {
        showError(
          'Error',
          json.decode(res.body)['ErrorMessage'],
        );
      }
    } catch (ex) {
      showError('Error', ex.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  submit() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (txtDocType.text.isEmpty) {
        throw Exception("Please select document type.");
      }
      if (txtShipType.text.isEmpty) {
        throw Exception("Please select ship type.");
      }
      if (txtShipVia.text.isEmpty) {
        throw Exception("Please select ship vai method.");
      }
      // String currentPackNum = await sharedPref.getString("currentPackNum");

      var body = {
        "Company": company,
        "TranDocTypeID": docTypeID,
        "ShortChar04": txtShipType.text,
        "ShipDate": DateTime.now().toIso8601String(),
        "RowMod": "A"
      };

      var res = await transferServices.postTransOrderShips(json.encode(body));
      if (res.body != null) {
        var payload = json.decode(res.body);
        print("Payload: $payload");
        setState(() {
          // Add setState here
          packNum = payload['PackNum'].toString();
        });

        // print("PackNum saved: $packNum"); // Debug print

        var item = {
          "orderNum": widget.item['orderNum'],
          "packNum": packNum,
          'transferShipNo': widget.item['transferShipNo'],
          'fromPlant': widget.item['fromPlant'],
          'toPlant': widget.item['toPlant'],
          'fromPlantName': widget.item['fromPlantName'],
          'toPlantName': widget.item['toPlantName'],
          'orderDate': widget.item['orderDate']
        };
        print("Item: $item");
        // Save packNum to shared preferences for persistence
        await sharedPref.setString("currentPackNum", packNum);

        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ScreenTransferShipItems(
              item: item,
            ),
          ),
        );
      }
    } catch (ex) {
      showError('Error', ex.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  showSucess(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.getRegularScund(16),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyles.getRegularScund(14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        child: Text(
                          'OK',
                          style: TextStyles.getBold(
                            14,
                            color: AppColors.colorPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  showError(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.getRegularScund(16),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: TextStyles.getRegularScund(14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        child: Text(
                          'OK',
                          style: TextStyles.getBold(
                            14,
                            color: AppColors.colorPrimary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
