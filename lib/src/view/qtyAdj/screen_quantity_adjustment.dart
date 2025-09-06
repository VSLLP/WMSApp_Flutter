import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/home/screen_qr_scan.dart';
import 'package:intl/intl.dart';

class ScreenQuantityAdjustment extends StatefulWidget {
  const ScreenQuantityAdjustment({super.key});

  @override
  State<ScreenQuantityAdjustment> createState() =>
      _ScreenQuantityAdjustmentState();
}

class _ScreenQuantityAdjustmentState extends State<ScreenQuantityAdjustment> {
  var txtScan = TextEditingController();
  var txtWere = TextEditingController();
  var txtBin = TextEditingController();
  var txtQty = TextEditingController();
  var txtReason = TextEditingController();
  var txtDocType = TextEditingController();

  List<dynamic> docTypes = [];
  List<dynamic> reasons = [];
  List<String> wheres = [];
  List<String> bins = [];
  List<dynamic> productItems = [];
  List<dynamic> productSerialItems = [];

  int qty = 0;
  int selectedIndex = -1;

  String _val = "1";
  String tag = "1";
  String company = "";
  String tranDoc = "";
  String reson = "";

  bool isLoading = true;
  bool isSubmit = false;
  bool isCam = false;

  String selectedWh = "";

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
                            'Quantity Adjustment',
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
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   children: [
                            //     Row(
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       children: [
                            //         Text(
                            //           "Lot",
                            //           style: TextStyles.getBold(16),
                            //         ),
                            //         Radio(
                            //           value: "1",
                            //           groupValue: _val,
                            //           activeColor: AppColors.colorDataColor,
                            //           onChanged: (String? value) {
                            //             _val = "1";
                            //             clearData();
                            //             setState(() {});
                            //           },
                            //         ),
                            //       ],
                            //     ),
                            //     const SizedBox(
                            //       width: 10,
                            //     ),
                            //     Row(
                            //       mainAxisAlignment: MainAxisAlignment.start,
                            //       children: [
                            //         Text(
                            //           "Serial",
                            //           style: TextStyles.getBold(16),
                            //         ),
                            //         Radio(
                            //           value: "2",
                            //           groupValue: _val,
                            //           activeColor: AppColors.colorDataColor,
                            //           onChanged: (String? value) {
                            //             _val = "2";
                            //             clearData();
                            //             setState(() {});
                            //           },
                            //         ),
                            //       ],
                            //     )
                            //   ],
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    // _val == "1"
                                    //     ? "Part / Lot: "
                                    //     : "Part / Serial: ",
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
                                      // _val == "1"
                                      //     ? "Scan Part / Lot"
                                      //     : "Scan Part / Serial",
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
                                                clearScan();
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
                                        return "Please scan lot / serial.";
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
                                    controller: txtWere,
                                    style: TextStyles.getRegularScund(12),
                                    decoration: InputDecoration(
                                      hintText: "Select Warehouse",
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
                                      choseWhae();
                                    },
                                    keyboardType: TextInputType.name,
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
                                    "Bin: ",
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
                                      hintText: "Select Bin",
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
                                      choseBins();
                                    },
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select bin.";
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
                                    "Quantity: ",
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "+ve",
                                          style: TextStyles.getBold(14),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              tag = '1';
                                            });
                                          },
                                          child: Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: tag == "1"
                                                    ? AppColors.colorDataColor
                                                    : AppColors.colorGray100,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: tag == "1"
                                                      ? AppColors.colorDataColor
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "-ve",
                                          style: TextStyles.getBold(14),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              tag = '2';
                                            });
                                          },
                                          child: Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: tag == "2"
                                                    ? AppColors.colorDataColor
                                                    : AppColors.colorGray100,
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Center(
                                              child: Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: tag == "2"
                                                      ? AppColors.colorDataColor
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        _val == "1" || _val == "3"
                                            ? Text(
                                                "Qty: ${selectedIndex <= -1 ? 0 : productItems[selectedIndex]["QTY"]}",
                                                style: TextStyles.getBold(14),
                                              )
                                            : SizedBox(
                                                width: 100,
                                                child: TextFormField(
                                                  controller: txtQty,
                                                  style: TextStyles
                                                      .getRegularScund(12),
                                                  decoration: InputDecoration(
                                                    hintText: "Quantity",
                                                    hintStyle: TextStyles
                                                        .getRegularScund(
                                                      14,
                                                      color: AppColors
                                                          .colorGray600,
                                                    ),
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                      horizontal: 4,
                                                      vertical: 0,
                                                    ),
                                                    counterText: "",
                                                  ),
                                                  onChanged: (val) {
                                                    productItems[selectedIndex]
                                                            ['QTY'] =
                                                        int.parse(val);
                                                  },
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  autofocus: false,
                                                  readOnly: selectedIndex == -1,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Please select quantity.";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              )
                                      ],
                                    ),
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
                                    style: TextStyles.getRegularScund(12),
                                    decoration: InputDecoration(
                                      hintText: "Select Document Type",
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
                                        return "Please entry document type.";
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
                                          0: FixedColumnWidth(100),
                                          1: FixedColumnWidth(280),
                                          2: FixedColumnWidth(80),
                                          3: FixedColumnWidth(80),
                                          4: FixedColumnWidth(200),
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
                          children: [
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.colorBlue300,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "Total Items: ${getTotal()}",
                                    style: TextStyles.getBold(14),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 44,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (!isLoading) {
                                  removeCommandHandler();
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
                                  child: isSubmit
                                      ? Lottie.asset(
                                          'assets/anim/anim-btnLoading.json',
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: Text(
                                            'Remove',
                                            style: TextStyles.getBold(
                                              14,
                                              color: AppColors.colorPrimary,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!isLoading) {
                                  proceedCommandHandler();
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
                                            'Proceed',
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

  clearScan() {
    txtScan.text = "";
    txtQty.text = "0";
    qty = 0;
    productItems[selectedIndex]['isSelect'] = false;
    selectedIndex = -1;
    wheres.clear();
    bins.clear();
    setState(() {});
  }

  clearData() {
    selectedIndex = -1;
    txtWere.text = "";
    txtBin.text = "";
    txtQty.text = "0";
    qty = 0;
    txtDocType.text = "";
    txtReason.text = "";
    tranDoc = "";
    reson = "";
    wheres.clear();
    bins.clear();
    productItems.clear();
    productSerialItems.clear();
    selectedWh = "";
    setState(() {});
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

  void getPartAsync(String val) async {
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

      List<String> words = val.split(splitKey);
      if (words.length <= 2) {
        return;
      }

      String partNumber = words[1].replaceAll("Part Code - ", '');
      String lotNumber =
          words[4].replaceAll("Lot No. -", '').replaceAll(" ", "");
      String serialNumber = words[5].replaceAll("Serial No. - ", '');

      setState(() {
        isLoading = true;
      });

      if (partNumber != "") {
        _val = '1';
      } else {
        _val = '2';
      }

      var response = await inventoryServices.getPartAsync(partNumber);
      if (response == null) {
        throw Exception("No product found.");
      }

      _val = getType(response['value'][0]);

      if (_val == '2') {
        if (!response['value'][0]['Part_TrackLots']) {
          throw Exception("Please scan Part / Lot");
        }
      }

      if (_val == '3') {
        if (!response['value'][0]['Part_TrackSerialNum']) {
          throw Exception("Please scan Part / Serial");
        }
      }

      if (_val == '2' || _val == "4") {
        int isProductExist = productItems.indexWhere(
          (item) =>
              item["Part_PartNum"].toString().toLowerCase() ==
              partNumber.toLowerCase(),
        );

        if (isProductExist >= 0) {
          throw Exception("Product already scanned!");
        } else {
          var product = response['value'][0];
          product['QTY'] = 1;
          product['Lot'] = lotNumber;
          product['isSelect'] = true;
          productItems.add(response['value'][0]);
          var items = response['value'];
          wheres.clear();
          for (var item in items) {
            wheres.add(item["PartWhse_WarehouseCode"].toString());
            selectedWh = item["PartPlant_PrimWhse"].toString();
          }
          selectedIndex = productItems.length - 1;

          txtWere.text = selectedWh;
          getPartBins(selectedWh);
        }
      } else {
        int isProductExist = productItems.indexWhere(
          (item) => item["Part_PartNum"] == partNumber,
        );
        if (isProductExist >= 0) {
          int isSerialExist = productSerialItems.indexWhere(
            (item) => item["SerialNumber"] == serialNumber,
          );
          if (isSerialExist >= 0) {
            throw Exception("Product already scanned!");
          }
        }

        var product = response['value'][0];
        product['QTY'] = 1;
        product['Serial'] = serialNumber;
        product['Lot'] = lotNumber;
        product['isSelect'] = true;
        productItems.add(response['value'][0]);
        var serialPrd = {
          "Company": company,
          "SerialNumber": serialNumber,
          "PartNum": partNumber,
          "RowMod": "A"
        };
        productSerialItems.add(serialPrd);
        var items = response['value'];
        wheres.clear();
        for (var item in items) {
          wheres.add(item["PartWhse_WarehouseCode"].toString());
          selectedWh = item["PartPlant_PrimWhse"].toString();
        }
        selectedIndex = productItems.length - 1;
        txtWere.text = selectedWh;
        getPartBins(selectedWh);
      }

      // var responseD = await inventoryServices.getDefaultPartAsync(partNumber);
      // if (responseD != null) {
      //   selectedWh = responseD["Warehse_Description"];
      //   txtWere.text = selectedWh;
      //   //txtWere = wheres;
      // }
    } catch (ex) {
      clearData();
      showError('Error', ex.toString());
    } finally {
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
                                  "No reasons found.",
                                  style: TextStyles.getRegularScund(
                                    16,
                                    color: AppColors.colorGray600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: reasons.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  txtReason.text =
                                      reasons[index]["Reason_Description"];
                                  reson = reasons[index]["Reason_ReasonCode"];
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
                                        reasons[index]["Reason_Description"],
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
                                  "No doc type found.",
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
                                  tranDoc = docTypes[index]
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
                                            ["TranDocType_TranDocTypeID"],
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

  List<TableRow> getRows() {
    List<TableRow> rows = [];
    rows.add(TableRow(
      children: [
        tableCell('Product'),
        tableCell('Description'),
        tableCell('UOM'),
        tableCell('Adj Qty'),
        _val == '2' || _val == '4' ? tableCell('Lot') : tableCell('Serial'),
      ],
    ));
    for (var items in productItems) {
      rows.add(TableRow(
        decoration: BoxDecoration(
          color:
              items['isSelect'] ? AppColors.colorCyan300 : AppColors.colorWhite,
        ),
        children: [
          TableCell(
            child: GestureDetector(
              onTap: () {
                makeSelect(
                  _val == "2" || _val == "4"
                      ? items["Part_PartNum"]
                      : items["Serial"],
                );
              },
              child: SizedBox(
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      items["Part_PartNum"],
                      style: TextStyles.getRegularScund(14),
                    ),
                  ),
                ),
              ),
            ),
          ),
          tableCellRow(items["Part_PartDescription"]),
          tableCellRow(items["Part_IUM"]),
          tableCellRow(items["QTY"].toString()),
          _val == '2' || _val == "4"
              ? tableCellRow(items["Lot"])
              : tableCellRow(items["Serial"]),
        ],
      ));
    }
    return rows;
  }

  makeSelect(partNum) {
    int isProductExist = -1;
    if (_val == "1") {
      isProductExist = productItems.indexWhere(
        (item) =>
            item["Part_PartNum"].toString().toLowerCase() ==
            partNum.toString().toLowerCase(),
      );
    } else {
      isProductExist = productItems.indexWhere(
        (item) => item["Serial"] == partNum,
      );
    }
    if (productItems[isProductExist]["isSelect"]) {
      productItems[isProductExist]["isSelect"] = false;
    } else {
      productItems[isProductExist]["isSelect"] = true;
    }
    setState(() {});
  }

  choseWhae() {
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
                  "Select Wharehouse",
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
                    child: wheres.isEmpty
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
                                  "No warehouse found.",
                                  style: TextStyles.getRegularScund(
                                    16,
                                    color: AppColors.colorGray600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: wheres.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  txtWere.text = wheres[index];
                                  Navigator.of(context).pop();
                                  getPartBins(wheres[index]);
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
                                        wheres[index],
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

  choseBins() {
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
                  "Select Bin",
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
                    child: bins.isEmpty
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
                                  "No bins found.",
                                  style: TextStyles.getRegularScund(
                                    16,
                                    color: AppColors.colorGray600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: bins.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  txtBin.text = bins[index];
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
                                        bins[index],
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

  void getPartBins(String whe) async {
    try {
      setState(() {
        isLoading = true;
      });
      var response = await inventoryServices.getPartBinAsync(
        productItems[selectedIndex]["Part_PartNum"],
        whe,
      );
      var items = response['value'];
      bins.clear();
      for (var item in items) {
        bins.add(item["WhseBin_BinNum"].toString());
      }

      txtBin.text = bins[0].toString();
    } catch (ex) {
      showError('', ex.toString());
    } finally {
      txtScan.text = "";
      setState(() {
        isLoading = false;
      });
    }
  }

  getTotal() {
    int total = 0;
    for (var item in productItems) {
      total = total + int.parse(item['QTY'].toString());
    }
    return total;
  }

  void removeCommandHandler() async {
    try {
      setState(() {
        isLoading = true;
      });
      if (productItems.isNotEmpty) {
        productItems.removeWhere((item) => item['isSelect'] == true);
      }
      clearScan();
    } catch (ex) {
      showError('', ex.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void proceedCommandHandler() async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = null;
      if (productItems.isEmpty) {
        throw Exception(
          "Please scan at least one product and then try to proceed.",
        );
      }

      if (tranDoc == "") {
        throw Exception(
          "Please select document type and then try to proceed.",
        );
      }

      if (reson == "") {
        throw Exception(
          "Please select Reason and then try to proceed.",
        );
      }

      for (var item in productItems) {
        if (item['QTY'] == null || item['QTY'] == 0) {
          throw Exception("Quantity can't be zero.");
        }
      }

      if (_val == '2' || _val == "4") {
        var qty = productItems[0]['QTY'] * (tag == "1" ? 1 : -1);

        body = {
          "ds": {
            "InventoryQtyAdj": [
              {
                "Company": company,
                "PartNum": productItems[0]['Part_PartNum'],
                "WareHseCode": txtWere.text,
                "BinNum": txtBin.text,
                "AdjustQuantity": "$qty",
                "ReasonCode": reson,
                "LotNum": productItems[0]['Lot'],
                "UnitOfMeasure": productItems[0]['Part_IUM'],
                "TransDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                "ReasonType": "M",
                "TranDocTypeID": tranDoc,
                "RowMod": "A"
              }
            ],
            "LegalNumGenOpts": [],
            "SelectedSerialNumbers": [],
            "SNFormat": []
          }
        };
        // var resW = await inventoryServices.postQtyAdjustmentLot(body);
      } else {
        var qty = productItems[0]['QTY'] * (tag == "1" ? 1 : -1);
        body = {
          "ds": {
            "InventoryQtyAdj": [
              {
                "Company": company,
                "PartNum": productItems[0]['Part_PartNum'],
                "WareHseCode": txtWere.text,
                "BinNum": txtBin.text,
                "AdjustQuantity": "$qty",
                "ReasonCode": reson,
                "LotNum": productItems[0]['Lot'],
                "UnitOfMeasure": productItems[0]['Part_IUM'],
                "TransDate": DateFormat("yyyy-MM-dd").format(DateTime.now()),
                "ReasonType": "M",
                "SerialNoQty": productSerialItems.length,
                "TranDocTypeID": tranDoc,
                "RowMod": "A"
              },
            ],
            "LegalNumGenOpts": [],
            "SelectedSerialNumbers": productSerialItems,
            "SNFormat": []
          }
        };
        // var resW = await inventoryServices.postQtyAdjustmentSearial(body);
        // if(resW)
      }

      var resW = await inventoryServices.postQtyAdjustmentLot(body);
      if (resW.statusCode == 200) {
        await showError(
            "Success", "Successfully set inventory qty adjustment.");
      } else {
        await showError("error", "unable to adjust inventory qty.");
      }
    } catch (ex) {
      showError('Error', ex.toString());
    } finally {
      txtScan.text = "";
      clearData();
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

  loadData() async {
    company = await sharedPref.getString("userCompnay");
    isCam = await sharedPref.getBool("isCam");
    var response = await inventoryServices.getDocType();
    docTypes.clear();
    docTypes = response['value'];

    var responseR = await inventoryServices.getReasonAsync();
    reasons.clear();
    reasons = responseR['value'];

    txtQty.text = "0";
    setState(() {
      isLoading = false;
    });
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
