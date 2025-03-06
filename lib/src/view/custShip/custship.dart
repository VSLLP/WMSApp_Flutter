import 'package:epicor/core_packages.dart';
import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';

import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class CustomerShipmentHead extends StatefulWidget {
  const CustomerShipmentHead({super.key});

  @override
  State<CustomerShipmentHead> createState() => _CustomerShipmentHeadState();
}

class _CustomerShipmentHeadState extends State<CustomerShipmentHead>
    with SingleTickerProviderStateMixin {
  String company = 'CTEMP1';
  String plant = '';
  List<dynamic> orders = [];
  bool isLoading = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.colorAssent,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Calling Open Orders")));
                              setState(() {
                                // loadOrders();
                              });
                            },
                            child: Text(
                              "Open Orders",
                              style: TextStyles.getBold(14,
                                  color: AppColors.colorWhite),
                            )),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.colorAssent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Callings Shipments")));
                                setState(() {
                                  // loasShipments();
                                });
                              },
                              child: Text(
                                "Shipments",
                                style: TextStyles.getBold(14,
                                    color: AppColors.colorWhite),
                              ))),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            gotoEntryPage(orders[index]);
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
                                        Text(
                                          "Pack Num: ",
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
                                      "CFIL Order No: ",
                                      style: TextStyles.getBold(
                                        14,
                                        color: AppColors.colorDataColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "From Branch: ",
                                      style: TextStyles.getBold(
                                        14,
                                        color: AppColors.colorDataColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Receiving Branch: ",
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
                                        "Date: ",
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
    var response = await authServices.getMenuAsync(company);
    var items = response['value'];
    orders.clear();
    for (var item in items) {
      orders.add(item);
    }
    setState(() {
      isLoading = false;
    });
  }

  //   choseSlipOptions() {
  //   slips.clear();
  //   // print(selItem);
  //   for (var item in selItem['RcvHead_PackSlip']) {
  //     // print(item);
  //     slips.add(item);
  //   }
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(4),
  //         ),
  //         child: Container(
  //           padding: const EdgeInsets.symmetric(
  //             horizontal: 20,
  //             vertical: 16,
  //           ),
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(0),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 "Select Pack Slip",
  //                 style: TextStyles.getBold(18),
  //               ),
  //               const SizedBox(height: 8),
  //               Container(
  //                 width: double.infinity,
  //                 height: 1,
  //                 color: AppColors.colorGray100,
  //               ),
  //               const SizedBox(height: 8),
  //               Expanded(
  //                 child: SizedBox(
  //                   child: slips.isEmpty
  //                       ? Container(
  //                           color: Colors.transparent,
  //                           margin: const EdgeInsets.symmetric(
  //                             horizontal: 0,
  //                             vertical: 10,
  //                           ),
  //                           child: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               Text(
  //                                 "No pack slip found.",
  //                                 style: TextStyles.getRegularScund(
  //                                   16,
  //                                   color: AppColors.colorGray600,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         )
  //                       : ListView.builder(
  //                           itemCount: slips.length,
  //                           shrinkWrap: true,
  //                           scrollDirection: Axis.vertical,
  //                           itemBuilder: (BuildContext context, int index) {
  //                             return GestureDetector(
  //                               onTap: () {
  //                                 Navigator.of(context).pop();
  //                                 confirm(slips[index]);
  //                               },
  //                               child: Container(
  //                                 color: Colors.transparent,
  //                                 margin: const EdgeInsets.symmetric(
  //                                   horizontal: 0,
  //                                   vertical: 10,
  //                                 ),
  //                                 child: Column(
  //                                   crossAxisAlignment:
  //                                       CrossAxisAlignment.start,
  //                                   children: [
  //                                     Text(
  //                                       slips[index],
  //                                       style: TextStyles.getRegularScund(
  //                                         16,
  //                                         color: AppColors.colorGray600,
  //                                       ),
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             );
  //                           },
  //                         ),
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Container(
  //                 width: double.infinity,
  //                 height: 1,
  //                 color: AppColors.colorGray100,
  //               ),
  //               const SizedBox(height: 8),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   GestureDetector(
  //                     onTap: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: SizedBox(
  //                       child: Text(
  //                         "Cancel",
  //                         style: TextStyles.getBold(14),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<void> getTTTTT(item) async {
    setState(() {
      isLoading = true;
      // loadAsnData(item);
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
                // if (!isSubmit) {
                //   choseSlipOptions();
                // }
              },
              child: const Text('Submit GRN'),
            ),
            TextButton(
              onPressed: () {
                // if (!isSubmit) {
                //   choseOptions();
                // }
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

  void gotoEntryPage(order) {
    getTTTTT(order);
    // Navigator.of(context).push(
    //   MaterialPageRoute(builder: (context) => const CustomerShupmentEntry()),
    // );
  }
}
