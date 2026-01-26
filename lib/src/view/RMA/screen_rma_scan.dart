import 'package:epicor/core_packages.dart';

//import 'package:flutter/material.dart';
import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/home/screen_qr_scan.dart';
//import 'package:epicor/src/config/style/style.dart';
import 'package:http/http.dart';

class ScreenRmaScan extends StatefulWidget {
  final dynamic item;

  const ScreenRmaScan({
    super.key,
    required this.item,
  });

  @override
  State<ScreenRmaScan> createState() => _ScreenRmaScan();
}

class _ScreenRmaScan extends State<ScreenRmaScan> {
  List<dynamic> docTypes = [];
  List<dynamic> whareHouses = [];
  List<dynamic> bins = [];
  List<dynamic> serItems = [];
  List<dynamic> tradqr = [];
  List<dynamic> scanitems = [];

  dynamic jobDetails = {};
  List<dynamic> productDetails = [];

  var txtScan = TextEditingController();
  var txtRmaNo = TextEditingController();
  var txtRmaDate = TextEditingController();
  var txtCustName = TextEditingController();
  var txtBin = TextEditingController();
  var txtWere = TextEditingController();

  // var txtTBin = TextEditingController();
  // var txtUom = TextEditingController();
  // var txtDocType = TextEditingController();
  // var txtQty = TextEditingController();

  String company = "";
  String plant = "";
  String userId = "";
  String wereTId = "";
  String wereFId = "";
  String prdType = "";

  String partNum = "";
  String serialNum = "";
  String partLot = "";
  String qrType = "";
  String custNum = "";
  String custID = "";

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
                            'RMA Scan',
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
                                    "RMA No.: ",
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
                                    controller: txtRmaNo,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "RMA No",
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
                                      // if (value!.isEmpty) {
                                      //   return "Please enter job no.";
                                      // }
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
                                    "RMA Date: ",
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
                                    controller: txtRmaDate,
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
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return "Please enter part no.";
                                    //   }
                                    //   return null;
                                    // },
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
                                    "Cust Name: ",
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
                                    controller: txtCustName,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "Cust Name",
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
                                    // onChanged: (val) {
                                    //   // getBins(val);
                                    // },
                                    // onTap: () {
                                    //   if (!isScan) {
                                    //     //choseWhae(true);
                                    //   }
                                    // },
                                    keyboardType: TextInputType.name,
                                    autofocus: false,
                                    readOnly: true,
                                    // validator: (value) {
                                    //   if (value!.isEmpty) {
                                    //     return "Please select warehouse.";
                                    //   }
                                    //   return null;
                                    // },
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
                            //         "From Bin: ",
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
                            //         controller: txtFBin,
                            //         style: TextStyles.getBold(
                            //           12,
                            //           color: AppColors.colorBlack,
                            //         ),
                            //         decoration: InputDecoration(
                            //           hintText: "Bin",
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
                            //         onTap: () {
                            //           if (!isScan) {
                            //             //choseBin(true);
                            //           }
                            //         },
                            //         keyboardType: TextInputType.name,
                            //         autofocus: false,
                            //         readOnly: true,
                            //         validator: (value) {
                            //           if (value!.isEmpty) {
                            //             return "Please select bin.";
                            //           }
                            //           return null;
                            //         },
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            //   isLot
                            //       ? Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.spaceBetween,
                            //           children: [
                            //             SizedBox(
                            //               width:
                            //                   MediaQuery.of(context).size.width *
                            //                       0.3,
                            //               child: Text(
                            //                 "Quantity: ",
                            //                 style: TextStyles.getBold(
                            //                   14,
                            //                   color: AppColors.colorDataColor,
                            //                 ),
                            //               ),
                            //             ),
                            //             SizedBox(
                            //               width:
                            //                   MediaQuery.of(context).size.width *
                            //                       0.54,
                            //               child: TextFormField(
                            //                 controller: txtQty,
                            //                 style: TextStyles.getBold(
                            //                   12,
                            //                   color: AppColors.colorBlack,
                            //                 ),
                            //                 decoration: InputDecoration(
                            //                   hintText: "Quantity",
                            //                   hintStyle:
                            //                       TextStyles.getRegularScund(
                            //                     14,
                            //                     color: AppColors.colorGray600,
                            //                   ),
                            //                   contentPadding:
                            //                       const EdgeInsets.symmetric(
                            //                     horizontal: 4,
                            //                     vertical: 0,
                            //                   ),
                            //                   counterText: "",
                            //                 ),
                            //                 keyboardType: TextInputType.number,
                            //                 autofocus: false,
                            //                 validator: (value) {
                            //                   if (value!.isEmpty) {
                            //                     return "Please select qty.";
                            //                   }
                            //                   return null;
                            //                 },
                            //               ),
                            //             ),
                            //           ],
                            //         )
                            //       : Container(),
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
                                      //if (!isScan) {
                                      choseWhae(false);
                                      //  }
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
                                      // if (!isScan) {
                                      choseBin(false);
                                      //}
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Text(
                                      "",
                                      style: TextStyles.getBold(
                                        14,
                                        color: AppColors.colorDataColor,
                                      ),
                                    ),
                                  ),
                                ]),
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
                                                txtWere.text = "";
                                                //wereTId = "";
                                                txtBin.text = "";
                                                //txtDocType.text = "";
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

                            //   // Row(
                            //   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   //   children: [
                            //   //     SizedBox(
                            //   //       width:
                            //   //           MediaQuery.of(context).size.width * 0.3,
                            //   //       child: Text(
                            //   //         "Uom: ",
                            //   //         style: TextStyles.getBold(
                            //   //           14,
                            //   //           color: AppColors.colorDataColor,
                            //   //         ),
                            //   //       ),
                            //   //     ),
                            //   //     SizedBox(
                            //   //       width:
                            //   //           MediaQuery.of(context).size.width * 0.54,
                            //   //       child: TextFormField(
                            //   //         controller: txtUom,
                            //   //         style: TextStyles.getBold(
                            //   //           12,
                            //   //           color: AppColors.colorBlack,
                            //   //         ),
                            //   //         decoration: InputDecoration(
                            //   //           hintText: "UOM",
                            //   //           hintStyle: TextStyles.getRegularScund(
                            //   //             14,
                            //   //             color: AppColors.colorGray600,
                            //   //           ),
                            //   //           contentPadding:
                            //   //               const EdgeInsets.symmetric(
                            //   //             horizontal: 4,
                            //   //             vertical: 0,
                            //   //           ),
                            //   //           counterText: "",
                            //   //         ),
                            //   //         keyboardType: TextInputType.name,
                            //   //         autofocus: false,
                            //   //         readOnly: true,
                            //   //         validator: (value) {
                            //   //           if (value!.isEmpty) {
                            //   //             return "Please enter UOM.";
                            //   //           }
                            //   //           return null;
                            //   //         },
                            //   //       ),
                            //   //     ),
                            //   //   ],
                            //   // ),
                            //   // Row(
                            //   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   //   children: [
                            //   //     SizedBox(
                            //   //       width:
                            //   //           MediaQuery.of(context).size.width * 0.3,
                            //   //       child: Text(
                            //   //         "Document Type: ",
                            //   //         style: TextStyles.getBold(
                            //   //           14,
                            //   //           color: AppColors.colorDataColor,
                            //   //         ),
                            //   //       ),
                            //   //     ),
                            //   //     SizedBox(
                            //   //       width:
                            //   //           MediaQuery.of(context).size.width * 0.54,
                            //   //       child: TextFormField(
                            //   //         controller: txtDocType,
                            //   //         style: TextStyles.getBold(
                            //   //           12,
                            //   //           color: AppColors.colorBlack,
                            //   //         ),
                            //   //         decoration: InputDecoration(
                            //   //           hintText: "Document Type",
                            //   //           hintStyle: TextStyles.getRegularScund(
                            //   //             14,
                            //   //             color: AppColors.colorGray600,
                            //   //           ),
                            //   //           contentPadding:
                            //   //               const EdgeInsets.symmetric(
                            //   //             horizontal: 4,
                            //   //             vertical: 0,
                            //   //           ),
                            //   //           counterText: "",
                            //   //         ),
                            //   //         onTap: () {
                            //   //           if (!isScan) {
                            //   //             // choseDocType();
                            //   //           }
                            //   //         },
                            //   //         keyboardType: TextInputType.name,
                            //   //         autofocus: false,
                            //   //         readOnly: true,
                            //   //         validator: (value) {
                            //   //           if (value!.isEmpty) {
                            //   //             return "Please entry document type.";
                            //   //           }
                            //   //           return null;
                            //   //         },
                            //   //       ),
                            //   //     ),
                            //   //   ],
                            //   // ),
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

  List<TableRow> getRows() {
    List<TableRow> rows = [];
    rows.add(TableRow(
      children: [
        tableCell('Line'),
        tableCell('Part'),
        tableCell('Description'),
        tableCell('Qty'),
        tableCell('Qty To RMA'),
        tableCell('InvoiceNum/Invoiceline'),
        //isLot ? tableCell('Lot') : tableCell('Serial'),
      ],
    ));
    for (var item in productDetails) {
      Color rowcolor =
          item['isSelect'] ? AppColors.colorYellow300 : Colors.transparent;

      if (item["RMADtl_ReturnQty"] != "") {
        if (double.parse(item["RMADtl_ReturnQty"].toString()) ==
            double.parse(item["RMADtl_VS_QtyToRMA_c"].toString())) {
          rowcolor = AppColors.colorCyan300;
        }
      }

      rows.add(
        TableRow(
          decoration: BoxDecoration(
            color: rowcolor,
          ),
          children: [
            tableCellRow(item['RMADtl_RMALine'].toString()),
            tableCellRow(item['RMADtl_PartNum'].toString()),
            tableCellRow(item['RMADtl_LineDesc'].toString()),
            tableCellRow(item['RMADtl_ReturnQty'].toString()),
            tableCellRow(item['RMADtl_VS_QtyToRMA_c'].toString()),
            tableCellRow(item['RMADtl_InvoiceNum'].toString()),
          ],
        ),
      );
    }

    return rows;
  }

  loadData() async {
    company = await sharedPref.getString("userCompnay");
    plant = await sharedPref.getString("userPlant");
    userId = await sharedPref.getString("userName");
    isCam = await sharedPref.getBool("isCam");
    String jobno = "";
    //widget.item['JobHead_JobNum'];
    // var response = await jobinvServices.getDocType();
    // docTypes.clear();
    // docTypes = response['value'];

    var resB = await jobinvServices.getWarehouseAsync(jobno);
    whareHouses.clear();
    whareHouses = resB['value'];

    String whdefault = "", whdesc = "";
    // for (var wh in whareHouses) {
    //   if (wh["Calculated_DefaultWarehouse"]) {
    //     whdefault = wh['Warehse_WarehouseCode'];
    //     whdesc = wh['Warehse_Description'];
    //   }
    // }

    //await getBins(whdefault);

    var resC = await rmaServices
        .getRMADetails(widget.item['RMAHead_RMANum'].toString());

    productDetails.clear();

    for (var it in resC['value']) {
      it["isSelect"] = false;
      it["shipQty"] = "0";
      it["scanLot"] = "-";
      it["serials"] = [];
      it["prdTrack"] = "";
      productDetails.add(it);
      //productDetails = resC['value'];
    }

    txtRmaNo.text = widget.item['RMAHead_RMANum'].toString();
    txtRmaDate.text = widget.item['RMAHead_RMADate'].toString();
    txtCustName.text = widget.item['Customer_Name'].toString();
    // txtPartNo.text = widget.item['JobHead_PartNum'];
    // txtUom.text = widget.item['JobHead_IUM'];
    // txtFWere.text = whdesc;
    // //wereFId = whdefault;
    // txtFBin.text = bins[0]['Calculated_DefaultBinNum'];
    // txtQty.text = "";

    setState(() {
      isLoading = false;
    });
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

  getBins(String val) async {
    var response = await jobinvServices.getBinAsync(val);
    bins.clear();
    bins = response['value'];
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
                                  txtWere.text =
                                      whareHouses[index]["Warehse_Description"];
                                  wereTId = whareHouses[index]
                                      ["Warehse_WarehouseCode"];
                                  getBins(wereTId);
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
                                  txtBin.text = bins[index]["WhseBin_BinNum"];
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

  getPartAsync(val) async {
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

        String splitKey = ",";

        List<String> words = val.split(splitKey);
        if (words.length <= 1) {
          return;
        }

        partNum = words[0].toString();
        serialNum = words[1].toString();
      }

      if (partNum.isEmpty && serialNum.isEmpty) {
        throw Exception("Invalid QR Code.");
      }

      int productIndex = productDetails.indexWhere(
        (item) =>
            item["RMADtl_PartNum"].toString().toLowerCase() ==
                partNum.toLowerCase() &&
            double.parse(item["RMADtl_ReturnQty"].toString()) <
                double.parse(item["RMADtl_VS_QtyToRMA_c"].toString()),
      );

      var resPrd = await custShipServices.getGetPart(partNum);
      if (resPrd["value"].length == 0) {
        throw Exception("Invalid partnum no details found or Qty is exceeding");
      }

      var prdDtl = resPrd["value"][0];

      if (productIndex == -1) {
        throw Exception("Please scan a valid PartNum.");
      } else {
        if (qrType == "B") {
          var resoldqrmatch = await rmaServices.getSerialNoRMAInvc(
              productDetails[productIndex]["RMADtl_InvoiceNum"].toString(),
              productDetails[productIndex]["RMADtl_InvoiceLine"].toString(),
              productDetails[productIndex]["RMADtl_RMANum"].toString(),
              productDetails[productIndex]["RMADtl_RMALine"].toString(),
              serialNum);

          var tempqr = resoldqrmatch['value'];

          if (tempqr.length == 0) {
            throw Exception("Please validate scan serial no.");
          }

          productDetails[productIndex]["scanLot"] = partLot;
          productDetails[productIndex]["isSelect"] = true;
          productDetails[productIndex]["RMADtl_ReturnQty"] =
              (double.parse(productDetails[productIndex]["RMADtl_ReturnQty"]) +
                      1)
                  .toString();
          productDetails[productIndex]["serials"].add({
            "num": serialNum,
            "lot": partLot,
            "qrType": qrType,
          });
          productDetails[productIndex]["prdTrack"] = getType(prdDtl);
          productDetails[productIndex]["isSelect"] = true;
        }
        //itemQty[productIndex].text = items[productIndex]["shipQty"];

        if (qrType == "A") {
          String company = await sharedPref.getString("userCompnay");
          String plant = await sharedPref.getString("userPlant");

          var oldqrbody = {
            "ds": {
              "UD16": [
                {
                  "Company": company, //Company
                  "Key1": "RMAOldQR", //hardcoded string
                  "Key2": txtRmaNo.text.toString(), //RMA num
                  "Key3": productDetails[productIndex]["RMADtl_RMALine"]
                      .toString(), //RMALineNum
                  "Key4": productDetails[productIndex]["RMADtl_InvoiceNum"]
                      .toString(), //InvoiceNum
                  "Key5": serialNum
                      .substring(serialNum.length - 7)
                      .toString(), //serial num
                  "Character01": partNum.toString(), //PartNum
                  "Character02": val.toString(), //QR String
                  "Character03": "", //lot
                  "Character04": plant.toString(), //plant
                  "Shortchar01": productDetails[productIndex]
                          ["RMADtl_InvoiceLine"]
                      .toString(), //InvoiceLine
                  "Shortchar02": wereTId, //Warehouse
                  "Shortchar03": txtBin.text, //Bin
                  "RowMod": "A"
                }
              ]
            }
          };

          Response resOldQr = await rmaServices.postOldQRRMA(oldqrbody);

          if (resOldQr.statusCode != 200) {
            throw Exception(json.decode(resOldQr.body)['ErrorMessage']);
          } else {
            var resoldqrmatch = await rmaServices.getSerialNoRMAInvc(
                productDetails[productIndex]["RMADtl_InvoiceNum"].toString(),
                productDetails[productIndex]["RMADtl_InvoiceLine"].toString(),
                productDetails[productIndex]["RMADtl_RMANum"].toString(),
                productDetails[productIndex]["RMADtl_RMALine"].toString(),
                "-1");

            var tempqr = resoldqrmatch['value'];
            if (tempqr != null) {
              var oldqrbody = {
                "ds": {
                  "UD16": [
                    {
                      "Company": company, //Company
                      "Key1": "RMAOldQR", //hardcoded string
                      "Key2": txtRmaNo.text.toString(), //RMA num
                      "Key3": productDetails[productIndex]["RMADtl_RMALine"]
                          .toString(), //RMALineNum
                      "Key4": productDetails[productIndex]["RMADtl_InvoiceNum"]
                          .toString(), //InvoiceNum
                      "Key5": serialNum
                          .substring(serialNum.length - 7)
                          .toString(), //serial num
                      "Character01": partNum.toString(), //PartNum
                      "Character02": val.toString(), //QR String
                      "Character03": "", //lot
                      "Character04": plant.toString(), //plant
                      "Shortchar01": productDetails[productIndex]
                              ["RMADtl_InvoiceLine"]
                          .toString(), //InvoiceLine
                      "Shortchar02": wereTId, //Warehouse
                      "Shortchar03": txtBin.text, //Bin
                      "Shortchar04": tempqr[0]["SerialNo_SerialNumber"]
                          .toString(), //InvoiceLine
                      "SysRevID":
                          tempqr[0]["UD16_SysRevID"].toString(), //Warehouse
                      "SysRowID": tempqr[0]["UD16_SysRowID"].toString(), //Bin
                      "RowMod": "U"
                    }
                  ]
                }
              };

              Response resOldQr1 = await rmaServices.postOldQRRMA(oldqrbody);

              if (resOldQr1.statusCode != 200) {
                throw Exception(json.decode(resOldQr1.body)['ErrorMessage']);
              } else {
                productDetails[productIndex]["scanLot"] = partLot;
                productDetails[productIndex]["isSelect"] = true;
                productDetails[productIndex]
                    ["RMADtl_ReturnQty"] = (double.parse(
                            productDetails[productIndex]["RMADtl_ReturnQty"]) +
                        1)
                    .toString();
                productDetails[productIndex]["serials"].add({
                  "num": tempqr[0]["SerialNo_SerialNumber"],
                  "lot": partLot,
                  "qrType": qrType,
                });
                productDetails[productIndex]["prdTrack"] = getType(prdDtl);
                productDetails[productIndex]["isSelect"] = true;
              }
            }
          }
        }
      }

      // if (val.length <= 3) {
      //   return;
      // }
      // String splitKey = "";
      // if (val.contains("\r\n")) {
      //   splitKey = "\r\n";
      // } else if (val.contains("\n")) {
      //   splitKey = "\n";
      // } else if (val.contains("~")) {
      //   splitKey = "~";
      // } else if (val.contains("~\n")) {
      //   splitKey = "~\n";
      // }

      // List<String> words = val.split(splitKey);
      // if (words.length <= 2) {
      //   return;
      // }

      // String partCode = words[1].replaceAll("Part Code - ", '');
      // String partLot = words[4].replaceAll("Lot No. -", '').replaceAll(" ", "");
      // String partSerial = words[5].replaceAll("Serial No. - ", '');

      // // if (partCode != txtPartNo.text) {
      // //   throw Exception("Please scan the same product.");
      // // }

      // int productIndex = serItems.indexWhere(
      //   (item) => item["SerialNumber"] == partSerial,
      // );

      // if (productIndex == -1) {
      //   setState(() {
      //     isLoading = true;
      //   });

      //   int prodIndex = productDetails.indexWhere(
      //     (item) =>
      //         item["RMADtl_PartNum"].toString().toLowerCase() ==
      //             partNum.toLowerCase() &&
      //         double.parse(item["RMADtl_VS_QtyToRMA_c"].toString()) <
      //             double.parse(item["RMADtl_ReturnQty"].toString()),
      //   );

      //   productDetails[prodIndex]["ShipDtl_OurInventoryShipQty"] =
      //       (double.parse(productDetails[productIndex]
      //                   ["ShipDtl_OurInventoryShipQty"]) +
      //               1)
      //           .toString();
      //   //productDetails[prodIndex]["prdTrack"] = getType(prdDtl);

      //   serItems.add({
      //     "Company": company,
      //     "SerialNumber": partSerial,
      //     //"LotNumber": partLot,
      //     "Scrapped": false,
      //     "ScrappedReasonCode": "",
      //     "Voided": false,
      //     "Reference": "",
      //     "ReasonCodeType": "",
      //     "ReasonCodeDesc": "",
      //     "PartNum": partCode,
      //     "SNPrefix": "",
      //     "SNFormat": "<P18><D><M><YY>#######",
      //     "SNBaseNumber": partSerial
      //         .substring(partSerial.length - 7), //partSerial.substring(0, 9),
      //     "XRefPartNum": "",
      //     "XRefPartType": "",
      //     "TransType": "SHIPPED",
      //     "RowMod": "A"
      //   });
      // } else {
      //   throw Exception("Product already scanned.");
      // }
      // isScan = false;
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

  submit() async {
    try {
      String plant = await sharedPref.getString("userPlant");
      String company = await sharedPref.getString("userCompnay");
      var body = null;
      var rcptbody = null;
      bool isSubmit = false;

      setState(() {
        isLoading = true;
      });

      if (wereTId == "") {
        throw Exception("Please select warehouse");
      }

      if (txtBin.text == "") {
        throw Exception("Please select bin");
      }

      for (var item in productDetails) {
        isSubmit = true;

        double qTY = double.parse(item['RMADtl_ReturnQty'].toString());
        double rqTY = double.parse(item['RMADtl_VS_QtyToRMA_c'].toString());

        // if (qTY <= 0) {
        //   throw Exception("Invalid QTY at ${item["RMADtl_OrderLine"]}.");
        // }
        if (qTY > rqTY) {
          throw Exception(
              "QTY cannot be grater than reqQty at Orderline ${item["RMADtl_OrderLine"]}.");
        }

        if (qTY > 0 && item["serials"] != null) {
          List<dynamic> serialBody = [];
          List<dynamic> serialrcptBody = [];

          var resSerial = await rmaServices.getRMASerialNoDetails(
              txtRmaNo.text.toString(),
              item["RMADtl_PartNum"].toString(),
              item["RMADtl_RMALine"].toString());

          for (var ser in resSerial['value']) {
            item["serials"].add({
              "num": ser["SerialNo_SerialNumber"],
              "lot": "",
              "qrType": "",
            });
          }

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
              "PartNum": item["RMADtl_PartNum"],
              "SNPrefix": "",
              "SNFormat": "<P18><D><M><YY>#######",
              "SNBaseNumber": serial["num"].substring(serial["num"].length - 5),
              "XRefPartNum": "",
              "XRefPartType": "",
              "TransType": "SHIPPED",
              "RowMod": "A"
            });

            serialrcptBody.add({
              "Company": company,
              "SerialNumber": serial["num"],
              "Scrapped": false,
              "ScrappedReasonCode": "",
              "Voided": false,
              "Reference": "",
              "ReasonCodeType": "",
              "ReasonCodeDesc": "",
              "PartNum": item["RMADtl_PartNum"],
              "SNPrefix": "",
              "SNFormat": "<P18><D><M><YY>#######",
              "SNBaseNumber": serial["num"].substring(serial["num"].length - 5),
              "XRefPartNum": "",
              "XRefPartType": "",
              "TransType": "INSPECTION",
              "RowMod": "A"
            });
          }

          body = {
            "ds": {
              "RMADtl": [
                {
                  "Company": company,
                  "OpenRMA": true,
                  "OpenDtl": true,
                  // "CustNum": custNum,
                  "RMANum": txtRmaNo.text,
                  "RMALine": item["RMADtl_RMALine"],
                  "OrderNum": item["RMADtl_OrderNum"],
                  "OrderLine": item["RMADtl_OrderLine"],
                  "ReturnReasonCode": "Defec",
                  "PartNum": item["RMADtl_PartNum"],
                  "LineDesc": item["RMADtl_LineDesc"],
                  "RevisionNum": item["RMADtl_RevisionNum"],
                  "ReturnQty": item["RMADtl_ReturnQty"],
                  "ReturnQtyUOM": item["RMADtl_ReturnQtyUOM"],
                  "CustNum": item["RMADtl_CustNum"],
                  "OrderRelNum": item["RMADtl_OrderRelNum"],
                  "ShipToCustNum": item["RMADtl_ShipToCustNum"],
                  "InvoiceNum": item["RMADtl_InvoiceNum"],
                  "InvoiceLine": item["RMADtl_InvoiceLine"],
                  "SysRevID": item["RMADtl_SysRevID"],
                  "SysRowID": item["RMADtl_SysRowID"],

                  "EnableSN": true,
                  "EnableUpdate": true,
                  "LegalNumber": item["RMADtl_InvoiceNum"],
                  "ShipToCustID": item["Customer_CustID"],
                  "CustomerCustID": item["Customer_CustID"],
                  "RowMod": "U",
                  "CFIL_RefControlNum_c": item["RMADtl_CFIL_RefControlNum_c"],
                  "CFIL_RefInvoiceNum_c": item["RMADtl_CFIL_RefInvoiceNum_c"],
                  "VS_QtyToRMA_c": item["RMADtl_VS_QtyToRMA_c"]
                }
              ],
              "SelectedSerialNumbers": serialBody
            }
          };

          rcptbody = {
            "ds": {
              "RMARcpt": [
                {
                  "Company": company,
                  //"OpenRMA": true,
                  //"OpenDtl": true,
                  // "CustNum": custNum,
                  "RMANum": txtRmaNo.text,
                  "RMALine": item["RMADtl_RMALine"],
                  "RMAReceipt": 1,
                  "RcvDate": txtRmaDate.text,
                  "WareHouseCode": wereTId,
                  "BinNum": txtBin.text,
                  "OpenReceipt": true,
                  "Plant": plant,
                  "ReceivedQty": qTY,
                  "CostUOM": "No.",
                  "ReceivedQtyUOM": "No.",
                  "LegalNumber": "",
                  "RequestMove": false,
                  "PartNum": item["RMADtl_PartNum"],
                  "CustNum": item["RMADtl_CustNum"], // txtCustName.text,
                  "PartPartDescription": item["RMADtl_LineDesc"],
                  "ThisRcptQty": qTY,
                  "DisposedQty": 0,
                  "ThisRcptQtyUOM": "No.",
                  "PartRevisionNum": item["RMADtl_RevisionNum"],
                  "EnableDelete": true,
                  "EnableUpdate": true,
                  "EnableSN": true,
                  "RowMod": "A"
                }
              ],
              "SelectedSerialNumbers": serialrcptBody
            }
          };

          printLargeString(json.encode(body));
          Response res = await rmaServices.submitrma(body);
          //printLargeString(res.body);

          print(res.statusCode);
          if (res.statusCode != 201 && res.statusCode != 200) {
            throw Exception(json.decode(res.body)['ErrorMessage']);
          }
          for (var serial in item["serials"]) {
            var serialonebody = {
              "Company": company,
              "PartNum": item["RMADtl_PartNum"].toString(),
              "SerialNumber": serial["num"].toString(),
              "RMANum": txtRmaNo.text,
              "RMALine": item["RMADtl_RMALine"],
              "RowMod": "U",
              "TransactionSource": "SNMaint"
            };

            Response resSerOne = await rmaServices.updateSerialNo(serialonebody,
                item["RMADtl_PartNum"].toString(), serial["num"].toString());
          }

          printLargeString(json.encode(rcptbody));

          if (qTY == rqTY) {
            Response res1 = await rmaServices.submitrcpt(rcptbody);
            //printLargeString(res1.body);

            print(res1.statusCode);
          }
          if (res.statusCode != 201 && res.statusCode != 200) {
            throw Exception(json.decode(res.body)['ErrorMessage']);
          }
        }
      }

      showSuccess(
        'Success: ',
        "RMA processed successfully.",
      );
    } catch (ex) {
      showError('', ex.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                        //clearData();
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
      debugPrint(text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
  }
}
