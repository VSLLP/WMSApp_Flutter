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
  var txtCustNum = TextEditingController();
  var txtDocType = TextEditingController();
  var txtShipVia = TextEditingController();
  var txtSearch = TextEditingController();

  List<dynamic> orders = [];
  List<dynamic> openOrderFilter = [];
  List<dynamic> docTypes = [];
  List<dynamic> shipVias = [];
  List<dynamic> founditems = [];

  Timer? debounce;

  dynamic customer = {};
  dynamic order = {};

  String docType = "";
  String comp = "";
  String plant = "";

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
                  TextField(
                    onChanged: (value) => _runFilter(value),
                    decoration: const InputDecoration(
                        labelText: 'Type here for search',
                        suffixIcon: Icon(Icons.search)),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: founditems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            gotoDetailsPage(founditems[index], false);
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
                                            "Customer Name: ${founditems[index]["Customer_Name"]}",
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
                                      "Pack Num: ${founditems[index]["ShipHead_PackNum"]}",
                                      style: TextStyles.getBold(
                                        14,
                                        color: AppColors.colorDataColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Entry Person: ${founditems[index]["OrderHed_EntryPerson"]}",
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
                                        "Date: ${founditems[index]["ShipHead_ShipDate"] == null ? '' : DateFormat('dd/MM/yyyy').format(DateTime.parse(founditems[index]["ShipHead_ShipDate"])).toString()}",
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

    var resA = await custShipServices.getTransDoc();
    docTypes.clear();
    docTypes = resA['value'];

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
      founditems = orders;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isNotEmpty) {
      results = orders.where((item) {
        final custName = item["Customer_Name"].toLowerCase();
        final packNum = item["ShipHead_PackNum"];
        final person = item["OrderHed_EntryPerson"].toLowerCase();
        return custName.contains(enteredKeyword.toLowerCase()) ||
            packNum.toString().contains(enteredKeyword) ||
            person.contains(enteredKeyword.toLowerCase());
      }).toList();
      // we use the toLowerCase() method to make it case-insensitive

      // Refresh the UI
      setState(() {
        founditems = results;
      });
    }
  }

  createShipment() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                          controller: txtCustNum,
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
                          keyboardType: TextInputType.text,
                          onTap: () {
                            if (isLoading) {
                              return;
                            }
                            choseCustOptions("Customer Name");
                          },
                          autofocus: false,
                          readOnly: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please select customar name.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
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
                          if (isLoading) {
                            return;
                          }
                          choseDropOptions("DocType", false, docTypes);
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
                          if (isLoading) {
                            return;
                          }
                          choseDropOptions("ShipVia", false, shipVias);
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
                            txtCustNum.text = "";
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
                        isLoading
                            ? Container(
                                width: 48,
                                height: 48,
                                color: Colors.transparent,
                                child: Center(
                                  child: Lottie.asset(
                                    'assets/anim/anim-bgLoading.json',
                                    width: 100,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  if (txtCustNum.text.isEmpty ||
                                      txtShipVia.text.isEmpty ||
                                      txtDocType.text.isEmpty) {
                                    setState(() {
                                      isError = true;
                                    });
                                  } else {
                                    setState(() {});
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
      },
    );
  }

  updateOtp(String title, dynamic option) {
    switch (title) {
      case "Customer Name":
        txtCustNum.text = option['Customer_Name'];
        customer = option;
        break;
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
      case "Customer Name":
        return "${option['Customer_CustID']}:${option['Customer_Name']}";
      case "DocType":
        return option['TranDocType_Description'];
      case "ShipVia":
        return option['ShipVia_ShipViaCode'];
      default:
        return "NA";
    }
  }

  choseDropOptions(String title, bool isSearch, List<dynamic> options) {
    List<dynamic> items = List.from(options);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select $title", style: TextStyles.getBold(18)),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: AppColors.colorGray100,
                    ),
                    Expanded(
                      child: items.isEmpty
                          ? Center(
                              child: Text("No $title found.",
                                  style: TextStyles.getRegularScund(16,
                                      color: AppColors.colorGray600)))
                          : ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    updateOtp(title, items[index]);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      getOptTitle(title, items[index]),
                                      style: TextStyles.getRegularScund(16,
                                          color: AppColors.colorGray600),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text("Cancel", style: TextStyles.getBold(14)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  choseCustOptions(String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select $title", style: TextStyles.getBold(18)),
                    const SizedBox(height: 4),
                    Column(
                      children: [
                        const SizedBox(height: 6),
                        SizedBox(
                          height: 36,
                          child: TextFormField(
                            controller: txtSearch,
                            style: TextStyles.getBold(10),
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 0.6, color: AppColors.colorGray600),
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              suffixIcon: Icon(Icons.search,
                                  color: AppColors.colorGray600, size: 16),
                              hintStyle: TextStyles.getRegularScund(14,
                                  color: AppColors.colorGray600),
                            ),
                            onChanged: (value) {
                              if (debounce?.isActive ?? false) {
                                debounce?.cancel();
                              }
                              debounce =
                                  Timer(const Duration(milliseconds: 500), () {
                                filterCustomerViaName(value, setState);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: AppColors.colorGray100,
                    ),
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : openOrderFilter.isEmpty
                              ? Center(
                                  child: Text("No $title found.",
                                      style: TextStyles.getRegularScund(16,
                                          color: AppColors.colorGray600)))
                              : ListView.builder(
                                  itemCount: openOrderFilter.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        updateOtp(
                                            title, openOrderFilter[index]);
                                        txtSearch.text = "";
                                        openOrderFilter = [];
                                        setState(() {});
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          getOptTitle(
                                              title, openOrderFilter[index]),
                                          style: TextStyles.getRegularScund(16,
                                              color: AppColors.colorGray600),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          openOrderFilter = [];
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        child: Text("Cancel", style: TextStyles.getBold(14)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  filterCustomerViaName(String query, StateSetter setState) async {
    setState(() {
      isLoading = true;
    });

    try {
      var res = await custShipServices.getCustByName(query);
      openOrderFilter = res["value"];
    } catch (e) {
      openOrderFilter = [];
    }

    setState(() {
      isLoading = false;
    });
  }

  gotoDetailsPage(dynamic record, bool isN) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenCustShipDetails(
          item: record,
          isNew: isN,
        ),
      ),
    );
  }

  createHead() async {
    setState(() {
      isLoading = true;
    });
    try {
      var body = {
        "Company": comp,
        "PackNum": 0,
        "ShipDate": DateTime.now().toIso8601String(),
        "ShipViaCode": txtShipVia.text,
        "Plant": plant,
        "CustNum": customer["Customer_CustNum"],
        "OrderNum": 0,
        "TranDocTypeID": docType,
        "RowMod": "A"
      };
      Response res = await custShipServices.createShipHead(body);
      if (res.statusCode == 201) {
        order = res.body;
        showSuccess(
          'Success',
          "Customer shipment created successfully!",
        );
      } else {
        showError(
          'Error',
          json.decode(res.body)['value'],
        );
      }
    } catch (ex) {
      showError('Error', ex.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  reset() {
    txtCustNum.text = "";
    txtDocType.text = "";
    txtShipVia.text = "";
    docType = "";
    customer = {};
    docTypes = [];
    openOrderFilter = [];
    Navigator.of(context).pop();
    loadData();
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
                        gotoDetailsPage(order, true);
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
