import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:http/http.dart';
import 'package:epicor/src/view/home/screen_qr_scan.dart';

class ScreenInvEntry extends StatefulWidget {
  final dynamic item;
  const ScreenInvEntry({
    super.key,
    required this.item,
  });

  @override
  State<ScreenInvEntry> createState() => _ScreenInvEntryState();
}

class _ScreenInvEntryState extends State<ScreenInvEntry> {
  List<dynamic> docTypes = [];
  List<dynamic> whareHouses = [];
  List<dynamic> bins = [];
  List<dynamic> serItems = [];

  dynamic jobDetails = {};
  dynamic productDetails = {};

  var txtScan = TextEditingController();
  var txtJobNo = TextEditingController();
  var txtPartNo = TextEditingController();
  var txtFWere = TextEditingController();
  var txtFBin = TextEditingController();
  var txtTWere = TextEditingController();
  var txtTBin = TextEditingController();
  var txtUom = TextEditingController();
  var txtDocType = TextEditingController();
  var txtQty = TextEditingController();

  String company = "";
  String plant = "";
  String userId = "";
  String wereTId = "";
  String wereFId = "";
  String prdType = "";

  bool isLoading = true;
  bool isSubmit = false;
  bool isScan = true;
  bool isLot = false;
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
                            'Job To Inventory',
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
                                                isScan = true;
                                                txtScan.text = "";
                                                txtTWere.text = "";
                                                wereTId = "";
                                                txtTBin.text = "";
                                                txtDocType.text = "";
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
                                    "Job No.: ",
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
                                    controller: txtJobNo,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Job No",
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
                                        return "Please enter job no.";
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
                                    "Part No.: ",
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
                                    controller: txtPartNo,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Part No.",
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
                                    readOnly: isScan,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter part no.";
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
                                    controller: txtFWere,
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
                                    onChanged: (val) {
                                      getBins(val);
                                    },
                                    onTap: () {
                                      if (!isScan) {
                                        choseWhae(true);
                                      }
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
                                    controller: txtFBin,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Bin",
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
                                      if (!isScan) {
                                        choseBin(true);
                                      }
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
                            isLot
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
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
                                            MediaQuery.of(context).size.width *
                                                0.54,
                                        child: TextFormField(
                                          controller: txtQty,
                                          style: TextStyles.getBold(
                                            12,
                                            color: AppColors.colorBlack,
                                          ),
                                          decoration: InputDecoration(
                                            hintText: "Quantity",
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
                                          autofocus: false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please select qty.";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
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
                                    onChanged: (val) {
                                      getBins(val);
                                    },
                                    onTap: () {
                                      if (!isScan) {
                                        choseWhae(false);
                                      }
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
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Bin",
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
                                      if (!isScan) {
                                        choseBin(false);
                                      }
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
                                    "Uom: ",
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
                                    controller: txtUom,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "UOM",
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
                                        return "Please enter UOM.";
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
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Document Type",
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
                                      if (!isScan) {
                                        choseDocType();
                                      }
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
                                        defaultColumnWidth:
                                            const FixedColumnWidth(150),
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
    plant = await sharedPref.getString("userPlant");
    userId = await sharedPref.getString("userName");
    isCam = await sharedPref.getBool("isCam");
    var response = await jobinvServices.getDocType();
    docTypes.clear();
    docTypes = response['value'];

    var resB = await jobinvServices.getWarehouseAsync();
    whareHouses.clear();
    whareHouses = resB['value'];

    await getBins(whareHouses[0]['Calculated_DefaultWarehouse']);

    var resC = await jobinvServices.getJobDetail(
      widget.item['JobHead_PartNum'],
      widget.item['JobHead_JobNum'],
    );
    jobDetails = resC['value'][0];

    txtJobNo.text = widget.item['JobHead_JobNum'];
    txtPartNo.text = widget.item['JobHead_PartNum'];
    txtUom.text = widget.item['JobHead_IUM'];
    txtFWere.text = whareHouses[0]['Warehse_Description'];
    wereFId = whareHouses[0]['Calculated_DefaultWarehouse'];
    txtFBin.text = bins[0]['Calculated_DefaultBinNum'];
    txtQty.text = "";

    setState(() {
      isLoading = false;
    });
  }

  getType(item) {
    if (item['Part_TrackLots'] && item['Part_TrackSerialNum']) {
      prdType = "1";
    }
    if (item['Part_TrackLots']) {
      prdType = "2";
    }
    if (item['Part_TrackSerialNum']) {
      prdType = "3";
    }
    if (!item['Part_TrackLots'] && !item['Part_TrackSerialNum']) {
      prdType = "4";
    }
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

      if (partCode != txtPartNo.text) {
        throw Exception("Please scan the same product.");
      }

      int productIndex = serItems.indexWhere(
        (item) => item["SerialNumber"] == partSerial,
      );

      if (productIndex == -1) {
        setState(() {
          isLoading = true;
        });

        var response = await jobinvServices.getPartAsync(txtJobNo.text);
        if (response == null) {
          throw Exception("No product found.");
        }
        productDetails = response['value'][0];

        if (!isScan) {
          if (productDetails['Part_TrackSerialNum'] && isLot) {
            throw Exception("Please scan the same product.");
          }
          if (!productDetails['Part_TrackSerialNum'] && !isLot) {
            throw Exception("Please scan the same product.");
          }
        }

        getType(productDetails);

        if (productDetails['Part_TrackSerialNum']) {
          isLot = false;
          serItems.add({
            "Company": company,
            "SerialNumber": partSerial,
            "LotNumber": partLot,
            "Scrapped": false,
            "Voided": false,
            "PartNum": widget.item['JobHead_PartNum'],
            "SNBaseNumber": partSerial
                .substring(partSerial.length - 7), //partSerial.substring(0, 9),
            "PassedInspection": false,
            "Deselected": false,
            "RawSerialNum": partSerial,
            "PreventDeselect": false,
            "PreDeselected": false,
            "SNMask": productDetails['Part_SNMask'],
            "NotSavedToDB": false,
            "RowMod": "A"
          });
        } else {
          isLot = true;
          serItems.add({
            "Company": company,
            "SerialNumber": partSerial,
            "LotNumber": partLot,
            "Scrapped": false,
            "Voided": false,
            "PartNum": widget.item['JobHead_PartNum'],
            "SNBaseNumber": partSerial
                .substring(partSerial.length - 7), //partSerial.substring(0, 9),
            "PassedInspection": false,
            "Deselected": false,
            "RawSerialNum": partSerial,
            "PreventDeselect": false,
            "PreDeselected": false,
            "SNMask": productDetails['Part_SNMask'],
            "NotSavedToDB": false,
            "RowMod": "A"
          });
        }
      } else {
        throw Exception("Product already scanned.");
      }
      isScan = false;
    } catch (ex) {
      showError('Error', ex.toString());
    } finally {
      txtScan.text = "";
      setState(() {
        isLoading = false;
      });
    }
  }

  getBins(String val) async {
    var response = await jobinvServices.getBinAsync(val);
    bins.clear();
    bins = response['value'];
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

  choseWhae(bool type) {
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
                  "Select Warehouse",
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
                            itemCount: whareHouses.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  if (type) {
                                    txtFWere.text = whareHouses[index]
                                        ["Warehse_Description"];
                                    wereFId = whareHouses[index]
                                        ["Warehse_WarehouseCode"];
                                  } else {
                                    txtTWere.text = whareHouses[index]
                                        ["Warehse_Description"];
                                    wereTId = whareHouses[index]
                                        ["Warehse_WarehouseCode"];
                                  }
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
                                        whareHouses[index]
                                            ["Warehse_Description"],
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

  choseBin(bool type) {
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
                                  if (type) {
                                    txtFBin.text =
                                        bins[index]["WhseBin_BinNum"];
                                  } else {
                                    txtTBin.text =
                                        bins[index]["WhseBin_BinNum"];
                                  }
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
                                        bins[index]["WhseBin_BinNum"],
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
      if (serItems.isEmpty) {
        throw Exception("Please scan atleast one product.");
      }
      DateTime customDate = DateTime.now();
      String formattedDate = "${customDate.year.toString().padLeft(4, '0')}-"
          "${customDate.month.toString().padLeft(2, '0')}-"
          "${customDate.day.toString().padLeft(2, '0')}T"
          "00:00:00+05:30";
      var body = {};
      switch (prdType) {
        case "1":
          body = {
            "ds": {
              "PartTran": [
                {
                  "Company": company,
                  "TranNum": 0,
                  "PartNum": widget.item['JobHead_PartNum'],
                  "WareHouseCode": wereFId,
                  "BinNum": txtFBin.text,
                  "TranClass": "R",
                  "TranType": "MFG-STK",
                  "InventoryTrans": true,
                  "TranDate": formattedDate,
                  "RevisionNum": productDetails['JobAsmbl_RevisionNum'],
                  "LotNum": serItems[0]['LotNumber'],
                  "EnableSerialNumbers": true,
                  "TranQty": serItems.length,
                  "UM": productDetails['Part_IUM'],
                  "CostMethod": productDetails['Part_CostMethod'],
                  "JobNum": widget.item['JobHead_JobNum'],
                  "AssemblySeq": productDetails['JobAsmbl_AssemblySeq'],
                  "JobSeqType": "M",
                  "WareHouse2": wereTId,
                  "BinNum2": txtTBin.text,
                  "EntryPerson": userId,
                  "PartDescription": productDetails['JobHead_PartDescription'],
                  "DimCode": "1",
                  "DimConvFactor2": "1",
                  "GLTrans": true,
                  "PostedToGL": false,
                  "Plant": productDetails['JobHead_Plant'],
                  "Plant2": productDetails['JobHead_Plant'],
                  "EmpID": "WMSEmp",
                  "CostID": productDetails['JobHead_Plant'],
                  "ActTranQty": serItems.length,
                  "ActTransUOM": productDetails['Part_IUM'],
                  "TranDocTypeID": txtDocType.text,
                  "QtyBearing": true,
                  "ThisTranQty": "1",
                  "PartNumSellingFactor": productDetails['Part_SellingFactor'],
                  "PartNumTrackSerialNum":
                      productDetails['Part_TrackSerialNum'],
                  "PartNumTrackDimension":
                      productDetails['Part_TrackDimension'],
                  "PartNumTrackLots": productDetails['Part_TrackLots'],
                  "PartNumIUM": productDetails['Part_IUM'],
                  "PartNumPartDescription":
                      productDetails['JobHead_PartDescription'],
                  "PartNumSalesUM": productDetails['Part_SalesUM'],
                  "PartNumPricePerCode": productDetails['Part_PricePerCode'],
                  "RowMod": "A"
                }
              ],
              "SelectedSerialNumbers": serItems,
              "SNFormat": [
                {
                  "Company": company,
                  "Plant": plant,
                  "PartNum": widget.item['JobHead_PartNum'],
                  "SNMask": productDetails['Part_SNMask'],
                  "SNBaseDataType": productDetails['Part_SNBaseDataType'],
                  "HasSerialNumbers": false,
                  "PartPricePerCode": productDetails['Part_PricePerCode'],
                  "PartTrackLots": productDetails['Part_TrackLots'],
                  "PartTrackSerialNum": productDetails['Part_TrackSerialNum'],
                  "PartTrackDimension": productDetails['Part_TrackDimension'],
                  "PartSalesUM": productDetails['Part_SalesUM'],
                  "PartIUM": productDetails['Part_IUM'],
                  "PartSellingFactor": productDetails['Part_SellingFactor'],
                  "PartPartDescription":
                      productDetails['JobHead_PartDescription'],
                  "SerialMaskMaskType": 1,
                  "SNFormat": productDetails['Part_SNFormat']
                }
              ]
            },
            "pdSerialNoQty": serItems.length,
            "plNegQtyAction": true,
            "pcProcessID": "RcptToInvEntry"
          };
          break;
        case "2":
          body = {
            "ds": {
              "PartTran": [
                {
                  "Company": company,
                  "TranNum": 0,
                  "PartNum": widget.item['JobHead_PartNum'],
                  "WareHouseCode": wereFId,
                  "BinNum": txtFBin.text,
                  "TranClass": "R",
                  "TranType": "MFG-STK",
                  "InventoryTrans": true,
                  "TranDate": formattedDate,
                  "RevisionNum": productDetails['JobAsmbl_RevisionNum'],
                  "LotNum": serItems[0]['LotNumber'],
                  "EnableSerialNumbers": false,
                  "TranQty": txtQty.text,
                  "UM": productDetails['Part_IUM'],
                  "CostMethod": productDetails['Part_CostMethod'],
                  "JobNum": widget.item['JobHead_JobNum'],
                  "AssemblySeq": productDetails['JobAsmbl_AssemblySeq'],
                  "JobSeqType": "M",
                  "WareHouse2": wereTId,
                  "BinNum2": txtTBin.text,
                  "EntryPerson": userId,
                  "PartDescription": productDetails['JobHead_PartDescription'],
                  "DimCode": "1",
                  "DimConvFactor2": "1",
                  "GLTrans": true,
                  "PostedToGL": false,
                  "Plant": productDetails['JobHead_Plant'],
                  "Plant2": productDetails['JobHead_Plant'],
                  "EmpID": "WMSEmp",
                  "CostID": productDetails['JobHead_Plant'],
                  "ActTranQty": txtQty.text,
                  "ActTransUOM": productDetails['Part_IUM'],
                  "BaseCostMethod": "A",
                  "TranDocTypeID": txtDocType.text,
                  "QtyBearing": true,
                  "QtyCompleted": "120",
                  "ThisTranQty": "1",
                  "PartNumSellingFactor": productDetails['Part_SellingFactor'],
                  "PartNumTrackSerialNum":
                      productDetails['Part_TrackSerialNum'],
                  "PartNumTrackDimension":
                      productDetails['Part_TrackDimension'],
                  "PartNumTrackLots": productDetails['Part_TrackLots'],
                  "PartNumIUM": productDetails['Part_IUM'],
                  "PartNumPartDescription":
                      productDetails['JobHead_PartDescription'],
                  "PartNumSalesUM": productDetails['Part_SalesUM'],
                  "PartNumPricePerCode": productDetails['Part_PricePerCode'],
                  "RowMod": "A"
                }
              ]
            },
            "pdSerialNoQty": txtQty.text,
            "plNegQtyAction": true,
            "pcProcessID": "RcptToInvEntry"
          };
          break;
        case "3":
          body = {
            "ds": {
              "PartTran": [
                {
                  "Company": company,
                  "TranNum": 0,
                  "PartNum": widget.item['JobHead_PartNum'],
                  "WareHouseCode": wereFId,
                  "BinNum": txtFBin.text,
                  "TranClass": "R",
                  "TranType": "MFG-STK",
                  "InventoryTrans": true,
                  "TranDate": formattedDate,
                  "RevisionNum": productDetails['JobAsmbl_RevisionNum'],
                  "LotNum": serItems[0]['LotNumber'],
                  "EnableSerialNumbers": true,
                  "TranQty": serItems.length,
                  "UM": productDetails['Part_IUM'],
                  "CostMethod": productDetails['Part_CostMethod'],
                  "JobNum": widget.item['JobHead_JobNum'],
                  "AssemblySeq": productDetails['JobAsmbl_AssemblySeq'],
                  "JobSeqType": "M",
                  "WareHouse2": wereTId,
                  "BinNum2": txtTBin.text,
                  "EntryPerson": userId,
                  "PartDescription": productDetails['JobHead_PartDescription'],
                  "DimCode": "1",
                  "DimConvFactor2": "1",
                  "GLTrans": true,
                  "PostedToGL": false,
                  "Plant": productDetails['JobHead_Plant'],
                  "Plant2": productDetails['JobHead_Plant'],
                  "EmpID": "WMSEmp",
                  "CostID": productDetails['JobHead_Plant'],
                  "ActTranQty": serItems.length,
                  "ActTransUOM": productDetails['Part_IUM'],
                  "TranDocTypeID": txtDocType.text,
                  "QtyBearing": true,
                  "ThisTranQty": "1",
                  "PartNumSellingFactor": productDetails['Part_SellingFactor'],
                  "PartNumTrackSerialNum":
                      productDetails['Part_TrackSerialNum'],
                  "PartNumTrackDimension":
                      productDetails['Part_TrackDimension'],
                  "PartNumTrackLots": productDetails['Part_TrackLots'],
                  "PartNumIUM": productDetails['Part_IUM'],
                  "PartNumPartDescription":
                      productDetails['JobHead_PartDescription'],
                  "PartNumSalesUM": productDetails['Part_SalesUM'],
                  "PartNumPricePerCode": productDetails['Part_PricePerCode'],
                  "RowMod": "A"
                }
              ],
              "SelectedSerialNumbers": serItems,
              "SNFormat": [
                {
                  "Company": company,
                  "Plant": plant,
                  "PartNum": widget.item['JobHead_PartNum'],
                  "SNMask": productDetails['Part_SNMask'],
                  "SNBaseDataType": productDetails['Part_SNBaseDataType'],
                  "HasSerialNumbers": false,
                  "PartPricePerCode": productDetails['Part_PricePerCode'],
                  "PartTrackLots": productDetails['Part_TrackLots'],
                  "PartTrackSerialNum": productDetails['Part_TrackSerialNum'],
                  "PartTrackDimension": productDetails['Part_TrackDimension'],
                  "PartSalesUM": productDetails['Part_SalesUM'],
                  "PartIUM": productDetails['Part_IUM'],
                  "PartSellingFactor": productDetails['Part_SellingFactor'],
                  "PartPartDescription":
                      productDetails['JobHead_PartDescription'],
                  "SerialMaskMaskType": 1,
                  "SNFormat": productDetails['Part_SNFormat']
                }
              ]
            },
            "pdSerialNoQty": serItems.length,
            "plNegQtyAction": true,
            "pcProcessID": "RcptToInvEntry"
          };
          break;
        case "4":
          body = {
            "ds": {
              "PartTran": [
                {
                  "Company": company,
                  "TranNum": 0,
                  "PartNum": widget.item['JobHead_PartNum'],
                  "WareHouseCode": wereFId,
                  "BinNum": txtFBin.text,
                  "TranClass": "R",
                  "TranType": "MFG-STK",
                  "InventoryTrans": true,
                  "TranDate": formattedDate,
                  "RevisionNum": productDetails['JobAsmbl_RevisionNum'],
                  "LotNum": serItems[0]['LotNumber'],
                  "EnableSerialNumbers": true,
                  "TranQty": serItems.length,
                  "UM": productDetails['Part_IUM'],
                  "CostMethod": productDetails['Part_CostMethod'],
                  "JobNum": widget.item['JobHead_JobNum'],
                  "AssemblySeq": productDetails['JobAsmbl_AssemblySeq'],
                  "JobSeqType": "M",
                  "WareHouse2": wereTId,
                  "BinNum2": txtTBin.text,
                  "EntryPerson": userId,
                  "PartDescription": productDetails['JobHead_PartDescription'],
                  "DimCode": "1",
                  "DimConvFactor2": "1",
                  "GLTrans": true,
                  "PostedToGL": false,
                  "Plant": productDetails['JobHead_Plant'],
                  "Plant2": productDetails['JobHead_Plant'],
                  "EmpID": "WMSEmp",
                  "CostID": productDetails['JobHead_Plant'],
                  "ActTranQty": serItems.length,
                  "ActTransUOM": productDetails['Part_IUM'],
                  "TranDocTypeID": txtDocType.text,
                  "QtyBearing": true,
                  "ThisTranQty": "1",
                  "PartNumSellingFactor": productDetails['Part_SellingFactor'],
                  "PartNumTrackSerialNum":
                      productDetails['Part_TrackSerialNum'],
                  "PartNumTrackDimension":
                      productDetails['Part_TrackDimension'],
                  "PartNumTrackLots": productDetails['Part_TrackLots'],
                  "PartNumIUM": productDetails['Part_IUM'],
                  "PartNumPartDescription":
                      productDetails['JobHead_PartDescription'],
                  "PartNumSalesUM": productDetails['Part_SalesUM'],
                  "PartNumPricePerCode": productDetails['Part_PricePerCode'],
                  "RowMod": "A"
                }
              ],
              "SelectedSerialNumbers": serItems,
              "SNFormat": [
                {
                  "Company": company,
                  "Plant": plant,
                  "PartNum": widget.item['JobHead_PartNum'],
                  "SNMask": productDetails['Part_SNMask'],
                  "SNBaseDataType": productDetails['Part_SNBaseDataType'],
                  "HasSerialNumbers": false,
                  "PartPricePerCode": productDetails['Part_PricePerCode'],
                  "PartTrackLots": productDetails['Part_TrackLots'],
                  "PartTrackSerialNum": productDetails['Part_TrackSerialNum'],
                  "PartTrackDimension": productDetails['Part_TrackDimension'],
                  "PartSalesUM": productDetails['Part_SalesUM'],
                  "PartIUM": productDetails['Part_IUM'],
                  "PartSellingFactor": productDetails['Part_SellingFactor'],
                  "PartPartDescription":
                      productDetails['JobHead_PartDescription'],
                  "SerialMaskMaskType": 1,
                  "SNFormat": productDetails['Part_SNFormat']
                }
              ]
            },
            "pdSerialNoQty": serItems.length,
            "plNegQtyAction": true,
            "pcProcessID": "RcptToInvEntry"
          };
          break;
      }
      printLargeString(json.encode(body));
      Response res = await jobinvServices.postJobToInvSerial(body);
      if (res.statusCode == 200) {
        showSuccess(
          'Success',
          "Job to inventory submitted successfully!",
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
      txtScan.text = "";
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
                        reset();
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

  reset() {
    serItems.clear();
    isScan = true;
    jobDetails = {};
    productDetails = {};
    txtTWere.text = "";
    wereTId = "";
    txtTBin.text = "";
    txtDocType.text = "";
    txtQty.text = "";
  }

  List<TableRow> getRows() {
    List<TableRow> rows = [];
    rows.add(TableRow(
      children: [
        tableCell('Product'),
        tableCell('Bin'),
        tableCell('Adj Qty'),
        tableCell('Description'),
        tableCell('UOM'),
        isLot ? tableCell('Lot') : tableCell('Serial'),
      ],
    ));
    for (var item in serItems) {
      rows.add(
        TableRow(
          children: [
            tableCellRow(widget.item['JobHead_PartNum']),
            tableCellRow(txtFBin.text),
            tableCellRow(jobDetails['JobHead_QtyCompleted']),
            tableCellRow(productDetails['JobHead_PartDescription']),
            tableCellRow(productDetails['Part_IUM']),
            isLot
                ? tableCellRow(item["LotNumber"])
                : tableCellRow(item["SerialNumber"]),
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

  void printLargeString(String text) {
    const int chunkSize = 800;
    for (int i = 0; i < text.length; i += chunkSize) {
      debugPrint(text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
  }
}
