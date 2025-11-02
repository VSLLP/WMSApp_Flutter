import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/RMA/screen_rma_scan.dart';

class ScreenRMAHeader extends StatefulWidget {
  const ScreenRMAHeader({super.key});

  @override
  State<ScreenRMAHeader> createState() => _ScreenRMAHeader();
}

class _ScreenRMAHeader extends State<ScreenRMAHeader> {
  bool isLoading = true;
  bool isCam = false;
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
                            'RMA Details',
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
                                            "RMA No.: ${founditems[index]["RMAHead_RMANum"]}",
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
                                        "Customer Name.: ${founditems[index]["Customer_Name"]}",
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorDataColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "RMA Date: ${founditems[index]["RMAHead_RMADate"]}",
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

  loadData() async {
    var response = await rmaServices.getRMAList();
    items.clear();
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
        final custName = item["Customer_Name"].toLowerCase();
        final rmanum = item["RMAHead_RMANum"].toString();
        //final desc = item["JobHead_PartDescription"].toLowerCase();
        return custName.contains(enteredKeyword.toLowerCase()) ||
            rmanum.contains(enteredKeyword.toLowerCase());
      }).toList();
      // we use the toLowerCase() method to make it case-insensitive

      // Refresh the UI
      setState(() {
        founditems = results;
      });
    }
  }

  gotoEntryPage(item) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenRmaScan(
          item: item,
        ),
      ),
    );
    loadData();
  }
}
