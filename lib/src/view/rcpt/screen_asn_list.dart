import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/rcpt/screen_asn_entry.dart';

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
  List<dynamic> items = [];

  bool isLoading = true;

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
                              gotoEntryPage(items[index]);
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

  gotoEntryPage(item) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenAsnEntry(
          type: widget.type,
          item: item,
        ),
      ),
    );
    loadData();
  }
}
