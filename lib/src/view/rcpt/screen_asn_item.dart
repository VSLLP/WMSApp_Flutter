import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/rcpt/screen_asn_line.dart';
import 'package:http/http.dart';

class ScreenAsnItem extends StatefulWidget {
  final dynamic item;
  final String packNum;

  const ScreenAsnItem({
    super.key,
    required this.item,
    required this.packNum,
  });

  @override
  State<ScreenAsnItem> createState() => _ScreenAsnItemState();
}

class _ScreenAsnItemState extends State<ScreenAsnItem> {
  List<dynamic> productItems = [];
  List<dynamic> whareHouses = [];
  List<dynamic> bins = [];
  List<dynamic> snFormats = [];
  List<dynamic> srItems = [];

  List<bool> inspections = [];

  List<String> itemWheID = [];

  List<TextEditingController> itemQty = [];
  List<TextEditingController> itemWhe = [];
  List<TextEditingController> itemBin = [];

  String plant = "";
  String company = "";

  bool isLoading = true;

  @override
  void initState() {
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
                        const SizedBox(
                          height: 28,
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
                                          0: FixedColumnWidth(120),
                                          1: FixedColumnWidth(100),
                                          2: FixedColumnWidth(50),
                                          3: FixedColumnWidth(100),
                                          4: FixedColumnWidth(100),
                                          5: FixedColumnWidth(100),
                                          6: FixedColumnWidth(120),
                                          7: FixedColumnWidth(80),
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
                                  itemQty.any((controller) =>
                                          controller.text.isNotEmpty)
                                      ? submit()
                                      : {};
                                }
                              },
                              child: Container(
                                height: 38,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: itemQty.any((controller) =>
                                          controller.text.isNotEmpty)
                                      ? AppColors.colorWhite
                                      : AppColors.colorGray300,
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
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      'Submit',
                                      style: TextStyles.getBold(
                                        16,
                                        color: itemQty.any((controller) =>
                                                controller.text.isNotEmpty)
                                            ? AppColors.colorAssent
                                            : AppColors.colorWhite,
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
      var resW = await utilServices.getWareHouses(
        productItems[i]["Part_PartNum"],
      );
      whareHouses.clear();
      whareHouses = resW['value'];

      if (productItems[i]["PODetail_RcvInspectionReq"]) {
        itemWheID
            .add(whareHouses[0]['Calculated_ReceiptInspWarehouse'].toString());
        itemWhe.add(
          TextEditingController(
            text: whareHouses[0]['Calculated_ReceiptInspWarehouse'].toString(),
          ),
        );
        itemBin.add(
          TextEditingController(
            text: whareHouses[0]['Calculated_ReceiptInspBin'].toString(),
          ),
        );
      } else {
        itemWheID.add(whareHouses[0]['Calculated_ReceiptWarhouse'].toString());
        itemWhe.add(
          TextEditingController(
            text: whareHouses[0]['Calculated_ReceiptWarhouse'].toString(),
          ),
        );
        itemBin.add(
          TextEditingController(
            text: whareHouses[0]['Calculated_ReceiptBin'].toString(),
          ),
        );
      }

      itemQty.add(
        TextEditingController(
          text: "",
        ),
      );
      inspections.add(productItems[i]['PODetail_RcvInspectionReq']);
    }

    whareHouses.clear();

    setState(() {
      isLoading = false;
    });
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

  getType(item) {
    if (item['Part_TrackLots'] && item['Part_TrackSerialNum']) {
      return "Serial / Lot";
    }
    if (item['Part_TrackLots']) {
      return "Lot";
    }
    if (item['Part_TrackSerialNum']) {
      return "Serial";
    }
    return '-';
  }

  generateItemsCode(dynamic item, int itemIndex) async {
    switch (getType(item)) {
      case "Serial / Lot":
        setState(() {
          isLoading = true;
        });
        var resA = await utilServices.getSerialMapping(item['Part_PartNum']);
        var bodyA = {"vPartNum": item["Part_PartNum"]};

        Response resB = await utilServices.generateLot(bodyA);
        var payloadA = json.decode(resB.body);
        productItems[itemIndex]['lotNum'] =
            payloadA['parameters']['vNewLotNum'];
        var payload = resA['value'][0];
        var bodyB = {
          "ds": {
            "SNFormat": [
              {
                "Company": company,
                "Plant": plant,
                "PartNum": item['Part_PartNum'],
                "SNMask": payload['Part_SNMask'],
                "SNBaseDataType": "MASK",
                "HasSerialNumbers": true,
                "PartPricePerCode": payload['Part_PricePerCode'],
                "PartTrackLots": item['Part_TrackLots'],
                "PartTrackSerialNum": item['Part_TrackSerialNum'],
                "PartSalesUM": payload['Part_SalesUM'],
                "PartIUM": payload['Part_IUM'],
                "PartSellingFactor": payload['Part_SellingFactor'],
                "PartPartDescription": payload['Part_PartDescription'],
                "SerialMaskMaskType": payload['SerialMask_MaskType']
              }
            ]
          },
          "PartNum": item['Part_PartNum'],
          "xrefPartNum": "",
          "xrefPartType": "",
          "xrefCustNum": 0,
          "NumToAdd": itemQty[itemIndex].text,
          "baseBeginNum": "TEMP00000103202",
          "TransType": "PUR-STK",
          "SourceRowID": item['RowIdent'],
          "plantID": plant
        };
        Response res = await utilServices.genrateSerialNum(bodyB);
        var payloadB = json.decode(res.body);
        productItems[itemIndex]['Part_SellingFactor'] =
            payload['Part_SellingFactor'];
        productItems[itemIndex]['Part_PricePerCode'] =
            payload['Part_PricePerCode'];
        productItems[itemIndex]['isSelect'] = true;
        var payloadSN = payloadB["parameters"]["ds"]["SNFormat"][0];
        var payloadSerail =
            payloadB["parameters"]["ds"]["SelectedSerialNumbers"];
        for (var srItem in payloadSerail) {
          srItems.add({
            "Company": company,
            "SerialNumber": srItem["SerialNumber"],
            "PartNum": srItem["PartNum"],
            "SNBaseNumber": srItem["SNBaseNumber"],
            "TransType": "PUR-STK",
            "RawSerialNum": srItem["RawSerialNum"],
            "SNMask": srItem["SNMask"],
            "RowMod": "A"
          });
        }
        snFormats.add({
          "Plant": plant,
          "PartNum": payloadSN['PartNum'],
          "SNMask": payloadSN['SNMask'],
          "SNBaseDataType": payloadSN['SNBaseDataType'],
          "PartPricePerCode": payloadSN['PartPricePerCode'],
          "PartSellingFactor": payloadSN['PartSellingFactor'],
          "RowMod": "A"
        });
        setState(() {
          isLoading = false;
        });
        break;

      case "Serial":
        setState(() {
          isLoading = true;
        });
        try {
          var resA = await utilServices.getSerialMapping(item['Part_PartNum']);
          if (resA == null ||
              !resA.containsKey('value') ||
              resA['value'].isEmpty) {
            throw Exception(
                'Invalid serial mapping response: ${resA.toString()}');
          }

          var payload = resA['value'][0];
          print('Serial Mapping Response: $payload');

          var bodyB = {
            "ds": {
              "SNFormat": [
                {
                  "Company": company,
                  "Plant": plant,
                  "PartNum": item['Part_PartNum'],
                  "SNMask": payload['Part_SNMask'] ?? '',
                  "SNBaseDataType": "MASK",
                  "HasSerialNumbers": true,
                  "PartPricePerCode": payload['Part_PricePerCode'] ?? '',
                  "PartTrackLots": item['Part_TrackLots'] ?? false,
                  "PartTrackSerialNum": item['Part_TrackSerialNum'] ?? false,
                  "PartSalesUM": payload['Part_SalesUM'] ?? '',
                  "PartIUM": payload['Part_IUM'] ?? '',
                  "PartSellingFactor": payload['Part_SellingFactor'] ?? '0',
                  "PartPartDescription": payload['Part_PartDescription'] ?? '',
                  "SerialMaskMaskType": payload['SerialMask_MaskType'] ?? ''
                }
              ]
            },
            "PartNum": item['Part_PartNum'],
            "xrefPartNum": "",
            "xrefPartType": "",
            "xrefCustNum": 0,
            "NumToAdd": itemQty[itemIndex].text,
            "baseBeginNum": "TEMP00000103202",
            "TransType": "PUR-STK",
            "SourceRowID": item['RowIdent'],
            "plantID": plant
          };

          print('Generate Serial Number Request: ${json.encode(bodyB)}');

          Response res = await utilServices.genrateSerialNum(bodyB);
          if (res.statusCode != 200) {
            throw Exception(
                'Failed to generate serial number - Status ${res.statusCode}: ${res.body}');
          }

          var payloadB = json.decode(res.body);
          print('Generate Serial Number Response: $payloadB');

          if (!payloadB.containsKey("parameters") ||
              !payloadB["parameters"].containsKey("ds") ||
              !payloadB["parameters"]["ds"].containsKey("SNFormat")) {
            throw Exception(
                'Invalid response format from generate serial number');
          }

          productItems[itemIndex]['lotNum'] = "";
          productItems[itemIndex]['Part_SellingFactor'] =
              payload['Part_SellingFactor'];
          productItems[itemIndex]['Part_PricePerCode'] =
              payload['Part_PricePerCode'];
          productItems[itemIndex]['isSelect'] = true;

          var payloadSN = payloadB["parameters"]["ds"]["SNFormat"][0];
          var payloadSerail =
              payloadB["parameters"]["ds"]["SelectedSerialNumbers"];

          for (var srItem in payloadSerail) {
            srItems.add({
              "Company": company,
              "SerialNumber": srItem["SerialNumber"],
              "PartNum": srItem["PartNum"],
              "SNBaseNumber": srItem["SNBaseNumber"],
              "TransType": "PUR-STK",
              "RawSerialNum": srItem["RawSerialNum"],
              "SNMask": srItem["SNMask"],
              "RowMod": "A"
            });
          }

          snFormats.add({
            "Plant": plant,
            "PartNum": payloadSN['PartNum'],
            "SNMask": payloadSN['SNMask'],
            "SNBaseDataType": payloadSN['SNBaseDataType'],
            "PartPricePerCode": payloadSN['PartPricePerCode'],
            "PartSellingFactor": payloadSN['PartSellingFactor'],
            "RowMod": "A"
          });
        } catch (e, stackTrace) {
          print('Error in Serial case: $e');
          print('Stack trace: $stackTrace');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to process serial number: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        } finally {
          setState(() {
            isLoading = false;
          });
        }
        break;
      case "Serial-v2":
        setState(() {
          isLoading = true;
        });
        try {
          var resA = await utilServices.getSerialMapping(item['Part_PartNum']);
          if (resA == null) {
            throw Exception('Failed to get serial mapping - response is null');
          }

          if (!resA.containsKey('value') ||
              resA['value'] == null ||
              resA['value'].isEmpty) {
            throw Exception(
                'Invalid serial mapping response structure: ${resA.toString()}');
          }

          var payload = resA['value'][0];
          if (payload == null) {
            throw Exception('Serial mapping payload is null');
          }

          var bodyB = {
            "ds": {
              "SNFormat": [
                {
                  "Company": company,
                  "Plant": plant,
                  "PartNum": item['Part_PartNum'] ?? '',
                  "SNMask": payload['Part_SNMask'] ?? '',
                  "SNBaseDataType": "MASK",
                  "HasSerialNumbers": true,
                  "PartPricePerCode": payload['Part_PricePerCode'] ?? '',
                  "PartTrackLots": item['Part_TrackLots'] ?? false,
                  "PartTrackSerialNum": item['Part_TrackSerialNum'] ?? false,
                  "PartSalesUM": payload['Part_SalesUM'] ?? '',
                  "PartIUM": payload['Part_IUM'] ?? '',
                  "PartSellingFactor": payload['Part_SellingFactor'] ?? '0',
                  "PartPartDescription": payload['Part_PartDescription'] ?? '',
                  "SerialMaskMaskType": payload['SerialMask_MaskType'] ?? ''
                }
              ]
            },
            "PartNum": item['Part_PartNum'] ?? '',
            "xrefPartNum": "",
            "xrefPartType": "",
            "xrefCustNum": 0,
            "NumToAdd": itemQty[itemIndex].text ?? '0',
            "baseBeginNum": "TEMP00000103202",
            "TransType": "PUR-STK",
            "SourceRowID": item['RowIdent'] ?? '',
            "plantID": plant
          };

          Response res = await utilServices.genrateSerialNum(bodyB);
          if (res.statusCode != 200) {
            throw Exception(
                'Failed to generate serial number - Status code: ${res.statusCode}');
          }

          var payloadB = json.decode(res.body);
          if (payloadB == null || !payloadB.containsKey("parameters")) {
            throw Exception(
                'Invalid response format from generate serial number');
          }

          productItems[itemIndex]['lotNum'] = "";
          productItems[itemIndex]['Part_SellingFactor'] =
              payload['Part_SellingFactor'] ?? '0';
          productItems[itemIndex]['Part_PricePerCode'] =
              payload['Part_PricePerCode'] ?? '';
          productItems[itemIndex]['isSelect'] = true;

          var payloadSN = payloadB["parameters"]["ds"]["SNFormat"][0];
          var payloadSerial =
              payloadB["parameters"]["ds"]["SelectedSerialNumbers"];

          if (payloadSerial != null) {
            for (var srItem in payloadSerial) {
              srItems.add({
                "Company": company,
                "SerialNumber": srItem["SerialNumber"] ?? '',
                "PartNum": srItem["PartNum"] ?? '',
                "SNBaseNumber": srItem["SNBaseNumber"] ?? '',
                "TransType": "PUR-STK",
                "RawSerialNum": srItem["RawSerialNum"] ?? '',
                "SNMask": srItem["SNMask"] ?? '',
                "RowMod": "A"
              });
            }
          }

          if (payloadSN != null) {
            snFormats.add({
              "Plant": plant,
              "PartNum": payloadSN['PartNum'] ?? '',
              "SNMask": payloadSN['SNMask'] ?? '',
              "SNBaseDataType": payloadSN['SNBaseDataType'] ?? '',
              "PartPricePerCode": payloadSN['PartPricePerCode'] ?? '',
              "PartSellingFactor": payloadSN['PartSellingFactor'] ?? '0',
              "RowMod": "A"
            });
          }
        } catch (e) {
          print('Error in Serial case: $e');

          showError('Error', 'Failed to process serial number: $e');
        } finally {
          setState(() {
            isLoading = false;
          });
        }
        break;
      case "Lot":
        setState(() {
          isLoading = true;
        });
        var bodyA = {"vPartNum": item["Part_PartNum"]};
        Response res = await utilServices.generateLot(bodyA);
        var payloadB = json.decode(res.body);
        print(payloadB);
        productItems[itemIndex]['lotNum'] =
            payloadB['parameters']['vNewLotNum'];
        productItems[itemIndex]['isSelect'] = true;
        setState(() {
          isLoading = false;
        });
        break;
      default:
        setState(() {
          isLoading = true;
        });
        productItems[itemIndex]['isSelect'] = true;
        productItems[itemIndex]['lotNum'] = "";
        setState(() {
          isLoading = false;
        });
    }
  }

  List<TableRow> getRows() {
    List<TableRow> rows = [];
    rows.add(TableRow(
      children: [
        tableCell('Part'),
        tableCell('Our Qty'),
        tableCell('Line'),
        tableCell('Inspection Req'),
        tableCell('Supplier Qty'),
        tableCell('Po Num'),
        tableCell('Warehouse'),
        tableCell('Bin num'),
      ],
    ));
    for (int i = 0; i < productItems.length; i++) {
      var item = productItems[i];
      rows.add(
        TableRow(
          children: [
            tableCellRow(item["Part_PartNum"].toString()),
            TableCell(
              child: Container(
                margin: const EdgeInsets.all(6),
                height: 28,
                child: TextFormField(
                  controller: itemQty[i],
                  style: TextStyles.getBold(12),
                  decoration: InputDecoration(
                    hintText: "QTY",
                    hintStyle: TextStyles.getRegularScund(
                      12,
                      color: AppColors.colorGray600,
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 4,
                      bottom: 16,
                    ),
                    counterText: "",
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    if (val.isEmpty) {
                      productItems[i]['isSelect'] = false;
                      clearAddedData(item, i);
                    }
                    setState(() {});
                  },
                  autofocus: false,
                  readOnly: false,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter qty.";
                    }
                    return null;
                  },
                ),
              ),
            ),
            tableCellRow(item["PODetail_POLine"].toString()),
            TableCell(
              child: Checkbox(
                checkColor: AppColors.colorWhite,
                activeColor: AppColors.colorAssent,
                value: item["PODetail_RcvInspectionReq"],
                onChanged: (bool? value) {
                  if (!inspections[i]) {
                    setState(() {
                      item["PODetail_RcvInspectionReq"] =
                          !item["PODetail_RcvInspectionReq"];
                    });
                    updateWhereHouse(item, i);
                  }
                },
              ),
            ),
            tableCellRow(
              double.parse(item["PODetail_OrderQty"].toString())
                  .toStringAsFixed(2),
            ),
            tableCellRow(item["PODetail_PONUM"].toString()),
            TableCell(
              child: Container(
                margin: const EdgeInsets.all(6),
                height: 28,
                child: TextFormField(
                  controller: itemWhe[i],
                  style: TextStyles.getBold(12),
                  decoration: InputDecoration(
                    hintText: "Wharehouse",
                    hintStyle: TextStyles.getRegularScund(
                      12,
                      color: AppColors.colorGray600,
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 4,
                      bottom: 16,
                    ),
                    counterText: "",
                  ),
                  keyboardType: TextInputType.name,
                  onTap: () {
                    chooseWaereHouse(i, item);
                  },
                  autofocus: false,
                  readOnly: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter wharehouse.";
                    }
                    return null;
                  },
                ),
              ),
            ),
            TableCell(
              child: Container(
                margin: const EdgeInsets.all(6),
                height: 28,
                child: TextFormField(
                  controller: itemBin[i],
                  style: TextStyles.getBold(12),
                  decoration: InputDecoration(
                    hintText: "Bin no",
                    hintStyle: TextStyles.getRegularScund(
                      12,
                      color: AppColors.colorGray600,
                    ),
                    contentPadding: const EdgeInsets.only(
                      left: 4,
                      bottom: 16,
                    ),
                    counterText: "",
                  ),
                  keyboardType: TextInputType.name,
                  onTap: () {
                    chooseBin(i, item);
                  },
                  autofocus: false,
                  readOnly: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter bin.";
                    }
                    return null;
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
    return rows;
  }

  updateWhereHouse(item, itemIndex) async {
    var resW = await utilServices.getWareHouses(
      item["Part_PartNum"],
    );
    whareHouses.clear();
    whareHouses = resW['value'];

    if (productItems[itemIndex]["PODetail_RcvInspectionReq"]) {
      itemWheID[itemIndex] =
          whareHouses[0]['Calculated_ReceiptInspWarehouse'].toString();
      itemWhe[itemIndex].text =
          whareHouses[0]['Calculated_ReceiptInspWarehouse'].toString();
      itemBin[itemIndex].text =
          whareHouses[0]['Calculated_ReceiptInspBin'].toString();
    } else {
      itemWheID[itemIndex] =
          whareHouses[0]['Calculated_ReceiptWarhouse'].toString();
      itemWhe[itemIndex].text =
          whareHouses[0]['Calculated_ReceiptWarhouse'].toString();
      itemBin[itemIndex].text =
          whareHouses[0]['Calculated_ReceiptBin'].toString();
    }

    setState(() {
      isLoading = false;
    });
  }

  clearAddedData(dynamic item, int itemIndex) {
    productItems[itemIndex]['lotNum'] = "";
    productItems[itemIndex]['Part_SellingFactor'] = "";
    productItems[itemIndex]['Part_PricePerCode'] = "";
    snFormats.removeWhere((item) => item['PartNum'] == item['Part_PartNum']);
    srItems.removeWhere((item) => item['PartNum'] == item['Part_PartNum']);
  }

  chooseWaereHouse(int index, dynamic item) async {
    setState(() {
      isLoading = true;
    });
    var resW = await utilServices.getWareHouses(
      item["Part_PartNum"],
    );
    whareHouses.clear();
    whareHouses = resW['value'];
    setState(() {
      isLoading = false;
    });
    choseOptions("Warehouse", index, whareHouses);
  }

  chooseBin(int index, dynamic item) async {
    setState(() {
      isLoading = true;
    });
    if (itemWhe[index].text == "null" || itemWhe[index].text == "") {
      showError("Error", "Please select wharehouse first.");
    } else {
      var response = await utilServices.getBins(
        item["Part_PartNum"],
        itemWheID[index],
      );
      bins.clear();
      bins = response['value'];
    }
    setState(() {
      isLoading = false;
    });
    choseOptions("Bin", index, bins);
  }

  getOptTitle(String title, dynamic option, int itemIndex) {
    switch (title) {
      case "Warehouse":
        return option['Warehse_Description'];
      case "Bin":
        return option['WhseBin_BinNum'];
      default:
        return "NA";
    }
  }

  updateOtp(String title, dynamic option, int itemIndex) {
    switch (title) {
      case "Warehouse":
        itemWhe[itemIndex].text = option['Warehse_Description'];
        itemWheID[itemIndex] = option['PartWhse_WarehouseCode'];
        itemBin[itemIndex].text = "";
        break;
      case "Bin":
        itemBin[itemIndex].text = option['WhseBin_BinNum'];
        break;
    }
    setState(() {});
  }

  choseOptions(String title, int itemIndex, List<dynamic> options) {
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
                                    itemIndex,
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
                                          itemIndex,
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

  resetItems() {
    setState(() {
      isLoading = true;
    });
    productItems.clear();
    whareHouses.clear();
    bins.clear();
    snFormats.clear();
    srItems.clear();
    inspections.clear();
    itemWheID.clear();
    itemQty.clear();
    itemWhe.clear();
    itemBin.clear();
    loadData();
  }

  submit() async {
    try {
      setState(() {
        isLoading = true;
      });

      for (int i = 0; i < productItems.length; i++) {
        if (itemQty[i].text.isNotEmpty) {
          await generateItemsCode(productItems[i], i);
        }
      }

      DateTime customDate = DateTime.now();
      String formattedDate = "${customDate.year.toString().padLeft(4, '0')}-"
          "${customDate.month.toString().padLeft(2, '0')}-"
          "${customDate.day.toString().padLeft(2, '0')}T"
          "00:00:00+05:30";
      int index = 0;
      bool isSubmit = false;
      for (var item in productItems) {
        if (item['isSelect']) {
          isSubmit = true;
          if (itemWhe[index].text.isEmpty || itemWhe[index].text == 'null') {
            showError("Error",
                "Please select wherehouse for part: ${item['Part_PartNum']}");
            isSubmit = false;
            break;
          }
          if (itemBin[index].text.isEmpty || itemBin[index].text == 'null') {
            showError(
                "Error", "Please select bin for part: ${item['Part_PartNum']}");
            isSubmit = false;
            break;
          }
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
                  "WareHouseCode": itemWheID[index],
                  "BinNum": itemBin[index].text,
                  "OurQty": itemQty[index].text,
                  "IUM": item['PODetail_IUM'],
                  "LotNum": item['lotNum'],
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
                  "CostPerFactor": double.parse(item['Part_SellingFactor']),
                  "EnableBin": true,
                  "EnableWhse": true,
                  "EnableSN": item["Part_TrackSerialNum"],
                  "InputOurQty": itemQty[index].text,
                  "Plant": plant,
                  "ThisTranUOM": item['PODetail_IUM'],
                  "TranType": "PUR-STK",
                  "PartNumPricePerCode": item['Part_PricePerCode'],
                  "PartNumSellingFactor":
                      double.parse(item['Part_SellingFactor']),
                  "RowMod": "A",
                  "InspectionReq": item["PODetail_RcvInspectionReq"],
                }
              ],
              "SelectedSerialNumbers": srItems
                  .where((itn) => itn['PartNum'] == item['Part_PartNum'])
                  .toList(),
              "SNFormat": snFormats
                  .where((itn) => itn['PartNum'] == item['Part_PartNum'])
                  .toList(),
            }
          };
          printLargeString(json.encode(body));
          Response res = await inventoryServices.postForJobtoinvLot(body);
          if (res.statusCode != 200) {
            showError('Error', json.decode(res.body)['ErrorMessage']);
            isSubmit = false;
            break;
          }
        } else {
          if (itemQty[index].text.isNotEmpty) {
            isSubmit = false;
            showError("Error",
                "Please genrate lot number or serial number for part: ${item['Part_PartNum']}");
            break;
          }
        }
        index = index + 1;
      }
      if (isSubmit) {
        showError('Success', 'GRN entry submitted successfully!');
        resetItems();
      }
    } catch (ex) {
      showError('Error', "Server error occurred!" + ex.toString());
      setState(() {
        isLoading = false;
      });
    }
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

  void printLargeString(String text) {
    const int chunkSize = 800;
    for (int i = 0; i < text.length; i += chunkSize) {
      debugPrint(text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
  }
}
