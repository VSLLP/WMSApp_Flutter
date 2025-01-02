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
                                          autofocus: false,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    "Inspection: ",
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorDataColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  color: Colors.transparent,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        checkColor: AppColors.colorWhite,
                                        activeColor: AppColors.colorAssent,
                                        value: isInsp,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            isInsp = value ?? false;
                                          });
                                          getCheangeInsp();
                                        },
                                      ),
                                    ],
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
                                              1: FixedColumnWidth(60),
                                              2: FixedColumnWidth(100),
                                              3: FixedColumnWidth(120),
                                              4: FixedColumnWidth(90),
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
      ],
    ));
    for (int i = 0; i < productItems.length; i++) {
      var item = productItems[i];
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

  getPartAsync(val) async {
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

      String partCode = words[1].replaceAll("Part Code - ", '');
      String partLot = words[4].replaceAll("Lot No. -", '').replaceAll(" ", "");
      String partSerial = words[5].replaceAll("Serial No. - ", '');

      int itemIndex =
          productItems.indexWhere((item) => item['Part_PartNum'] == partCode);

      if (itemIndex == -1) {
        throw Exception("Please scan valid product in PO.");
      } else {
        productItems[itemIndex]['isSelect'] = true;
        String prdType = getType(productItems[itemIndex]);

        partNum = partCode;
        txtQty.text = productItems[itemIndex]['ScanQty'].toString();
        qty = productItems[itemIndex]['ScanQty'];

        setState(() {
          isLoading = true;
        });

        switch (prdType) {
          case '1':
            productItems[itemIndex]['lotNum'] = partLot;

            var resA = await utilServices.getSerialMapping(partCode);
            var payload = resA['value'][0];

            int seIndex = srItems
                .indexWhere((item) => item['SerialNumber'] == partSerial);

            if (seIndex != -1) {
              throw Exception("Product already scanned.");
            }

            srItems.add({
              "Company": company,
              "SerialNumber": partSerial,
              "PartNum": partCode,
              "SNBaseNumber": partSerial.substring(0, 15),
              "TransType": "PUR-STK",
              "RawSerialNum": partSerial,
              "SNMask": payload['Part_SNMask'],
              "RowMod": "A"
            });

            qty = srItems.where((item) => item["PartNum"] == partCode).length;
            txtQty.text = qty.toString();
            productItems[itemIndex]['ScanQty'] = qty;

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
          case '2':
            productItems[itemIndex]['lotNum'] = partLot;
            break;
          case '3':
            var resA = await utilServices.getSerialMapping(partCode);
            var payload = resA['value'][0];
            productItems[itemIndex]['lotNum'] = "";

            int seIndex = srItems
                .indexWhere((item) => item['SerialNumber'] == partSerial);

            if (seIndex != -1) {
              throw Exception("Product already scanned.");
            }

            srItems.add({
              "Company": company,
              "SerialNumber": partSerial,
              "PartNum": partCode,
              "SNBaseNumber": partSerial.substring(0, 15),
              "TransType": "PUR-STK",
              "RawSerialNum": partSerial,
              "SNMask": payload['Part_SNMask'],
              "RowMod": "A"
            });

            qty = srItems.where((item) => item["PartNum"] == partCode).length;
            txtQty.text = qty.toString();
            productItems[itemIndex]['ScanQty'] = qty;

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
          case '4':
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

  submit() async {
    try {
      setState(() {
        isLoading = true;
      });
      DateTime customDate = DateTime.now();
      String formattedDate = "${customDate.year.toString().padLeft(4, '0')}-"
          "${customDate.month.toString().padLeft(2, '0')}-"
          "${customDate.day.toString().padLeft(2, '0')}T"
          "00:00:00+05:30";
      int index = 0;
      bool isSubmit = false;
      for (var item in productItems) {
        if (item['ScanQty'] > 0) {
          isSubmit = true;
          if (txtWare.text.isEmpty) {
            showError("Error",
                "Please select wherehouse for part: ${item['Part_PartNum']}");
            isSubmit = false;
            break;
          }
          if (txtBin.text.isEmpty) {
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
                  "WareHouseCode": wherId,
                  "BinNum": txtBin.text,
                  "OurQty": item['ScanQty'],
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
                  "InputOurQty": item['ScanQty'],
                  "Plant": plant,
                  "ThisTranUOM": item['PODetail_IUM'],
                  "TranType": "PUR-STK",
                  "PartNumPricePerCode": item['Part_PricePerCode'],
                  "PartNumSellingFactor":
                      double.parse(item['Part_SellingFactor']),
                  "RowMod": "A",
                  "InspectionReq": isInsp,
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
        }
        index = index + 1;
      }
      if (isSubmit) {
        showError('Success', 'GRN entry submitted successfully!');
        loadData();
        txtQty.text = "";
        txtScan.text = "";
        txtWare.text = "";
        txtBin.text = "";
        isInsp = false;
        isLot = false;
        qty = 0;
      }
    } catch (ex) {
      showError('Error', "Server error occurred!");
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

  void printLargeString(String text) {
    const int chunkSize = 800;
    for (int i = 0; i < text.length; i += chunkSize) {
      // Print the string in chunks
      debugPrint(text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
  }
}
