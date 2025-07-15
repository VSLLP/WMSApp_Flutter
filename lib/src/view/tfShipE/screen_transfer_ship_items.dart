import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class ScreenTransferShipItems extends StatefulWidget {
  final dynamic item;

  const ScreenTransferShipItems({
    super.key,
    required this.item,
  });

  @override
  State<ScreenTransferShipItems> createState() =>
      _ScreenTransferShipItemsState();
}

class _ScreenTransferShipItemsState extends State<ScreenTransferShipItems> {
  List<dynamic> productItems = [];
  List<dynamic> whareHouses = [];
  List<dynamic> bins = [];
  List<dynamic> lots = [];
  List<dynamic> productItemSearils = [];

  List<String> itemWheID = [];

  List<TextEditingController> itemWhe = [];
  List<TextEditingController> itemBin = [];
  List<TextEditingController> itemQty = [];

  var txtScan = TextEditingController();
  var txtpackNum = TextEditingController();
  var txtShipNo = TextEditingController();
  var txtOrdNo = TextEditingController();

  String company = '';
  String partNumber = '';

  bool isLoading = true;
  bool isSubmit = false;

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
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            'Transfer Shipment',
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
                    height: 8,
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
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
                                      width: MediaQuery.of(context).size.width *
                                          0.54,
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
                                                    // txtScan.text = "";
                                                    // print("Loading Data ");
                                                    for (var item
                                                        in productItems) {
                                                      item['isSelected'] =
                                                          false;
                                                    }
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  },
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.clear,
                                                        color: AppColors
                                                            .colorGray600,
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
                                                      color: AppColors
                                                          .colorGray600,
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "Pack Num: ",
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorDataColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.54,
                                      child: TextFormField(
                                        controller: txtpackNum,
                                        style: TextStyles.getBold(12),
                                        decoration: InputDecoration(
                                          hintText: "pack num",
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
                                            return "Please enter pack num.";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "CFIL Transfer Shipment No: ",
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorDataColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.54,
                                      child: TextFormField(
                                        controller: txtShipNo,
                                        style: TextStyles.getBold(12),
                                        decoration: InputDecoration(
                                          hintText: "CFIL Transfer Shipment No",
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
                                            return "Please enter CFIL Transfer Shipment No.";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "CFIL Transfer Order No: ",
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorDataColor,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.54,
                                      child: TextFormField(
                                        controller: txtOrdNo,
                                        style: TextStyles.getBold(12),
                                        decoration: InputDecoration(
                                          hintText: "CFIL Transfer Order No",
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
                                            return "Please enter CFIL Transfer Order No.";
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
                                              0: FixedColumnWidth(150),
                                              1: FixedColumnWidth(80),
                                              2: FixedColumnWidth(120),
                                              3: FixedColumnWidth(80),
                                              4: FixedColumnWidth(80),
                                              5: FixedColumnWidth(80),
                                              6: FixedColumnWidth(160),
                                              7: FixedColumnWidth(120),
                                              8: FixedColumnWidth(120),
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
                              height: 28,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
    print("Load Data");
    company = await sharedPref.getString("userCompnay");
    txtpackNum.text = widget.item['packNum'].toString();
    txtShipNo.text = widget.item['transferShipNo'].toString();
    txtOrdNo.text = widget.item['orderNum'].toString();

    var resA = await transferServices
        .getTransferShipmentDtl(widget.item['orderNum'].toString());
    productItems = resA['value'];

    for (var item in productItems) {
      var resB = await materialServices.getGetPart(item["TFOrdDtl_PartNum"]);
      String prdType = getType(resB['value'][0]);
      item['scanQTY'] = 0.00;
      itemQty.add(
        TextEditingController(
          text: "0",
        ),
      );
      item['isSelected'] = false;
      item['lineDisc'] = '';
      item['Lot'] = '-';
      item['type'] = prdType;
      var resW = await utilServices.getWareHouses(
        item["TFOrdDtl_PartNum"],
      );
      dynamic whe = resW['value'][0];
      itemWheID.add(whe['Calculated_ReceiptWarhouse'].toString());
      itemWhe.add(
        TextEditingController(
          text: whe['Warehse_Description'].toString(),
        ),
      );
      itemBin.add(
        TextEditingController(
          text: whe['Calculated_ReceiptBin'].toString(),
        ),
      );
      if (item['type'] == "2") {
        var resLots = await transferServices.getLots(
          item['TFOrdDtl_PartNum'],
          whe['Calculated_ReceiptWarhouse'].toString(),
          whe['Calculated_ReceiptBin'].toString(),
        );
        item['Lot'] = resLots['value'][0]['PartBin_LotNum'];
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  ship() async {
    try {
      setState(() {
        isLoading = true;
      });

      String packNum = txtpackNum.text;

      if (packNum.isEmpty) {
        throw Exception(
            "No valid PackNum found. Please submit the form first.");
      }

      // print("Shipping with PackNum: $packNum");

      var body = {
        "Company": company,
        "PackNum": packNum,
        "ShipDate": DateFormat('yyyy-mm-dd').format(DateTime.now()),
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
    if (!item['Part_TrackLots'] && !item['Part_TrackSerialNum']) {
      return "4";
    }
  }

  getPartAsync(val) async {
    try {
      print("Entred to the fun");
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

      print("split the key and value ");

      List<String> words = val.split(splitKey);
      if (words.length <= 2) {
        return;
      }
      print("check the parnum length ");

      if (words.length < 6) {
        showError('Error', 'Invalid input format');
        return;
      }
      setState(() {
        isLoading = true;
      });

      print("replacing key with '' ");

      partNumber = words[1].replaceAll("Part Code - ", '');
      String partDesc = words[2].replaceAll("Part Desc. - ", '');
      String lotNum = words[4].replaceAll("Lot No. -", '').replaceAll(" ", "");
      String serialNum = words[5].replaceAll("Serial No. - ", '');

      print("get part infor ");

      var resB = await materialServices.getGetPart(partNumber);
      print("get type of part");

      String prdType = getType(resB['value'][0]);

      int productIndex = productItems.indexWhere(
        (item) =>
            item["TFOrdDtl_PartNum"].toString().toLowerCase() ==
            partNumber.toLowerCase(),
      );
      if (productIndex != -1) {
        productItems[productIndex]['type'] = prdType;
        switch (prdType) {
          case "1":
            int serailIndex = productItemSearils.indexWhere(
              (item) => item["SerialNumber"] == serialNum,
            );
            if (serailIndex == -1) {
              productItems[productIndex]['Lot'] = lotNum;
              productItems[productIndex]['scanQTY'] =
                  productItems[productIndex]['scanQTY'] + 1;
              itemQty[productIndex].text =
                  double.parse(productItems[productIndex]['scanQTY'].toString())
                      .toStringAsFixed(2);
              productItems[productIndex]['lineDisc'] = partDesc;
              productItems[productIndex]['Lot'] = lotNum;
              productItems[productIndex]['isSelected'] = true;
              var newSerail = {
                "Company": company,
                "SerialNumber": serialNum,
                "NotSavedToDB": true,
                "PartNum": partNumber,
                "TransType": "STK-PLT",
                "RowMod": "A"
              };
              productItemSearils.add(newSerail);
            } else {
              throw Exception("Product already scanned");
            }
            break;
          case "3":
            int serailIndex = productItemSearils.indexWhere(
              (item) => item["SerialNumber"] == serialNum,
            );
            if (serailIndex == -1) {
              productItems[productIndex]['scanQTY'] =
                  productItems[productIndex]['scanQTY'] + 1;
              itemQty[productIndex].text =
                  double.parse(productItems[productIndex]['scanQTY'].toString())
                      .toStringAsFixed(2);
              productItems[productIndex]['lineDisc'] = partDesc;
              productItems[productIndex]['Lot'] = lotNum;
              productItems[productIndex]['isSelected'] = true;
              var newSerail = {
                "Company": company,
                "SerialNumber": serialNum,
                "NotSavedToDB": true,
                "PartNum": partNumber,
                "TransType": "STK-PLT",
                "RowMod": "A"
              };
              productItemSearils.add(newSerail);
            } else {
              throw Exception("Product already scanned");
            }
            break;
          case "2":
            productItems[productIndex]['Lot'] = lotNum;
            productItems[productIndex]['scanQTY'] =
                productItems[productIndex]['scanQTY'] + 1;
            itemQty[productIndex].text =
                double.parse(productItems[productIndex]['scanQTY'].toString())
                    .toStringAsFixed(2);
            break;
          case "4":
            productItems[productIndex]['Lot'] = lotNum;
            productItems[productIndex]['scanQTY'] =
                productItems[productIndex]['scanQTY'] + 1;
            itemQty[productIndex].text =
                double.parse(productItems[productIndex]['scanQTY'].toString())
                    .toStringAsFixed(2);
            break;
        }
      } else {
        throw Exception("Product not found.");
      }
      productItems[productIndex]['isSelected'] = true;
    } catch (ex) {
      showError('Error', ex.toString());
    } finally {
      txtScan.text = "";
      setState(() {
        isLoading = false;
      });
    }
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
        child: Center(
          child: Text(
            text,
            style: TextStyles.getRegularScund(14),
          ),
        ),
      ),
    );
  }

  List<TableRow> getRows() {
    List<TableRow> rows = [];
    rows.add(TableRow(
      children: [
        tableCell('Transfer OrdNum'),
        tableCell('Line'),
        tableCell('PartNum'),
        tableCell('Lot'),
        tableCell('Ord Qty'),
        tableCell('Scan Qty'),
        tableCell('Warehouse'),
        tableCell('Bin num'),
      ],
    ));
    for (int i = 0; i < productItems.length; i++) {
      var item = productItems[i];
      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: item['isSelected']
                ? AppColors.colorCyan300
                : Colors.transparent,
          ),
          children: [
            tableCellRow(item["TFOrdHed_TFOrdNum"].toString()),
            tableCellRow(item["TFOrdDtl_TFOrdLine"].toString()),
            tableCellRow(item["TFOrdDtl_PartNum"].toString()),
            TableCell(
              child: GestureDetector(
                onTap: () {
                  chooseLot(i, item);
                },
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        item['Lot'].toString(),
                        style: TextStyles.getRegularScund(14),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            tableCellRow(
              double.parse(item["TFOrdDtl_SellingQty"].toString())
                  .toStringAsFixed(2),
            ),
            (item['type'] != "3" && item['type'] != "1")
                ? TableCell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 0),
                      child: SizedBox(
                        height: 36,
                        child: TextFormField(
                          controller: itemQty[i],
                          style: TextStyles.getBold(
                            12,
                            color: AppColors.colorBlack,
                          ),
                          decoration: InputDecoration(
                            hintText: "Qty",
                            hintStyle: TextStyles.getRegularScund(
                              14,
                              color: AppColors.colorGray600,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 0,
                            ),
                            counterText: "",
                          ),
                          onChanged: (val) {
                            setState(() {
                              item["scanQTY"] = double.parse(val);
                            });
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          readOnly: getQtyRead(item),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please select qty";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  )
                : tableCellRow(
                    double.parse(item["scanQTY"].toString()).toStringAsFixed(2),
                  ),
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

  getQtyRead(item) {
    if (item['type'] == "2" || item['type'] == "4") {
      return false;
    }
    return !item["isSelected"];
  }

  chooseWaereHouse(int index, dynamic item) async {
    setState(() {
      isLoading = true;
    });
    var resW = await utilServices.getWareHouses(
      item["TFOrdDtl_PartNum"],
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
        item["TFOrdDtl_PartNum"],
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

  chooseLot(int index, dynamic item) async {
    setState(() {
      isLoading = true;
    });
    if (item['type'] == "2") {
      var resLots = await transferServices.getLots(
        item['TFOrdDtl_PartNum'],
        itemWheID[index],
        itemBin[index].text,
      );
      lots = resLots['value'];
      choseOptions("lotnum", index, lots);
      setState(() {
        isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  getOptTitle(String title, dynamic option) {
    switch (title) {
      case "Warehouse":
        return option["Warehse_Description"];
      case "Bin":
        return option["WhseBin_BinNum"];
      case "lotnum":
        return option["PartBin_LotNum"];
      default:
        return "NA";
    }
  }

  updateOtp(String title, dynamic option, int itemIndex) async {
    switch (title) {
      case "Warehouse":
        itemWhe[itemIndex].text = option['Warehse_Description'];
        itemWheID[itemIndex] = option['PartWhse_WarehouseCode'];
        itemBin[itemIndex].text = "";
        break;
      case "Bin":
        itemBin[itemIndex].text = option['WhseBin_BinNum'];
        if (productItems[itemIndex]['type'] == "2") {
          var resLots = await transferServices.getLots(
            productItems[itemIndex]['TFOrdDtl_PartNum'],
            itemWheID[itemIndex],
            option['WhseBin_BinNum'],
          );
          productItems[itemIndex]['Lot'] =
              resLots['value'][0]['PartBin_LotNum'];
        }
        break;
      case "lotnum":
        productItems[itemIndex]['Lot'] = option['PartBin_LotNum'];
        break;
      default:
        return "NA";
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
                                  updateOtp(title, options[index], itemIndex);
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
                                        getOptTitle(title, options[index]),
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

  submit() async {
    try {
      setState(() {
        isLoading = true;
      });

      var tfHead = [
        {
          "Company": company,
          "PackNum": widget.item['packNum'],
        }
      ];
      var tfShipDtl = [];

      for (int i = 0; i < productItems.length; i++) {
        var item = productItems[i];
        if (item["scanQTY"] > 0) {
          tfShipDtl.add(
            {
              "Company": company,
              "PackNum": widget.item['packNum'],
              "PackLine": 0,
              "PartNum": item['TFOrdDtl_PartNum'],
              "LineDesc": item['lineDisc'],
              "IUM": item['TFOrdDtl_SellingQtyUOM'],
              "WarehouseCode": itemWheID[i],
              "BinNum": itemBin[i].text,
              "LotNum": item['Lot'],
              "TFOrdLine": item['TFOrdDtl_TFOrdLine'],
              "OurStockQty":
                  double.parse(item["TFOrdDtl_SellingQty"].toString())
                      .toStringAsFixed(2),
              "OurStockShippedQty":
                  double.parse(item["scanQTY"].toString()).toStringAsFixed(2),
              "TFOrdNum": widget.item['orderNum'].toString(),
              "DisplayShipQty":
                  double.parse(item["scanQTY"].toString()).toStringAsFixed(2),
              "ShippedQty": "0",
              "OrderShipmentQty":
                  double.parse(item["scanQTY"].toString()).toStringAsFixed(2),
              "RemainingQty":
                  double.parse(item["TFOrdDtl_SellingQty"].toString())
                      .toStringAsFixed(2),
              "RequestQty": double.parse(item["TFOrdDtl_SellingQty"].toString())
                  .toStringAsFixed(2),
              "RowMod": "A"
            },
          );
        }
      }

      var selSerialNum = [];
      for (int i = 0; i < productItemSearils.length; i++) {
        selSerialNum.add(productItemSearils[i]);
      }

      var body = {
        "ds": {
          "TFShipHead": tfHead,
          "TFShipDtl": tfShipDtl,
          "SelectedSerialNumbers": selSerialNum
        },
        "continueProcessingOnError": true,
        "rollbackParentOnChildError": true
      };
      printLargeString(json.encode(body));
      Response res = await transferServices.postTransferShipmentDtl(
        json.encode(body),
      );
      if (res.statusCode != 200) {
        showError('Error', json.decode(res.body)['ErrorMessage']);
        isSubmit = false;
      } else {
        showSucess(
          'Success: ',
          "Shipment line created successfully.",
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

  void printLargeString(String text) {
    const int chunkSize = 800;
    for (int i = 0; i < text.length; i += chunkSize) {
      // Print the string in chunks
      debugPrint(text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
  }
}
