import 'package:epicor/core_packages.dart';
import 'package:flutter/material.dart';
import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';

class ScreenNcView extends StatefulWidget {
  const ScreenNcView({super.key});

  @override
  State<ScreenNcView> createState() => _ScreenNcView();
}

class _ScreenNcView extends State<ScreenNcView> {
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
                            'Non-Conformance View',
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
                    onChanged: (value) => runFilter(value),
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
                              // gotoEntryPage(founditems[index]);
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
                                            "Trans ID: ${founditems[index]["NonConf_TranID"]}",
                                            style: TextStyles.getBold(
                                              14,
                                              color: AppColors.colorDataColor,
                                            ),
                                          ),
                                          // Container(
                                          //   width: 20,
                                          //   height: 20,
                                          //   color: Colors.transparent,
                                          //   child: Center(
                                          //     child: SvgPicture.asset(
                                          //       "assets/icons/ic_right_arrow.svg",
                                          //       semanticsLabel: 'Logo',
                                          //       width: 12,
                                          //       height: 12,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Part No: ${founditems[index]["NonConf_PartNum"]}",
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorDataColor,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "Part Desc.: ${founditems[index]["NonConf_Description"]}",
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
                                          "Quantity: ${founditems[index]["NonConf_Quantity"]}",
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
    var response = await nonconfServices.getNonConformanceHeaderView();
    items.clear();
    items = response['value'];
    setState(() {
      isLoading = false;
      founditems = items;
    });
  }

  void runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isNotEmpty) {
      results = items.where((item) {
        final NonConf_TranID = item["NonConf_TranID"].toString();
        final NonConf_PartNum = item["NonConf_PartNum"].toLowerCase();
        //final plant2 = item["Plant1_Name"].toLowerCase();
        return NonConf_TranID.contains(enteredKeyword.toLowerCase()) ||
            NonConf_PartNum.contains(enteredKeyword.toLowerCase());
      }).toList();
      setState(() {
        founditems = results;
      });
    }
  }
}
