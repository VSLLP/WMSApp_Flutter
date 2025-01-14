import 'package:epicor/core_packages.dart';
import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/rcpt/screen_asn_item.dart';
import 'package:epicor/src/view/rcpt/screen_asn_r_item.dart';
import 'package:epicor/src/view/rcpt/screen_rcpt_option.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:http/http.dart';

class ScreenAsnList extends StatefulWidget {
  final bool type;

  const ScreenAsnList({
    super.key,
    required this.type,
  });

  @override
  State<ScreenAsnList> createState() => _ScreenAsnListState();
}

class _ScreenAsnListState extends State<ScreenAsnList> {
  List<dynamic> docTypes = [];
  List<dynamic> shipVias = [];
  List<dynamic> slips = [];
  List<dynamic> items = [];

  var txtPackNum = TextEditingController();
  var txtDocType = TextEditingController();
  var txtShipVia = TextEditingController();
  bool isLoading = true;
  bool isSubmit = false;
  bool isError = false;

  String company = "";
  String userId = "";
  String plant = "";
  String docType = "";

  var selItem = {};

  @override
  void initState() {
    super.initState();

    loadOpenPo();
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
                            'Receipt Entry',
                            style: TextStyles.getBold(
                              22,
                              color: AppColors.colorWhite,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: const ButtonStyle(),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Call Open PO")));
                              setState(() {
                                loadOpenPo();
                              });
                            },
                            child: const Text("Open PO")),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Call Receipts")));
                                setState(() {
                                  loadReceipt();
                                });
                              },
                              child: const Text("Receipts"))),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        itemCount: items.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              getTTTTT(items[index]);
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.74,
                                            child: Text(
                                              "Company Name: ${items[index]["VendorPP_Name"]}",
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
                                        "PO: ${items[index]["POHeader_PONum"]}",
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
                                          "City: ${items[index]["VendorPP_City"]}",
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
    var response = await inventoryServices.getAssignedASNList();
    items.clear();
    for (var item in response['value']) {
      int isProductExist = items.indexWhere(
        (i) => i["POHeader_PONum"] == item["POHeader_PONum"],
      );
      if (item["RcvHead_PackSlip"] == null) {
      } else {}
      if (isProductExist == -1) {
        items.add(
          {
            "POHeader_Company": item["POHeader_Company"],
            "POHeader_OpenOrder": item["POHeader_OpenOrder"],
            "POHeader_EntryPerson": item["POHeader_EntryPerson"],
            "POHeader_PONum": item["POHeader_PONum"],
            "VendorPP_Name": item["VendorPP_Name"],
            "VendorPP_City": item["VendorPP_City"],
            "POHeader_PurPoint": item["POHeader_PurPoint"],
            "RcvHead_PackSlip": item["RcvHead_PackSlip"] != null
                ? [item["RcvHead_PackSlip"].toString()]
                : [],
            "Vendor_VendorNum": item["Vendor_VendorNum"],
          },
        );
      } else {
        List<String> slips = items[isProductExist]['RcvHead_PackSlip'];
        slips.add(item['RcvHead_PackSlip']);
        items[isProductExist]['RcvHead_PackSlip'] = slips;
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  loadOpenPo() async {
    setState(() {
      isLoading = true;
    });
    var response = await inventoryServices.getAssignedASNList();
    items.clear();
    for (var item in response['value']) {
      int isProductExist = items.indexWhere(
        (i) => i["POHeader_PONum"] == item["POHeader_PONum"],
      );
      if (item["RcvHead_PackSlip"] == null) {
        if (isProductExist == -1) {
          items.add(
            {
              "POHeader_Company": item["POHeader_Company"],
              "POHeader_OpenOrder": item["POHeader_OpenOrder"],
              "POHeader_EntryPerson": item["POHeader_EntryPerson"],
              "POHeader_PONum": item["POHeader_PONum"],
              "VendorPP_Name": item["VendorPP_Name"],
              "VendorPP_City": item["VendorPP_City"],
              "POHeader_PurPoint": item["POHeader_PurPoint"],
              "RcvHead_PackSlip": item["RcvHead_PackSlip"] != null
                  ? [item["RcvHead_PackSlip"].toString()]
                  : [],
              "Vendor_VendorNum": item["Vendor_VendorNum"],
            },
          );
        } else {
          List<String> slips = items[isProductExist]['RcvHead_PackSlip'];
          slips.add(item['RcvHead_PackSlip']);
          items[isProductExist]['RcvHead_PackSlip'] = slips;
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  loadReceipt() async {
    setState(() {
      isLoading = true;
    });
    var response = await inventoryServices.getAssignedASNList();
    items.clear();
    for (var item in response['value']) {
      int isProductExist = items.indexWhere(
        (i) => i["POHeader_PONum"] == item["POHeader_PONum"],
      );
      if (item["RcvHead_PackSlip"] != null) {
        if (isProductExist == -1) {
          items.add(
            {
              "POHeader_Company": item["POHeader_Company"],
              "POHeader_OpenOrder": item["POHeader_OpenOrder"],
              "POHeader_EntryPerson": item["POHeader_EntryPerson"],
              "POHeader_PONum": item["POHeader_PONum"],
              "VendorPP_Name": item["VendorPP_Name"],
              "VendorPP_City": item["VendorPP_City"],
              "POHeader_PurPoint": item["POHeader_PurPoint"],
              "RcvHead_PackSlip": item["RcvHead_PackSlip"] != null
                  ? [item["RcvHead_PackSlip"].toString()]
                  : [],
              "Vendor_VendorNum": item["Vendor_VendorNum"],
            },
          );
        } else {
          List<String> slips = items[isProductExist]['RcvHead_PackSlip'];
          slips.add(item['RcvHead_PackSlip']);
          items[isProductExist]['RcvHead_PackSlip'] = slips;
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getTTTTT(item) async {
    setState(() {
      isLoading = true;
      loadAsnData(item);
    });

    showModalBottomSheet(
      context: context,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      builder: (BuildContext context) {
        return GiffyBottomSheet.image(
          Image.network(
            "https://media.giphy.com/media/jAYUbVXgESSti/giphy.gif",
            height: 200,
            fit: BoxFit.cover,
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (!isSubmit) {
                  choseSlipOptions();
                }
              },
              child: const Text('Submit GRN'),
            ),
            TextButton(
              onPressed: () {
                if (!isSubmit) {
                  choseOptions();
                }
              },
              child: const Text('Processed'),
            ),
          ],
        );
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  loadAsnData(item) async {
    plant = await sharedPref.getString("userPlant");

    var resA = await inventoryServices.getFacTrnsDoc();
    var payloadA = json.decode(resA.body);
    docTypes.clear();
    docTypes = payloadA['value'];

    var resB = await inventoryServices.getFacShipVia();
    var payloadB = json.decode(resB.body);
    shipVias.clear();
    shipVias = payloadB['value'];

    company = await sharedPref.getString("userCompnay");
    userId = await sharedPref.getString("userName");
    selItem = item;
    setState(() {
      isLoading = false;
    });
  }

  choseOptions() {
    slips.clear();
    for (var item in selItem['RcvHead_PackSlip']) {
      slips.add(item);
    }
    if (!slips.contains('Add New')) {
      slips.add("Add New");
    }
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
                  "Select Pack Slip",
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
                    child: slips.isEmpty
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
                                  "No data found.",
                                  style: TextStyles.getRegularScund(
                                    16,
                                    color: AppColors.colorGray600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: slips.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  if (slips[index] == "Add New") {
                                    addNewSlip();
                                  } else {
                                    proceed(selItem, slips[index]);
                                    setState(() {});
                                  }
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
                                        slips[index],
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

  proceed(dynamic item, String packNum) async {
    if (widget.type) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ScreenAsnRItem(
            item: item,
            packNum: packNum,
          ),
        ),
      );
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ScreenAsnItem(
            item: item,
            packNum: packNum,
          ),
        ),
      );
    }
    loadData();
  }

  addNewSlip() {
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
                  "Create new pack slip",
                  style: TextStyles.getBold(18),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: AppColors.colorGray100,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  child: Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 10,
                    ),
                    child: TextFormField(
                      controller: txtPackNum,
                      style: TextStyles.getBold(12),
                      decoration: InputDecoration(
                        hintText: "Pack slip number",
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
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter pack slip number.";
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                isError
                    ? Text(
                        "Please enter pack slip number",
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
                        txtPackNum.text = "";
                        txtDocType.text = "";
                        txtShipVia.text = "";
                        docType = "";
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
                        if (txtPackNum.text.isEmpty ||
                            txtShipVia.text.isEmpty ||
                            txtDocType.text.isEmpty) {
                          setState(() {
                            isError = true;
                          });
                        } else {
                          createPack(txtPackNum.text);
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

  createPack(packNum) async {
    Navigator.of(context).pop();
    setState(() {
      isLoading = true;
    });
    var body = {
      "Company": selItem['POHeader_Company'],
      "VendorNum": selItem['Vendor_VendorNum'],
      "PurPoint": selItem['POHeader_PurPoint'],
      "PackSlip": packNum,
      "PONum": selItem['POHeader_PONum'],
      "Plant": plant,
      "ShipViaCode": txtShipVia.text,
      "TranDocTypeID": docType
    };
    Response res = await inventoryServices.postReciptHead(body);
    if (res.statusCode == 201) {
      proceed(selItem, packNum);
    } else {
      showError(
        'Error',
        json.decode(res.body)['ErrorMessage'],
      );
    }
    txtPackNum.text = "";
    txtDocType.text = "";
    txtShipVia.text = "";
    docType = "";
    setState(() {
      isLoading = false;
    });
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

  choseSlipOptions() {
    slips.clear();
    for (var item in selItem['RcvHead_PackSlip']) {
      slips.add(item);
    }
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
                  "Select Pack Slip",
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
                    child: slips.isEmpty
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
                                  "No pack slip found.",
                                  style: TextStyles.getRegularScund(
                                    16,
                                    color: AppColors.colorGray600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: slips.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  confirm(slips[index]);
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
                                        slips[index],
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

  confirm(String slip) {
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
                  "Confirm",
                  style: TextStyles.getRegularScund(16),
                ),
                const SizedBox(height: 8),
                Text(
                  "Do you confirm to continue submit: $slip",
                  style: TextStyles.getRegularScund(14),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        child: Text(
                          'NO',
                          style: TextStyles.getBold(
                            14,
                            color: AppColors.colorBlack,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await submit(slip);

                        Navigator.of(context).pop();

                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: SizedBox(
                        child: Text(
                          'YES',
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

  submit(String slip) async {
    try {
      setState(() {
        isLoading = true;
      });
      var body = {
        "SaveForInvoicing": true,
        "ReceivePerson": userId,
        "Received": true
      };
      Response response = await inventoryServices.submitGRN(
        body,
        selItem['Vendor_VendorNum'].toString(),
        selItem['POHeader_PurPoint'],
        slip.toString(),
      );
      if (response.statusCode == 204) {
        showError('Success', 'GRN entry submitted successfully!');
      } else {
        if (response.body.isEmpty) {
          showError('Error', 'Server error occurred!');
        } else {
          showError('Error', json.decode(response.body)['ErrorMessage']);
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
}
