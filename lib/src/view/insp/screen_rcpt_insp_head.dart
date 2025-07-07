import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/insp/screen_rcpt_insp_dtl.dart';
import 'package:intl/intl.dart';

class ScreenRcptInspHead extends StatefulWidget {
  const ScreenRcptInspHead({super.key});

  @override
  State<ScreenRcptInspHead> createState() => _ScreenRcptInspHeadState();
}

class _ScreenRcptInspHeadState extends State<ScreenRcptInspHead> {
  List<dynamic> items = [];
  List<dynamic> founditems = [];
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
                            'Receipt Inspection Header',
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
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.74,
                                            child: Text(
                                              "Po Num: ${founditems[index]["RcvHead_PONum"]}",
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
                                        "Pack Slip: ${founditems[index]["RcvHead_PackSlip"]}",
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorDataColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Supplier Name: ${founditems[index]["Vendor_Name"]}",
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorDataColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Arrived Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(items[index]["RcvHead_ArrivedDate"].toString())).toString()}",
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorDataColor,
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

  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isNotEmpty) {
      results = items.where((item) {
        final poNum = item["RcvHead_PONum"];
        final packSlip = item["RcvHead_PackSlip"].toLowerCase();
        final vendorName = item["Vendor_Name"].toLowerCase();

        return poNum.toString().contains(enteredKeyword) ||
            packSlip.contains(enteredKeyword.toLowerCase()) ||
            vendorName.contains(enteredKeyword.toLowerCase());
      }).toList();
      // we use the toLowerCase() method to make it case-insensitive

      // Refresh the UI
      setState(() {
        founditems = results;
      });
    }
  }

  loadData() async {
    var response = await isnpServices.getRcptHead();
    items.clear();
    items = response['value'];
    setState(() {
      isLoading = false;
      founditems = items;
    });
  }

  gotoEntryPage(item) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenRcptInspDtl(
          item: item,
        ),
      ),
    );
    loadData();
  }
}
