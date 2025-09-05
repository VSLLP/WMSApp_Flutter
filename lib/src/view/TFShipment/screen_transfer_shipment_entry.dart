import 'package:epicor/core_packages.dart';
import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/tfShipE/screen_transfer_ship_items.dart';
import 'package:epicor/src/view/home/screen_qr_scan.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ScreenTransferShipmentEntry extends StatefulWidget {
  final dynamic item;
  const ScreenTransferShipmentEntry({
    super.key,
    required this.item,
  });

  @override
  State<ScreenTransferShipmentEntry> createState() =>
      _ScreenTransferShipmentEntry();
}

class _ScreenTransferShipmentEntry extends State<ScreenTransferShipmentEntry> {
  var txtOrdNum = TextEditingController();
  var txtDocType = TextEditingController();
  var txtShipType = TextEditingController();
  var txtShipVia = TextEditingController();
  var txtScan = TextEditingController();
  //var txtPackNum = TextEditingController();

  List<dynamic> docTypes = [];
  List<dynamic> shipTypes = [];
  List<dynamic> shipVia = [];
  List<dynamic> packList = [];
  List<dynamic> items = [];

  List<TextEditingController> itemQty = [];

  String packNum = "";
  String docTypeID = "";
  String company = "";
  String txtFromPlant = "";
  String txtToPlant = "";
  String txtPackNum = "";
  String txtshipDate = "";

  String partNum = "";
  String serialNum = "";
  String partLot = "";
  String qrType = "";

  bool isLoading = true;
  bool isSubmit = false;
  bool isCam = false;

  @override
  void initState() {
    super.initState();
    loadData();
    //loadSavedPackNum();
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
                                    "Pack Num: ",
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: Text(
                                    txtPackNum,
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
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
                                    "From Plant: ",
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: Text(
                                    txtFromPlant,
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
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
                                    "To Plant: ",
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: Text(
                                    txtToPlant,
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
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
                                    "Ship Date: ",
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: Text(
                                    DateFormat('dd/MM/yyyy')
                                        .format(DateTime.parse(txtshipDate)),
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
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
                                    "Product Scan: ",
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: AppColors.colorBlue300,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(2),
                                      bottomLeft: Radius.circular(2),
                                      bottomRight: Radius.circular(16),
                                    ),
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtScan,
                                    style: TextStyles.getRegularScund(12),
                                    decoration: InputDecoration(
                                      hintText: "Scan Product",
                                      hintStyle: TextStyles.getRegularScund(
                                        14,
                                        color: AppColors.colorDataColor,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      suffixIcon: txtScan.text.isNotEmpty
                                          ? GestureDetector(
                                              onTap: () {
                                                txtScan.text = "";
                                              },
                                              child: SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.clear,
                                                    color:
                                                        AppColors.colorGray600,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: Center(
                                                child: Icon(
                                                  Icons.search,
                                                  color: AppColors.colorGray600,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                      counterText: "",
                                    ),
                                    onChanged: (val) {
                                      getPartAsync(val);
                                    },
                                    onTap: () {
                                      if (isCam) {
                                        getScan();
                                      }
                                    },
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    readOnly: isCam,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please scan product.";
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
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.colorWhite,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.colorTansprent20,
                                      blurRadius: 4,
                                      //offset: const Offset(-4, 4),
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height -
                                                500,
                                        color: Colors.transparent,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Table(
                                            columnWidths: const {
                                              0: FixedColumnWidth(50),
                                              1: FixedColumnWidth(100),
                                              2: FixedColumnWidth(100),
                                              3: FixedColumnWidth(50),
                                              4: FixedColumnWidth(50),
                                              5: FixedColumnWidth(130),
                                              6: FixedColumnWidth(70),
                                              7: FixedColumnWidth(50),
                                              8: FixedColumnWidth(50),
                                              9: FixedColumnWidth(70)
                                            },
                                            border: const TableBorder.symmetric(
                                              inside: BorderSide(
                                                width: 1,
                                                color: Colors.black,
                                              ),
                                              outside: BorderSide(
                                                width: 1,
                                                color: Colors.black,
                                              ),
                                            ),
                                            children: getRows(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     SizedBox(
                            //       width:
                            //           MediaQuery.of(context).size.width * 0.3,
                            //       child: Text(
                            //         "Shipment Via: ",
                            //         style: TextStyles.getBold(
                            //           14,
                            //           color: AppColors.colorDataColor,
                            //         ),
                            //       ),
                            //     ),
                            //     SizedBox(
                            //       width:
                            //           MediaQuery.of(context).size.width * 0.54,
                            //       child: TextFormField(
                            //         controller: txtShipVia,
                            //         style: TextStyles.getBold(
                            //           12,
                            //           color: AppColors.colorBlack,
                            //         ),
                            //         decoration: InputDecoration(
                            //           hintText: "Shipment via",
                            //           hintStyle: TextStyles.getRegularScund(
                            //             14,
                            //             color: AppColors.colorGray600,
                            //           ),
                            //           contentPadding:
                            //               const EdgeInsets.symmetric(
                            //             horizontal: 4,
                            //             vertical: 0,
                            //           ),
                            //           counterText: "",
                            //         ),
                            //         onTap: () {
                            //           choseShipVia();
                            //         },
                            //         keyboardType: TextInputType.name,
                            //         autofocus: false,
                            //         readOnly: true,
                            //         validator: (value) {
                            //           if (value!.isEmpty) {
                            //             return "Please select shipment via.";
                            //           }
                            //           return null;
                            //         },
                            //       ),
                            //     ),
                            //   ],
                            // ),
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
                            // GestureDetector(
                            //   onTap: () {
                            //     if (!isSubmit) {
                            //       ship();
                            //     }
                            //   },
                            //   child: Container(
                            //     height: 38,
                            //     width: 100,
                            //     decoration: BoxDecoration(
                            //       color: AppColors.colorAssent,
                            //       borderRadius: BorderRadius.circular(8),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: AppColors.colorTansprent40,
                            //           blurRadius: 2,
                            //           offset: const Offset(-2, -2),
                            //         )
                            //       ],
                            //     ),
                            //     child: Center(
                            //       child: isSubmit
                            //           ? Lottie.asset(
                            //               'assets/anim/anim-btnLoading.json',
                            //             )
                            //           : Padding(
                            //               padding: const EdgeInsets.symmetric(
                            //                 vertical: 8.0,
                            //               ),
                            //               child: Text(
                            //                 'Shipped',
                            //                 style: TextStyles.getBold(
                            //                   16,
                            //                   color: AppColors.colorWhite,
                            //                 ),
                            //               ),
                            //             ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        // const SizedBox(
                        //   height: 25,
                        // ),
                        // Container(
                        //   margin: const EdgeInsets.all(5),
                        //   child: Text(
                        //       "Packslips For Order Number: ${txtOrdNum.text}"),
                        // ),
                        // SingleChildScrollView(
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: packList.isNotEmpty
                        //         ? packList.map((pack) {
                        //             return GestureDetector(
                        //               onTap: () async {
                        //                 // Use the clicked pack number instead of packNum variable
                        //                 var itemP = {
                        //                   "orderNum": widget.item['orderNum'],
                        //                   "packNum":
                        //                       pack, // Use pack from map callback
                        //                   'transferShipNo':
                        //                       widget.item['transferShipNo'],
                        //                 };

                        //                 // Save clicked pack number to shared preferences
                        //                 await sharedPref.setString(
                        //                     "currentPackNum", pack.toString());

                        //                 if (!mounted) return;

                        //                 // Show snackbar before navigation
                        //                 ScaffoldMessenger.of(context)
                        //                     .showSnackBar(
                        //                   SnackBar(
                        //                     content: Container(
                        //                       margin: const EdgeInsets.all(10),
                        //                       child: Text(
                        //                           "You clicked pack slip no: $pack"),
                        //                     ),
                        //                     duration:
                        //                         const Duration(seconds: 2),
                        //                   ),
                        //                 );

                        //                 // Navigate after showing snackbar
                        //                 Navigator.of(context).push(
                        //                   MaterialPageRoute(
                        //                     builder: (context) =>
                        //                         ScreenTransferShipItems(
                        //                       item: itemP,
                        //                     ),
                        //                   ),
                        //                 );
                        //               },
                        //               child: Container(
                        //                 margin: const EdgeInsets.only(
                        //                     left: 10, top: 5),
                        //                 child: Text(
                        //                   pack.toString(),
                        //                   style: const TextStyle(
                        //                       fontSize: 16, color: Colors.blue),
                        //                 ),
                        //               ),
                        //             );
                        //           }).toList()
                        //         : [
                        //             const Text(
                        //               "No data available",
                        //               style: TextStyle(
                        //                   fontSize: 16, color: Colors.red),
                        //             ),
                        //           ],
                        //   ),
                        // ),
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

  getScan() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ScreenQrScan(),
      ),
    );
    if (result != null && result is String) {
      getPartAsync(result);
    }
  }

  getPartAsync(String val) async {
    try {
      if (val.length <= 3) {
        return;
      }

      partNum = "";
      serialNum = "";
      partLot = "";
      qrType = "";

      if (val.contains("Company Name")) {
        qrType = "B";
        String splitKey = "~";

        List<String> words = val.split(splitKey);
        if (words.length <= 2) {
          return;
        }

        partNum = words[1].replaceAll("Part Code - ", '').replaceAll("~", "");
        serialNum =
            words[5].replaceAll("Serial No. - ", '').replaceAll("~", "");
        partLot = words[4]
            .replaceAll("Lot No. -", '')
            .replaceAll("~", "")
            .replaceAll(" ", "");
      } else {
        qrType = "A";
        partNum = val.substring(0, 9);
        serialNum = val.substring(13);

        // if (!val.contains("\n")) {
        //   qrType = "A";
        //   partNum = val.substring(0, 9);
        //   serialNum = val.substring(13);
        // } else {
        //   qrType = "B";
        //   String splitKey = "";
        //   if (val.contains("\r\n")) {
        //     splitKey = "\r\n";
        //   } else if (val.contains("\n")) {
        //     splitKey = "\n";
        //   } else if (val.contains("~")) {
        //     splitKey = "~";
        //   } else if (val.contains("~\n")) {
        //     splitKey = "~\n";
        //   }
      }

      if (partNum.isEmpty && serialNum.isEmpty) {
        throw Exception("Invalid QR Code.");
      }

      int productIndex = items.indexWhere(
        (item) =>
            item["ShipDtl_PartNum"].toString().toLowerCase() ==
                partNum.toLowerCase() &&
            double.parse(item["ShipDtl_OurInventoryShipQty"].toString()) <
                double.parse(item["ShipDtl_VS_QtyToShip_c"].toString()),
      );

      var resPrd = await custShipServices.getGetPart(partNum);
      if (resPrd["value"].length == 0) {
        throw Exception("Invalid partnum no details found.");
      }

      var prdDtl = resPrd["value"][0];

      if (productIndex == -1) {
        throw Exception("Please scan a valid PartNum.");
      } else {
        if (qrType == "B" && partLot.isNotEmpty) {
          items[productIndex]["ShipDtl_LotNum"] = partLot;
        }
        items[productIndex]["isSelect"] = true;
        items[productIndex]["ShipDtl_OurInventoryShipQty"] =
            (double.parse(items[productIndex]["ShipDtl_OurInventoryShipQty"]) +
                    1)
                .toString();
        items[productIndex]["serials"].add({
          "num": serialNum,
          "lot": partLot,
          "qrType": qrType,
        });
        items[productIndex]["prdTrack"] = getType(prdDtl);
        itemQty[productIndex].text =
            items[productIndex]["ShipDtl_OurInventoryShipQty"];
      }

      //getWhere(partNum);
    } catch (ex) {
      showError('Error', ex.toString());
    } finally {
      //txtScan.text = "";
      setState(() {
        isLoading = false;
      });
    }
  }

  getType(item) {
    /*if (item['Part_TrackLots'] && item['Part_TrackSerialNum']) {
      return "1";
    }
    if (item['Part_TrackLots']) {
      return "2";
    }
    if (item['Part_TrackSerialNum']) {
      return "3";
    }
    if (!item['Part_TrackLots'] && !item['Part_TrackSerialNum']) {
      return "4";
    }*/
    if (item['Part_TrackLots'] && item['Part_TrackSerialNum']) {
      return "1";
    }
    if (item['Part_TrackLots']) {
      return "2";
    }
    if (item['Part_TrackSerialNum']) {
      return "3";
    }
    if (!item['Part_TrackLots'] && !item['Part_TrackSerialNum']) {
      return "4";
    }
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
      setState(() {
        isLoading = true;
      });

      // Initialize text field and shared preferences
      // print(widget.item);
      // txtOrdNum.text = widget.item['TFOrdHed_TFOrdNum'] ?? '';
      txtPackNum = widget.item['packNum'].toString();
      txtFromPlant = widget.item['fromPlantName'].toString();
      txtToPlant = widget.item['toPlantName'].toString();
      txtshipDate = widget.item['shipDate'].toString();
      //txtOrdNum.text = widget.item['orderNum'] ?? '';
      isCam = await sharedPref.getBool("isCam");
      company = await sharedPref.getString("userCompnay") ?? '';
      String apiUrl = await sharedPref.getString("userUrl") ?? '';
      String userId = await sharedPref.getString("userName") ?? '';
      String password = await sharedPref.getString("userPass") ?? '';

      String userPlant = await sharedPref.getString("userPlant");

      // Validate critical fields
      // if (apiUrl.isEmpty ||
      //     userId.isEmpty ||
      //     password.isEmpty ||
      //     company.isEmpty) {
      //   throw Exception("Required configuration values are missing.");
      // }

      // // Fetch document types, ship types, and ship vias
      // var resA = await transferServices.getDocType();
      // docTypes = resA['value'] ?? [];

      // var resB = await transferServices.getShipType();
      // shipTypes = resB['value'] ?? [];

      // var resC = await transferServices.getShipVia();
      // shipVia = resC['value'] ?? [];

      // Construct the API URL
      Uri url = Uri.parse(
          "$apiUrl/BaqSvc/VSAPP_TfShipmentDtlGrid?pr_Plant=$userPlant&Pr_PackNum=${widget.item['packNum'].toString()}");

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
              packList.add(item['TFShipDtl_PackNum'].toString());
              item["TFShipDtl_OrderRelNum"] = "";
              item["isSelect"] = false;
              items.add(item);
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

  List<TableRow> getRows() {
    List<TableRow> rows = [];
    rows.add(TableRow(
      children: [
        tableCell('Line'),
        tableCell('OrderNum/Line'),
        tableCell('PartNum'),
        tableCell("ShipQty"),
        tableCell("PickQty"),
        tableCell('Desc'),
        tableCell('WH/Bin'),
        tableCell('Lot'),
        tableCell("IUM"),
        tableCell("Type"),
      ],
    ));

    for (int i = 0; i < items.length; i++) {
      var item = items[i];
      String ordernum = item["TFShipDtl_TFOrdNum"].toString();
      String orderline = item["TFShipDtl_TFOrdLine"].toString();
      //String relnum = item["TFShipDtl_OrderRelNum"].toString();
      String warehouse = item["TFShipDtl_WarehouseCode"].toString();
      String bin = item["TFShipDtl_BinNum"].toString();
      Color rowcolor;

      rowcolor =
          item['isSelect'] ? AppColors.colorYellow300 : Colors.transparent;

      if (item["TFShipDtl_OurStockShippedQty"] != "") {
        if (double.parse(item["TFShipDtl_OurStockShippedQty"].toString()) ==
            double.parse(item["TFShipDtl_VS_QtyToShip_c"].toString())) {
          rowcolor = AppColors.colorCyan300;
        }
      }

      bool manualQty = false;

      // if (!item["Part_TrackLots"] && item["Part_TrackSerialNum"]) {
      //   manualQty = false;
      // } else if (item["Part_TrackLots"] && !item["Part_TrackSerialNum"]) {
      //   manualQty = true;
      // } else if (!item["Part_TrackLots"] && !item["Part_TrackSerialNum"]) {
      //   manualQty = true;
      // }

      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: rowcolor,
          ),
          children: [
            tableCellRow(item["TFShipDtl_PackLine"].toString()),
            tableCellRow("$ordernum/$orderline"),
            tableCellRow(item["TFShipDtl_PackNum"].toString()),
            manualQty
                ? TableCell(
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      height: 28,
                      child: Align(
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: itemQty[i],
                          style: TextStyles.getBold(12),
                          decoration: InputDecoration(
                            hintText: "Qty",
                            hintStyle: TextStyles.getRegularScund(
                              12,
                              color: AppColors.colorGray600,
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 11,
                              bottom: 16,
                            ),
                            counterText: "",
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            items[i]["TFShipDtl_OurStockShippedQty"] = val;
                            items[i]["prdTrack"] = getType(items[i]);
                            itemQty[i].text =
                                items[i]["TFShipDtl_OurStockShippedQty"];
                            setState(() {});
                          },
                          autofocus: false,
                          readOnly: (item["prdTrack"] == "1" ||
                              item["prdTrack"] == "3"),
                        ),
                      ),
                    ),
                  )
                : tableCellRow(
                    double.parse(
                            item["TFShipDtl_OurStockShippedQty"].toString())
                        .toStringAsFixed(0),
                  ),
            tableCellRow(
              double.parse(item["TFShipDtl_VS_QtyToShip_c"].toString())
                  .toStringAsFixed(0),
            ),
            tableCellRow(item["TFShipDtl_LineDesc"].toString()),
            tableCellRow("$warehouse/$bin"),
            tableCellRow(item["TFShipDtl_LotNum"].toString()),
            tableCellRow(item["TFShipDtl_IUM"].toString()),
            tableCellRow(item["Calculated_PartType"].toString()),
            // item["isSelect"]
            //     ? TableCell(
            //         child: Container(
            //           margin: const EdgeInsets.all(6),
            //           height: 28,
            //           child: TextFormField(
            //             controller: itemQty[i],
            //             style: TextStyles.getBold(12),
            //             decoration: InputDecoration(
            //               hintText: "Qty",
            //               hintStyle: TextStyles.getRegularScund(
            //                 12,
            //                 color: AppColors.colorGray600,
            //               ),
            //               contentPadding: const EdgeInsets.only(
            //                 left: 4,
            //                 bottom: 16,
            //               ),
            //               counterText: "",
            //             ),
            //             keyboardType: TextInputType.name,
            //             onChanged: (val) {
            //               items[i]["ShipDtl_OurInventoryShipQty"] = val;
            //               setState(() {});
            //             },
            //             autofocus: false,
            //             readOnly: (item["prdTrack"] == "1" ||
            //                 item["prdTrack"] == "3"),
            //           ),
            //         ),
            //       )
            //     : tableCellRow(item["ShipDtl_OurInventoryShipQty"]),
            // tableCellRow(item["ShipDtl_OurInventoryShipQty"]),
          ],
        ),
      );
    }
    return rows;
  }

  Widget tableCell(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            text,
            style: TextStyles.getBold(
              14,
              color: AppColors.colorDataColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget tableCellRow(String text) {
    return TableCell(
      child: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              text,
              style: TextStyles.getRegularScund(14),
            ),
          ),
        ),
      ),
    );
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
