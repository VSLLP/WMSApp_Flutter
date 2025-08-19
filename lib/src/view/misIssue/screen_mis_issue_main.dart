import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:http/http.dart';

class ScreenMisIssueMain extends StatefulWidget {
  const ScreenMisIssueMain({super.key});

  @override
  State<ScreenMisIssueMain> createState() => _ScreenMisIssueMainState();
}

class _ScreenMisIssueMainState extends State<ScreenMisIssueMain> {
  final formInit = GlobalKey<FormState>();
  final OverlayPortalController tooltipController = OverlayPortalController();

  var txtSearch = TextEditingController();
  var txtScan = TextEditingController();
  var txtWare = TextEditingController();
  var txtBin = TextEditingController();
  var txtQty = TextEditingController();
  var txtLotNum = TextEditingController();
  var txtReference = TextEditingController();
  var txtReason = TextEditingController();
  var txtDocType = TextEditingController();

  List<dynamic> suggestions = [];
  List<dynamic> whareHouses = [];
  List<dynamic> bins = [];
  List<dynamic> productItems = [];
  List<dynamic> lotNums = [];
  List<String> productSerials = [];
  List<dynamic> docTypes = [];
  List<dynamic> reasonItems = [];

  bool isLoading = true;
  bool isSearch = false;
  bool isScan = false;

  String company = "";
  String plant = "";
  String partNumber = "";
  String lotNum = "";
  String wareID = "";
  String docType = "";
  String reason = "";
  String prdType = "";

  int itemIndex = -1;

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
                            'Issue Miscellaneous Material',
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
                        Form(
                          key: formInit,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(
                                      "Product Search: ",
                                      style: TextStyles.getBold(
                                        14,
                                        color: AppColors.colorDataColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.54,
                                    child: OverlayPortal(
                                      controller: tooltipController,
                                      overlayChildBuilder:
                                          (BuildContext context) {
                                        return Positioned(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.54,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          top: 120,
                                          child: Material(
                                            elevation: 4.0,
                                            child: SizedBox(
                                              height: 400,
                                              child: ListView.builder(
                                                padding: EdgeInsets.zero,
                                                shrinkWrap: true,
                                                itemCount: suggestions.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    title: Text(
                                                        suggestions[index]
                                                            ['Part_PartNum']),
                                                    onTap: () async {
                                                      partNumber =
                                                          suggestions[index]
                                                              ['Part_PartNum'];
                                                      var resB =
                                                          await materialServices
                                                              .getGetPart(
                                                                  partNumber);
                                                      whareHouses.clear();
                                                      whareHouses =
                                                          resB['value'];
                                                      resetProduct();
                                                      isScan = true;
                                                      setState(() {
                                                        txtSearch.text =
                                                            suggestions[index][
                                                                'Part_PartNum'];
                                                        suggestions.clear();
                                                        tooltipController
                                                            .hide();
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: TextFormField(
                                        controller: txtSearch,
                                        style: TextStyles.getBold(12),
                                        decoration: InputDecoration(
                                          hintText: "Part number",
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
                                        readOnly: isSearch,
                                        autofocus: false,
                                        onChanged: (value) {
                                          getSuggestions(value);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                  setState(() {
                                                    txtScan.text == "";
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
                                                    color:
                                                        AppColors.colorGray600,
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
                                      readOnly: isScan,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.54,
                                    child: TextFormField(
                                      controller: txtWare,
                                      style: TextStyles.getBold(12),
                                      decoration: InputDecoration(
                                        hintText: "warehouse",
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
                                        if (partNumber.isNotEmpty) {
                                          choseOptions(
                                            "Warehouse",
                                            whareHouses,
                                          );
                                        }
                                      },
                                      autofocus: false,
                                      readOnly: true,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter warehouse.";
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(
                                      "Bin Num: ",
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
                                      controller: txtBin,
                                      style: TextStyles.getBold(12),
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
                                      keyboardType: TextInputType.name,
                                      onTap: () {
                                        if (txtWare.text.isNotEmpty) {
                                          choseOptions("Bin", bins);
                                        }
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
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.54,
                                    child: TextFormField(
                                      controller: txtQty,
                                      style: TextStyles.getBold(12),
                                      decoration: InputDecoration(
                                        hintText: "Quantity",
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
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          productItems[itemIndex]['QTY'] =
                                              double.parse(value);
                                        }
                                      },
                                      keyboardType: TextInputType.number,
                                      autofocus: false,
                                      readOnly: !isScan,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(
                                      "lotNum: ",
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
                                      controller: txtLotNum,
                                      style: TextStyles.getBold(12),
                                      decoration: InputDecoration(
                                        hintText: "lot number",
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
                                        if (prdType == "2" || prdType == "4") {
                                          choseOptions("lotnum", lotNums);
                                        }
                                      },
                                      autofocus: false,
                                      readOnly: true,
                                      validator: (value) {
                                        if (value!.isEmpty && isSearch) {
                                          return "Please enter lot number.";
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(
                                      "Reference: ",
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
                                      controller: txtReference,
                                      style: TextStyles.getBold(12),
                                      decoration: InputDecoration(
                                        hintText: "Reference",
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
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.54,
                                    child: TextFormField(
                                      controller: txtReason,
                                      style: TextStyles.getBold(12),
                                      decoration: InputDecoration(
                                        hintText: "Reason",
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
                                        choseOptions("Reason", reasonItems);
                                      },
                                      autofocus: false,
                                      readOnly: true,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter reason.";
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(
                                      "Transaction Doc Type: ",
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
                                      controller: txtDocType,
                                      style: TextStyles.getBold(12),
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
                                      keyboardType: TextInputType.name,
                                      onTap: () {
                                        choseOptions("DocType", docTypes);
                                      },
                                      autofocus: false,
                                      readOnly: true,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Please enter document type.";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                                      'Issue',
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
                                          0: FixedColumnWidth(300),
                                          1: FixedColumnWidth(100),
                                          2: FixedColumnWidth(100),
                                          3: FixedColumnWidth(100),
                                          4: FixedColumnWidth(100),
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
    company = await sharedPref.getString("userCompnay");
    plant = await sharedPref.getString("userPlant");

    var resA = await materialServices.getDocTypeB();
    docTypes.clear();
    docTypes = resA['value'];

    var resB = await materialServices.getResons();
    reasonItems.clear();
    reasonItems = resB['value'];

    setState(() {
      isLoading = false;
    });
  }

  void getSuggestions(String query) async {
    if (query.length >= 2) {
      setState(() {
        isLoading = true;
      });
      var res = await materialServices.getSearchPart(query);
      suggestions = res['value'];
      setState(() {
        isLoading = false;
      });
      tooltipController.show();
    } else {
      tooltipController.hide();
      isScan = false;
    }
  }

  getBins(String val) async {
    setState(() {
      isLoading = true;
    });
    var response = await materialServices.getGetPartBin(partNumber, val);
    bins.clear();
    bins = response['value'];
    setState(() {
      isLoading = false;
    });
    txtBin.text = bins[0]["WhseBin_BinNum"].toString();
  }

  resetProduct() {
    productItems.clear();
    productSerials.clear();
    lotNums.clear();
    txtSearch.text = "";
    txtWare.text = "";
    wareID = "";
    txtBin.text = "";
    txtReason.text = "";
    txtDocType.text = "";
    txtLotNum.text = "";
    prdType = "";
    lotNum = "";
    reason = "";
    docType = "";
    txtQty.text = "";
    txtReference.text = "";
    isSearch = false;
    isScan = false;
    itemIndex = -1;
    setState(() {});
  }

  getProducts() async {
    setState(() {
      isLoading = true;
    });
    var res = await materialServices.getProducts(
      partNumber,
      wareID,
      txtBin.text,
    );
    productItems.clear();
    lotNums.clear();
    productItems = res['value'];
    prdType = getType(productItems[0]);
    itemIndex = 0;
    if (productItems.isNotEmpty) {
      if (lotNum.isEmpty) {
        txtLotNum.text = productItems[itemIndex]["PartBin_LotNum"];
      } else {
        txtLotNum.text = lotNum;
      }
    }
    for (int i = 0; i < productItems.length; i++) {
      if (productItems[i]["PartBin_LotNum"] == txtLotNum.text) {
        productItems[i]['QTY'] = 1;
        itemIndex = i;
      } else {
        productItems[i]['QTY'] = 0;
      }
      lotNums.add(productItems[i]["PartBin_LotNum"]);
    }
    txtQty.text = productItems[itemIndex]['QTY'].toString();
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
      case "DocType":
        return option['TranDocType_Description'];
      case "Reason":
        return option['Reason_Description'];
      case "lotnum":
        return option;
      default:
        return "NA";
    }
  }

  updateOtp(String title, dynamic option) {
    switch (title) {
      case "Warehouse":
        txtWare.text = option["PartWhse_WarehouseCode"];
        wareID = option["PartWhse_WarehouseCode"];
        txtBin.text = "";
        getBins(option["PartWhse_WarehouseCode"]);
        if (productItems.isNotEmpty) {
          productItems.clear();
          productSerials.clear();
          lotNums.clear();
        }
        break;
      case "Bin":
        txtBin.text = option["WhseBin_BinNum"];
        productItems.clear();
        lotNums.clear();
        getProducts();
        break;
      case "lotnum":
        txtLotNum.text = option;
        itemIndex =
            productItems.indexWhere((ita) => ita['PartBin_LotNum'] == option);
        if (itemIndex == -1) {
          txtQty.text = "0";
        } else {
          txtQty.text = productItems[itemIndex]['QTY'].toString();
        }
        break;
      case "DocType":
        txtDocType.text = option['TranDocType_Description'];
        docType = option['TranDocType_TranDocTypeID'];
        break;
      case "Reason":
        txtReason.text = option['Reason_Description'];
        reason = option['Reason_ReasonCode'];
        break;
      default:
        return "NA";
    }
    setState(() {});
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
                                  updateOtp(title, options[index]);
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

  List<TableRow> getRows() {
    List<TableRow> rows = [];
    rows.add(TableRow(
      children: [
        tableCell('Product Disc'),
        tableCell('On Hand'),
        tableCell('UOM'),
        tableCell('Lot'),
        tableCell('Scan Qty'),
      ],
    ));
    for (int i = 0; i < productItems.length; i++) {
      var item = productItems[i];
      rows.add(
        TableRow(
          children: [
            tableCellRow(
              "${item["PartBin_PartNum"].toString()}\n${item["Part_PartDescription"].toString()}",
            ),
            tableCellRow(
              double.parse(item["PartBin_OnhandQty"]).toStringAsFixed(2),
            ),
            tableCellRow(item["Part_IUM"].toString()),
            tableCellRow(item["PartBin_LotNum"].toString()),
            tableCellRow(
              double.parse(item["QTY"].toString()).toStringAsFixed(2),
            ),
          ],
        ),
      );
    }
    return rows;
  }

  getPartAsync(String val) async {
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

      String partNum = words[1].replaceAll("Part Code - ", '');
      lotNum = words[4].replaceAll("Lot No. -", '');
      if (lotNum.isNotEmpty) {
        lotNum = lotNum.replaceAll(" ", '');
      }

      String serialNum = words[5].replaceAll("Serial No. - ", '');

      if (partNumber.isEmpty) {
        partNumber = partNum;
        setState(() {
          isLoading = true;
        });

        var resB = await materialServices.getGetPart(partNumber);
        whareHouses.clear();
        whareHouses = resB['value'];
        var items = resB['value'];
        for (var item in items) {
          txtWare.text = item["PartPlant_PrimWhse"].toString();
          wareID = item["PartPlant_PrimWhse"].toString();
        }
        getBins(wareID);
        productSerials.add(serialNum);
      } else {
        int itmIndex = productSerials.indexOf(serialNum);
        if (itmIndex == -1) {
          if (partNum != partNumber) {
            throw Exception("Please scan same part number.");
          } else {
            productItems[itemIndex]['QTY'] = productItems[itemIndex]['QTY'] + 1;
            productSerials.add(serialNum);
            txtQty.text = productSerials.length.toString();
          }
        } else {
          throw Exception("Items scaned already.");
        }
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

  submit() async {
    try {
      if (formInit.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });

        if (productItems.isEmpty) {
          throw Exception("Please scan atleast one item.");
        }

        DateTime customDate = DateTime.now();
        String formattedDate = "${customDate.year.toString().padLeft(4, '0')}-"
            "${customDate.month.toString().padLeft(2, '0')}-"
            "${customDate.day.toString().padLeft(2, '0')}T"
            "00:00:00+05:30";

        var body = {};

        switch (prdType) {
          case "1":
            var resA = await materialServices.getLegalNumber(docType);
            bool isLeagal = resA['value'].length != 0;
            var leagalNumer = {};
            if (isLeagal) {
              leagalNumer = resA['value'][0];
            }

            var selectedSerialNumbers = [];
            for (var srItem in productSerials) {
              selectedSerialNumbers.add({
                "Company": company,
                "SerialNumber": srItem,
                "PartNum": partNumber,
                "TransType": txtDocType.text,
                "NotSavedToDB": true,
                "RowMod": "A"
              });
            }

            body = {
              "plNegQtyAction": true,
              "ds": {
                "IssueReturn": [
                  {
                    "Company": company,
                    "TranDate": formattedDate,
                    "PartNum": partNumber,
                    "TranQty": productItems[itemIndex]['QTY'],
                    "DimCode": productItems[itemIndex]['Part_IUM'],
                    "LotNum": txtLotNum.text,
                    "ReasonCode": reason,
                    "FromWarehouseCode": wareID,
                    "FromBinNum": txtBin.text,
                    "OnHandQty": productItems[itemIndex]['PartBin_OnhandQty'],
                    "IssuedComplete": true,
                    "ReasonType": txtReason.text,
                    "TranType": "STK-UKN",
                    "DimConvFactor": "1",
                    "UM": productItems[itemIndex]['Part_IUM'],
                    "FromJobPlant": "UK90",
                    "ToJobPlant": "UK90",
                    "RequirementUOM": productItems[itemIndex]['Part_IUM'],
                    "RequirementQty": productItems[itemIndex]['QTY'],
                    "EnableSN": true,
                    "TranReference": txtReference.text,
                    "SerialControlPlant": "UK90",
                    "SerialControlPlantIsFromPlt": true,
                    "OnHandUM": productItems[itemIndex]['Part_IUM'],
                    "TranDocTypeID": docType,
                    "Plant": plant,
                    "PartPartDescription": productItems[itemIndex]
                        ['Part_PartDescription'],
                    "RowMod": "U"
                  }
                ],
                "LegalNumGenOpts": [
                  {
                    "Company": company,
                    "LegalNumberID": "INVTRF",
                    "TransYear": 2024,
                    "TransYearSuffix": "24-25",
                    "DspTransYear": "202424-25",
                    "ShowDspTransYear": true,
                    "Prefix":
                        isLeagal ? leagalNumer['LegalNumPrefix_Prefix'] : "",
                    "NumberOption": "System",
                    "DocumentDate": formattedDate,
                    "GenerationType": "system",
                    "Description": "Warehouse to Warehouse Transfer",
                    "TransPeriod": 1,
                    "ShowTransPeriod": true,
                    "TranDocTypeID": isLeagal
                        ? leagalNumer['TranDocType_TranDocTypeID']
                        : "",
                    "TranDocTypeID2": isLeagal
                        ? leagalNumer['TranDocType_TranDocTypeID']
                        : "",
                    "GenerationOption": "Save",
                    "SysRowID": "00000000-0000-0000-0000-000000000000",
                    "RowMod": "A"
                  }
                ],
                "SelectedSerialNumbers": selectedSerialNumbers,
                "SNFormat": [],
                "ExtensionTables": []
              }
            };
            break;
          case "2":
            body = {
              "plNegQtyAction": true,
              "ds": {
                "IssueReturn": [
                  {
                    "Company": company,
                    "TranDate": formattedDate,
                    "PartNum": partNumber,
                    "TranQty": productItems[itemIndex]['QTY'],
                    "DimCode": productItems[itemIndex]['Part_IUM'],
                    "LotNum": txtLotNum.text,
                    "ReasonCode": reason,
                    "FromWarehouseCode": wareID,
                    "FromBinNum": txtBin.text,
                    "OnHandQty": productItems[itemIndex]['PartBin_OnhandQty'],
                    "IssuedComplete": true,
                    "ReasonType": txtReason.text,
                    "TranType": "STK-UKN",
                    "DimConvFactor": "1",
                    "UM": productItems[itemIndex]['Part_IUM'],
                    "FromJobPlant": "UK90",
                    "ToJobPlant": "UK90",
                    "RequirementUOM": productItems[itemIndex]['Part_IUM'],
                    "RequirementQty": "1",
                    "EnableSN": false,
                    "TranReference": txtReference.text,
                    "OnHandUM": productItems[itemIndex]['Part_IUM'],
                    "TranDocTypeID": docType,
                    "Plant": plant,
                    "PartPartDescription": productItems[itemIndex]
                        ['Part_PartDescription'],
                    "RowMod": "U"
                  }
                ]
              }
            };
            break;
          case "3":
            var resA = await materialServices.getLegalNumber(docType);
            bool isLeagal = resA['value'].length != 0;
            var leagalNumer = {};
            if (isLeagal) {
              leagalNumer = resA['value'][0];
            }

            var selectedSerialNumbers = [];
            for (var srItem in productSerials) {
              selectedSerialNumbers.add({
                "Company": company,
                "SerialNumber": srItem,
                "PartNum": partNumber,
                "TransType": txtDocType.text,
                "NotSavedToDB": true,
                "RowMod": "A"
              });
            }

            body = {
              "plNegQtyAction": true,
              "ds": {
                "IssueReturn": [
                  {
                    "Company": company,
                    "TranDate": formattedDate,
                    "PartNum": partNumber,
                    "TranQty": productItems[itemIndex]['QTY'],
                    "DimCode": productItems[itemIndex]['Part_IUM'],
                    "LotNum": txtLotNum.text,
                    "ReasonCode": reason,
                    "FromWarehouseCode": wareID,
                    "FromBinNum": txtBin.text,
                    "OnHandQty": productItems[itemIndex]['PartBin_OnhandQty'],
                    "IssuedComplete": true,
                    "ReasonType": txtReason.text,
                    "TranType": "STK-UKN",
                    "DimConvFactor": "1",
                    "UM": productItems[itemIndex]['Part_IUM'],
                    "FromJobPlant": "UK90",
                    "ToJobPlant": "UK90",
                    "RequirementUOM": productItems[itemIndex]['Part_IUM'],
                    "RequirementQty": productItems[itemIndex]['QTY'],
                    "EnableSN": true,
                    "TranReference": txtReference.text,
                    "SerialControlPlant": "UK90",
                    "SerialControlPlantIsFromPlt": true,
                    "OnHandUM": productItems[itemIndex]['Part_IUM'],
                    "TranDocTypeID": docType,
                    "Plant": plant,
                    "PartPartDescription": productItems[itemIndex]
                        ['Part_PartDescription'],
                    "RowMod": "U"
                  }
                ],
                "LegalNumGenOpts": [
                  {
                    "Company": company,
                    "LegalNumberID": "INVTRF",
                    "TransYear": 2024,
                    "TransYearSuffix": "24-25",
                    "DspTransYear": "202424-25",
                    "ShowDspTransYear": true,
                    "Prefix":
                        isLeagal ? leagalNumer['LegalNumPrefix_Prefix'] : "",
                    "NumberOption": "System",
                    "DocumentDate": formattedDate,
                    "GenerationType": "system",
                    "Description": "Warehouse to Warehouse Transfer",
                    "TransPeriod": 1,
                    "ShowTransPeriod": true,
                    "TranDocTypeID": isLeagal
                        ? leagalNumer['TranDocType_TranDocTypeID']
                        : "",
                    "TranDocTypeID2": isLeagal
                        ? leagalNumer['TranDocType_TranDocTypeID']
                        : "",
                    "GenerationOption": "Save",
                    "SysRowID": "00000000-0000-0000-0000-000000000000",
                    "RowMod": "A"
                  }
                ],
                "SelectedSerialNumbers": selectedSerialNumbers,
                "SNFormat": [],
                "ExtensionTables": []
              }
            };
            break;
          case "4":
            var resA = await materialServices.getLegalNumber(docType);
            bool isLeagal = resA['value'].length != 0;
            var leagalNumer = {};
            if (isLeagal) {
              leagalNumer = resA['value'][0];
            }

            var selectedSerialNumbers = [];
            for (var srItem in productSerials) {
              selectedSerialNumbers.add({
                "Company": company,
                "SerialNumber": srItem,
                "PartNum": partNumber,
                "TransType": txtDocType.text,
                "NotSavedToDB": true,
                "RowMod": "A"
              });
            }

            body = {
              "plNegQtyAction": true,
              "ds": {
                "IssueReturn": [
                  {
                    "Company": company,
                    "TranDate": formattedDate,
                    "PartNum": partNumber,
                    "TranQty": productItems[itemIndex]['QTY'],
                    "DimCode": productItems[itemIndex]['Part_IUM'],
                    "LotNum": txtLotNum.text,
                    "ReasonCode": reason,
                    "FromWarehouseCode": wareID,
                    "FromBinNum": txtBin.text,
                    "OnHandQty": productItems[itemIndex]['PartBin_OnhandQty'],
                    "IssuedComplete": true,
                    "ReasonType": txtReason.text,
                    "TranType": "STK-UKN",
                    "DimConvFactor": "1",
                    "UM": productItems[itemIndex]['Part_IUM'],
                    "FromJobPlant": "UK90",
                    "ToJobPlant": "UK90",
                    "RequirementUOM": productItems[itemIndex]['Part_IUM'],
                    "RequirementQty": productItems[itemIndex]['QTY'],
                    "EnableSN": false,
                    "TranReference": txtReference.text,
                    "SerialControlPlant": "UK90",
                    "SerialControlPlantIsFromPlt": true,
                    "OnHandUM": productItems[itemIndex]['Part_IUM'],
                    "TranDocTypeID": docType,
                    "Plant": plant,
                    "PartPartDescription": productItems[itemIndex]
                        ['Part_PartDescription'],
                    "RowMod": "U"
                  }
                ],
                "LegalNumGenOpts": [
                  {
                    "Company": company,
                    "LegalNumberID": "INVTRF",
                    "TransYear": 2024,
                    "TransYearSuffix": "24-25",
                    "DspTransYear": "202424-25",
                    "ShowDspTransYear": true,
                    "Prefix":
                        isLeagal ? leagalNumer['LegalNumPrefix_Prefix'] : "",
                    "NumberOption": "System",
                    "DocumentDate": formattedDate,
                    "GenerationType": "system",
                    "Description": "Warehouse to Warehouse Transfer",
                    "TransPeriod": 1,
                    "ShowTransPeriod": true,
                    "TranDocTypeID": isLeagal
                        ? leagalNumer['TranDocType_TranDocTypeID']
                        : "",
                    "TranDocTypeID2": isLeagal
                        ? leagalNumer['TranDocType_TranDocTypeID']
                        : "",
                    "GenerationOption": "Save",
                    "SysRowID": "00000000-0000-0000-0000-000000000000",
                    "RowMod": "A"
                  }
                ],
                "SelectedSerialNumbers": selectedSerialNumbers,
                "SNFormat": [],
                "ExtensionTables": []
              }
            };
            break;
        }

        printLargeString(json.encode(body));
        Response res = await materialServices.postIssueMaterialPost(body);
        if (res.statusCode == 200) {
          showSucess('Success: ', "Material issue successful for you job.");
        } else {
          showError(
            'Error',
            json.decode(res.body)['ErrorMessage'],
          );
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
                        resetProduct();
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
