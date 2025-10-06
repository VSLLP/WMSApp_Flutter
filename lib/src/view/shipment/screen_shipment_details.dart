import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/home/screen_qr_scan.dart';
import 'package:http/http.dart';

class ScreenShipmentDetails extends StatefulWidget {
  final dynamic item;
  final bool isNew;

  const ScreenShipmentDetails({
    super.key,
    required this.item,
    required this.isNew,
  });

  @override
  State<ScreenShipmentDetails> createState() => _ScreenShipmentDetails();
}

class _ScreenShipmentDetails extends State<ScreenShipmentDetails> {
  List<dynamic> orders = [];
  List<dynamic> ordersFilter = [];
  List<dynamic> items = [];
  List<dynamic> wheres = [];
  List<dynamic> bins = [];
  List<dynamic> tradqr = [];
  List<TextEditingController> itemQty = [];
  List<dynamic> scanitems = [];

  dynamic ord = {};
  dynamic whe = {};
  dynamic bin = {};

  var txtPackNum = TextEditingController();
  var txtOrdNum = TextEditingController();
  var txtScan = TextEditingController();
  var txtWare = TextEditingController();
  var txtBin = TextEditingController();
  var txtSearch = TextEditingController();

  String partNum = "";
  String serialNum = "";
  String partLot = "";
  String qrType = "";
  String custNum = "";
  String custID = "";

  bool isLoading = true;
  bool isCam = false;

  final bool _isGestureEnabled = false;

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
                            'Shipment Details',
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
                                  child: TextFormField(
                                    controller: txtPackNum,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Pack Num",
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
                                        return "Please select pack num.";
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
                            //     SizedBox(
                            //       width:
                            //           MediaQuery.of(context).size.width * 0.3,
                            //       child: Text(
                            //         "Order Num: ",
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
                            //         controller: txtOrdNum,
                            //         style: TextStyles.getBold(
                            //           12,
                            //           color: AppColors.colorBlack,
                            //         ),
                            //         decoration: InputDecoration(
                            //           hintText: "OrderNum",
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
                            //         keyboardType: TextInputType.name,
                            //         onTap: () {
                            //           choseDropOptions(
                            //               "Order Num", true, ordersFilter);
                            //         },
                            //         autofocus: false,
                            //         readOnly: true,
                            //         validator: (value) {
                            //           if (value!.isEmpty) {
                            //             return "Please select order num.";
                            //           }
                            //           return null;
                            //         },
                            //       ),
                            //     ),
                            //   ],
                            // ),
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
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     SizedBox(
                            //       width:
                            //           MediaQuery.of(context).size.width * 0.3,
                            //       child: Text(
                            //         "Warehouse: ",
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
                            //         controller: txtWare,
                            //         style: TextStyles.getBold(
                            //           12,
                            //           color: AppColors.colorBlack,
                            //         ),
                            //         decoration: InputDecoration(
                            //           hintText: "Warehouse",
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
                            //         keyboardType: TextInputType.name,
                            //         onTap: () {
                            //           choseDropOptions(
                            //               "Warehouse", false, wheres);
                            //         },
                            //         autofocus: false,
                            //         readOnly: true,
                            //         validator: (value) {
                            //           if (value!.isEmpty) {
                            //             return "Please select warehouse.";
                            //           }
                            //           return null;
                            //         },
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     SizedBox(
                            //       width:
                            //           MediaQuery.of(context).size.width * 0.3,
                            //       child: Text(
                            //         "Binnum: ",
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
                            //         controller: txtBin,
                            //         style: TextStyles.getBold(
                            //           12,
                            //           color: AppColors.colorBlack,
                            //         ),
                            //         decoration: InputDecoration(
                            //           hintText: "Binnum",
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
                            //         keyboardType: TextInputType.name,
                            //         onTap: () {
                            //           choseDropOptions("Binnum", false, bins);
                            //         },
                            //         autofocus: false,
                            //         readOnly: true,
                            //         validator: (value) {
                            //           if (value!.isEmpty) {
                            //             return "Please select binnum.";
                            //           }
                            //           return null;
                            //         },
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(
                              height: 40,
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
                                                400,
                                        color: Colors.transparent,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
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
                                              border:
                                                  const TableBorder.symmetric(
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
                                    if (_isGestureEnabled) {
                                      if (!isLoading) {
                                        shipped();
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 38,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: _isGestureEnabled
                                          ? AppColors.colorWhite
                                          : AppColors.colorGray100,
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
                                          'Shipped',
                                          style: TextStyles.getBold(
                                            16,
                                            color: AppColors.colorAssent,
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
                                          'Submit',
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
    setState(() {
      isLoading = true;
    });

    scanitems.clear();
    isCam = await sharedPref.getBool("isCam");
    if (widget.isNew) {
      var selItem = json.decode(widget.item);
      custNum = selItem["CustNum"].toString();
      custID = selItem["CustomerCustID"].toString();

      txtPackNum.text = json.decode(widget.item)["PackNum"].toString();
      var resA =
          await custShipServices.getOpenShipmentByCustomer(custNum.toString());
      orders.clear();
      ordersFilter.clear();
      orders = resA['value'];
      ordersFilter = resA['value'];
    } else {
      var res =
          await custShipServices.getCustByName(widget.item["Customer_Name"]);
      custNum = res["value"][0]["Customer_CustNum"].toString();
      custID = res["value"][0]["Customer_CustID"].toString();

      orders.clear();
      ordersFilter.clear();
      orders.add(widget.item);
      ordersFilter.add(widget.item);
      txtOrdNum.text = widget.item["OrderHed_OrderNum"].toString();
      txtPackNum.text = widget.item["ShipHead_PackNum"].toString();
    }
    if (txtPackNum.text.isNotEmpty) {
      var resA =
          await custShipServices.getOpenShipmentItemsPacknum(txtPackNum.text);
      items.clear();
      itemQty.clear();
      for (var it in resA['value']) {
        it["isSelect"] = false;
        it["shipQty"] = "0";
        it["scanLot"] = "-";
        it["serials"] = [];
        it["prdTrack"] = "";
        items.add(it);
        itemQty.add(
          TextEditingController(
            text: double.parse(it["ShipDtl_OurInventoryShipQty"])
                .toStringAsFixed(0),
          ),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  List<TableRow> getRows() {
    List<TableRow> rows = [];
    rows.add(TableRow(
      children: [
        tableCell('Line'),
        tableCell('OrderNum/Line/Rel'),
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
      String ordernum = item["ShipDtl_OrderNum"].toString();
      String orderline = item["ShipDtl_OrderLine"].toString();
      String relnum = item["ShipDtl_OrderRelNum"].toString();
      String warehouse = item["ShipDtl_WarehouseCode"].toString();
      String bin = item["ShipDtl_BinNum"].toString();
      Color rowcolor;

      rowcolor =
          item['isSelect'] ? AppColors.colorYellow300 : Colors.transparent;

      if (item["ShipDtl_OurInventoryShipQty"] != "") {
        if (double.parse(item["ShipDtl_OurInventoryShipQty"].toString()) ==
            double.parse(item["ShipDtl_VS_QtyToShip_c"].toString())) {
          rowcolor = AppColors.colorCyan300;
        }
      }

      bool manualQty = false;

      if (!item["Part_TrackLots"] && item["Part_TrackSerialNum"]) {
        manualQty = false;
      } else if (item["Part_TrackLots"] && !item["Part_TrackSerialNum"]) {
        manualQty = true;
      } else if (!item["Part_TrackLots"] && !item["Part_TrackSerialNum"]) {
        manualQty = true;
      }

      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: rowcolor,
          ),
          children: [
            tableCellRow(item["ShipDtl_PackLine"].toString()),
            tableCellRow("$ordernum/$orderline/$relnum"),
            tableCellRow(item["ShipDtl_PartNum"].toString()),
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
                            items[i]["ShipDtl_OurInventoryShipQty"] = val;
                            items[i]["prdTrack"] = getType(items[i]);
                            itemQty[i].text =
                                items[i]["ShipDtl_OurInventoryShipQty"];
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
                    double.parse(item["ShipDtl_OurInventoryShipQty"].toString())
                        .toStringAsFixed(0),
                  ),
            tableCellRow(
              double.parse(item["ShipDtl_VS_QtyToShip_c"].toString())
                  .toStringAsFixed(0),
            ),
            tableCellRow(item["ShipDtl_LineDesc"].toString()),
            tableCellRow("$warehouse/$bin"),
            tableCellRow(item["ShipDtl_LotNum"].toString()),
            tableCellRow(item["ShipDtl_IUM"].toString()),
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

  refreshOrderNumber(String custName) async {
    if (txtOrdNum.text.isNotEmpty) {
      var resA = await custShipServices.getOpenShipmentItems(txtOrdNum.text);
      items.clear();
      itemQty.clear();
      for (var it in resA['value']) {
        it["isSelect"] = false;
        it["shipQty"] = "0";
        it["scanLot"] = "-";
        it["serials"] = [];
        it["prdTrack"] = "";
        items.add(it);
        itemQty.add(
          TextEditingController(
            text: it["ShipDtl_OurInventoryShipQty"],
          ),
        );
      }
    }
    setState(() {});
  }

  updateOtp(String title, dynamic option) {
    setState(() {
      isLoading = true;
    });
    switch (title) {
      case "Order Num":
        txtOrdNum.text = option['OrderHed_OrderNum'].toString();
        ord = option;
        refreshOrderNumber(ord["Customer_Name"]);
        break;
      case "Warehouse":
        whe = option;
        txtWare.text = whe["PartWhse_WarehouseCode"];
        getBin();
        break;
      case "Binnum":
        bin = option;
        txtBin.text = bin["WhseBin_BinNum"];
        break;
      default:
        return "NA";
    }
    setState(() {
      isLoading = false;
    });
  }

  getOptTitle(String title, dynamic option) {
    switch (title) {
      case "Order Num":
        return option['OrderHed_OrderNum'].toString();
      case "Warehouse":
        return option['Warehse_Description'].toString();
      case "Binnum":
        return option['WhseBin_BinNum'].toString();
      default:
        return "NA";
    }
  }

  choseDropOptions(String title, bool isSearch, List<dynamic> options) {
    List<dynamic> items = List.from(options);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select $title", style: TextStyles.getBold(18)),
                    isSearch
                        ? TextFormField(
                            controller: txtSearch,
                            style: TextStyles.getBold(
                              12,
                              color: AppColors.colorBlack,
                            ),
                            decoration: InputDecoration(
                              hintText: "Search item",
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
                              items = orders
                                  .where((ord) => ord["OrderHed_OrderNum"]
                                      .toString()
                                      .startsWith(val))
                                  .toList();
                              setState(() {});
                            },
                            keyboardType: TextInputType.name,
                            autofocus: false,
                          )
                        : Container(),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: AppColors.colorGray100,
                    ),
                    Expanded(
                      child: items.isEmpty
                          ? Center(
                              child: Text("No $title found.",
                                  style: TextStyles.getRegularScund(16,
                                      color: AppColors.colorGray600)))
                          : ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    txtSearch.text = "";
                                    updateOtp(title, items[index]);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      getOptTitle(title, items[index]),
                                      style: TextStyles.getRegularScund(16,
                                          color: AppColors.colorGray600),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          txtSearch.text = "";
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel", style: TextStyles.getBold(14)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
        var resTradQr = await transferShipServices.getTraditionalQRData(val);
        if (resTradQr == null) {
          return;
        }
        tradqr.clear();
        tradqr = resTradQr["value"];
        //qrType = "A";
        partNum = tradqr[0]["UD16_Character01"]; //val.substring(0, 9);
        serialNum = tradqr[0]["UD16_Character02"];

        // qrType = "A";
        // partNum = val.substring(0, 9);
        // serialNum = val.substring(13);

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

      int isProductExist = scanitems.indexWhere(
        (item) =>
            item["partnum"].toString().toLowerCase() == partNum.toLowerCase() &&
            item["serialnum"].toString().toLowerCase() ==
                serialNum.toLowerCase(),
      );

      if (isProductExist >= 0) {
        throw Exception("Product already scanned!");
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

      var resStatus =
          await transferShipServices.getSerialStatus(partNum, serialNum);
      List<dynamic> statusList = resStatus["value"];

      if (statusList[0]["SerialNo_SNStatus"].toString() == "INVENTORY") {
        var prdDtl = resPrd["value"][0];

        if (productIndex == -1) {
          throw Exception("Please scan a valid PartNum.");
        } else {
          if (qrType == "B" && partLot.isNotEmpty) {
            items[productIndex]["ShipDtl_LotNum"] = partLot;
          }
          items[productIndex]["isSelect"] = true;
          items[productIndex]["ShipDtl_OurInventoryShipQty"] = (double.parse(
                      items[productIndex]["ShipDtl_OurInventoryShipQty"]) +
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

          scanitems.add({"partnum": partNum, "serialnum": serialNum});
        }

        getWhere(partNum);
      } else {
        throw Exception(
            " Invalid Part/Serial No scanned. Please scan a valid Part/Serial No.");
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

  getWhere(String partnum) async {
    var response = await inventoryServices.getPartAsync(partnum);
    if (response == null) {
      throw Exception("No product found.");
    }
    var items = response['value'];
    wheres.clear();
    for (var item in items) {
      wheres.add(item);
    }
    if (wheres.isNotEmpty) {
      whe = wheres.first;
      txtWare.text = whe["Calculated_ReceiptWarhouse"];
    }
    getBin();
    setState(() {});
  }

  getBin() async {
    var response =
        await inventoryServices.getPartBinAsync(partNum, txtWare.text);
    if (response == null) {
      throw Exception("No product found.");
    }
    var items = response['value'];
    bins.clear();
    for (var item in items) {
      bins.add(item);
    }
    if (bins.isNotEmpty) {
      bin = bins.first;
      txtBin.text = bin["WhseBin_BinNum"];
    }
    setState(() {});
  }

  clearData() {
    items.clear();
    itemQty.clear();
    wheres.clear();
    bins.clear();
    txtOrdNum.text = "";
    txtScan.text = "";
    txtWare.text = "";
    txtBin.text = "";
    txtSearch.text = "";
    whe = {};
    bin = {};
    ord = {};
    partNum = "";
    serialNum = "";
    partLot = "";
    qrType = "";
    custNum = "";
    loadData();
  }

  submit() async {
    try {
      String plant = await sharedPref.getString("userPlant");
      String company = await sharedPref.getString("userCompnay");

      bool isSubmit = false;

      setState(() {
        isLoading = true;
      });

      for (var item in items) {
        if (item["prdTrack"] != "") {
          isSubmit = true;
          custNum = item["ShipDtl_CustNum"].toString();

          double qTY =
              double.parse(item['ShipDtl_OurInventoryShipQty'].toString());
          double rqTY = double.parse(item['ShipDtl_VS_QtyToShip_c'].toString());
          if (qTY <= 0) {
            throw Exception(
                "Invalid QTY at Orderline ${item["ShipDtl_OrderLine"]}.");
          }
          if (qTY > rqTY) {
            throw Exception(
                "QTY cannot be grater than reqQty at Orderline ${item["ShipDtl_OrderLine"]}.");
          }

          if (item["prdTrack"] == "1" || item["prdTrack"] == "3") {
            String lot = item["scanLot"] == "-" ? "" : item["scanLot"];
            for (var serialItem in item["serials"]) {
              if (serialItem["qrType"] == "A") {
                print("Call API A");
                var apia = await custShipServices.getSerialAvail(
                    item["ShipDtl_PartNum"],
                    item["ShipDtl_WarehouseCode"],
                    item["ShipDtl_BinNum"]);
                var serialdata = apia["value"][0];
                printLargeString(json.encode(serialdata));
                lot = serialdata["ShipDtl_LotNum"];
                print("Call API B");
                var srupdbody = {
                  "Company": company,
                  "PartNum": serialdata["SerialNo_PartNum"],
                  "SerialNumber": serialdata["SerialNo_SerialNumber"],
                  "SNStatus": "Shipped",
                  "SNReference": "Test",
                  "TransactionSource": "SNMaint"
                };

                Response apib = await custShipServices.patchSerialUpdate(
                    srupdbody,
                    serialdata["SerialNo_PartNum"],
                    serialdata["SerialNo_SerialNumber"]);
                printLargeString(apib.body);
                print("Call API C");
                var updBody = {
                  "Company": company,
                  "PartNum": item["OrderRel_PartNum"],
                  "SerialNumber": serialItem["num"],
                  "SNStatus": "Shipped",
                  "SNReference": " Opening SerialNo",
                  "TransactionSource": "SNMaint",
                  "CustNum": int.parse(custNum),
                  "CustID": custID,
                  "LotNum": serialdata["SerialNo_LotNum"]
                };
                printLargeString(json.encode(updBody));
                Response apic = await custShipServices.patchSerialNoAdd(
                  updBody,
                  serialdata["SerialNo_PartNum"],
                  serialItem["num"],
                );
                print("Call API D");
                printLargeString(apic.body);
                var serBody = {
                  "Company": company,
                  "PartNum": item["ShipDtl_PartNum"],
                  "SerialNumber": serialItem["num"],
                  "SNStatus": "Inventory",
                  "SNReference": " Opening SerialNo",
                  "TransactionSource": "SNMaint",
                  "WareHouseCode": item["ShipDtl_WarehouseCode"],
                  "BinNum": item["ShipDtl_BinNum"]
                };
                printLargeString(json.encode(serBody));
                Response apid = await custShipServices.patchSerial(
                  serBody,
                  serialdata["SerialNo_PartNum"],
                  serialItem["num"],
                );
                printLargeString(apid.body);
              }
            }

            List<dynamic> serialBody = [];
            for (var serial in item["serials"]) {
              serialBody.add({
                "Company": company,
                "SerialNumber": serial["num"],
                "Scrapped": false,
                "ScrappedReasonCode": "",
                "Voided": false,
                "Reference": "",
                "ReasonCodeType": "",
                "ReasonCodeDesc": "",
                "PartNum": item["ShipDtl_PartNum"],
                "SNPrefix": "",
                "SNFormat": "",
                "SNBaseNumber": serial["num"],
                "XRefPartNum": "",
                //serial["num"].substring(serial["num"].length - 7),
                "XRefPartType": "",
                "TransType": "STK-PCK",
                "RowMod": "A"
              });
            }

            var body = {
              "ds": {
                "ShipDtl": [
                  {
                    "Company": company,
                    "CustNum": custNum,
                    "PackNum": txtPackNum.text,
                    "PackLine": item["ShipDtl_PackLine"],
                    "OrderNum": item["ShipDtl_OrderNum"],
                    "OrderLine": item["ShipDtl_OrderLine"],
                    "OrderRelNum": item["ShipDtl_OrderRelNum"],
                    "PartNum": item["ShipDtl_PartNum"],
                    "LineDesc": item["ShipDtl_LineDesc"],
                    "Plant": plant,
                    "BinNum": item["ShipDtl_BinNum"],
                    "LotNum": lot,
                    "WarehouseCode": item["ShipDtl_WarehouseCode"],
                    "InventoryShipUOM": item["ShipDtl_InventoryShipUOM"],
                    "DisplayInvQty": item['ShipDtl_OurInventoryShipQty'],
                    "VS_QtyToShip_c": item['ShipDtl_VS_QtyToShip_c'],
                    "SalesUM": item["ShipDtl_SalesUM"],
                    "IUM": item["ShipDtl_IUM"],
                    "JobShipUOM": item["ShipDtl_JobShipUOM"],
                    "PartNumTrackLots": item["Part_TrackLots"],
                    "TrackSerialNum": item["Part_TrackSerialNum"],
                    "SysRevID": item["ShipDtl_SysRevID"],
                    "SysRowID": item["ShipDtl_SysRowID"],
                    "BinType": item["ShipDtl_BinType"],
                    "WUM": item["ShipDtl_WUM"],
                    "ShipCmpl":
                        double.parse(item["Calculated_TotShipQty"].toString()) +
                                    qTY >=
                                double.parse(
                                    item["Calculated_TotOrderQty"].toString())
                            ? true
                            : false,
                    // "FromPlantTracking": true,
                    // "ToPlantTracking": true,
                    "RowMod": "U"
                  }
                ],
                "SelectedSerialNumbers": serialBody
              }
            };
            printLargeString(json.encode(body));
            Response res = await custShipServices.submitShipment(body);
            printLargeString(res.body);
            print(res.statusCode);
            if (res.statusCode != 201 && res.statusCode != 200) {
              throw Exception(json.decode(res.body)['ErrorMessage']);
            }
          } else {
            String lot = item["scanLot"] == "-" ? "" : item["scanLot"];
            var body = {
              "ds": {
                "ShipDtl": [
                  {
                    "Company": company,
                    "CustNum": custNum,
                    "PackNum": txtPackNum.text,
                    "PackLine": item["ShipDtl_PackLine"],
                    "OrderNum": item["ShipDtl_OrderNum"],
                    "OrderLine": item["ShipDtl_OrderLine"],
                    "OrderRelNum": item["ShipDtl_OrderRelNum"],
                    "PartNum": item["ShipDtl_PartNum"],
                    "LineDesc": item["ShipDtl_LineDesc"],
                    "Plant": plant,
                    "BinNum": item["ShipDtl_BinNum"],
                    "LotNum": item["ShipDtl_LotNum"],
                    "WarehouseCode": item["ShipDtl_WarehouseCode"],
                    "InventoryShipUOM": item["ShipDtl_InventoryShipUOM"],
                    "DisplayInvQty": item['ShipDtl_OurInventoryShipQty'],
                    "VS_QtyToShip_c": item['ShipDtl_VS_QtyToShip_c'],
                    "SalesUM": item["ShipDtl_SalesUM"],
                    "IUM": item["ShipDtl_IUM"],
                    "JobShipUOM": item["ShipDtl_JobShipUOM"],
                    "PartNumTrackLots": item["Part_TrackLots"],
                    "TrackSerialNum": item["Part_TrackSerialNum"],
                    "SysRevID": item["ShipDtl_SysRevID"],
                    "SysRowID": item["ShipDtl_SysRowID"],
                    // "FromPlantTracking": true,
                    // "ToPlantTracking": true,
                    "RowMod": "U"
                  }
                ],
                "SelectedSerialNumbers": []
              }
            };

            printLargeString(json.encode(body));
            Response res = await custShipServices.submitShipment(body);

            if (res.statusCode != 201 && res.statusCode != 200) {
              throw Exception(json.decode(res.body)['ErrorMessage']);
            }
          }
        }
      }
      if (isSubmit) {
        showSuccess(
          'Success: ',
          "Customer shipment submitted successfully.",
        );
      } else {
        throw Exception("Please scan atleast one product to submit.");
      }
    } catch (ex) {
      showError('', ex.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  shipped() async {
    try {
      //String plant = await sharedPref.getString("userPlant");
      String company = await sharedPref.getString("userCompnay");

      bool isSubmit = false;

      setState(() {
        isLoading = true;
      });

      var updBody = {
        "Company": company,
        "PackNum": txtPackNum.text,
        "ReadyToInvoice": true,
        "RowMod": "A"
      };

      Response res = await custShipServices.submitShipped(updBody);

      if (res.statusCode != 201 && res.statusCode != 200) {
        throw Exception(json.decode(res.body)['ErrorMessage']);
      } else {
        isSubmit = true;
      }

      if (isSubmit) {
        showSuccess(
          'Success: ',
          "Order Shipped successfully.",
        );
      }
      // else {
      //   throw Exception("Please scan atleast one product to submit.");
      // }
    } catch (ex) {
      showError('', ex.toString());
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
                        clearData();
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
