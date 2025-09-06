import 'package:epicor/core_packages.dart';
import 'package:epicor/src/services/model/menu.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/scan/screen_transfer_scan.dart';
import 'package:epicor/src/view/shipment/screen_shipment_main.dart';
import 'package:epicor/src/view/home/screen_profile.dart';
import 'package:epicor/src/view/issueMtl/screen_issue_mtl_list.dart';
import 'package:epicor/src/view/misIssue/screen_mis_issue_main.dart';
import 'package:epicor/src/view/prdRcpt/screen_job_list.dart';
import 'package:epicor/src/view/qtyAdj/screen_quantity_adjustment.dart';
import 'package:epicor/src/view/rcpt/screen_asn_list.dart';
import 'package:epicor/src/view/returnMtl/screen_return_mtl_list.dart';
import 'package:epicor/src/view/tfReceipt/screen_transfer_receipt_main.dart';
//import 'package:epicor/src/view/tfShipE/screen_transfer_ship_main.dart';
import 'package:epicor/src/view/TFShipment/screen_transfer_shipment_main.dart';
import 'package:epicor/src/view/insp/screen_rcpt_insp_head.dart';
import 'package:epicor/src/view/scan/screen_open_scan.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  bool isLoading = true;
  bool isSubmit = false;

  String company = '';
  String plant = '';

  List<Meun> menus = [];

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
              child: ListView(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          gotoProfile();
                        },
                        child: Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: AppColors.colorWhite,
                            border: Border.all(
                              color: AppColors.colorGray200,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(34),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              size: 36,
                              color: AppColors.colorBlack,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 34,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 24.0,
                        mainAxisSpacing: 20.0,
                        childAspectRatio: 1.3,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: menus.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            gotoMenu(menus[index].ud15Key1);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.colorWhite,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.colorTansprent40,
                                  blurRadius: 4,
                                  offset: const Offset(-2, 2),
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    getIcons(menus[index].ud15Key1),
                                    semanticsLabel: 'Logo',
                                    width: 34,
                                    height: 34,
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    menus[index].ud15Character01,
                                    style: TextStyles.getBold(
                                      16,
                                      color: AppColors.colorPrimary,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 34,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getIcons(key) {
    switch (key) {
      case "TFShipE":
        return "assets/icons/ic_cycle.svg";
      case "TFShipment":
        return "assets/icons/ic_cycle.svg";
      case "QtyAdj":
        return "assets/icons/ic_cycle.svg";
      case "PltStp":
        return "assets/icons/ic_pallet.svg";
      case "OrdPick":
        return "assets/icons/ic_cart.svg";
      case "Ship":
        return "assets/icons/ic_dispatch.svg";
      case "Shipment":
        return "assets/icons/ic_dispatch.svg";
      case "LocTrf":
        return "assets/icons/ic_location.svg";
      case "PrdRcpt":
        return "assets/icons/ic_cycle.svg";
      case "PutAway":
        return "assets/icons/ic_putaway.svg";
      case "Rcpt":
        return "assets/icons/ic_grn.svg";
      case "InvTrf":
        return "assets/icons/ic_cycle.svg";
      case "StockPick":
        return "assets/icons/ic_cycle.svg";
      case "TFReceipt":
        return "assets/icons/ic_cycle.svg";
      case "IssueMtl":
        return "assets/icons/ic_cycle.svg";
      default:
        return "assets/icons/ic_cycle.svg";
    }
  }

  loadData() async {
    company = await sharedPref.getString("userCompnay");
    plant = await sharedPref.getString("userPlant");
    var response = await authServices.getMenuAsync(company);
    var items = response['value'];
    menus.clear();
    for (var item in items) {
      if (item['UD15_CheckBox01']) {
        menus.add(meunFromJson(json.encode(item).toString()));
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  gotoProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ScreenProfile()),
    );
  }

  gotoCustShip() async {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ScreenShipmentMain()),
    );
  }

  gotoTF() async {
    var res = await transferServices.checkFirst();
    var data = res['value'];
    bool isPresent = true;
    for (var plant in data) {
      if (plant['Plant_Plant'] == plant) {
        isPresent = false;
      }
    }
    if (isPresent) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ScreenTransferShipmentMain(),
        ),
      );
    } else {
      showError("Alert", "Entry Not Allow in this Branch");
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
                  style: TextStyles.getBold(16),
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

  gotoMenu(key) {
    switch (key) {
      case "TFShipment":
        gotoTF();
        break;
      case "QtyAdj":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ScreenQuantityAdjustment(),
          ),
        );
        break;
      case "Shipment":
        gotoCustShip();
        break;
      // case "PltStp":
      //   page = nameof(PalletTransferPage);
      //   break;
      // case "OrdPick":
      //   page = nameof(OrderPickingPage);
      //   break;
      // case "Ship":
      //   page = nameof(AssignedPackPage);
      //   break;
      // case "LocTrf":
      //   page = nameof(LocationTransferPage);
      //   break;
      case "PrdRcpt":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ScreenJoblist(),
          ),
        );
        break;
      // case "PutAway":
      //   page = nameof(PutAwayPage);
      //   break;
      case "Rcpt":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ScreenAsnList(
              type: true,
            ),
          ),
        );
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => const ScreenRcptOption(),
        //   ),
        // );
        break;
      // case "InvTrf":
      //   break;
      // case "StockPick":
      //   break;
      case "IssueMtl":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ScreenIssueMtlList(),
          ),
        );
        break;
      case "MisIssue":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ScreenMisIssueMain(),
          ),
        );
        break;
      case "ReturnMtl":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ScreenReturnMtlList(),
          ),
        );
        break;
      case "TFReceipt":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ScreenTransferReceiptMain(),
          ),
        );
        break;
      case "Insp":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ScreenRcptInspHead(),
          ),
        );
        break;
      case "OpScan":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ScreenOpenScan(),
          ),
        );
        break;
      case "TFReceiptScan":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const ScreenTransferScan(),
          ),
        );
        break;
      default:
        break;
    }
  }
}
