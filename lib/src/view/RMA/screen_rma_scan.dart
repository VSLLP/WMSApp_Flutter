import 'package:epicor/core_packages.dart';

//import 'package:flutter/material.dart';
import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
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

  dynamic jobDetails = {};
  dynamic productDetails = [];

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
                                      //getPartAsync(val);
                                    },
                                    onTap: () {
                                      if (isCam) {
                                        // getScan();
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
                                      //getBins(val);
                                    },
                                    onTap: () {
                                      if (!isScan) {
                                        //  choseWhae(false);
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
                                      if (!isScan) {
                                        //choseBin(false);
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
                                  // submit();
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
                                // child: Center(
                                //   child: isSubmit
                                //       ? Lottie.asset(
                                //           'assets/anim/anim-btnLoading.json',
                                //         )
                                //       : Padding(
                                //           padding: const EdgeInsets.symmetric(
                                //             vertical: 8.0,
                                //           ),
                                //           child: Text(
                                //             'Submit',
                                //             style: TextStyles.getBold(
                                //               16,
                                //               color: AppColors.colorWhite,
                                //             ),
                                //           ),
                                //         ),
                                // ),
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
      rows.add(
        TableRow(
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
    productDetails = resC['value'];

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
}
