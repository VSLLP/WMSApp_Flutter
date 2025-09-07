import 'package:epicor/core_packages.dart';
import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/home/screen_qr_scan.dart';
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
  var txtScan = TextEditingController();

  List<dynamic> items = [];
  List<dynamic> submitItem = [];
  List<TextEditingController> itemQty = [];

  String packNum = "";
  String company = "";
  String txtFromPlant = "";
  String txtToPlant = "";
  String txtPackNum = "";
  String txtshipDate = "2025-09-07T12:25:31+00:00";

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
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.colorWhite,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.colorTansprent20,
                                blurRadius: 4,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Table(
                                      columnWidths: const {
                                        0: FixedColumnWidth(50),
                                        1: FixedColumnWidth(148),
                                        2: FixedColumnWidth(100),
                                        3: FixedColumnWidth(80),
                                        4: FixedColumnWidth(80),
                                        5: FixedColumnWidth(140),
                                        6: FixedColumnWidth(110),
                                        7: FixedColumnWidth(40),
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
    try {
      setState(() {
        isLoading = true;
      });

      isCam = await sharedPref.getBool("isCam");
      company = await sharedPref.getString("userCompnay");

      txtPackNum = widget.item['packNum'].toString();
      txtFromPlant = widget.item['fromPlantName'].toString();
      txtToPlant = widget.item['toPlantName'].toString();
      txtshipDate = widget.item['shipDate'].toString();

      var response = await transferShipServices
          .getTfShipmentDtlGrid(widget.item['packNum'].toString());
      for (var item in response['value']) {
        if (item['TFShipDtl_PackNum'] != null) {
          item["TFShipDtl_OrderRelNum"] = "";
          item["ShipDtl_OurInventoryShipQty"] = 0;
          item["isSelect"] = false;
          items.add(item);
          itemQty.add(TextEditingController());
        }
      }
    } catch (e) {
      showError("Error", e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
      }

      if (partNum.isEmpty && serialNum.isEmpty) {
        throw Exception("Invalid QR Code.");
      }

      int productIndex = items.indexWhere(
        (item) =>
            item["TFShipDtl_PartNum"].toString().toLowerCase() ==
                partNum.toLowerCase() &&
            double.parse(item["TFShipDtl_OurStockShippedQty"].toString()) <
                double.parse(item["TFShipDtl_VS_QtyToShip_c"].toString()),
      );

      var resPrd = await custShipServices.getGetPart(partNum);
      if (resPrd["value"].length == 0) {
        throw Exception("Invalid partnum no details found.");
      }

      if (productIndex == -1) {
        throw Exception("Please scan a valid PartNum.");
      } else {
        if (qrType == "B" && partLot.isNotEmpty) {
          items[productIndex]["TFShipDtl_LotNum"] = partLot;
        }
        items[productIndex]["isSelect"] = true;
        items[productIndex]["TFShipDtl_OurStockShippedQty"] = (double.parse(
                    items[productIndex]["TFShipDtl_OurStockShippedQty"]
                        .toString()) +
                1)
            .toString();
        itemQty[productIndex].text =
            items[productIndex]["TFShipDtl_OurStockShippedQty"];
        addProductToSubmit(items[productIndex], serialNum);
      }
    } catch (ex) {
      showError('Error', ex.toString());
    } finally {
      txtScan.text = "";
      setState(() {
        isLoading = false;
      });
    }
  }

  addProductToSubmit(dynamic selItem, String serialNum) {
    int productIndex = submitItem.indexWhere((itm) =>
        itm["Key3"] == selItem["TFShipDtl_PackLine"] && itm["Key5"] == "P");
    if (productIndex == -1) {
      submitItem.add({
        "Company": company,
        "Key1": "TFShipDtl",
        "Key2": selItem["TFShipDtl_PackNum"],
        "Key3": selItem["TFShipDtl_PackLine"],
        "Key4": "",
        "Key5": "P",
        "Number01": selItem["TFShipDtl_PackNum"],
        "Number02": selItem["TFShipDtl_PackLine"],
        "Number03": selItem["TFShipDtl_OurStockShippedQty"],
        "RowMod": "A"
      });
    }
    submitItem.add({
      "Company": company,
      "Key1": "TFShipDtl",
      "Key2": selItem["TFShipDtl_PackNum"],
      "Key3": selItem["TFShipDtl_PackLine"],
      "Key4": serialNum,
      "Key5": "C",
      "Number01": selItem["TFShipDtl_PackNum"],
      "Number02": selItem["TFShipDtl_PackLine"],
      "Number03": 1,
      "RowMod": "A"
    });
  }

  submit() async {
    try {
      if (submitItem.isEmpty) {
        throw Exception("Please scan atleast one item to submit!");
      } else {
        setState(() {
          isLoading = true;
        });
        var body = {
          "ds": {
            "UD16": submitItem,
          }
        };
        printLargeString(json.encode(body));
        var resW =
            await transferShipServices.postTransShipOrder(json.encode(body));

        for (var item in submitItem) {
          var bodyD = {
            "key1": item["Key1"].toString(),
            "key2": item["Key2"].toString(),
            "key3": item["Key3"].toString(),
            "key4": item["Key4"].toString(),
            "key5": item["Key5"].toString(),
          };
          var resD =
              await transferShipServices.deleteStagging(json.encode(bodyD));
        }

        if (resW.statusCode == 200) {
          await showError("Success", "Successfully submitted.");
        } else {
          var response = json.decode(resW.body);
          if (response["ErrorMessage"] != null) {
            await showError("error", response["ErrorMessage"]);
          } else {
            await showError("error", "Server error occurred.");
          }
        }
      }
    } catch (ex) {
      showError('Error', ex.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void printLargeString(String text) {
    const int chunkSize = 800;
    for (int i = 0; i < text.length; i += chunkSize) {
      debugPrint(text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize));
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
      String warehouse = item["TFShipDtl_WarehouseCode"].toString();
      String bin = item["TFShipDtl_BinNum"].toString();
      Color rowcolor =
          item['isSelect'] ? AppColors.colorYellow300 : Colors.transparent;

      if (item["TFShipDtl_OurStockShippedQty"] != "") {
        if (double.parse(item["TFShipDtl_OurStockShippedQty"].toString()) ==
            double.parse(item["TFShipDtl_VS_QtyToShip_c"].toString())) {
          rowcolor = AppColors.colorCyan300;
        }
      }

      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: rowcolor,
          ),
          children: [
            tableCellRow(item["TFShipDtl_PackLine"].toString()),
            tableCellRow("$ordernum/$orderline"),
            tableCellRow(item["TFShipDtl_PartNum"].toString()),
            tableCellRow(
              double.parse(item["TFShipDtl_OurStockShippedQty"].toString())
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
        child: Padding(
          padding: const EdgeInsets.all(8),
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
