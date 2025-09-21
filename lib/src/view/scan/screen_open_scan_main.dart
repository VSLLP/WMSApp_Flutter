import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
//import 'package:epicor/src/view/scan/screen_open_scan.dart';
import 'package:epicor/src/view/scan/screen_transfer_scan.dart';

import 'package:intl/intl.dart';

class ScreenOpenScanMain extends StatefulWidget {
  const ScreenOpenScanMain({super.key});

  @override
  State<ScreenOpenScanMain> createState() => _ScreenOpenScanMain();
}

class _ScreenOpenScanMain extends State<ScreenOpenScanMain> {
  bool isLoading = true;

  List<dynamic> items = [];
  List<dynamic> founditems = [];

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
                            'Transfer Receipt Scan',
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
                  TextField(
                    onChanged: (value) => _runFilter(value),
                    decoration: const InputDecoration(
                        labelText: 'Type here for search',
                        suffixIcon: Icon(Icons.search)),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: SizedBox(
                      child: ListView.builder(
                        itemCount: founditems.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              gotoEntryPage(founditems[index]);
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
                                          Text(
                                            "TFOrdNum: ${founditems[index]["TFOrdHed_TFOrdNum"]}",
                                            style: TextStyles.getBold(
                                              14,
                                              color: AppColors.colorDataColor,
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
                                        "CFIL Transfer No: ${founditems[index]["TFOrdHed_Character01"]}",
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorDataColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "From Plant: ${founditems[index]["Plant_Name"]}",
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorDataColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "To Plant: ${founditems[index]["Plant1_Name"]}",
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
                                          "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(items[index]["TFOrdHed_OrderDate"]))}",
                                          style: TextStyles.getBold(
                                            14,
                                            color: AppColors.colorDataColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          "Pack Slip: ${(founditems[index]["TFShipDtl_PackNum"]) ?? 'New Shipment'}",
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
    var response = await scanServices.getTansferShipList();
    items.clear();
    //founditems.clear();
    items = response['value'];
    setState(() {
      isLoading = false;
      founditems = items;
    });
  }

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isNotEmpty) {
      results = items.where((item) {
        final ordernum = item["TFOrdHed_TFOrdNum"].toLowerCase();
        final plant1 = item["Plant_Name"].toLowerCase();
        final plant2 = item["Plant1_Name"].toLowerCase();
        final PackNum = item["TFShipDtl_PackNum"].toString();

        return ordernum.contains(enteredKeyword.toLowerCase()) ||
            plant1.contains(enteredKeyword.toLowerCase()) ||
            plant2.contains(enteredKeyword.toLowerCase()) ||
            PackNum.contains(enteredKeyword.toLowerCase());
      }).toList();
      // we use the toLowerCase() method to make it case-insensitive

      // Refresh the UI
      setState(() {
        founditems = results;
      });
    }
  }

  gotoEntryPage(item) async {
    print("Item: $item");
    var packNum = item['TFShipDtl_PackNum'] ?? "NEW";

    var itemP = {
      "orderNum": item['TFOrdHed_TFOrdNum'],
      "packNum": packNum,
      'transferShipNo': item['TFOrdHed_Character01'],
      'fromPlant': item['TFOrdHed_Plant'],
      'toPlant': item['TFOrdHed_ToPlant'],
      'fromPlantName': item['Plant_Name'],
      'toPlantName': item['Plant1_Name'],
      'orderDate': item['TFOrdHed_OrderDate']
    };

    await sharedPref.setString("currentPackNum", packNum.toString());

    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenTransferScan(
          item: itemP,
        ),
      ),
    );

    loadData();
  }
}
