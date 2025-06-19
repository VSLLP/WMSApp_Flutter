import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/custShip/screen_cust_ship_details.dart';
import 'package:http/http.dart';

import 'package:intl/intl.dart';

class ScreenCustShipMain extends StatefulWidget {
  const ScreenCustShipMain({super.key});

  @override
  State<ScreenCustShipMain> createState() => _ScreenCustShipMainState();
}

class _ScreenCustShipMainState extends State<ScreenCustShipMain> {
  var txtOrdNum = TextEditingController();
  var txtCustomer = TextEditingController();
  var txtDocType = TextEditingController();
  var txtShipVia = TextEditingController();

  List<dynamic> orders = [];
  List<dynamic> docTypes = [];
  List<dynamic> shipVias = [];

  dynamic customer = {};

  String docType = "";
  String comp = "";
  String plant = "";
  String packNum = "";

  bool isLoading = true;
  bool isError = false;

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
                            'Customer Shipment',
                            style: TextStyles.getBold(
                              22,
                              color: AppColors.colorWhite,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          createShipment();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.colorAssent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.colorTansprent40,
                                blurRadius: 2,
                                offset: const Offset(2, 2),
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Center(
                              child: Text(
                                "Create shipment Header",
                                style: TextStyles.getBold(
                                  14,
                                  color: AppColors.colorWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            loadData();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.colorAssent,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.colorTansprent40,
                                  blurRadius: 2,
                                  offset: const Offset(2, 2),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Center(
                                child: Text(
                                  "Shipments",
                                  style: TextStyles.getBold(
                                    14,
                                    color: AppColors.colorWhite,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            gotoDetailsPage(orders[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.colorWhite,
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.colorTansprent40,
                                    blurRadius: 4,
                                    offset: const Offset(-2, 2),
                                  )
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          child: Text(
                                            "Customer Name: ${orders[index]["Customer_Name"]}",
                                            style: TextStyles.getBold(
                                              14,
                                              color: AppColors.colorDataColor,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 20,
                                          height: 20,
                                          color: Colors.transparent,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              "assets/icons/ic_right_arrow.svg",
                                              semanticsLabel: 'Logo',
                                              width: 12,
                                              height: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Pack Num: ${orders[index]["ShipHead_PackNum"]}",
                                      style: TextStyles.getBold(
                                        14,
                                        color: AppColors.colorDataColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Entry Person: ${orders[index]["OrderHed_EntryPerson"]}",
                                      style: TextStyles.getBold(
                                        14,
                                        color: AppColors.colorDataColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                        "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(orders[index]["ShipHead_ShipDate"])).toString()}",
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorDataColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
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

    comp = await sharedPref.getString("userCompnay");
    plant = await sharedPref.getString("userPlant");

    var resB = await inventoryServices.getFacShipVia();
    var payloadB = json.decode(resB.body);
    shipVias.clear();
    shipVias = payloadB['value'];

    var response = await custShipServices.getOpenShipment();
    var items = response['value'];
    orders.clear();
    for (var item in items) {
      orders.add(item);
    }
    setState(() {
      isLoading = false;
    });
  }

  createShipment() {
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
                  "Create new shipment header",
                  style: TextStyles.getBold(18),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.colorGray100,
                ),
                const SizedBox(height: 2),
                SizedBox(
                  child: Container(
                    color: Colors.transparent,
                    child: TextFormField(
                      controller: txtOrdNum,
                      style: TextStyles.getBold(12),
                      decoration: InputDecoration(
                        hintText: "Order Name",
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
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      onChanged: (quer) {
                        getOrderDetails(quer);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter order number.";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  child: Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 10,
                    ),
                    child: TextFormField(
                      controller: txtCustomer,
                      style: TextStyles.getBold(12),
                      decoration: InputDecoration(
                        hintText: "Customer Name",
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
                          return "Please select customer.";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                isError
                    ? Text(
                        "Please enter customer name",
                        style: TextStyles.getBold(8,
                            color: AppColors.colorPrimary),
                      )
                    : Container(),
                SizedBox(
                  child: TextFormField(
                    controller: txtDocType,
                    style: TextStyles.getBold(12),
                    decoration: InputDecoration(
                      hintText: "Document Type",
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
                    onTap: () {
                      choseDropOptions("DocType", docTypes);
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
                SizedBox(
                  child: TextFormField(
                    controller: txtShipVia,
                    style: TextStyles.getBold(12),
                    decoration: InputDecoration(
                      hintText: "Ship Via",
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
                    onTap: () {
                      choseDropOptions("ShipVia", shipVias);
                    },
                    autofocus: false,
                    readOnly: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter ship via.";
                      }
                      return null;
                    },
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
                        txtOrdNum.text = "";
                        txtCustomer.text = "";
                        txtDocType.text = "";
                        txtShipVia.text = "";
                        docType = "";
                        packNum = "";
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        child: Text(
                          "Cancel",
                          style: TextStyles.getBold(14),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (txtOrdNum.text.isEmpty ||
                            txtCustomer.text.isEmpty ||
                            txtShipVia.text.isEmpty ||
                            txtDocType.text.isEmpty ||
                            packNum.isEmpty) {
                          setState(() {
                            isError = true;
                          });
                        } else {
                          createHead();
                        }
                      },
                      child: SizedBox(
                        child: Text(
                          "Create",
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

  getOrderDetails(pcNum) async {
    if (pcNum.length < 5) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    var res = await customerShipmentServices.getOrderPackNum(pcNum);
    customer = res["value"][0];
    txtCustomer.text = customer["Customer_Name"];

    var resA = await customerShipmentServices.getTransDoc(pcNum);
    docTypes.clear();
    docTypes = resA['value'];

    packNum = pcNum;
    setState(() {
      isLoading = false;
    });
  }

  createHead() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    var body = {
      "Company": comp,
      "PackNum": packNum,
      "ShipDate": DateTime.now().toIso8601String(),
      "ShipViaCode": txtShipVia.text,
      "Plant": plant,
      "CustNum": customer["OrderHed_CustNum"],
      "OrderNum": customer["OrderHed_OrderNum"],
      "TranDocTypeID": docType,
      "RowMod": "A"
    };
    printLargeString(json.encode(body));
    Response res = await customerShipmentServices.createShipHead(body);
    if (res.statusCode == 200) {
      showSuccess(
        'Success',
        "Customer shipment created successfully!",
      );
    } else {
      showError(
        'Error',
        json.decode(res.body)['ErrorMessage'],
      );
    }
  }

  reset() {
    txtOrdNum.text = "";
    txtCustomer.text = "";
    txtDocType.text = "";
    txtShipVia.text = "";
    docType = "";
    packNum = "";
    customer = {};
    docTypes = [];
    loadData();
  }

  void printLargeString(String text) {
    const int chunkSize = 800;
    for (int i = 0; i < text.length; i += chunkSize) {
      debugPrint(text.substring(
          i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
  }

  gotoDetailsPage(dynamic record) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenCustShipDetails(
          item: record,
        ),
      ),
    );
  }

  updateOtp(String title, dynamic option) {
    switch (title) {
      case "DocType":
        txtDocType.text = option['TranDocType_Description'];
        docType = option['TranDocType_TranDocTypeID'];
        break;
      case "ShipVia":
        txtShipVia.text = option['ShipVia_ShipViaCode'];
        break;
      default:
        return "NA";
    }
    setState(() {});
  }

  getOptTitle(String title, dynamic option) {
    switch (title) {
      case "DocType":
        return option['TranDocType_Description'];
      case "ShipVia":
        return option['ShipVia_ShipViaCode'];
      default:
        return "NA";
    }
  }

  choseDropOptions(String title, List<dynamic> options) {
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
}
