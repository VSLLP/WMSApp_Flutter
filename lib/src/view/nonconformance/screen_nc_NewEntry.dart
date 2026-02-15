import 'package:epicor/core_packages.dart';
import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/home/screen_qr_scan.dart';

import 'package:http/http.dart';

class ScreenNcNewentry extends StatefulWidget {
  const ScreenNcNewentry({super.key});

  @override
  State<ScreenNcNewentry> createState() => _ScreenNcNewentry();
}

class _ScreenNcNewentry extends State<ScreenNcNewentry> {
  var txtScan = TextEditingController();
  var txtWere = TextEditingController();
  var txtBin = TextEditingController();
  var txtTWere = TextEditingController();
  var txtTBin = TextEditingController();
  var txtReason = TextEditingController();

  String wereFId = "", fbinID = "", txtReasonId = "";
  String wereTId = "", tbinId = "";

  List<dynamic> items = [];
  List<dynamic> whareHouses = [];
  List<dynamic> bins = [];
  List<dynamic> defaultWhare = [];
  List<dynamic> reasonList = [];

  dynamic selWheres = [];
  dynamic selBins = [];

  String company = "";
  String plant = "";

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
                            'Create New',
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
                                    "Product Scan",
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
                                      hintText: "Product Scan",
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
                                      suffixIcon: txtScan.text.isEmpty
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: Center(
                                                child: Icon(
                                                  Icons.search,
                                                  color: AppColors.colorGray600,
                                                  size: 20,
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                txtScan.text = "";
                                                setState(() {});
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
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please scan.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "From Warehouse: ",
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
                                    controller: txtWere,
                                    style: TextStyles.getRegularScund(12),
                                    decoration: InputDecoration(
                                      hintText: "Select From Warehouse",
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
                                      //choseOptions(
                                      //    "From Warehouse", whareHouses);
                                    },
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select From warehouse.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "From Bin: ",
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
                                    style: TextStyles.getRegularScund(12),
                                    decoration: InputDecoration(
                                      hintText: "Select From Bin",
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
                                      // choseBins();
                                    },
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select from bin.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "To Warehouse: ",
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
                                    controller: txtTWere,
                                    style: TextStyles.getRegularScund(12),
                                    decoration: InputDecoration(
                                      hintText: "Select To Warehouse",
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
                                      //choseOptions("To Warehouse", whareHouses);
                                    },
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select To warehouse.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "To Bin: ",
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
                                    controller: txtTBin,
                                    style: TextStyles.getRegularScund(12),
                                    decoration: InputDecoration(
                                      hintText: "Select To Bin",
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
                                      // choseBins();
                                    },
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select To bin.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Reason: ",
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
                                    controller: txtReason,
                                    style: TextStyles.getRegularScund(12),
                                    decoration: InputDecoration(
                                      hintText: "Select Reason",
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
                                      choseReason();
                                    },
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select reason.";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 36,
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
                                          0: FixedColumnWidth(80),
                                          //1: FixedColumnWidth(200),
                                          1: FixedColumnWidth(200),
                                          2: FixedColumnWidth(200),
                                          3: FixedColumnWidth(200),
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
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                                  color: AppColors.colorPrimary,
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
                                            'SUBMIT',
                                            style: TextStyles.getBold(
                                              14,
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
                          height: 22,
                        ),
                        // Row(
                        //   children: [
                        //     const SizedBox(
                        //       width: 8,
                        //     ),
                        //     Container(
                        //       decoration: BoxDecoration(
                        //         color: AppColors.colorBlue300,
                        //       ),
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(8.0),
                        //         child: Center(
                        //           child: Text(
                        //             "Total Items: ${items.length}",
                        //             style: TextStyles.getBold(14),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // const SizedBox(
                        //   height: 60,
                        // ),
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

  void getPartAsync(String val) async {
    try {
      if (val.length <= 3) {
        return;
      }

      String partNum = "";
      String serialNum = "";
      String partLot = "";

      if (val.length == 20) {
        partNum = val.substring(0, 9);
        serialNum = val.substring(13, 20);
      } else {
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

        List<String> words = val.split(splitKey);
        if (words.length <= 2) {
          return;
        }

        partNum = words[1].replaceAll("Part Code - ", '');
        serialNum = words[5].replaceAll("Serial No. - ", '');
        partLot = words[4].replaceAll("Lot No. -", '').replaceAll(" ", "");
      }

      var resNc = await nonconfServices.getAvailableWarehouse(serialNum);
      if (resNc["value"].length == 0) {
        throw Exception("Invalid partnum. no details found.");
      }

      var data = resNc["value"];
      if (data[0]["SerialNo_SNStatus"] != "INVENTORY") {
        throw Exception("Invalid partnum. no details found.");
      }

      if (items.isEmpty) {
        txtWere.text = data[0]["Warehse_Description"];
        wereFId = data[0]["SerialNo_WareHouseCode"];
        txtBin.text = data[0]["WhseBin_Description"];
        fbinID = data[0]["SerialNo_BinNum"];
      }

      if (wereFId != data[0]["SerialNo_WareHouseCode"] ||
          fbinID != data[0]["SerialNo_BinNum"]) {
        throw Exception(
            "Please scan valid serial num from same Wharehouse and Bin");
      }

      //int productDuplicate = 0;
      for (var item in items) {
        int indexDuplicate = item["serials"].indexWhere(
          (i) =>
              i["serialNum"].toString().toLowerCase() ==
              serialNum.toLowerCase(),
        );

        if (indexDuplicate != -1) {
          throw Exception("$serialNum already scanned");
        }
      }

      int productIndex = items.indexWhere(
        (item) =>
            item["SerialNo_PartNum"].toString().toLowerCase() ==
            partNum.toLowerCase(),
      );

      if (productIndex == -1) {
        items.add({
          "SerialNo_PartNum": data[0]["SerialNo_PartNum"],
          "PartRev_RevisionNum": data[0]["PartRev_RevisionNum"],
          "qty": "1",
          "serials": []
        });

        int productIndex1 = items.indexWhere(
          (item) =>
              item["SerialNo_PartNum"].toString().toLowerCase() ==
              partNum.toLowerCase(),
        );
        items[productIndex1]["serials"].add({
          "serialNum": serialNum,
          "SerialNo_SerialNumber": data[0]["SerialNo_SerialNumber"],
        });
      } else {
        items[productIndex]["qty"] =
            (int.parse(items[productIndex]["qty"]) + 1).toString();
        items[productIndex]["serials"].add({"serialNum": serialNum});
      }

      // if (txtWere.text.isEmpty || txtBin.text.isEmpty) {
      //   throw Exception("Please select warehouse and bin!");
      // }

      // if (val.length <= 14) {
      //   return;
      // }

      // String partNumber = val.substring(0, 9);
      // String fullQR = val;

      // int isProductExist = items.indexWhere(
      //   (item) =>
      //       item["PartNum"].toString().toLowerCase() ==
      //           partNumber.toLowerCase() &&
      //       item["QR"].toString().toLowerCase() == fullQR.toLowerCase(),
      // );

      // if (isProductExist >= 0) {
      //   throw Exception("Product already scanned!");
      // } else {
      //   items.add({
      //     "PartNum": partNumber,
      //     "QR": fullQR,
      //     "whe": selWheres["Warehse_WarehouseCode"],
      //     "bin": txtBin.text
      //   });
      // }
    } catch (ex) {
      showError('Error', ex.toString());
    } finally {
      txtScan.text = "";
      setState(() {
        isLoading = false;
      });
    }
  }

  choseReason() {
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
                  "Select Reason",
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
                    child: whareHouses.isEmpty
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
                                  "No reason found.",
                                  style: TextStyles.getRegularScund(
                                    16,
                                    color: AppColors.colorGray600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: reasonList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  txtReason.text =
                                      reasonList[index]["Reason_Description"];
                                  txtReasonId =
                                      reasonList[index]["Reason_ReasonCode"];
                                  // getBins(wereTId);
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
                                        reasonList[index]["Reason_Description"],
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

  List<TableRow> getRows() {
    List<TableRow> rows = [];
    rows.add(TableRow(
      children: [
        tableCell('Sr No.'),
        //tableCell('Product'),
        tableCell('Part Num'),
        tableCell('Rev Num'),
        tableCell('QTY'),
      ],
    ));
    int count = 0;
    for (var item in items) {
      rows.add(TableRow(
        children: [
          tableCellRow((count + 1).toString()),
          //tableCellRow(item["PartNum"]),
          tableCellRow(item["SerialNo_PartNum"].toString()),
          tableCellRow(item["PartRev_RevisionNum"].toString()),
          tableCellRow(item["qty"].toString()),
        ],
      ));
      count += 1;
    }
    return rows;
  }

  Widget tableCell(String text) {
    return TableCell(
      child: SizedBox(
        height: 40,
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

  clearData() {
    items.clear();
    isLoading = false;
    txtScan.text = "";
    setState(() {});
  }

  choseOptions(String title, List<dynamic> options) async {
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
                                onTap: () async {
                                  updateOtp(title, options[index]);
                                  Navigator.of(context).pop();
                                  setState(() {
                                    // await loadData();
                                  });
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

  getOptTitle(String title, dynamic option) {
    switch (title) {
      case "Assembly":
        return option['lable'];
      case "MtlSeq":
        return option['lable'];
      case "Warehouse":
        return option['Warehse_Description'];
      case "From Warehouse":
        return option['Warehse_Description'];
      case "Bin":
        return option['WhseBin_BinNum'];
      case "From Bin":
        return option['WhseBin_BinNum'];
      case "Doc Type":
        return option['TranDocType_Description'];
      case "Lot Number":
        return option;
      default:
        return "NA";
    }
  }

  updateOtp(String title, dynamic option) async {
    switch (title) {
      case "From Warehouse":
        setState(() {
          txtWere.text = option['Warehse_Description'];
          //= option['PartWhse_WarehouseCode'];
          // print(txtFWere.text);
          // print(wereFID);
        });

        // First update bins
        await getBins(option['Warehse_WarehouseCode']);

        // Clear the bin selection since warehouse changed
        txtBin.text = "";

        // Then update lot numbers with current context
        //await updateLotNumbers();
        break;
      case "To Warehouse":
        setState(() {
          txtTWere.text = option['Warehse_Description'];
          //= option['PartWhse_WarehouseCode'];
          // print(txtFWere.text);
          // print(wereFID);
        });

        // First update bins
        await getBins(option['PartWhse_WarehouseCode']);

        // Clear the bin selection since warehouse changed
        txtBin.text = "";

        // Then update lot numbers with current context
        //await updateLotNumbers();
        break;
      case "From Bin":
        setState(() {
          txtBin.text = option['WhseBin_BinNum'];
        });
        //await updateLotNumbers();
        break;
      case "To Bin":
        setState(() {
          txtTBin.text = option['WhseBin_BinNum'];
        });
        //await updateLotNumbers();
        break;

      default:
        return "NA";
    }
    setState(() {});
  }

  getBins(String val) async {
    var response = await materialServices.getGetPartBin("", val);
    bins.clear();
    bins = response['value'];
  }

  showSuccess(String title, String message) {
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
                        // clearData();
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

  loadData() async {
    clearData();
    isCam = await sharedPref.getBool("isCam");
    var resB = await scanServices.getWarehouseAsync();
    whareHouses.clear();
    whareHouses = resB['value'];

    var resD = await nonconfServices.getDefaultWarehouse();
    defaultWhare = resD['value'];
    txtTWere.text = defaultWhare[0]["Warehse_Description"].toString();
    wereTId = defaultWhare[0]["PlantConfCtrl_DefInspWhse"].toString();
    txtTBin.text = defaultWhare[0]["WhseBin_Description"].toString();
    tbinId = defaultWhare[0]["PlantConfCtrl_DefInspBin"].toString();

    var resReason = await nonconfServices.getReasons();
    reasonList = resReason["value"];

    setState(() {
      isLoading = false;
    });
  }

  submit() async {
    try {
      String plant = await sharedPref.getString("userPlant");
      String company = await sharedPref.getString("userCompnay");

      bool isSubmit = false;
      List<dynamic> serialBody = [];
      List<dynamic> serialMainBody = [];

      if (txtReasonId == null || txtReasonId == "") {
        throw Exception("Please select reason code");
      }

      setState(() {
        isLoading = true;
      });

      for (var item in items) {
        for (var i in item["serials"]) {
          serialBody.add({
            "Company": company, //fixed
            "SerialNumber": i["serialNum"],
            "PartNum": item["SerialNo_PartNum"],
            "SNBaseNumber": i["serialNum"].substring(i["serialNum"].length - 7),
            "TransType": "STK-INS", //fixed
            "PassedInspection": false, //fixed
            "RowMod": "A"
          });
        }

        serialMainBody.add({
          "Company": company, //fixed
          "Quantity": item["qty"], //scanned
          "ReasonCode": txtReasonId, //fixed
          "PartNum": item["SerialNo_PartNum"],
          "RevisionNum": item["PartRev_RevisionNum"],
          "TrnTyp": "I", //fixed
          //"Description": "Ceasefire Quick Response System (CA-HCFC-123) Direct - 9Kg- Container, Gas & Valve",
          //"EntryPerson": "manager",
          "EmpID": "manager",
          "InspectionPending": true, //fixed
          "SysDate": DateTime.now().toIso8601String(),
          "WarehouseCode": wereFId,
          "BinNum": fbinID,
          "ScrapUM": "No.",
          "PartNumIUM": "No.",
          "TranID": 0, //fixed
          "Plant": plant,
          "ToWarehouseCode": wereTId,
          "ToBinNum": tbinId,
          "RequestMove": false, //fixed
          // "ReasonDescription": "Parameter does not matched",
          "TranQty": item["qty"], //scanned
          "TranUOM": "No.",
          "TrnTypDescription": "Inventory", //fixed
          // "EmpIDName": "manager manager",
          "PartNumTrackSerialNum": true, //fixed
          // "PlantName": "FACTORY (UK90)", //loginplant
          "RowMod": "A", //fixed
          "EnableSN": true
        });
      }

      var body = {
        "pcNonConfType": "INVENTORY",
        "ds": {"NonConf": serialMainBody, "SelectedSerialNumbers": serialBody}
      };

      printLargeString(json.encode(body));
      Response res = await nonconfServices.submitNC(body);
      if (res.statusCode == 200) {
        isSubmit = true;
      } else {
        isSubmit = false;
      }

      if (isSubmit) {
        showSuccess(
          'Success: ',
          "Submitted successfully.",
        );
      } else {
        throw Exception("Unable to submit...");
      }
    } catch (ex) {
      showError('', ex.toString());
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
}
