import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/home/screen_qr_scan.dart';
import 'package:http/http.dart';

class ScreenCustShipDetails extends StatefulWidget {
  final dynamic item;
  final bool isNew;

  const ScreenCustShipDetails({
    super.key,
    required this.item,
    required this.isNew,
  });

  @override
  State<ScreenCustShipDetails> createState() => _ScreenCustShipDetailsState();
}

class _ScreenCustShipDetailsState extends State<ScreenCustShipDetails> {
  List<dynamic> orders = [];
  List<dynamic> ordersFilter = [];
  List<dynamic> items = [];
  List<dynamic> wheres = [];
  List<dynamic> bins = [];

  List<TextEditingController> itemQty = [];

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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Order Num: ",
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
                                      hintText: "OrderNum",
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
                                      choseDropOptions(
                                          "Order Num", true, ordersFilter);
                                    },
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select order num.";
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
                                      choseDropOptions(
                                          "Warehouse", false, wheres);
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
                                      choseDropOptions("Binnum", false, bins);
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
                                              1: FixedColumnWidth(100),
                                              2: FixedColumnWidth(130),
                                              3: FixedColumnWidth(100),
                                              4: FixedColumnWidth(100),
                                              5: FixedColumnWidth(100),
                                              6: FixedColumnWidth(100)
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
                                      shipped();
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
            text: it["shipQty"],
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
        tableCell('Order Num'),
        tableCell('Order Line'),
        tableCell('Order Relase'),
        tableCell('Part Num'),
        tableCell('Order Qty'),
        tableCell('Ship Qty'),
        tableCell("Lot Num")
      ],
    ));

    for (int i = 0; i < items.length; i++) {
      var item = items[i];
      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color:
                item['isSelect'] ? AppColors.colorCyan300 : Colors.transparent,
          ),
          children: [
            tableCellRow(item["OrderHed_OrderNum"].toString()),
            tableCellRow(item["OrderRel_OrderLine"].toString()),
            tableCellRow(item["OrderRel_OrderRelNum"].toString()),
            tableCellRow(item["OrderRel_PartNum"]),
            tableCellRow(
              double.parse(item["OrderRel_OurReqQty"].toString())
                  .toStringAsFixed(2),
            ),
            item["isSelect"]
                ? TableCell(
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      height: 28,
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
                            left: 4,
                            bottom: 16,
                          ),
                          counterText: "",
                        ),
                        keyboardType: TextInputType.name,
                        onChanged: (val) {
                          items[i]["shipQty"] = val;
                          setState(() {});
                        },
                        autofocus: false,
                        readOnly: (item["prdTrack"] == "1" ||
                            item["prdTrack"] == "3"),
                      ),
                    ),
                  )
                : tableCellRow(item["shipQty"]),
            tableCellRow(item["scanLot"]),
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
            text: it["shipQty"],
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
            item["OrderRel_PartNum"].toString().toLowerCase() ==
            partNum.toLowerCase(),
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
          items[productIndex]["scanLot"] = partLot;
        }
        items[productIndex]["isSelect"] = true;
        items[productIndex]["shipQty"] =
            (int.parse(items[productIndex]["shipQty"]) + 1).toString();
        items[productIndex]["serials"].add({
          "num": serialNum,
          "lot": partLot,
          "qrType": qrType,
        });
        items[productIndex]["prdTrack"] = getType(prdDtl);
        itemQty[productIndex].text = items[productIndex]["shipQty"];
      }

      getWhere(partNum);
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

          double qTY = double.parse(item['shipQty'].toString());
          double rqTY = double.parse(item['OrderRel_OurReqQty'].toString());
          if (qTY <= 0) {
            throw Exception(
                "Invalid QTY at Orderline ${item["OrderRel_OrderLine"]}.");
          }
          if (qTY > rqTY) {
            throw Exception(
                "QTY cannot be grater than reqQty at Orderline ${item["OrderRel_OrderLine"]}.");
          }

          if (item["prdTrack"] == "1" || item["prdTrack"] == "3") {
            String lot = item["scanLot"] == "-" ? "" : item["scanLot"];
            for (var serialItem in item["serials"]) {
              if (serialItem["qrType"] == "A") {
                print("Call API A");
                var apia = await custShipServices.getSerialAvail(
                    item["OrderRel_PartNum"], txtWare.text, txtBin.text);
                var serialdata = apia["value"][0];
                printLargeString(json.encode(serialdata));
                lot = serialdata["SerialNo_LotNum"];
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
                  "PartNum": item["OrderRel_PartNum"],
                  "SerialNumber": serialItem["num"],
                  "SNStatus": "Inventory",
                  "SNReference": " Opening SerialNo",
                  "TransactionSource": "SNMaint",
                  "WareHouseCode": txtWare.text,
                  "BinNum": txtBin.text
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
                "PartNum": item["OrderRel_PartNum"],
                "SNPrefix": "",
                "SNBaseNumber": serial["num"],
                "XRefPartNum": "",
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
                    "PackLine": 0,
                    "OrderNum": txtOrdNum.text,
                    "OrderLine": item["OrderRel_OrderLine"],
                    "OrderRelNum": item["OrderRel_OrderRelNum"],
                    "PartNum": item["OrderRel_PartNum"],
                    "LineDesc": item["OrderDtl_LineDesc"],
                    "Plant": plant,
                    "BinNum": txtBin.text,
                    "LotNum": lot,
                    "WarehouseCode": txtWare.text,
                    "InventoryShipUOM": item["OrderDtl_IUM"],
                    "DisplayInvQty": item['shipQty'],
                    "SellingInventoryShipQty": item['shipQty'],
                    "SalesUM": item["OrderDtl_SalesUM"],
                    "IUM": item["OrderDtl_IUM"],
                    "TrackSerialNum": true,
                    "FromPlantTracking": true,
                    "ToPlantTracking": true,
                    "RowMod": "A"
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
                    "PackLine": 0,
                    "OrderNum": txtOrdNum.text,
                    "OrderLine": item["OrderRel_OrderLine"],
                    "OrderRelNum": item["OrderRel_OrderRelNum"],
                    "PartNum": item["OrderRel_PartNum"],
                    "LineDesc": item["OrderDtl_LineDesc"],
                    "Plant": plant,
                    "BinNum": txtBin.text,
                    "LotNum": lot, //item['scanLot'],
                    "WarehouseCode": txtWare.text,
                    "InventoryShipUOM": item["OrderDtl_IUM"],
                    "DisplayInvQty": item['shipQty'],
                    "SellingInventoryShipQty": item['shipQty'],
                    "SalesUM": item["OrderDtl_SalesUM"],
                    "IUM": item["OrderDtl_IUM"],
                    "RowMod": "A"
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
