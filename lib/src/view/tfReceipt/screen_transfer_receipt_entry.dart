import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class ScreenTransferReceiptEntry extends StatefulWidget {
  final dynamic item;
  const ScreenTransferReceiptEntry({
    super.key,
    required this.item,
  });

  @override
  State<ScreenTransferReceiptEntry> createState() =>
      _ScreenTransferReceiptEntryState();
}

class _ScreenTransferReceiptEntryState
    extends State<ScreenTransferReceiptEntry> {
  var txtPackNum = TextEditingController();
  var txtOrderNum = TextEditingController();

  List<dynamic> items = [];

  bool isLoading = true;
  bool isSubmit = false;

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
                            'Transfer Receipt Details',
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
                                        return "Please enter pack Num";
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
                                    "CFIL Order No: ",
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
                                    controller: txtOrderNum,
                                    style: TextStyles.getBold(
                                      12,
                                      color: AppColors.colorBlack,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "CFIL Order No",
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
                                        return "Please select CFIL Order No.";
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

  loadData() async {
    txtPackNum.text = widget.item['PlantTran_PackNum'].toString();
    txtOrderNum.text = widget.item['TFShipHead_Character01'];
    var res = await transferServices.getTansferReceiptItems(txtPackNum.text);
    items.clear();
    items = res['value'];

    for (var item in items) {
      item['recvDate'] = '';
      item['isSelect'] = false;
    }

    setState(() {
      isLoading = false;
    });
  }

  List<TableRow> getRows() {
    List<TableRow> rows = [];
    rows.add(TableRow(
      children: [
        tableCell('Receive Date'),
        tableCell('PackID'),
        tableCell('Line'),
        tableCell('Part'),
        tableCell('Shipped Qty'),
      ],
    ));
    for (int i = 0; i < items.length; i++) {
      var item = items[i];
      rows.add(TableRow(
        children: [
          TableCell(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: SizedBox(
                height: 36,
                child: item['recvDate'] != ""
                    ? GestureDetector(
                        onTap: () {
                          getRecvDate(i);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 4,
                          ),
                          child: Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(item['recvDate']))
                                .toString(),
                          ),
                        ),
                      )
                    : TextFormField(
                        style: TextStyles.getBold(
                          12,
                          color: AppColors.colorBlack,
                        ),
                        decoration: InputDecoration(
                          hintText: "Date",
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
                        keyboardType: TextInputType.datetime,
                        autofocus: false,
                        readOnly: true,
                        onTap: () {
                          getRecvDate(i);
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please select date";
                          }
                          return null;
                        },
                      ),
              ),
            ),
          ),
          tableCellRow(item["TFShipHead_PackNum"].toString()),
          tableCellRow(item["TFShipDtl_PackLine"].toString()),
          tableCellRow(item["TFShipDtl_PartNum"]),
          tableCellRow(
            double.parse(item["TFShipDtl_OurStockShippedQty"].toString())
                .toStringAsFixed(2),
          ),
        ],
      ));
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

  getRecvDate(int index) async {
    List<DateTime?>? results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.single,
      ),
      dialogSize: const Size(325, 400),
      value: [DateTime.now()],
      borderRadius: BorderRadius.circular(15),
    );
    items[index]['recvDate'] = results![0]?.toIso8601String();
    setState(() {});
  }

  submit() async {
    try {
      setState(() {
        isLoading = true;
      });

      String company = await sharedPref.getString("userCompnay");
      String plant = await sharedPref.getString("userPlant");
      bool isExcuted = false;
      bool isSucess = false;
      // Run before Patch
      // https://epicor.ceasefire.asia/CFILPilot/api/v1/Ice.BO.UserFileSvc/UserComps(manager,CTEMP1)

      var authBody = {"CurPlant": plant};
      print(authBody);
      print(items);
      await authServices.pathUserComps(authBody);
      for (var item in items) {
        if (item['recvDate'] != "") {
          isExcuted = true;
          var body = {
            "Company": company,
            "TranNum": item['PlantTran_TranNum'],
            "PartNum": item['TFShipDtl_PartNum'],
            "PartDescription": item['TFShipDtl_LineDesc'],
            "UM": item['TFShipDtl_IUM'],
            "RecTranDate": item['recvDate'],
            "TranDate": item['recvDate'],
            "FromPlant": item['PlantTran_FromPlant'],
            "ToPlant": item['PlantTran_ToPlant'],
            "FromWarehouseCode": item['PlantTran_FromWarehouseCode'],
            "BinNum": item['PlantTran_BinNum'],
            "WarehseCodeTo": item['PlantConfCtrl_DefRcvWhse'],
            "PackNum": item['PlantTran_PackNum'],
            "PackLine": item['PlantTran_PackLine'],
            "ReceiveTo": "STOCK",
            "ReceiveToBinNum": "F",
            "ReceiveToWhseCode": plant,
            "RequiredQty": item['TFShipDtl_OurStockShippedQty'],
            "TranType": "TO",
            //"SysRowID": item['PlantTran_SysRowID'],
            "ThisTranQty": item['TFShipDtl_OurStockShippedQty'],
            "TranDocTypeID": "INVTRF",
            "Character01": item['PlantTran_Character01'],
            "Character02": item['PlantTran_Character02'],
            "RowMod": "U"
          };
          print(body);
          print("Pack Num " + item['PlantTran_TranNum'].toString());
          Response res = await transferServices.patchRecvItem(
            json.encode(body),
            item['PlantTran_TranNum'].toString(),
          );
          print("Response " + res.body);
          if (res.statusCode == 204) {
            isSucess = true;
          } else {
            isSucess = false;
            showError(
              'Error',
              json.decode(res.body)['ErrorMessage'],
            );
          }
        }
      }
      if (!isExcuted) {
        showError('Error', "Please select date on at least on recived item.");
      }
      if (isSucess) {
        showSucess('Success: ', "Item received successfully.");
      }
    } catch (ex) {
      showError('Error', ex.toString());
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
}
