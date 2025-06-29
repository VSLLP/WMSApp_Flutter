import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:http/http.dart';

class ScreenIssueMtlEntry extends StatefulWidget {
  final dynamic item;
  const ScreenIssueMtlEntry({
    super.key,
    required this.item,
  });

  @override
  State<ScreenIssueMtlEntry> createState() => _ScreenIssueMtlEntryState();
}

class _ScreenIssueMtlEntryState extends State<ScreenIssueMtlEntry> {
  final _formInit = GlobalKey<FormState>();

  var txtJobNo = TextEditingController();
  var txtPartNo = TextEditingController();
  var txtAsem = TextEditingController();
  var txtMtlSeq = TextEditingController();
  var txtTWere = TextEditingController();
  var txtTBin = TextEditingController();

  var txtFPartNo = TextEditingController();
  var txtPartDesc = TextEditingController();
  var txtQty = TextEditingController();
  var txtFWere = TextEditingController();
  var txtFBin = TextEditingController();
  var txtTransDoc = TextEditingController();
  var txtScanPart = TextEditingController();
  var txtLotNum = TextEditingController();

  List<dynamic> assems = [];
  List<dynamic> mtlSeqs = [];
  List<dynamic> docTypes = [];
  List<dynamic> whareHouses = [];
  List<dynamic> bins = [];
  List<dynamic> items = [];
  List<dynamic> serItems = [];
  List<dynamic> lotNums = [];

  String company = "";
  String plant = "";
  String txtReqQty = "";
  String txtPreIssu = "";
  String txtIUM = "";
  String docType = "";
  String selAssems = "";
  String selMtl = "";
  String wereTID = "";
  String wereFID = "";
  String prdType = "";
  String lotNum = "";
  String pricePerCode = "";
  String sellingFactor = "";

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
                            'Issue Material Details',
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
                  Form(
                    key: _formInit,
                    child: Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Text(
                            "To",
                            style: TextStyles.getBold(
                              16,
                              color: AppColors.colorBlack,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  "Job No.: ",
                                  style: TextStyles.getRegularScund(
                                    14,
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.54,
                                child: TextFormField(
                                  controller: txtJobNo,
                                  style: TextStyles.getBold(
                                    12,
                                    color: AppColors.colorBlack,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Job No.",
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
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  "Part No.: ",
                                  style: TextStyles.getRegularScund(
                                    14,
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.54,
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
                                    contentPadding: const EdgeInsets.symmetric(
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
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  "Assembly: ",
                                  style: TextStyles.getRegularScund(
                                    14,
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.54,
                                child: TextFormField(
                                  controller: txtAsem,
                                  style: TextStyles.getBold(
                                    12,
                                    color: AppColors.colorBlack,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Assembly",
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
                                  keyboardType: TextInputType.name,
                                  autofocus: false,
                                  readOnly: true,
                                  onTap: () {
                                    choseOptions("Assembly", assems);
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please select assembly.";
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
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  "MtlSeq: ",
                                  style: TextStyles.getRegularScund(
                                    14,
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.54,
                                child: TextFormField(
                                  controller: txtMtlSeq,
                                  style: TextStyles.getBold(
                                    12,
                                    color: AppColors.colorBlack,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "MtlSeq",
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
                                  keyboardType: TextInputType.name,
                                  autofocus: false,
                                  readOnly: true,
                                  // onTap: () {
                                  //   choseOptions("MtlSeq", mtlSeqs);
                                  // },
                                  onTap: () async {
                                    choseOptions("MtlSeq", mtlSeqs)
                                        .then((selectedValue) {
                                      if (selectedValue != null) {
                                        handleMtlSeqChange(
                                            selectedValue.toString());
                                      }
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please select mtl seq.";
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
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  "Warehouse: ",
                                  style: TextStyles.getRegularScund(
                                    14,
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.54,
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 0,
                                    ),
                                    counterText: "",
                                  ),
                                  keyboardType: TextInputType.name,
                                  autofocus: false,
                                  readOnly: true,
                                  onTap: () async {
                                    choseOptions("Warehouse", whareHouses);
                                  },
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
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  "Bin no: ",
                                  style: TextStyles.getRegularScund(
                                    14,
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.54,
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 0,
                                    ),
                                    counterText: "",
                                  ),
                                  keyboardType: TextInputType.name,
                                  autofocus: false,
                                  readOnly: true,
                                  onTap: () {
                                    choseOptions("Bin", bins);
                                  },
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
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "From",
                            style: TextStyles.getBold(
                              16,
                              color: AppColors.colorBlack,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  "Part No.: ",
                                  style: TextStyles.getRegularScund(
                                    14,
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.54,
                                child: TextFormField(
                                  controller: txtFPartNo,
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
                                    contentPadding: const EdgeInsets.symmetric(
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
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  "Part Description: ",
                                  style: TextStyles.getRegularScund(
                                    14,
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.54,
                                child: TextFormField(
                                  controller: txtPartDesc,
                                  style: TextStyles.getBold(
                                    12,
                                    color: AppColors.colorBlack,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Part Description.",
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
                                  keyboardType: TextInputType.name,
                                  autofocus: false,
                                  readOnly: true,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter part description.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Row(
                                  children: [
                                    Text(
                                      "Req Qty: ",
                                      style: TextStyles.getRegularScund(
                                        14,
                                        color: AppColors.colorBlack,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        txtReqQty,
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorBlack,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Row(
                                  children: [
                                    Text(
                                      "Pre Issued: ",
                                      style: TextStyles.getRegularScund(
                                        14,
                                        color: AppColors.colorBlack,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      child: Text(
                                        txtPreIssu,
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorBlack,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          isLot
                              ? Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Quantity: ",
                                            style: TextStyles.getRegularScund(
                                              14,
                                              color: AppColors.colorBlack,
                                            ),
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              controller: txtQty,
                                              style: TextStyles.getBold(
                                                12,
                                                color: AppColors.colorBlack,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: "Qty.",
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
                                              keyboardType:
                                                  TextInputType.number,
                                              autofocus: false,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Please enter qty.";
                                                }
                                                return null;
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      child: Row(
                                        children: [
                                          Text(
                                            "UOM: ",
                                            style: TextStyles.getRegularScund(
                                              14,
                                              color: AppColors.colorBlack,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              txtIUM,
                                              style: TextStyles.getBold(
                                                14,
                                                color: AppColors.colorBlack,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          isLot
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: AppColors.colorBlue300,
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(16),
                                              topRight: Radius.circular(2),
                                              bottomLeft: Radius.circular(2),
                                              bottomRight: Radius.circular(16),
                                            ),
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: TextFormField(
                                            controller: txtScanPart,
                                            style: TextStyles.getRegularScund(
                                              12,
                                            ),
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
                                              suffixIcon: txtScanPart
                                                      .text.isNotEmpty
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          txtScanPart.text ==
                                                              "";
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
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text(
                                            "Qty : ${serItems.length}",
                                            style: TextStyles.getBold(
                                              14,
                                              color: AppColors.colorDataColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "UOM: ",
                                          style: TextStyles.getRegularScund(
                                            14,
                                            color: AppColors.colorBlack,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: Text(
                                            txtIUM,
                                            style: TextStyles.getBold(
                                              14,
                                              color: AppColors.colorBlack,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                          const SizedBox(
                            height: 14,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  "Warehouse: ",
                                  style: TextStyles.getRegularScund(
                                    14,
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.54,
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 0,
                                    ),
                                    counterText: "",
                                  ),
                                  keyboardType: TextInputType.name,
                                  autofocus: false,
                                  readOnly: true,
                                  onTap: () {
                                    choseOptions("From Warehouse", whareHouses);
                                  },
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  "Bin no: ",
                                  style: TextStyles.getRegularScund(
                                    14,
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.54,
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
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 0,
                                    ),
                                    counterText: "",
                                  ),
                                  keyboardType: TextInputType.name,
                                  autofocus: false,
                                  readOnly: true,
                                  onTap: () {
                                    choseOptions("From Bin", bins);
                                  },
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
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        "Lot Num: ",
                                        style: TextStyles.getRegularScund(
                                          14,
                                          color: AppColors.colorBlack,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.54,
                                      child: TextFormField(
                                        controller: txtLotNum,
                                        style: TextStyles.getBold(
                                          12,
                                          color: AppColors.colorBlack,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: "Lot Num",
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
                                        onTap: () {
                                          choseOptions("Lot Number", lotNums);
                                        },
                                        validator: (value) {
                                          if (prdType == "2") {
                                            if (value!.isEmpty) {
                                              return "Please select lot number.";
                                            }
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
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: Text(
                                  "Tran Doc Type: ",
                                  style: TextStyles.getRegularScund(
                                    14,
                                    color: AppColors.colorBlack,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.54,
                                child: TextFormField(
                                  controller: txtTransDoc,
                                  style: TextStyles.getBold(
                                    12,
                                    color: AppColors.colorBlack,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "Doc Type",
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
                                  keyboardType: TextInputType.name,
                                  autofocus: false,
                                  readOnly: true,
                                  onTap: () {
                                    choseOptions("Doc Type", docTypes);
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter doc type.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
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

    var response = await materialServices.getIssueMaterialDetail(
      widget.item['JobHead_JobNum'],
    );
    items = response['value'];
    assems.clear();
    mtlSeqs.clear();
    for (var item in items) {
      if (!assems.contains(item['JobAsmbl_AssemblySeq'])) {
        assems.add({
          'value': item['JobAsmbl_AssemblySeq'],
          'lable':
              '${item['JobAsmbl_AssemblySeq']}-${item['JobAsmbl_PartNum']}-${item['JobAsmbl_Description']}'
        });
      }
      if (!mtlSeqs.contains(item['JobMtl_MtlSeq'])) {
        mtlSeqs.add({
          'value': item['JobMtl_MtlSeq'],
          'lable':
              '${item['JobMtl_MtlSeq']}-${item['JobMtl_PartNum']}-${item['JobMtl_Description']}'
        });
      }
    }

    var resA = await materialServices.getDocType(
      widget.item['JobHead_PartNum'],
    );
    docTypes.clear();
    docTypes = resA['value'];

    var resB = await materialServices.getGetPart(
      widget.item['JobHead_PartNum'],
    );
    whareHouses.clear();
    whareHouses = resB['value'];

    await getBins(whareHouses[0]['PartWhse_WarehouseCode']);

    txtJobNo.text = widget.item['JobHead_JobNum'];
    txtPartNo.text = widget.item['JobHead_PartNum'];

    txtAsem.text = assems[0]['value'].toString();
    selAssems = assems[0]['value'].toString();

    txtMtlSeq.text = mtlSeqs[0]['value'].toString();
    selMtl = mtlSeqs[0]['value'].toString();

    handleMtlSeqChange(mtlSeqs[0]['value'].toString());

    /*

    var selectedItem = items.firstWhere(
        (item) => item['JobMtl_MtlSeq'].toString() == selMtl,
        orElse: () => null);

    if (selectedItem != null) {
      // Get products and update lot numbers
      var res = await materialServices.getProducts(
        widget.item['JobHead_PartNum'],
        selectedItem['Calculated_DefaultFromWarehouse'],
        selectedItem['Calculated_DefaultFrombin'],
      );

      List<dynamic> tempItems = res['value'];
      lotNums.clear();

      for (var item in tempItems) {
        if (item["PartBin_LotNum"] != "") {
          lotNums.add(item["PartBin_LotNum"]);
        }
      }

      if (lotNums.isNotEmpty && prdType == "2") {
        lotNum = lotNums[0];
        txtLotNum.text = lotNums[0];
      }
    }
*/

    txtTWere.text = items[0]['Calculated_DefaultToWarehouse'];
    wereTID = items[0]['Calculated_DefaultToWarehouse'];
    txtTBin.text = items[0]['Calculated_DefaultToBin'];

    txtFWere.text = items[0]['Calculated_DefaultFromWarehouse'];
    wereFID = items[0]['Calculated_DefaultFromWarehouse'];
    txtFBin.text = items[0]['Calculated_DefaultFrombin'];

    var res = await materialServices.getProducts(
      widget.item['JobHead_PartNum'],
      items[0]['Calculated_DefaultFromWarehouse'],
      items[0]['Calculated_DefaultFrombin'],
    );
    // print(res);
    List<dynamic> tempItems = res['value'];
    lotNums.clear();

    for (int i = 0; i < tempItems.length; i++) {
      if (tempItems[i]["PartBin_LotNum"] != "") {
        lotNums.add(tempItems[i]["PartBin_LotNum"]);
        // print(lotNum);
      }
    }
    // print(tempItems);

    if (lotNums.isNotEmpty && prdType == "2") {
      lotNum = lotNums[0];
      txtLotNum.text = lotNums[0];
    } else {
      lotNum = "";
      txtLotNum.text = "";
    }

    txtFPartNo.text = items[0]['JobMtl_PartNum'];
    txtPartDesc.text = items[0]['JobMtl_Description'];

    txtReqQty = double.parse(items[0]['JobMtl_RequiredQty'].toString())
        .toStringAsFixed(2);
    txtPreIssu = double.parse(items[0]['JobMtl_IssuedQty'].toString())
        .toStringAsFixed(2);
    txtIUM = items[0]['JobMtl_IUM'];
    txtQty.text = '0';

    await updateLotNumbers();

    serItems.clear();
    getType(items[0]);
    pricePerCode = items[0]['Part_PricePerCode'];
    sellingFactor = items[0]['Part_SellingFactor'];

    if (items[0]['Part_TrackSerialNum']) {
      isLot = false;
    } else {
      isLot = true;
    }

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

  getBins(String val) async {
    var response = await materialServices.getGetPartBin(
        widget.item['JobHead_PartNum'], val);
    bins.clear();
    bins = response['value'];
  }

  Future<void> updateLotNumbers() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Get the current part number - make sure to use the correct one
      String currentPartNum = txtFPartNo.text;

      // Only proceed if we have all required data
      if (currentPartNum.isEmpty || txtFWere.text.isEmpty) {
        return;
      }

      // Get products for the current warehouse and bin
      var res = await materialServices.getProducts(
        currentPartNum,
        txtFWere.text,
        txtFBin.text.isEmpty ? "" : txtFBin.text, // Make bin optional
      );

      if (res['value'] != null) {
        List<dynamic> tempItems = res['value'];

        setState(() {
          lotNums.clear();
          // Update lot numbers list
          for (var item in tempItems) {
            if (item["PartBin_LotNum"] != null &&
                item["PartBin_LotNum"].toString().isNotEmpty) {
              lotNums.add(item["PartBin_LotNum"]);
            }
          }

          // Update the lot number field if needed
          if (lotNums.isNotEmpty && prdType == "2") {
            lotNum = lotNums[0];
            txtLotNum.text = lotNums[0];
          } else {
            lotNum = "";
            txtLotNum.text = "";
          }
        });
      }
    } catch (ex) {
      showError('Error', 'Failed to update lot numbers: ${ex.toString()}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  updateOtp(String title, dynamic option) async {
    switch (title) {
      case "Assembly":
        txtAsem.text = option['value'].toString();
        selAssems = option['value'].toString();
        serItems.clear();
        break;
      case "MtlSeq":
        txtMtlSeq.text = option['value'].toString();
        selMtl = option['value'].toString();
        for (var item in items) {
          if (item['JobMtl_MtlSeq'] == option['value']) {
            txtFPartNo.text = item['JobMtl_PartNum'];
            txtPartDesc.text = item['JobMtl_Description'];
            txtReqQty = double.parse(item['JobMtl_RequiredQty'].toString())
                .toStringAsFixed(2);
            txtPreIssu = double.parse(item['JobMtl_IssuedQty'].toString())
                .toStringAsFixed(2);
            txtQty.text = '0';
            var res = await materialServices.getProducts(
              item['JobMtl_PartNum'],
              items[0]['Calculated_DefaultFromWarehouse'],
              items[0]['Calculated_DefaultFrombin'],
            );
            List<dynamic> tempItems = res['value'];
            lotNums.clear();

            for (int i = 0; i < tempItems.length; i++) {
              if (tempItems[i]["PartBin_LotNum"] != "") {
                lotNums.add(tempItems[i]["PartBin_LotNum"]);
              }
            }

            if (lotNums.isNotEmpty && prdType == "2") {
              lotNum = lotNums[0];
              txtLotNum.text = lotNums[0];
            } else {
              lotNum = "";
              txtLotNum.text = "";
            }

            txtIUM = item['JobMtl_IUM'];
            getType(item);
            pricePerCode = items[0]['Part_PricePerCode'];
            sellingFactor = items[0]['Part_SellingFactor'];
            serItems.clear();
            if (item['Part_TrackSerialNum']) {
              isLot = false;
            } else {
              isLot = true;
            }
            break;
          }
        }
      // case "Warehouse":
      //   txtTWere.text = option['Warehse_Description'];
      //   wereTID = option['PartWhse_WarehouseCode'];
      //   getBins(option['PartWhse_WarehouseCode']);
      //   txtTBin.text = "";
      //   break;
      // case "From Warehouse":
      //   txtFWere.text = option['Warehse_Description'];
      //   wereFID = option['PartWhse_WarehouseCode'];
      //   getBins(option['PartWhse_WarehouseCode']);
      //   txtFBin.text = "";
      case "From Warehouse":
        setState(() {
          txtFWere.text = option['Warehse_Description'];
          wereFID = option['PartWhse_WarehouseCode'];
          // print(txtFWere.text);
          // print(wereFID);
        });

        // First update bins
        await getBins(option['PartWhse_WarehouseCode']);

        // Clear the bin selection since warehouse changed
        txtFBin.text = "";

        // Then update lot numbers with current context
        await updateLotNumbers();
        break;
      // case "From Bin":
      //   txtFBin.text = option['WhseBin_BinNum'];
      //   // Add this: Update lot numbers when bin changes
      //   await updateLotNumbers();
      //   break;
      case "Bin":
        setState(() {
          txtFBin.text = option['WhseBin_BinNum'];
        });
        await updateLotNumbers();
        break;

      case "From Bin":
        setState(() {
          txtFBin.text = option['WhseBin_BinNum'];
        });
        await updateLotNumbers();
        break;
      case "Lot Number":
        txtLotNum.text = option;
        lotNum = option;
        break;
      case "Doc Type":
        txtTransDoc.text = option['TranDocType_Description'];
        docType = option['TranDocType_TranDocTypeID'];
        break;
      default:
        return "NA";
    }
    setState(() {});
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

  getPartAsync(String val) async {
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

      if (txtFPartNo.text == partNum) {
        lotNum = partLot;

        int productIndex = serItems.indexWhere(
          (item) => item["SerialNumber"] == serialNum,
        );
        if (productIndex == -1) {
          serItems.add({
            "Company": company,
            "SerialNumber": serialNum,
            "PartNum": partNum,
            "TransType": "STK-MTL",
            "RowMod": "A"
          });
        } else {
          throw Exception("Product already scanned.");
        }
      } else {
        throw Exception("Please scan a valid PartNum.");
      }
    } catch (ex) {
      showError('Error', ex.toString());
    } finally {
      txtScanPart.text = "";
      setState(() {
        isLoading = false;
      });
    }
  }

  submit() async {
    try {
      if (_formInit.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        DateTime customDate = DateTime.now();
        String formattedDate = "${customDate.year.toString().padLeft(4, '0')}-"
            "${customDate.month.toString().padLeft(2, '0')}-"
            "${customDate.day.toString().padLeft(2, '0')}T"
            "00:00:00+05:30";
        var body = {};
        switch (prdType) {
          case "1":
            body = {
              "plNegQtyAction": true,
              "ds": {
                "IssueReturn": [
                  {
                    "Company": company,
                    "TranDate": formattedDate,
                    "PartNum": txtFPartNo.text,
                    "TranQty": double.parse(serItems.length.toString()),
                    "FromWarehouseCode": wereFID,
                    "FromBinNum": txtFBin.text,
                    "ToJobNum": widget.item['JobHead_JobNum'],
                    "ToAssemblySeq": selAssems,
                    "ToJobSeq": selMtl,
                    "LotNum": lotNum,
                    "ToWarehouseCode": wereTID,
                    "ToBinNum": txtTBin.text,
                    "FromJobPlant": plant,
                    "ToJobPlant": plant,
                    "EnableSN": true,
                    "SerialControlPlant": plant,
                    "SerialControlPlantIsFromPlt": true,
                    "ProcessID": "IssueMaterial",
                    "Plant": plant,
                    "PartTrackSerialNum": true,
                    "PartTrackLots": true,
                    "PartPricePerCode": pricePerCode,
                    "PartSellingFactor": sellingFactor,
                    "ToJobSeqPartNum": txtFPartNo.text,
                    "TranType": "STK-MTL",
                    "UM": txtIUM,
                    "TranDocTypeID": "Mass Issue",
                    "PartPartDescription": txtPartDesc.text,
                    "RowMod": "U"
                  }
                ],
                "SelectedSerialNumbers": serItems,
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
                    "PartNum": txtFPartNo.text,
                    "TranQty": double.parse(txtQty.text),
                    "FromWarehouseCode": wereFID,
                    "FromBinNum": txtFBin.text,
                    "IssuedComplete": false,
                    "ToJobNum": widget.item['JobHead_JobNum'],
                    "ToAssemblySeq": selAssems,
                    "ToJobSeq": selMtl,
                    "LotNum": lotNum,
                    "ToWarehouseCode": wereTID,
                    "ToBinNum": txtTBin.text,
                    "ToJobSeqPartNum": txtFPartNo.text,
                    "TranType": "STK-MTL",
                    "UM": txtIUM,
                    "TranDocTypeID": "Mass Issue",
                    "PartPartDescription": txtPartDesc.text,
                    "RowMod": "U"
                  }
                ],
              }
            };
            break;
          case "3":
            body = {
              "plNegQtyAction": true,
              "ds": {
                "IssueReturn": [
                  {
                    "Company": company,
                    "TranDate": formattedDate,
                    "PartNum": txtFPartNo.text,
                    "TranQty": double.parse(serItems.length.toString()),
                    "FromWarehouseCode": wereFID,
                    "FromBinNum": txtFBin.text,
                    "ToJobNum": widget.item['JobHead_JobNum'],
                    "ToAssemblySeq": selAssems,
                    "ToJobSeq": selMtl,
                    "LotNum": lotNum,
                    "ToWarehouseCode": wereTID,
                    "ToBinNum": txtTBin.text,
                    "FromJobPlant": plant,
                    "ToJobPlant": plant,
                    "EnableSN": true,
                    "SerialControlPlant": plant,
                    "SerialControlPlantIsFromPlt": true,
                    "ProcessID": "IssueMaterial",
                    "Plant": plant,
                    "PartTrackSerialNum": true,
                    "PartTrackLots": false,
                    "PartPricePerCode": pricePerCode,
                    "PartSellingFactor": sellingFactor,
                    "ToJobSeqPartNum": txtFPartNo.text,
                    "TranType": "STK-MTL",
                    "UM": txtIUM,
                    "TranDocTypeID": "Mass Issue",
                    "PartPartDescription": txtPartDesc.text,
                    "RowMod": "U"
                  }
                ],
                "SelectedSerialNumbers": serItems,
              }
            };
            break;
          case "4":
            body = {
              "plNegQtyAction": true,
              "ds": {
                "IssueReturn": [
                  {
                    "Company": company,
                    "TranDate": formattedDate,
                    "PartNum": txtFPartNo.text,
                    "TranQty": double.parse(txtQty.text),
                    "FromWarehouseCode": wereFID,
                    "FromBinNum": txtFBin.text,
                    "ToJobNum": widget.item['JobHead_JobNum'],
                    "ToAssemblySeq": selAssems,
                    "ToJobSeq": selMtl,
                    "LotNum": "",
                    "ToWarehouseCode": wereTID,
                    "ToBinNum": txtTBin.text,
                    "ToJobSeqPartNum": txtFPartNo.text,
                    "TranType": "STK-MTL",
                    "UM": txtIUM,
                    "TranDocTypeID": "Mass Issue",
                    "PartPartDescription": txtPartDesc.text,
                    "RowMod": "U"
                  }
                ],
                "SelectedSerialNumbers": serItems,
              }
            };
        }
        printLargeString(json.encode(body));
        Response res = await materialServices.postIssueMaterialPost(body);
        if (res.statusCode == 200) {
          showSucess('Success: ', "Material issue successful for you job.");
          loadData();
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

  void printLargeString(String text) {
    const int chunkSize = 800;
    for (int i = 0; i < text.length; i += chunkSize) {
      // Print the string in chunks
      debugPrint(text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
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
                        //Todo: make it clear
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

  Future<void> handleMtlSeqChange(String value) async {
    selMtl = value;
    txtMtlSeq.text = value;

    // Find the corresponding item
    var selectedItem = items.firstWhere(
        (item) => item['JobMtl_MtlSeq'].toString() == value,
        orElse: () => null);

    if (selectedItem != null) {
      // Update all dependent fields
      txtTWere.text = selectedItem['Calculated_DefaultToWarehouse'];
      wereTID = selectedItem['Calculated_DefaultToWarehouse'];
      txtTBin.text = selectedItem['Calculated_DefaultToBin'];

      txtFWere.text = selectedItem['Calculated_DefaultFromWarehouse'];
      wereFID = selectedItem['Calculated_DefaultFromWarehouse'];
      txtFBin.text = selectedItem['Calculated_DefaultFrombin'];

      // Update lot numbers
      var res = await materialServices.getProducts(
        widget.item['JobHead_PartNum'],
        selectedItem['Calculated_DefaultFromWarehouse'],
        selectedItem['Calculated_DefaultFrombin'],
      );

      List<dynamic> tempItems = res['value'];
      lotNums.clear();

      for (int i = 0; i < tempItems.length; i++) {
        if (tempItems[i]["PartBin_LotNum"] != "") {
          lotNums.add(tempItems[i]["PartBin_LotNum"]);
        }
      }

      // Update lot number field
      if (lotNums.isNotEmpty && prdType == "2") {
        lotNum = lotNums[0];
        txtLotNum.text = lotNums[0];
      } else {
        lotNum = "";
        txtLotNum.text = "";
      }

      setState(() {}); // Trigger UI update
    }
  }
}
