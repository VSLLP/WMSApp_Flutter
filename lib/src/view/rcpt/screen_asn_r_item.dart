import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/rcpt/screen_asn_line.dart';
import 'package:http/http.dart';

class ScreenAsnRItem extends StatefulWidget {
  final dynamic item;
  final String packNum;

  const ScreenAsnRItem({
    super.key,
    required this.item,
    required this.packNum,
  });

  @override
  State<ScreenAsnRItem> createState() => _ScreenAsnRItemState();
}

class _ScreenAsnRItemState extends State<ScreenAsnRItem> {
  List<dynamic> productItems = [];
  List<dynamic> whareHouses = [];
  List<dynamic> bins = [];
  List<dynamic> snFormats = [];
  List<dynamic> srItems = [];

  var txtScan = TextEditingController();
  var txtQty = TextEditingController();
  var txtWare = TextEditingController();
  var txtBin = TextEditingController();

  bool isLoading = true;
  bool isInsp = false;
  bool isLot = false;

  int qty = 0;

  String plant = "";
  String company = "";
  String partNum = "";
  String wherId = "";

  String lotNum = "";

  @override
  void initState() {
    lotNum = "";
    super.initState();
    loadData();
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
                            'Receipt Details',
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
                                                int itemIndex =
                                                    productItems.indexWhere(
                                                  (item) =>
                                                      item['Part_PartNum'] ==
                                                      partNum,
                                                );
                                                productItems[itemIndex]
                                                    ['isSelect'] = false;
                                                txtQty.text = "";
                                                txtScan.text = "";
                                                isLot = false;
                                                qty = 0;
                                                setState(() {
                                                  partNum = "";
                                                });
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
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
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
                            SizedBox(
                              height: !isLot ? 14 : 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Recived Qty: ",
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: !isLot
                                      ? SizedBox(
                                          child: Text(
                                            "Qty: $qty",
                                            style: TextStyles.getBold(
                                              14,
                                              color: AppColors.colorDataColor,
                                            ),
                                          ),
                                        )
                                      : TextFormField(
                                          controller: txtQty,
                                          style: TextStyles.getBold(
                                            12,
                                            color: AppColors.colorBlack,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Qty",
                                            hintStyle:
                                                TextStyles.getRegularScund(
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
                                          keyboardType: TextInputType.number,
                                          onChanged: (val) {
                                            if (partNum.isNotEmpty) {
                                              int itemIndex =
                                                  productItems.indexWhere(
                                                (item) =>
                                                    item['Part_PartNum'] ==
                                                    partNum,
                                              );
                                              if (val.isNotEmpty) {
                                                qty = int.parse(val);
                                                productItems[itemIndex]
                                                    ['ScanQty'] = qty;
                                              } else {
                                                qty = 0;
                                                productItems[itemIndex]
                                                    ['ScanQty'] = 0;
                                              }
                                            } else {
                                              txtQty.text = "";
                                            }
                                          },
                                        ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: !isLot ? 6 : 0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Warehouse: ",
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
                                    controller: txtWare,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Warehouse",
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
                                    onTap: () {
                                      chooseWaereHouse();
                                    },
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select warehouse.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Binnum: ",
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
                                    controller: txtBin,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Binnum",
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
                                    onTap: () {
                                      chooseBin();
                                    },
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select binnum.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     // SizedBox(
                            //     //   // width:
                            //     //   //     MediaQuery.of(context).size.width * 0.15,
                            //     //   child: Text(
                            //     //     "Inspection: ",
                            //     //     style: TextStyles.getBold(
                            //     //       14,
                            //     //       color: AppColors.colorDataColor,
                            //     //     ),
                            //     //   ),
                            //     // ),
                            //     // Container(
                            //     //   width:
                            //     //       MediaQuery.of(context).size.width * 0.4,
                            //     //   color: Colors.transparent,
                            //     //   child: Row(
                            //     //     children: [
                            //     //       Checkbox(
                            //     //         checkColor: AppColors.colorWhite,
                            //     //         activeColor: AppColors.colorAssent,
                            //     //         value: isInsp,
                            //     //         onChanged: (bool? value) {
                            //     //           setState(() {
                            //     //             isInsp = value ?? false;
                            //     //           });
                            //     //           getCheangeInsp();
                            //     //         },
                            //     //       ),
                            //     //       SizedBox(
                            //     //         child: Text(
                            //     //             "Lot no:  ${lotNum == '' ? '-' : lotNum}"),
                            //     //       )
                            //     //     ],
                            //     //   ),
                            //     // ),
                            //   ],
                            // ),

                            const SizedBox(
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.colorWhite,
                                  borderRadius: BorderRadius.circular(4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.colorTansprent20,
                                      blurRadius: 4,
                                      offset: const Offset(-4, 4),
                                    )
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        color: Colors.transparent,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Table(
                                            columnWidths: const {
                                              // TODO::  Add New Columns
                                              0: FixedColumnWidth(100),
                                              1: FixedColumnWidth(60),
                                              2: FixedColumnWidth(100),
                                              3: FixedColumnWidth(120),
                                              4: FixedColumnWidth(90),
                                              5: FixedColumnWidth(90)
                                            },
                                            border: const TableBorder.symmetric(
                                              inside: BorderSide(
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
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (!isLoading) {
                                      gotoGRNLine();
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
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: Text(
                                          'GRN Lines',
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
                                    if (!isLoading) {
                                      submit();
                                    }
                                  },
                                  child: Container(
                                    height: 38,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: AppColors.colorWhite,
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
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8.0,
                                        ),
                                        child: Text(
                                          'Submit', // Check what BAQ and Api are called
                                          style: TextStyles.getBold(
                                            16,
                                            color: AppColors.colorAssent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 60,
                            ),
                          ],
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

  loadData() async {
    plant = await sharedPref.getString("userPlant");
    company = await sharedPref.getString("userCompnay");

    var resB = await inventoryServices
        .getASNDtl(widget.item['POHeader_PONum'].toString());
    productItems = resB['value'];
    for (int i = 0; i < productItems.length; i++) {
      productItems[i]['isSelect'] = false;
      productItems[i]['ScanQty'] = 0;
    }

    setState(() {
      isLoading = false;
    });
  }

  List<TableRow> getRows() {
    List<TableRow> rows = [];
    rows.add(TableRow(
      children: [
        tableCell('Po Num'),
        tableCell('Line'),
        tableCell('Part'),
        tableCell('Supplier Qty'),
        tableCell('Our Qty'),
        tableCell("Lot Num")
      ],
    ));
    for (int i = 0; i < productItems.length; i++) {
      var item = productItems[i];
      // print(item);
      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: productItems[i]['isSelect']
                ? AppColors.colorCyan300
                : Colors.transparent,
          ),
          children: [
            tableCellRow(item["PODetail_PONUM"].toString()),
            tableCellRow(item["PODetail_POLine"].toString()),
            tableCellRow(item["Part_PartNum"].toString()),
            tableCellRow(
              double.parse(item["PODetail_OrderQty"].toString())
                  .toStringAsFixed(2),
            ),
            tableCellRow(
              double.parse(item["ScanQty"].toString()).toStringAsFixed(2),
            ),
            tableCell(item["lotNum"].toString())
          ],
        ),
      );
    }
    return rows;
  }

  getType(item) {
    if (item['Part_TrackLots'] && item['Part_TrackSerialNum']) {
      return "1";
    }
    if (item['Part_TrackLots']) {
      return "2";
    }
    if (item['Part_TrackSerialNum']) {
      return "3";
    }
    return '4';
  }

  getCheangeInsp() async {
    setState(() {
      isLoading = true;
    });
    var resW = await utilServices.getWareHouses(partNum);
    whareHouses.clear();
    whareHouses = resW['value'];

    if (isInsp) {
      txtWare.text = whareHouses[0]['Calculated_ReceiptInspWarehouse'];
      wherId = whareHouses[0]['Calculated_ReceiptInspWarehouse'];
      txtBin.text = whareHouses[0]['Calculated_ReceiptInspBin'];
    } else {
      txtWare.text = whareHouses[0]['Calculated_ReceiptWarhouse'];
      wherId = whareHouses[0]['Calculated_ReceiptWarhouse'];
      txtBin.text = whareHouses[0]['Calculated_ReceiptBin'];
    }

    setState(() {
      isLoading = false;
    });
  }

  // getPartAsync(val) async {
  //   try {
  //     if (val.length <= 3) {
  //       return;
  //     }
  //     String splitKey = "";
  //     if (val.contains("\r\n")) {
  //       splitKey = "\r\n";
  //     } else if (val.contains("\n")) {
  //       splitKey = "\n";
  //     } else if (val.contains("~")) {
  //       splitKey = "~";
  //     } else if (val.contains("~\n")) {
  //       splitKey = "~\n";
  //     }

  //     List<String> words = val.split(splitKey);
  //     if (words.length <= 2) {
  //       return;
  //     }

  //     String partCode = words[1].replaceAll("Part Code - ", '');
  //     String partLot = words[4].replaceAll("Lot No. -", '').replaceAll(" ", "");
  //     lotNum = partLot;
  //     String partSerial = words[5].replaceAll("Serial No. - ", '');

  //     int itemIndex =
  //         productItems.indexWhere((item) => item['Part_PartNum'] == partCode);

  //     if (itemIndex == -1) {
  //       throw Exception("Please scan valid product in PO.");
  //     } else {
  //       productItems[itemIndex]['isSelect'] = true;
  //       String prdType = getType(productItems[itemIndex]);

  //       partNum = partCode;
  //       txtQty.text = productItems[itemIndex]['ScanQty'].toString();
  //       qty = productItems[itemIndex]['ScanQty'];

  //       setState(() {
  //         isLoading = true;
  //       });

  //       switch (prdType) {
  //         case '1':
  //           productItems[itemIndex]['lotNum'] = partLot;

  //           var resA = await utilServices.getSerialMapping(partCode);
  //           var payload = resA['value'][0];

  //           int seIndex = srItems
  //               .indexWhere((item) => item['SerialNumber'] == partSerial);

  //           if (seIndex != -1) {
  //             throw Exception("Product already scanned.");
  //           }

  //           srItems.add({
  //             "Company": company,
  //             "SerialNumber": partSerial,
  //             "PartNum": partCode,
  //             "SNBaseNumber": partSerial.substring(0, 15),
  //             "TransType": "PUR-STK",
  //             "RawSerialNum": partSerial,
  //             "SNMask": payload['Part_SNMask'],
  //             "RowMod": "A"
  //           });

  //           qty = srItems.where((item) => item["PartNum"] == partCode).length;
  //           txtQty.text = qty.toString();
  //           productItems[itemIndex]['ScanQty'] = qty;

  //           isLot = false; // Don't show manual quantity input

  //           // print("The productItems[itemIndex]['ScanQty'] $qty");

  //           int snIndex =
  //               snFormats.indexWhere((item) => item['PartNum'] == partCode);
  //           if (snIndex == -1) {
  //             snFormats.add({
  //               "Plant": plant,
  //               "PartNum": partCode,
  //               "SNMask": payload['Part_SNMask'],
  //               "SNBaseDataType": payload['Part_SNBaseDataType'],
  //               "PartPricePerCode": payload['Part_PricePerCode'],
  //               "PartSellingFactor": payload['Part_SellingFactor'],
  //               "RowMod": "A"
  //             });
  //           }

  //           break;
  //         case '2':
  //           productItems[itemIndex]['lotNum'] = partLot;
  //           isLot = true;
  //           break;
  //         case '3':
  //           var resA = await utilServices.getSerialMapping(partCode);
  //           var payload = resA['value'][0];
  //           productItems[itemIndex]['lotNum'] = "";

  //           int seIndex = srItems
  //               .indexWhere((item) => item['SerialNumber'] == partSerial);

  //           if (seIndex != -1) {
  //             throw Exception("Product already scanned.");
  //           }

  //           srItems.add({
  //             "Company": company,
  //             "SerialNumber": partSerial,
  //             "PartNum": partCode,
  //             "SNBaseNumber": partSerial.substring(0, 15),
  //             "TransType": "PUR-STK",
  //             "RawSerialNum": partSerial,
  //             "SNMask": payload['Part_SNMask'],
  //             "RowMod": "A"
  //           });

  //           qty = srItems.where((item) => item["PartNum"] == partCode).length;
  //           txtQty.text = qty.toString();
  //           productItems[itemIndex]['ScanQty'] = qty;
  //           // productItems[itemIndex][]

  //           isLot = false;
  //           int snIndex =
  //               snFormats.indexWhere((item) => item['PartNum'] == partCode);
  //           if (snIndex == -1) {
  //             snFormats.add({
  //               "Plant": plant,
  //               "PartNum": partCode,
  //               "SNMask": payload['Part_SNMask'],
  //               "SNBaseDataType": payload['Part_SNBaseDataType'],
  //               "PartPricePerCode": payload['Part_PricePerCode'],
  //               "PartSellingFactor": payload['Part_SellingFactor'],
  //               "RowMod": "A"
  //             });
  //           }
  //           break;
  //         case '4':
  //           isLot = true;
  //           break;
  //       }

  //       setState(() {
  //         isLoading = true;
  //       });
  //       var resW = await utilServices.getWareHouses(partNum);
  //       whareHouses.clear();
  //       whareHouses = resW['value'];

  //       if (isInsp) {
  //         txtWare.text = whareHouses[0]['Calculated_ReceiptInspWarehouse'];
  //         wherId = whareHouses[0]['Calculated_ReceiptWarhouse'];
  //         txtBin.text = whareHouses[0]['Calculated_ReceiptInspBin'];
  //       } else {
  //         txtWare.text = whareHouses[0]['Calculated_ReceiptWarhouse'];
  //         wherId = whareHouses[0]['Calculated_ReceiptWarhouse'];
  //         txtBin.text = whareHouses[0]['Calculated_ReceiptBin'];
  //       }
  //     }
  //   } catch (ex) {
  //     showError('Error', ex.toString());
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
  // getPartAsync(val) async {
  //   try {
  //     if (val.length <= 3) {
  //       return;
  //     }
  //     String splitKey = "";
  //     if (val.contains("\r\n")) {
  //       splitKey = "\r\n";
  //     } else if (val.contains("\n")) {
  //       splitKey = "\n";
  //     } else if (val.contains("~")) {
  //       splitKey = "~";
  //     } else if (val.contains("~\n")) {
  //       splitKey = "~\n";
  //     }

  //     List<String> words = val.split(splitKey);
  //     if (words.length <= 2) {
  //       return;
  //     }

  //     String partCode = words[1].replaceAll("Part Code - ", '');
  //     String partLot = words[4].replaceAll("Lot No. -", '').replaceAll(" ", "");
  //     lotNum = partLot;
  //     String partSerial = words[5].replaceAll("Serial No. - ", '');

  //     // Find all instances of this part in productItems
  //     List<int> itemIndexes = [];
  //     for (int i = 0; i < productItems.length; i++) {
  //       if (productItems[i]['Part_PartNum'] == partCode) {
  //         itemIndexes.add(i);
  //       }
  //     }

  //     if (itemIndexes.isEmpty) {
  //       throw Exception("Please scan valid product in PO.");
  //     }

  //     // Find if there's an existing entry with the same lot number
  //     int matchingLotIndex = -1;
  //     for (int index in itemIndexes) {
  //       if (productItems[index]['lotNum'] == partLot) {
  //         matchingLotIndex = index;
  //         break;
  //       }
  //     }

  //     // If no matching lot found and part tracking lots, create new entry
  //     if (matchingLotIndex == -1 &&
  //         productItems[itemIndexes[0]]['Part_TrackLots']) {
  //       // Clone the first instance of this part
  //       var newItem = Map<String, dynamic>.from(productItems[itemIndexes[0]]);
  //       newItem['isSelect'] = true;
  //       newItem['ScanQty'] = 0;
  //       newItem['lotNum'] = partLot;

  //       // Add the new item to productItems
  //       productItems.add(newItem);
  //       matchingLotIndex = productItems.length - 1;
  //     } else if (matchingLotIndex == -1) {
  //       // If not tracking lots, use the first instance
  //       matchingLotIndex = itemIndexes[0];
  //     }

  //     productItems[matchingLotIndex]['isSelect'] = true;
  //     String prdType = getType(productItems[matchingLotIndex]);

  //     partNum = partCode;
  //     txtQty.text = productItems[matchingLotIndex]['ScanQty'].toString();
  //     qty = productItems[matchingLotIndex]['ScanQty'];

  //     setState(() {
  //       isLoading = true;
  //     });

  //     switch (prdType) {
  //       case '1': // Both lot and serial
  //         productItems[matchingLotIndex]['lotNum'] = partLot;

  //         var resA = await utilServices.getSerialMapping(partCode);
  //         var payload = resA['value'][0];

  //         int seIndex =
  //             srItems.indexWhere((item) => item['SerialNumber'] == partSerial);

  //         if (seIndex != -1) {
  //           throw Exception("Product already scanned.");
  //         }

  //         srItems.add({
  //           "Company": company,
  //           "SerialNumber": partSerial,
  //           "PartNum": partCode,
  //           "SNBaseNumber": partSerial.substring(0, 15),
  //           "TransType": "PUR-STK",
  //           "RawSerialNum": partSerial,
  //           "SNMask": payload['Part_SNMask'],
  //           "RowMod": "A"
  //         });

  //         qty = srItems.where((item) => item["PartNum"] == partCode).length;
  //         txtQty.text = qty.toString();
  //         productItems[matchingLotIndex]['ScanQty'] = qty;

  //         isLot = false;

  //         int snIndex =
  //             snFormats.indexWhere((item) => item['PartNum'] == partCode);
  //         if (snIndex == -1) {
  //           snFormats.add({
  //             "Plant": plant,
  //             "PartNum": partCode,
  //             "SNMask": payload['Part_SNMask'],
  //             "SNBaseDataType": payload['Part_SNBaseDataType'],
  //             "PartPricePerCode": payload['Part_PricePerCode'],
  //             "PartSellingFactor": payload['Part_SellingFactor'],
  //             "RowMod": "A"
  //           });
  //         }
  //         break;

  //       case '2': // Lot only
  //         productItems[matchingLotIndex]['lotNum'] = partLot;
  //         isLot = true;
  //         break;

  //       case '3': // Serial only
  //         var resA = await utilServices.getSerialMapping(partCode);
  //         var payload = resA['value'][0];
  //         productItems[matchingLotIndex]['lotNum'] = "";

  //         int seIndex =
  //             srItems.indexWhere((item) => item['SerialNumber'] == partSerial);

  //         if (seIndex != -1) {
  //           throw Exception("Product already scanned.");
  //         }

  //         srItems.add({
  //           "Company": company,
  //           "SerialNumber": partSerial,
  //           "PartNum": partCode,
  //           "SNBaseNumber": partSerial.substring(0, 15),
  //           "TransType": "PUR-STK",
  //           "RawSerialNum": partSerial,
  //           "SNMask": payload['Part_SNMask'],
  //           "RowMod": "A"
  //         });

  //         qty = srItems.where((item) => item["PartNum"] == partCode).length;
  //         txtQty.text = qty.toString();
  //         productItems[matchingLotIndex]['ScanQty'] = qty;

  //         isLot = false;
  //         int snIndex =
  //             snFormats.indexWhere((item) => item['PartNum'] == partCode);
  //         if (snIndex == -1) {
  //           snFormats.add({
  //             "Plant": plant,
  //             "PartNum": partCode,
  //             "SNMask": payload['Part_SNMask'],
  //             "SNBaseDataType": payload['Part_SNBaseDataType'],
  //             "PartPricePerCode": payload['Part_PricePerCode'],
  //             "PartSellingFactor": payload['Part_SellingFactor'],
  //             "RowMod": "A"
  //           });
  //         }
  //         break;

  //       case '4': // Regular item
  //         isLot = true;
  //         break;
  //     }

  //     setState(() {
  //       isLoading = true;
  //     });

  //     var resW = await utilServices.getWareHouses(partNum);
  //     whareHouses.clear();
  //     whareHouses = resW['value'];

  //     if (isInsp) {
  //       txtWare.text = whareHouses[0]['Calculated_ReceiptInspWarehouse'];
  //       wherId = whareHouses[0]['Calculated_ReceiptWarhouse'];
  //       txtBin.text = whareHouses[0]['Calculated_ReceiptInspBin'];
  //     } else {
  //       txtWare.text = whareHouses[0]['Calculated_ReceiptWarhouse'];
  //       wherId = whareHouses[0]['Calculated_ReceiptWarhouse'];
  //       txtBin.text = whareHouses[0]['Calculated_ReceiptBin'];
  //     }
  //   } catch (ex) {
  //     showError('Error', ex.toString());
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
  getPartAsync(val) async {
    // if (val.length <= 3) {
    //   return;
    // }

    // Determine the split key

    // // Handle different tracking types
    // String prdType = getType(productItems[itemIndexes[0]]);
    // int targetIndex;

    // switch (prdType) {
    //   case '2': // Lot only
    //     // Find existing lot or empty lot slot

    // }
    try {
      if (val.length <= 3) {
        return;
      }

      String splitKey = "";
      if (val.contains("\r\n")) {
        splitKey = "\r\n";
      } else if (val.contains("\n")) {
        splitKey = "\n";
      } else if (val.contains("~")) {
        splitKey = "~";
      } else if (val.contains("~\n")) {
        splitKey = "~\n";
      }

      // Split the scanned value
      List<String> words = val.split(splitKey);

      // Validate we have enough data
      if (words.isEmpty) {
        throw Exception("Invalid scan format");
      }

      // Extract part code - safely handle different scan formats
      String partCode = '';
      String partLot = '';
      String partSerial = '';

      // Try to extract information based on scan format
      for (String word in words) {
        if (word.contains("Part Code -")) {
          partCode = word.replaceAll("Part Code - ", '').trim();
        } else if (word.contains("Lot No.")) {
          partLot = word.replaceAll("Lot No. -", '').replaceAll(" ", "").trim();
        } else if (word.contains("Serial No.")) {
          partSerial = word.replaceAll("Serial No. - ", '').trim();
        }
      }

      // Validate part code was found
      if (partCode.isEmpty) {
        throw Exception("Part code not found in scan");
      }

      // Find matching items for the part
      List<int> itemIndexes = [];
      for (int i = 0; i < productItems.length; i++) {
        if (productItems[i]['Part_PartNum'] == partCode) {
          itemIndexes.add(i);
        }
      }

      if (itemIndexes.isEmpty) {
        throw Exception("Please scan valid product in PO.");
      }

      // String splitKey = "";
      // if (val.contains("\r\n")) {
      //   splitKey = "\r\n";
      // } else if (val.contains("\n")) {
      //   splitKey = "\n";
      // } else if (val.contains("~")) {
      //   splitKey = "~";
      // } else if (val.contains("~\n")) {
      //   splitKey = "~\n";
      // }

      // List<String> words = val.split(splitKey);
      // if (words.length <= 2) {
      //   return;
      // }

      // // String partCode = words[1].replaceAll("Part Code - ", '');
      // // String partLot = words[4].replaceAll("Lot No. -", '').replaceAll(" ", "");
      // // lotNum = partLot;
      // // String partSerial = words[5].replaceAll("Serial No. - ", '');

      // String partCode = words[1].replaceAll("Part Code - ", '');
      // String partLot = words[4].replaceAll("Lot No. -", '').replaceAll(" ", "");
      // lotNum = partLot;
      // String partSerial = words[5].replaceAll("Serial No. - ", '');

      // // Find all instances of this part in productItems
      // List<int> itemIndexes = [];
      // for (int i = 0; i < productItems.length; i++) {
      //   if (productItems[i]['Part_PartNum'] == partCode) {
      //     itemIndexes.add(i);
      //   }
      // }

      // if (itemIndexes.isEmpty) {
      //   throw Exception("Please scan valid product in PO.");
      // }

      // Find if there's an existing entry with the same lot number
      int nullLotIndex = -1;
      for (int index in itemIndexes) {
        if (productItems[index]['lotNum'] == null ||
            productItems[index]['lotNum'] == "") {
          nullLotIndex = index;
          break;
        }
      }
      // Then check for matching lot number if no null entry found
      int matchingLotIndex = -1;
      if (nullLotIndex == -1) {
        for (int index in itemIndexes) {
          if (productItems[index]['lotNum'] == partLot) {
            matchingLotIndex = index;
            break;
          }
        }
      }

      // Determine which index to use
      int targetIndex;
      if (nullLotIndex != -1) {
        // Use the first entry with null lotNum
        targetIndex = nullLotIndex;
      } else if (matchingLotIndex != -1) {
        // Use existing entry with matching lot number
        targetIndex = matchingLotIndex;
      } else if (productItems[itemIndexes[0]]['Part_TrackLots']) {
        // Create new entry for new lot number
        var newItem = Map<String, dynamic>.from(productItems[itemIndexes[0]]);
        newItem['isSelect'] = true;
        newItem['ScanQty'] = 0;
        newItem['lotNum'] = partLot;
        // newItem[''] = partSerial;

        productItems.add(newItem);
        targetIndex = productItems.length - 1;
      } else {
        // If not tracking lots, use the first instance
        targetIndex = itemIndexes[0];
      }

      productItems[targetIndex]['isSelect'] = true;
      String prdType = getType(productItems[targetIndex]);

      partNum = partCode;
      txtQty.text = productItems[targetIndex]['ScanQty'].toString();
      qty = productItems[targetIndex]['ScanQty'];

      setState(() {
        isLoading = true;
      });

      switch (prdType) {
        case '1':
          // Both lot and serial

          productItems[targetIndex]['lotNum'] = partLot;

          var resA = await utilServices.getSerialMapping(partCode);
          var payload = resA['value'][0];

          int seIndex = srItems.indexWhere((item) =>
              item['SerialNumber'] == partSerial && item['LotNum'] == partLot);

          if (seIndex != -1) {
            throw Exception("Product already scanned.");
          }
          double requiredQty = double.parse(
              productItems[targetIndex]['PODetail_OrderQty'].toString());

          int existingSerials = srItems
              .where((item) =>
                  item["PartNum"] == partCode && item["LotNum"] == partLot)
              .length;

          // Check if adding another serial would exceed required quantity
          if (existingSerials >= requiredQty) {
            throw Exception(
                "Cannot scan more items. Required quantity already met.");
          }
          srItems.add({
            "Company": company,
            "SerialNumber": partSerial,
            "PartNum": partCode,
            "LotNum": partLot, // Add lot number to srItems
            "SNBaseNumber": partSerial.substring(0, 15),
            "TransType": "PUR-STK",
            "RawSerialNum": partSerial,
            "SNMask": payload['Part_SNMask'],
            "RowMod": "A"
          });

          // Count only serial numbers matching both part and lot
          qty = existingSerials + 1;
          txtQty.text = qty.toString();
          productItems[targetIndex]['ScanQty'] = qty;

          isLot = false;

          int snIndex =
              snFormats.indexWhere((item) => item['PartNum'] == partCode);
          if (snIndex == -1) {
            snFormats.add({
              "Plant": plant,
              "PartNum": partCode,
              "SNMask": payload['Part_SNMask'],
              "SNBaseDataType": payload['Part_SNBaseDataType'],
              "PartPricePerCode": payload['Part_PricePerCode'],
              "PartSellingFactor": payload['Part_SellingFactor'],
              "RowMod": "A"
            });
          }
          break;

        // case '2': // Lot only
        //   // productItems[matchingLotIndex]['lotNum'] = partLot;
        //   // isLot = true;
        //   targetIndex = -1;
        //   for (int index in itemIndexes) {
        //     if (productItems[index]['lotNum'] == partLot) {
        //       targetIndex = index;
        //       break;
        //     }
        //   }

        //   // If no matching lot found, look for empty lot slot
        //   if (targetIndex == -1) {
        //     for (int index in itemIndexes) {
        //       if (productItems[index]['lotNum'] == null ||
        //           productItems[index]['lotNum'] == '') {
        //         targetIndex = index;
        //         break;
        //       }
        //     }
        //   }

        //   // If still no slot found, create new item
        //   if (targetIndex == -1) {
        //     var newItem =
        //         Map<String, dynamic>.from(productItems[itemIndexes[0]]);
        //     newItem['isSelect'] = true;
        //     newItem['ScanQty'] = 0;
        //     newItem['lotNum'] = partLot;
        //     productItems.add(newItem);
        //     targetIndex = productItems.length - 1;
        //   }

        //   productItems[targetIndex]['isSelect'] = true;
        //   productItems[targetIndex]['lotNum'] = partLot;
        //   isLot = true;
        //   break;

        case '2': // Lot only
          // Reset any previous selections
          for (var item in productItems) {
            item['isSelect'] = false;
          }

          // First try to find existing item with this lot number
          targetIndex = itemIndexes.firstWhere(
              (index) => productItems[index]['lotNum'] == partLot,
              orElse: () => -1);

          // If lot not found, look for empty slot only if we haven't created a line for this lot yet
          if (targetIndex == -1) {
            targetIndex = itemIndexes.firstWhere(
                (index) =>
                    productItems[index]['lotNum'] == null ||
                    productItems[index]['lotNum'].toString().trim() == '',
                orElse: () => -1);
          }

          // If still no slot and part tracks lots, create new item
          if (targetIndex == -1 &&
              productItems[itemIndexes[0]]['Part_TrackLots'] == true) {
            // Before creating new item, verify this lot doesn't already have a line
            bool lotExists = false;
            for (var item in productItems) {
              if (item['Part_PartNum'] == partCode &&
                  item['lotNum'] == partLot) {
                lotExists = true;
                targetIndex = productItems.indexOf(item);
                break;
              }
            }

            // Only create new item if lot doesn't exist
            if (!lotExists) {
              var newItem =
                  Map<String, dynamic>.from(productItems[itemIndexes[0]]);
              newItem['isSelect'] = true;
              newItem['ScanQty'] = 0; // Initialize new quantity
              newItem['lotNum'] = partLot;
              productItems.add(newItem);
              targetIndex = productItems.length - 1;
            }
          } else if (targetIndex == -1) {
            // If not tracking lots, use first item
            targetIndex = itemIndexes[0];
          }

          if (targetIndex != -1) {
            // Set the selected item
            productItems[targetIndex]['isSelect'] = true;
            productItems[targetIndex]['lotNum'] = partLot;

            // Update display values with the SELECTED item's values
            partNum = partCode;
            qty = productItems[targetIndex]['ScanQty'];
            txtQty.text = qty.toString();
          }

          isLot = true;
          break;

        // break;

        // case '3': // Serial only
        //   var resA = await utilServices.getSerialMapping(partCode);
        //   var payload = resA['value'][0];
        //   productItems[targetIndex]['lotNum'] = "";

        //   int seIndex =
        //       srItems.indexWhere((item) => item['SerialNumber'] == partSerial);

        //   if (seIndex != -1) {
        //     throw Exception("Product already scanned.");
        //   }

        //   double requiredQty = double.parse(
        //       productItems[targetIndex]['PODetail_OrderQty'].toString());
        //   int existingSerials =
        //       srItems.where((item) => item["PartNum"] == partCode).length;
        //   if (existingSerials >= requiredQty) {
        //     throw Exception(
        //         "Cannot scan more items. Required quantity already met.");
        //   }

        //   srItems.add({
        //     "Company": company,
        //     "SerialNumber": partSerial,
        //     "PartNum": partCode,
        //     "SNBaseNumber": partSerial.substring(0, 15),
        //     "TransType": "PUR-STK",
        //     "RawSerialNum": partSerial,
        //     "SNMask": payload['Part_SNMask'],
        //     "RowMod": "A"
        //   });

        //   // Count only serial numbers matching the part
        //   qty = existingSerials + 1;
        //   txtQty.text = qty.toString();
        //   productItems[targetIndex]['ScanQty'] = qty;

        //   // isLot = false;

        //   isLot = false;
        //   int snIndex =
        //       snFormats.indexWhere((item) => item['PartNum'] == partCode);
        //   if (snIndex == -1) {
        //     snFormats.add({
        //       "Plant": plant,
        //       "PartNum": partCode,
        //       "SNMask": payload['Part_SNMask'],
        //       "SNBaseDataType": payload['Part_SNBaseDataType'],
        //       "PartPricePerCode": payload['Part_PricePerCode'],
        //       "PartSellingFactor": payload['Part_SellingFactor'],
        //       "RowMod": "A"
        //     });
        //   }
        //   break;

        // case '3':
        //   var resA = await utilServices.getSerialMapping(partCode);
        //   var payload = resA['value'][0];
        //   productItems[targetIndex]['lotNum'] = "";

        //   // Only check quantity limit for this part
        //   double requiredQty = double.parse(
        //       productItems[targetIndex]['PODetail_OrderQty'].toString());
        //   int existingSerials =
        //       srItems.where((item) => item["PartNum"] == partCode).length;

        //   if (existingSerials >= requiredQty) {
        //     throw Exception(
        //         "Cannot scan more items. Required quantity already met.");
        //   }

        //   // Simply assign the scanned serial number, just like in case '1'
        //   srItems.add({
        //     "Company": company,
        //     "SerialNumber": partSerial,
        //     "PartNum": partCode,
        //     "SNBaseNumber": partSerial.substring(0, 15),
        //     "TransType": "PUR-STK",
        //     "RawSerialNum": partSerial,
        //     "SNMask": payload['Part_SNMask'],
        //     "RowMod": "A"
        //   });

        //   qty = existingSerials + 1;
        //   txtQty.text = qty.toString();
        //   productItems[targetIndex]['ScanQty'] = qty;

        //   isLot = false;
        //   int snIndex =
        //       snFormats.indexWhere((item) => item['PartNum'] == partCode);
        //   if (snIndex == -1) {
        //     snFormats.add({
        //       "Plant": plant,
        //       "PartNum": partCode,
        //       "SNMask": payload['Part_SNMask'],
        //       "SNBaseDataType": payload['Part_SNBaseDataType'],
        //       "PartPricePerCode": payload['Part_PricePerCode'],
        //       "PartSellingFactor": payload['Part_SellingFactor'],
        //       "RowMod": "A"
        //     });
        //   }
        //   break;

        case '3': // Serial only
          var resA = await utilServices.getSerialMapping(partCode);
          var payload = resA['value'][0];
          productItems[targetIndex]['lotNum'] = "";

          // Check if this serial number already exists
          int seIndex =
              srItems.indexWhere((item) => item['SerialNumber'] == partSerial);

          if (seIndex != -1) {
            throw Exception("Product already scanned.");
          }

          // Verify quantity limits
          double requiredQty = double.parse(
              productItems[targetIndex]['PODetail_OrderQty'].toString());
          int existingSerials =
              srItems.where((item) => item["PartNum"] == partCode).length;

          if (existingSerials >= requiredQty) {
            throw Exception(
                "Cannot scan more items. Required quantity already met.");
          }

          // Add the serial number with minimal required fields
          srItems.add({
            "Company": company,
            "SerialNumber": partSerial,
            "PartNum": partCode,
            "SNBaseNumber": partSerial, // Changed from substring
            "TransType": "PUR-STK",
            "RawSerialNum": partSerial,
            "SNMask": payload['Part_SNMask'],
            "RowMod": "A"
          });

          // Update quantities
          qty = existingSerials + 1;
          txtQty.text = qty.toString();
          productItems[targetIndex]['ScanQty'] = qty;

          isLot = false;

          // Only add to snFormats if not already present
          int snIndex =
              snFormats.indexWhere((item) => item['PartNum'] == partCode);
          if (snIndex == -1) {
            snFormats.add({
              "Plant": plant,
              "PartNum": partCode,
              "SNMask": payload['Part_SNMask'],
              "SNBaseDataType": payload['Part_SNBaseDataType'],
              "PartPricePerCode": payload['Part_PricePerCode'],
              "PartSellingFactor": payload['Part_SellingFactor'],
              "RowMod": "A"
            });
          }
          break;
        case '4': // Regular item
          isLot = true;
          break;
      }

      setState(() {
        isLoading = true;
      });

      var resW = await utilServices.getWareHouses(partNum);
      whareHouses.clear();
      whareHouses = resW['value'];

      if (isInsp) {
        txtWare.text = whareHouses[0]['Calculated_ReceiptInspWarehouse'];
        wherId = whareHouses[0]['Calculated_ReceiptWarhouse'];
        txtBin.text = whareHouses[0]['Calculated_ReceiptInspBin'];
      } else {
        txtWare.text = whareHouses[0]['Calculated_ReceiptWarhouse'];
        wherId = whareHouses[0]['Calculated_ReceiptWarhouse'];
        txtBin.text = whareHouses[0]['Calculated_ReceiptBin'];
      }
    } catch (ex) {
      showError('Error', ex.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  chooseWaereHouse() async {
    setState(() {
      isLoading = true;
    });
    var resW = await utilServices.getWareHouses(partNum);
    whareHouses.clear();
    whareHouses = resW['value'];
    setState(() {
      isLoading = false;
    });
    choseOptions("Warehouse", whareHouses);
  }

  chooseBin() async {
    setState(() {
      isLoading = true;
    });
    if (txtWare.text.isEmpty) {
      showError("Error", "Please select wharehouse first.");
    } else {
      var response = await utilServices.getBins(
        partNum,
        wherId,
      );
      bins.clear();
      bins = response['value'];
      choseOptions("Bin", bins);
    }
    setState(() {
      isLoading = false;
    });
  }

  updateOtp(String title, dynamic option) {
    switch (title) {
      case "Warehouse":
        txtWare.text = option['Warehse_Description'];
        wherId = option['PartWhse_WarehouseCode'];
        txtBin.text = "";
        break;
      case "Bin":
        txtBin.text = option['WhseBin_BinNum'];
        break;
    }
    setState(() {});
  }

  getOptTitle(String title, dynamic option) {
    switch (title) {
      case "Warehouse":
        return option['Warehse_Description'];
      case "Bin":
        return option['WhseBin_BinNum'];
      default:
        return "NA";
    }
  }

  choseOptions(String title, List<dynamic> options) {
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
                  "Select $title",
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
                    child: options.isEmpty
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
                                  "No $title found.",
                                  style: TextStyles.getRegularScund(
                                    16,
                                    color: AppColors.colorGray600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: options.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  updateOtp(
                                    title,
                                    options[index],
                                  );
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
                                        getOptTitle(
                                          title,
                                          options[index],
                                        ),
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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyles.getRegularScund(14),
        ),
      ),
    );
  }

  gotoGRNLine() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenAsnLine(
          item: widget.item,
          packNum: widget.packNum,
        ),
      ),
    );
  }

  // submit() async {
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     DateTime customDate = DateTime.now();
  //     String formattedDate = "${customDate.year.toString().padLeft(4, '0')}-"
  //         "${customDate.month.toString().padLeft(2, '0')}-"
  //         "${customDate.day.toString().padLeft(2, '0')}T"
  //         "00:00:00+05:30";
  //     int index = 0;
  //     bool isSubmit = false;
  //     for (var item in productItems) {
  //       if (item['ScanQty'] > 0) {
  //         isSubmit = true;
  //         if (txtWare.text.isEmpty) {
  //           showError("Error",
  //               "Please select wherehouse for part: ${item['Part_PartNum']}");
  //           isSubmit = false;
  //           break;
  //         }
  //         if (txtBin.text.isEmpty) {
  //           showError(
  //               "Error", "Please select bin for part: ${item['Part_PartNum']}");
  //           isSubmit = false;
  //           break;
  //         }
  //         var body = {
  //           "ds": {
  //             "RcvDtl": [
  //               {
  //                 "Company": company,
  //                 "VendorNum": widget.item['Vendor_VendorNum'],
  //                 "PurPoint": "P1",
  //                 "PackSlip": widget.packNum,
  //                 "PackLine": 0,
  //                 "PartNum": item['Part_PartNum'],
  //                 "WareHouseCode": wherId,
  //                 "BinNum": txtBin.text,
  //                 "OurQty": item['ScanQty'],
  //                 "IUM": item['PODetail_IUM'],
  //                 "LotNum": item['lotNum'],
  //                 "PONum": widget.item['POHeader_PONum'],
  //                 "POLine": item['PODetail_POLine'],
  //                 "PORelNum": item['PORel_PORelNum'],
  //                 "PartDescription": item['PODetail_LineDesc'],
  //                 "VendorQty": item['PODetail_OrderQty'],
  //                 "ReceiptType": "P",
  //                 "ReceivedTo": "PUR-STK",
  //                 "PUM": item['PODetail_IUM'],
  //                 "CostPerCode": item['Part_PricePerCode'],
  //                 "ReceivedComplete": true,
  //                 "ArrivedDate": formattedDate,
  //                 "CostPerFactor": double.parse(item['Part_SellingFactor']),
  //                 "EnableBin": true,
  //                 "EnableWhse": true,
  //                 "EnableSN": item["Part_TrackSerialNum"],
  //                 "InputOurQty": item['ScanQty'],
  //                 "Plant": plant,
  //                 "ThisTranUOM": item['PODetail_IUM'],
  //                 "TranType": "PUR-STK",
  //                 "PartNumPricePerCode": item['Part_PricePerCode'],
  //                 "PartNumSellingFactor":
  //                     double.parse(item['Part_SellingFactor']),
  //                 "RowMod": "A",
  //                 "InspectionReq": isInsp,
  //               }
  //             ],
  //             "SelectedSerialNumbers": srItems
  //                 .where((itn) => itn['PartNum'] == item['Part_PartNum'])
  //                 .toList(),
  //             "SNFormat": snFormats
  //                 .where((itn) => itn['PartNum'] == item['Part_PartNum'])
  //                 .toList(),
  //           }
  //         };
  //         printLargeString(json.encode(body));
  //         Response res = await inventoryServices.postForJobtoinvLot(body);
  //         if (res.statusCode != 200) {
  //           showError('Error', json.decode(res.body)['ErrorMessage']);
  //           isSubmit = false;
  //           break;
  //         }
  //       }
  //       index = index + 1;
  //     }
  //     if (isSubmit) {
  //       showError('Success', 'GRN entry submitted successfully!');
  //       loadData();
  //       txtQty.text = "";
  //       txtScan.text = "";
  //       txtWare.text = "";
  //       txtBin.text = "";
  //       isInsp = false;
  //       isLot = false;
  //       qty = 0;
  //     }
  //   } catch (ex) {
  //     showError('Error', "Server error occurred!");
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }
  submit() async {
    try {
      // Validate if any items are selected for submission
      bool hasItemsToSubmit =
          productItems.any((item) => (item['ScanQty'] ?? 0) > 0);
      if (!hasItemsToSubmit) {
        showError('Error', 'Please scan at least one item before submitting.');
        return;
      }

      setState(() {
        isLoading = true;
      });

      DateTime customDate = DateTime.now();
      String formattedDate = "${customDate.year.toString().padLeft(4, '0')}-"
          "${customDate.month.toString().padLeft(2, '0')}-"
          "${customDate.day.toString().padLeft(2, '0')}T"
          "00:00:00+05:30";

      // Process each product item
      for (var item in productItems) {
        // Skip if no quantity
        if ((item['ScanQty'] ?? 0) <= 0) continue;

        // Validate warehouse and bin
        if (txtWare.text.isEmpty) {
          throw Exception(
              "Please select warehouse for part: ${item['Part_PartNum']}");
        }
        if (txtBin.text.isEmpty) {
          throw Exception(
              "Please select bin for part: ${item['Part_PartNum']}");
        }

        // Safely handle numeric conversions
        double sellingFactor = 0.0;
        try {
          sellingFactor =
              double.parse(item['Part_SellingFactor']?.toString() ?? '0');
        } catch (e) {
          throw Exception(
              "Invalid selling factor for part: ${item['Part_PartNum']}");
        }

        // Get serial numbers specific to this part and lot combination
        List<dynamic> serialNumbersForLot = srItems
            .where((sItem) =>
                sItem['PartNum'] == item['Part_PartNum'] &&
                (item['Part_TrackLots']
                    ? sItem['LotNum'] == item['lotNum']
                    : true))
            .toList();

        // Validate serial numbers count against quantity for serial-tracked items
        if (item['Part_TrackSerialNum'] == true) {
          int requiredSerials = item['ScanQty'];
          if (serialNumbersForLot.length != requiredSerials) {
            throw Exception(
                "Mismatch in serial numbers for part ${item['Part_PartNum']}" +
                    (item['Part_TrackLots']
                        ? " and lot ${item['lotNum']}"
                        : "") +
                    ". Required: $requiredSerials, Found: ${serialNumbersForLot.length}");
          }
        }

        // Prepare API payload
        var body = {
          "ds": {
            "RcvDtl": [
              {
                "Company": company,
                "VendorNum": widget.item['Vendor_VendorNum'],
                "PurPoint": "P1",
                "PackSlip": widget.packNum,
                "PackLine": 0,
                "PartNum": item['Part_PartNum'],
                "WareHouseCode": wherId,
                "BinNum": txtBin.text,
                "OurQty": item['ScanQty'],
                "IUM": item['PODetail_IUM'],
                "LotNum": item['lotNum'] ?? '',
                "PONum": widget.item['POHeader_PONum'],
                "POLine": item['PODetail_POLine'],
                "PORelNum": item['PORel_PORelNum'],
                "PartDescription": item['PODetail_LineDesc'],
                "VendorQty": item['PODetail_OrderQty'],
                "ReceiptType": "P",
                "ReceivedTo": "PUR-STK",
                "PUM": item['PODetail_IUM'],
                "CostPerCode": item['Part_PricePerCode'],
                "ReceivedComplete": true,
                "ArrivedDate": formattedDate,
                "CostPerFactor": sellingFactor,
                "EnableBin": true,
                "EnableWhse": true,
                "EnableSN": item["Part_TrackSerialNum"] ?? false,
                "InputOurQty": item['ScanQty'],
                "Plant": plant,
                "ThisTranUOM": item['PODetail_IUM'],
                "TranType": "PUR-STK",
                "PartNumPricePerCode": item['Part_PricePerCode'],
                "PartNumSellingFactor": sellingFactor,
                "RowMod": "A",
                "InspectionReq": isInsp,
              }
            ],
            // Only include serial numbers for this specific part and lot combination
            "SelectedSerialNumbers": serialNumbersForLot,
            "SNFormat": snFormats
                .where((itn) => itn['PartNum'] == item['Part_PartNum'])
                .toList(),
          }
        };

        // Make API call with error handling
        Response res = await inventoryServices.postForJobtoinvLot(body);
        if (res.statusCode != 200) {
          var errorMessage = '';
          try {
            errorMessage = json.decode(res.body)['ErrorMessage'] ??
                'Unknown error occurred';
          } catch (e) {
            errorMessage = 'Failed to process server response';
          }
          throw Exception(errorMessage);
        }
      }

      // Success handling
      showError('Success', 'GRN entry submitted successfully!');
      resetForm();
      await loadData();
    } catch (ex) {
      showError('Error', ex.toString().replaceAll('Exception:', '').trim());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

// Helper method to reset form
  void resetForm() {
    setState(() {
      txtQty.text = "";
      txtScan.text = "";
      txtWare.text = "";
      txtBin.text = "";
      isInsp = false;
      isLot = false;
      qty = 0;
      srItems = []; // Clear serial items
    });
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

  void printLargeString(String text) {
    const int chunkSize = 800;
    for (int i = 0; i < text.length; i += chunkSize) {
      // Print the string in chunks
      debugPrint(text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
  }
}
