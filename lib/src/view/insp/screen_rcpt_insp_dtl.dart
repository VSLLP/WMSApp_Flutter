import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:http/http.dart';

class ScreenRcptInspDtl extends StatefulWidget {
  final dynamic item;
  const ScreenRcptInspDtl({
    super.key,
    required this.item,
  });

  @override
  State<ScreenRcptInspDtl> createState() => _ScreenRcptInspDtlState();
}

class _ScreenRcptInspDtlState extends State<ScreenRcptInspDtl> {
  final _formInit = GlobalKey<FormState>();

  var txtLine = TextEditingController();
  var txtPartNum = TextEditingController();
  var txtInspectorId = TextEditingController();
  var txtQty = TextEditingController();
  var txtWarehousePass = TextEditingController();
  var txtBinPass = TextEditingController();
  var txtWarehouseFail = TextEditingController();
  var txtBinFail = TextEditingController();
  var txtDocPass = TextEditingController();
  var txtDocFail = TextEditingController();
  var txtReason = TextEditingController();
  var txtQtyPass = TextEditingController();
  var txtScanPass = TextEditingController();
  var txtQtyFail = TextEditingController();
  var txtScanFail = TextEditingController();

  Timer? debounce;

  List<dynamic> items = [];
  List<dynamic> inspectors = [];
  List<dynamic> serialItems = [];
  List<dynamic> serialMaps = [];
  List<dynamic> whareHouses = [];
  List<dynamic> bins = [];
  List<dynamic> docs = [];
  List<dynamic> reasons = [];

  dynamic selItems = {};

  String company = "";
  String plant = "";
  String poNum = "";
  String packSlip = "";
  String inspectrId = "";
  String warePID = "";
  String wareFID = "";
  String trnDocIdPass = "";
  String trnDocIdFail = "";
  String reasonCode = "";
  String lotNum = "";

  int passQty = 0;
  int failQty = 0;

  bool isLoading = true;
  bool isLot = false;

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
                            'Receipt Inspection Detail',
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
                  Form(
                    key: _formInit,
                    child: Expanded(
                      child: SizedBox(
                        child: ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "Po Num : ",
                                    style: TextStyles.getBold(
                                      18,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    poNum,
                                    style: TextStyles.getBold(
                                      18,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "Pack Slip : ",
                                    style: TextStyles.getRegularScund(
                                      14,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    packSlip,
                                    style: TextStyles.getBold(
                                      14,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    "Line : ",
                                    style: TextStyles.getRegularScund(
                                      14,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 100,
                                  child: TextFormField(
                                    controller: txtLine,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "line",
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
                                      choseOptions("Line", false, items);
                                    },
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select line";
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
                                    "Inspector ID: ",
                                    style: TextStyles.getRegularScund(
                                      14,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtInspectorId,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Inspector ID",
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
                                      choseOptions(
                                        "Inspector",
                                        false,
                                        inspectors,
                                      );
                                    },
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select inspector id";
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
                                    "Part Num: ",
                                    style: TextStyles.getRegularScund(
                                      14,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtPartNum,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Part Num",
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
                                        return "Please select part num";
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
                                    style: TextStyles.getRegularScund(
                                      14,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtQty,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
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
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please entry quantity";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 22,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "Passed",
                                    style: TextStyles.getBold(
                                      20,
                                      color: AppColors.colorBlack,
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
                                    "Warehouse : ",
                                    style: TextStyles.getRegularScund(
                                      14,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtWarehousePass,
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
                                      chooseWaereHouse(true);
                                    },
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select warehouse";
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
                                    "Bin Num : ",
                                    style: TextStyles.getRegularScund(
                                      14,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtBinPass,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Bin Num",
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
                                      chooseBin(true);
                                    },
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select bin num";
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
                                    "Tran Doc Type : ",
                                    style: TextStyles.getRegularScund(
                                      14,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtDocPass,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Tran Doc Type",
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
                                      choseOptions("TranDoc", true, docs);
                                    },
                                    autofocus: false,
                                    readOnly: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please select tran doc type";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
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
                                          style: TextStyles.getRegularScund(
                                            14,
                                            color: AppColors.colorBlack,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.54,
                                        child: TextFormField(
                                          controller: txtQtyPass,
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
                                          onChanged: (val) {
                                            if (val.isNotEmpty) {
                                              passQty = int.parse(val);
                                            }
                                            setState(() {});
                                          },
                                          keyboardType: TextInputType.number,
                                          autofocus: false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please entry quantity";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
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
                                            MediaQuery.of(context).size.width *
                                                0.54,
                                        child: TextFormField(
                                          controller: txtScanPass,
                                          style: TextStyles.getRegularScund(12),
                                          decoration: InputDecoration(
                                            hintText: "Scan Product",
                                            hintStyle:
                                                TextStyles.getRegularScund(
                                              14,
                                              color: AppColors.colorDataColor,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            suffixIcon: txtScanPass
                                                    .text.isNotEmpty
                                                ? GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        txtScanPass.text == "";
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
                                            if (debounce?.isActive ?? false) {
                                              debounce?.cancel();
                                            }
                                            debounce = Timer(
                                                const Duration(
                                                    milliseconds: 300), () {
                                              getPartAsync(val, true);
                                            });
                                          },
                                          keyboardType: TextInputType.multiline,
                                          autofocus: false,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text(
                                          "Pass Qty : $passQty",
                                          style: TextStyles.getBold(
                                            14,
                                            color: AppColors.colorDataColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 22,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  child: Text(
                                    "Failed",
                                    style: TextStyles.getBold(
                                      20,
                                      color: AppColors.colorBlack,
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
                                    "Warehouse : ",
                                    style: TextStyles.getRegularScund(
                                      14,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtWarehouseFail,
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
                                      chooseWaereHouse(false);
                                    },
                                    autofocus: false,
                                    readOnly: true,
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
                                    "Bin Num : ",
                                    style: TextStyles.getRegularScund(
                                      14,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtBinFail,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Bin Num",
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
                                      chooseBin(false);
                                    },
                                    autofocus: false,
                                    readOnly: true,
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
                                    "Reason : ",
                                    style: TextStyles.getRegularScund(
                                      14,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtReason,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
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
                                      choseOptions("Reason", false, reasons);
                                    },
                                    autofocus: false,
                                    readOnly: true,
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
                                    "Tran Doc Type : ",
                                    style: TextStyles.getRegularScund(
                                      14,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.54,
                                  child: TextFormField(
                                    controller: txtDocFail,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Tran Doc Type",
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
                                      choseOptions("TranDoc", false, docs);
                                    },
                                    autofocus: false,
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
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
                                          style: TextStyles.getRegularScund(
                                            14,
                                            color: AppColors.colorBlack,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.54,
                                        child: TextFormField(
                                          controller: txtQtyFail,
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
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          keyboardType: TextInputType.number,
                                          onChanged: (val) {
                                            if (val.isNotEmpty) {
                                              failQty = int.parse(val);
                                            }
                                            setState(() {});
                                          },
                                          autofocus: false,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return "Please entry quantity";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
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
                                            MediaQuery.of(context).size.width *
                                                0.54,
                                        child: TextFormField(
                                          controller: txtScanFail,
                                          style: TextStyles.getRegularScund(12),
                                          decoration: InputDecoration(
                                            hintText: "Scan Product",
                                            hintStyle:
                                                TextStyles.getRegularScund(
                                              14,
                                              color: AppColors.colorDataColor,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            suffixIcon: txtScanFail
                                                    .text.isNotEmpty
                                                ? GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        txtScanFail.text == "";
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
                                            if (debounce?.isActive ?? false) {
                                              debounce?.cancel();
                                            }
                                            debounce = Timer(
                                                const Duration(
                                                    milliseconds: 300), () {
                                              getPartAsync(val, false);
                                            });
                                          },
                                          keyboardType: TextInputType.name,
                                          autofocus: false,
                                          maxLines: 6,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text(
                                          "Failed Qty : $failQty",
                                          style: TextStyles.getBold(
                                            14,
                                            color: AppColors.colorDataColor,
                                          ),
                                        ),
                                      ),
                                    ],
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
                              height: 100,
                            ),
                          ],
                        ),
                      ),
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

    var resA = await isnpServices.getRcptDtl(widget.item['RcvHead_PackSlip']);
    items.clear();
    items = resA['value'];
    selItems = items[0];

    packSlip = selItems['RcvHead_PackSlip'];
    txtLine.text = selItems['RcvDtl_PackLine'].toString();
    txtPartNum.text = selItems['RcvDtl_PartNum'];

    var resB =
        await isnpServices.getInspectors(widget.item['RcvHead_PackSlip']);
    inspectors.clear();
    inspectors = resB['value'];

    txtQty.text = selItems['RcvDtl_OurQty'];
    txtWarehousePass.text = selItems['RcvDtl_WareHouseCode'];
    warePID = selItems['RcvDtl_WareHouseCode'];
    txtBinPass.text = selItems['RcvDtl_BinNum'];

    txtWarehouseFail.text = selItems['Calculated_DefaultRejectWarehouse'];
    wareFID = selItems['Calculated_DefaultRejectWarehouse'];
    txtBinFail.text = selItems['Calculated_DefaultRejectBin'];
    lotNum = selItems['RcvDtl_LotNum'];

    var resC = await isnpServices.getTransDoc();
    docs.clear();
    docs = resC['value'];
    txtDocPass.text = docs[0]['TranDocType_Description'];
    trnDocIdPass = docs[0]['TranDocType_TranDocTypeID'];

    var resD = await isnpServices.getRemark();
    reasons.clear();
    reasons = resD['value'];

    var resE = await isnpServices.getIsnpSerMap(packSlip, txtLine.text);
    serialMaps.clear();
    serialMaps = resE['value'];

    if (!selItems['Part_TrackSerialNum']) {
      isLot = true;
    } else {
      isLot = false;
    }

    txtQtyPass.text = '0';
    txtQtyFail.text = '0';

    serialItems.clear();

    poNum = widget.item["RcvHead_PONum"].toString();

    setState(() {
      isLoading = false;
    });
  }

  updateOtp(String title, dynamic option, bool itemType) {
    switch (title) {
      case "Inspector":
        txtInspectorId.text = option['Inspectr_Name'];
        inspectrId = option['Inspectr_InspectorID'];
        break;
      case "Line":
        refreshLine(option);
        break;
      case "Warehouse":
        if (itemType) {
          txtWarehousePass.text = option['Warehse_Description'];
          warePID = option['PartWhse_WarehouseCode'];
          txtBinPass.text = "";
        } else {
          txtWarehouseFail.text = option['Warehse_Description'];
          wareFID = option['PartWhse_WarehouseCode'];
          txtBinFail.text = "";
        }
        break;
      case "Bin":
        if (itemType) {
          txtBinPass.text = option['WhseBin_BinNum'];
        } else {
          txtBinFail.text = option['WhseBin_BinNum'];
        }
        break;
      case "TranDoc":
        if (itemType) {
          txtDocPass.text = option['TranDocType_Description'];
          trnDocIdPass = option['TranDocType_TranDocTypeID'];
        } else {
          txtDocFail.text = option['TranDocType_Description'];
          trnDocIdFail = option['TranDocType_TranDocTypeID'];
        }
        break;
      case "Reason":
        txtReason.text = option['Reason_Description'];
        reasonCode = option['Reason_ReasonCode'];
        break;
    }
    setState(() {});
  }

  getOptTitle(String title, dynamic option) {
    switch (title) {
      case "Inspector":
        return option['Inspectr_Name'];
      case "Line":
        return option['RcvDtl_PackLine'].toString();
      case "Warehouse":
        return option['Warehse_Description'];
      case "Bin":
        return option['WhseBin_BinNum'];
      case "TranDoc":
        return option['TranDocType_Description'];
      case "Reason":
        return option['Reason_Description'];
      default:
        return "NA";
    }
  }

  choseOptions(String title, bool itemType, List<dynamic> options) {
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
                                    itemType,
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

  refreshLine(dynamic item) async {
    setState(() {
      isLoading = true;
    });

    selItems = item;

    packSlip = selItems['RcvHead_PackSlip'];
    txtLine.text = selItems['RcvDtl_PackLine'].toString();
    txtPartNum.text = selItems['RcvDtl_PartNum'];

    txtQty.text = selItems['RcvDtl_OurQty'];
    txtWarehousePass.text = selItems['RcvDtl_WareHouseCode'];
    warePID = selItems['RcvDtl_WareHouseCode'];
    txtBinPass.text = selItems['RcvDtl_BinNum'];

    txtWarehouseFail.text = selItems['Calculated_DefaultRejectWarehouse'];
    wareFID = selItems['Calculated_DefaultRejectWarehouse'];
    txtBinFail.text = selItems['Calculated_DefaultRejectBin'];
    lotNum = selItems['RcvDtl_LotNum'];

    txtReason.text = "";
    reasonCode = "";

    txtDocFail.text = "";
    trnDocIdFail = "";

    if (!selItems['Part_TrackSerialNum']) {
      isLot = true;
    } else {
      isLot = false;
    }

    txtQtyPass.text = '0';
    txtQtyFail.text = '0';

    passQty = 0;
    failQty = 0;

    serialItems.clear();

    var resE = await isnpServices.getIsnpSerMap(packSlip, txtLine.text);
    serialMaps.clear();
    serialMaps = resE['value'];

    setState(() {
      isLoading = false;
    });
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

  chooseWaereHouse(bool type) async {
    setState(() {
      isLoading = true;
    });
    var resW = await isnpServices.getWareHouses(
      txtPartNum.text,
    );
    whareHouses.clear();
    whareHouses = resW['value'];
    setState(() {
      isLoading = false;
    });
    choseOptions("Warehouse", type, whareHouses);
  }

  chooseBin(bool type) async {
    setState(() {
      isLoading = true;
    });
    if (type) {
      if (txtWarehousePass.text == "null" || txtWarehousePass.text == "") {
        showError("Error", "Please select wharehouse first.");
      } else {
        var response = await isnpServices.getBins(
          txtPartNum.text,
          warePID,
        );
        bins.clear();
        bins = response['value'];
      }
    } else {
      if (txtWarehouseFail.text == "null" || txtWarehouseFail.text == "") {
        showError("Error", "Please select wharehouse first.");
      } else {
        var response = await isnpServices.getBins(
          txtPartNum.text,
          wareFID,
        );
        bins.clear();
        bins = response['value'];
      }
    }
    setState(() {
      isLoading = false;
    });
    choseOptions("Bin", type, bins);
  }

  getPartAsync(String val, bool scanType) async {
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

      String partNum =
          words[1].replaceAll("Part Code - ", '').replaceAll("~", "");
      String partLot = words[4]
          .replaceAll("Lot No. -", '')
          .replaceAll("~", "")
          .replaceAll(" ", "");
      String serialNum =
          words[5].replaceAll("Serial No. - ", '').replaceAll("~", "");

      lotNum = partLot;

      if (partNum == selItems['RcvDtl_PartNum']) {
        int productIndex = serialItems.indexWhere(
          (item) => item["SerialNumber"] == serialNum,
        );

        int itemIndex = serialMaps.indexWhere(
          (item) => item["SerialNo_SerialNumber"] == serialNum,
        );

        if (productIndex == -1) {
          var serItem = {
            "Company": company,
            "SerialNumber": serialNum,
            "Scrapped": false,
            "Voided": false,
            "PartNum": partNum,
            "SNBaseNumber": serialMaps[itemIndex]['SerialNo_SNBaseNumber'],
            "SourceRowID": serialMaps[itemIndex]['RcvDtl_SysRowID'],
            "TransType": "O",
            "PassedInspection": scanType,
            "Deselected": !scanType,
            "RawSerialNum": serialMaps[itemIndex]['SerialNo_RawSerialNum'],
            "PreventDeselect": false,
            "PreDeselected": false,
            "SNMask": serialMaps[itemIndex]['SerialNo_SNMask'],
            "NotSavedToDB": false,
            "SysRowID": serialMaps[itemIndex]['SerialNo_SysRowID'],
            "RowMod": "U"
          };
          serialItems.add(serItem);
          if (scanType) {
            passQty = passQty + 1;
          } else {
            failQty = failQty + 1;
          }
        } else {
          throw Exception("Searial number already scanned.");
        }
      } else {
        throw Exception("Please scan same part number.");
      }
    } catch (ex) {
      showError('Error', ex.toString());
    } finally {
      if (scanType) {
        txtScanPass.text = "";
      } else {
        txtScanFail.text = "";
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  submit() async {
    try {
      if (_formInit.currentState!.validate()) {
        double grnQTY = double.parse(selItems['RcvDtl_OurQty'].toString());
        String prdType = getType(selItems);
        double totalQTY =
            double.parse(passQty.toString()) + double.parse(failQty.toString());
        if (grnQTY == totalQTY) {
          setState(() {
            isLoading = true;
          });
          DateTime customDate = DateTime.now();
          String formattedDate =
              "${customDate.year.toString().padLeft(4, '0')}-"
              "${customDate.month.toString().padLeft(2, '0')}-"
              "${customDate.day.toString().padLeft(2, '0')}T"
              "00:00:00+05:30";
          var body = {};
          switch (prdType) {
            case "1":
              body = {
                "ds": {
                  "InspRcpt": [
                    {
                      "Company": company,
                      "VendorNum": selItems['Vendor_VendorNum'],
                      "PurPoint": selItems['Vendor_PurPoint'],
                      "PackSlip": selItems['RcvHead_PackSlip'],
                      "PackLine": int.parse(txtLine.text),
                      "Invoiced": false,
                      "PartNum": selItems['RcvDtl_PartNum'],
                      "WareHouseCode": serialMaps[0]['RcvDtl_WareHouseCode'],
                      "BinNum": serialMaps[0]['RcvDtl_BinNum'],
                      "OurQty": selItems['RcvDtl_OurQty'],
                      "IUM": serialMaps[0]['RcvDtl_IUM'],
                      "OurUnitCost": serialMaps[0]['RcvDtl_OurUnitCost'],
                      "PONum": serialMaps[0]['RcvDtl_PONum'],
                      "POLine": serialMaps[0]['RcvDtl_POLine'],
                      "PORelNum": serialMaps[0]['RcvDtl_PORelNum'],
                      "PartDescription": serialMaps[0]
                          ['RcvDtl_PartDescription'],
                      "RevisionNum": serialMaps[0]['RcvDtl_RevisionNum'],
                      "VendorQty": serialMaps[0]['RcvDtl_VendorQty'],
                      "VendorUnitCost": serialMaps[0]['RcvDtl_VendorUnitCost'],
                      "ReceiptType": serialMaps[0]['RcvDtl_ReceiptType'],
                      "ReceivedTo": serialMaps[0]['RcvDtl_ReceivedTo'],
                      "ReceivedComplete": serialMaps[0]
                          ['RcvDtl_ReceivedComplete'],
                      "IssuedComplete": serialMaps[0]['RcvDtl_IssuedComplete'],
                      "PUM": serialMaps[0]['RcvDtl_PUM'],
                      "CostPerCode": serialMaps[0]['RcvDtl_CostPerCode'],
                      "LotNum": lotNum,
                      "NumLabels": 1,
                      "DimConvFactor": serialMaps[0]['RcvDtl_DimConvFactor'],
                      "InspectionReq": serialMaps[0]['RcvDtl_InspectionReq'],
                      "InspectionPending": serialMaps[0]
                          ['RcvDtl_InspectionPending'],
                      "InspectorID": inspectrId,
                      "InspectedBy": inspectrId,
                      "InspectedDate": formattedDate,
                      "InspectedTime": 0,
                      "PassedQty": passQty,
                      "FailedQty": failQty,
                      "TotCostVariance": serialMaps[0]
                          ['RcvDtl_TotCostVariance'],
                      "NonConformnce": false,
                      "SysRowID": serialMaps[0]['RcvDtl_SysRowID'],
                      "DMRNum": 0,
                      "CreateCorAct": false,
                      "PassedMove": false,
                      "PassedIssueTo": "STK",
                      "PassedWarehouseCode": warePID,
                      "PassedBin": txtBinPass.text,
                      "PassedJobPartNum": selItems['RcvDtl_PartNum'],
                      "PassedJobPartDesc": serialMaps[0]
                          ['RcvDtl_PartDescription'],
                      "FailedMove": false,
                      "FailedWarehouseCode": wareFID,
                      "FailedBin": txtBinFail.text,
                      "FailedReasonCode": reasonCode,
                      "EnforceSerialNumCount": true,
                      "xID": serialMaps[0]['RcvDtl_SysRowID'],
                      "Plant": plant,
                      "DimOurQty": totalQTY,
                      "DimPassedQty": passQty,
                      "DimFailedQty": failQty,
                      "AcceptUM": serialMaps[0]['RcvDtl_IUM'],
                      "TranUOM": serialMaps[0]['RcvDtl_IUM'],
                      "TranQty": "1",
                      "InspDataRequired": false,
                      "InspDataEntered": true,
                      "Done": false,
                      "PassedTranDocTypeID": trnDocIdPass,
                      "FailedTranDocTypeID": trnDocIdFail,
                      "PartNumTrackDimension": serialMaps[0]
                          ['Part_TrackDimension'],
                      "PartNumIUM": serialMaps[0]['Part_IUM'],
                      "PartNumSellingFactor": serialMaps[0]
                          ['Part_SellingFactor'],
                      "PartNumSalesUM": serialMaps[0]['Part_SalesUM'],
                      "PartNumTrackLots": serialMaps[0]['Part_TrackLots'],
                      "PartNumPartDescription": serialMaps[0]
                          ['RcvDtl_PartDescription'],
                      "PartNumPricePerCode": serialMaps[0]['Part_PricePerCode'],
                      "PartNumTrackSerialNum": serialMaps[0]
                          ['Part_TrackSerialNum'],
                      "RowMod": "U"
                    }
                  ],
                  "SelectedSerialNumbers": serialItems,
                  "SNFormat": [
                    {
                      "Company": company,
                      "Plant": plant,
                      "PartNum": selItems['RcvDtl_PartNum'],
                      "SNMask": serialMaps[0]['SerialNo_SNMask'],
                      "SNBaseDataType": serialMaps[0]
                          ['SerialNo_SNBaseStructure'],
                      "HasSerialNumbers": false,
                      "PartPricePerCode": serialMaps[0]['Part_PricePerCode'],
                      "PartTrackLots": serialMaps[0]['Part_TrackLots'],
                      "PartTrackSerialNum": serialMaps[0]
                          ['Part_TrackSerialNum'],
                      "PartTrackDimension": serialMaps[0]
                          ['Part_TrackDimension'],
                      "PartSellingFactor": serialMaps[0]['Part_SellingFactor'],
                      "SerialMaskMaskType": serialMaps[0]
                          ['SerialMask_MaskType'],
                      "RowMod": ""
                    }
                  ]
                }
              };
              break;
            case "2":
              body = {
                "ds": {
                  "InspRcpt": [
                    {
                      "Company": company,
                      "VendorNum": selItems['Vendor_VendorNum'],
                      "PurPoint": selItems['Vendor_PurPoint'],
                      "PackSlip": selItems['RcvHead_PackSlip'],
                      "PackLine": int.parse(txtLine.text),
                      "Invoiced": false,
                      "PartNum": selItems['RcvDtl_PartNum'],
                      "WareHouseCode": selItems['RcvDtl_WareHouseCode'],
                      "BinNum": selItems['RcvDtl_BinNum'],
                      "OurQty": selItems['RcvDtl_OurQty'],
                      "IUM": selItems['Part_IUM'],
                      "OurUnitCost": selItems['RcvDtl_OurUnitCost'],
                      "PONum": selItems['RcvDtl_PONum'],
                      "POLine": selItems['RcvDtl_POLine'],
                      "PORelNum": selItems['RcvDtl_PORelNum'],
                      "PartDescription": selItems['RcvDtl_PartDescription'],
                      "RevisionNum": selItems['RcvDtl_RevisionNum'],
                      "VendorQty": selItems['RcvDtl_VendorQty'],
                      "VendorUnitCost": selItems['RcvDtl_VendorUnitCost'],
                      "ReceiptType": selItems['RcvDtl_ReceiptType'],
                      "ReceivedTo": selItems['RcvDtl_ReceivedTo'],
                      "ReceivedComplete": selItems['RcvDtl_ReceivedComplete'],
                      "IssuedComplete": selItems['RcvDtl_IssuedComplete'],
                      "PUM": selItems['RcvDtl_PUM'],
                      "CostPerCode": selItems['RcvDtl_CostPerCode'],
                      "LotNum": lotNum,
                      "NumLabels": 1,
                      "DimConvFactor": selItems['RcvDtl_DimConvFactor'],
                      "InspectionReq": selItems['RcvDtl_InspectionReq'],
                      "InspectionPending": selItems['RcvDtl_InspectionPending'],
                      "InspectorID": inspectrId,
                      "InspectedBy": inspectrId,
                      "InspectedDate": formattedDate,
                      "InspectedTime": 0,
                      "PassedQty": passQty,
                      "FailedQty": failQty,
                      // "TotCostVariance": selItems['RcvDtl_TotCostVariance'],
                      "NonConformnce": false,
                      "SysRowID": selItems['RcvDtl_SysRowID'],
                      "DMRNum": 0,
                      "CreateCorAct": false,
                      "PassedMove": false,
                      "PassedIssueTo": "STK",
                      "PassedWarehouseCode": warePID,
                      "PassedBin": txtBinPass.text,
                      // "PassedJobPartNum": selItems['RcvDtl_PartNum'],
                      // "PassedJobPartDesc": selItems['RcvDtl_PartDescription'],
                      "FailedMove": false,
                      "FailedWarehouseCode": wareFID,
                      "FailedBin": txtBinFail.text,
                      "FailedReasonCode": reasonCode,
                      // "EnforceSerialNumCount": true,
                      "xID": selItems['RcvDtl_SysRowID'],
                      "Plant": plant,
                      "DimOurQty": totalQTY,
                      "DimPassedQty": passQty,
                      "DimFailedQty": failQty,
                      "AcceptUM": selItems['RcvDtl_IUM'],
                      "TranUOM": selItems['RcvDtl_IUM'],
                      "TranQty": passQty,
                      "InspDataRequired": false,
                      "InspDataEntered": true,
                      "Done": false,
                      "PassedTranDocTypeID": trnDocIdPass,
                      "FailedTranDocTypeID": trnDocIdFail,
                      "PartNumTrackDimension": false,
                      "PartNumIUM": selItems['Part_IUM'],
                      "PartNumSellingFactor": selItems['Part_SellingFactor'],
                      "PartNumSalesUM": selItems['Part_SalesUM'],
                      "PartNumTrackLots": selItems['Part_TrackLots'],
                      "PartNumPartDescription":
                          selItems['RcvDtl_PartDescription'],
                      "PartNumPricePerCode": selItems['Part_PricePerCode'],
                      "PartNumTrackSerialNum": selItems['Part_TrackSerialNum'],
                      "RowMod": "U"
                    }
                  ]
                }
              };
              break;
            case "3":
              body = {
                "ds": {
                  "InspRcpt": [
                    {
                      "Company": company,
                      "VendorNum": selItems['Vendor_VendorNum'],
                      "PurPoint": selItems['Vendor_PurPoint'],
                      "PackSlip": selItems['RcvHead_PackSlip'],
                      "PackLine": int.parse(txtLine.text),
                      "Invoiced": false,
                      "PartNum": selItems['RcvDtl_PartNum'],
                      "WareHouseCode": serialMaps[0]['RcvDtl_WareHouseCode'],
                      "BinNum": serialMaps[0]['RcvDtl_BinNum'],
                      "OurQty": selItems['RcvDtl_OurQty'],
                      "IUM": serialMaps[0]['RcvDtl_IUM'],
                      "OurUnitCost": serialMaps[0]['RcvDtl_OurUnitCost'],
                      "PONum": serialMaps[0]['RcvDtl_PONum'],
                      "POLine": serialMaps[0]['RcvDtl_POLine'],
                      "PORelNum": serialMaps[0]['RcvDtl_PORelNum'],
                      "PartDescription": serialMaps[0]
                          ['RcvDtl_PartDescription'],
                      "RevisionNum": serialMaps[0]['RcvDtl_RevisionNum'],
                      "VendorQty": serialMaps[0]['RcvDtl_VendorQty'],
                      "VendorUnitCost": serialMaps[0]['RcvDtl_VendorUnitCost'],
                      "ReceiptType": serialMaps[0]['RcvDtl_ReceiptType'],
                      "ReceivedTo": serialMaps[0]['RcvDtl_ReceivedTo'],
                      "ReceivedComplete": serialMaps[0]
                          ['RcvDtl_ReceivedComplete'],
                      "IssuedComplete": serialMaps[0]['RcvDtl_IssuedComplete'],
                      "PUM": serialMaps[0]['RcvDtl_PUM'],
                      "CostPerCode": serialMaps[0]['RcvDtl_CostPerCode'],
                      "LotNum": "",
                      "NumLabels": 1,
                      "DimConvFactor": serialMaps[0]['RcvDtl_DimConvFactor'],
                      "InspectionReq": serialMaps[0]['RcvDtl_InspectionReq'],
                      "InspectionPending": serialMaps[0]
                          ['RcvDtl_InspectionPending'],
                      "InspectorID": inspectrId,
                      "InspectedBy": inspectrId,
                      "InspectedDate": formattedDate,
                      "InspectedTime": 0,
                      "PassedQty": passQty,
                      "FailedQty": failQty,
                      "TotCostVariance": serialMaps[0]
                          ['RcvDtl_TotCostVariance'],
                      "NonConformnce": false,
                      "SysRowID": serialMaps[0]['RcvDtl_SysRowID'],
                      "DMRNum": 0,
                      "CreateCorAct": false,
                      "PassedMove": false,
                      "PassedIssueTo": "STK",
                      "PassedWarehouseCode": warePID,
                      "PassedBin": txtBinPass.text,
                      "PassedJobPartNum": selItems['RcvDtl_PartNum'],
                      "PassedJobPartDesc": serialMaps[0]
                          ['RcvDtl_PartDescription'],
                      "FailedMove": false,
                      "FailedWarehouseCode": wareFID,
                      "FailedBin": txtBinFail.text,
                      "FailedReasonCode": reasonCode,
                      "EnforceSerialNumCount": true,
                      "xID": serialMaps[0]['RcvDtl_SysRowID'],
                      "Plant": plant,
                      "DimOurQty": totalQTY,
                      "DimPassedQty": passQty,
                      "DimFailedQty": failQty,
                      "AcceptUM": serialMaps[0]['RcvDtl_IUM'],
                      "TranUOM": serialMaps[0]['RcvDtl_IUM'],
                      "TranQty": "1",
                      "InspDataRequired": false,
                      "InspDataEntered": true,
                      "Done": false,
                      "PassedTranDocTypeID": trnDocIdPass,
                      "FailedTranDocTypeID": trnDocIdFail,
                      "PartNumTrackDimension": serialMaps[0]
                          ['Part_TrackDimension'],
                      "PartNumIUM": serialMaps[0]['Part_IUM'],
                      "PartNumSellingFactor": serialMaps[0]
                          ['Part_SellingFactor'],
                      "PartNumSalesUM": serialMaps[0]['Part_SalesUM'],
                      "PartNumTrackLots": serialMaps[0]['Part_TrackLots'],
                      "PartNumPartDescription": serialMaps[0]
                          ['RcvDtl_PartDescription'],
                      "PartNumPricePerCode": serialMaps[0]['Part_PricePerCode'],
                      "PartNumTrackSerialNum": serialMaps[0]
                          ['Part_TrackSerialNum'],
                      "RowMod": "U"
                    }
                  ],
                  "SelectedSerialNumbers": serialItems,
                  "SNFormat": [
                    {
                      "Company": company,
                      "Plant": plant,
                      "PartNum": selItems['RcvDtl_PartNum'],
                      "SNMask": serialMaps[0]['SerialNo_SNMask'],
                      "SNBaseDataType": serialMaps[0]
                          ['SerialNo_SNBaseStructure'],
                      "HasSerialNumbers": false,
                      "PartPricePerCode": serialMaps[0]['Part_PricePerCode'],
                      "PartTrackLots": serialMaps[0]['Part_TrackLots'],
                      "PartTrackSerialNum": serialMaps[0]
                          ['Part_TrackSerialNum'],
                      "PartTrackDimension": serialMaps[0]
                          ['Part_TrackDimension'],
                      "PartSellingFactor": serialMaps[0]['Part_SellingFactor'],
                      "SerialMaskMaskType": serialMaps[0]
                          ['SerialMask_MaskType'],
                      "RowMod": ""
                    }
                  ]
                }
              };
              break;
            case "4":
              body = {
                "ds": {
                  "InspRcpt": [
                    {
                      "Company": company,
                      "VendorNum": selItems['Vendor_VendorNum'],
                      "PurPoint": selItems['Vendor_PurPoint'],
                      "PackSlip": selItems['RcvHead_PackSlip'],
                      "PackLine": int.parse(txtLine.text),
                      "Invoiced": false,
                      "PartNum": selItems['RcvDtl_PartNum'],
                      "WareHouseCode": selItems['RcvDtl_WareHouseCode'],
                      "BinNum": selItems['RcvDtl_BinNum'],
                      "OurQty": selItems['RcvDtl_OurQty'],
                      "IUM": selItems['Part_IUM'],
                      "OurUnitCost": selItems['RcvDtl_OurUnitCost'],
                      "PONum": selItems['RcvDtl_PONum'],
                      "POLine": selItems['RcvDtl_POLine'],
                      "PORelNum": selItems['RcvDtl_PORelNum'],
                      "PartDescription": selItems['RcvDtl_PartDescription'],
                      "RevisionNum": selItems['RcvDtl_RevisionNum'],
                      "VendorQty": selItems['RcvDtl_VendorQty'],
                      "VendorUnitCost": selItems['RcvDtl_VendorUnitCost'],
                      "ReceiptType": selItems['RcvDtl_ReceiptType'],
                      "ReceivedTo": selItems['RcvDtl_ReceivedTo'],
                      "ReceivedComplete": selItems['RcvDtl_ReceivedComplete'],
                      "IssuedComplete": selItems['RcvDtl_IssuedComplete'],
                      "PUM": selItems['RcvDtl_PUM'],
                      "CostPerCode": selItems['RcvDtl_CostPerCode'],
                      "LotNum": lotNum,
                      "NumLabels": 1,
                      "DimConvFactor": selItems['RcvDtl_DimConvFactor'],
                      "InspectionReq": selItems['RcvDtl_InspectionReq'],
                      "InspectionPending": selItems['RcvDtl_InspectionPending'],
                      "InspectorID": inspectrId,
                      "InspectedBy": inspectrId,
                      "InspectedDate": formattedDate,
                      "InspectedTime": 0,
                      "PassedQty": passQty,
                      "FailedQty": failQty,
                      // "TotCostVariance": selItems['RcvDtl_TotCostVariance'],
                      "NonConformnce": false,
                      "SysRowID": selItems['RcvDtl_SysRowID'],
                      "DMRNum": 0,
                      "CreateCorAct": false,
                      "PassedMove": false,
                      "PassedIssueTo": "STK",
                      "PassedWarehouseCode": warePID,
                      "PassedBin": txtBinPass.text,
                      // "PassedJobPartNum": selItems['RcvDtl_PartNum'],
                      // "PassedJobPartDesc": selItems['RcvDtl_PartDescription'],
                      "FailedMove": false,
                      "FailedWarehouseCode": wareFID,
                      "FailedBin": txtBinFail.text,
                      "FailedReasonCode": reasonCode,
                      // "EnforceSerialNumCount": true,
                      "xID": selItems['RcvDtl_SysRowID'],
                      "Plant": plant,
                      "DimOurQty": totalQTY,
                      "DimPassedQty": passQty,
                      "DimFailedQty": failQty,
                      "AcceptUM": selItems['RcvDtl_IUM'],
                      "TranUOM": selItems['RcvDtl_IUM'],
                      "TranQty": passQty,
                      "InspDataRequired": false,
                      "InspDataEntered": true,
                      "Done": false,
                      "PassedTranDocTypeID": trnDocIdPass,
                      "FailedTranDocTypeID": trnDocIdFail,
                      "PartNumTrackDimension": false,
                      "PartNumIUM": selItems['Part_IUM'],
                      "PartNumSellingFactor": selItems['Part_SellingFactor'],
                      "PartNumSalesUM": selItems['Part_SalesUM'],
                      "PartNumTrackLots": selItems['Part_TrackLots'],
                      "PartNumPartDescription":
                          selItems['RcvDtl_PartDescription'],
                      "PartNumPricePerCode": selItems['Part_PricePerCode'],
                      "PartNumTrackSerialNum": selItems['Part_TrackSerialNum'],
                      "RowMod": "U"
                    }
                  ]
                }
              };
              break;
          }
          printLargeString(json.encode(body));
          Response res = await isnpServices.postIsnp(body);
          if (res.statusCode == 200) {
            showSucess(
              'Success: ',
              "Material inspection successful for your receipt.",
            );
          } else {
            showError(
              'Error',
              json.decode(res.body)['ErrorMessage'],
            );
          }
        } else {
          showError(
            'Error',
            "Total Pass QTY + Fail QTY Must be equal to GRN QTY.",
          );
        }
      }
    } catch (ex) {
      showError('', ex.toString());
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
