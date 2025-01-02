import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/insp/screen_rcpt_insp_head.dart';

class ScreenInspMain extends StatefulWidget {
  const ScreenInspMain({super.key});

  @override
  State<ScreenInspMain> createState() => _ScreenInspMainState();
}

class _ScreenInspMainState extends State<ScreenInspMain> {
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
                            'Inspection Menu',
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
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          GestureDetector(
                            onTap: () {
                              gotoRcptInsp();
                            },
                            child: Container(
                              height: 48,
                              width: 240,
                              decoration: BoxDecoration(
                                color: AppColors.colorWhite,
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.colorBlack,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Text(
                                    'Receipt Inspection',
                                    style: TextStyles.getBold(
                                      16,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                          GestureDetector(
                            onTap: () {
                              gotoJobInsp();
                            },
                            child: Container(
                              height: 48,
                              width: 240,
                              decoration: BoxDecoration(
                                color: AppColors.colorWhite,
                                border: Border.all(
                                  width: 1,
                                  color: AppColors.colorBlack,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Text(
                                    'Job Inspection',
                                    style: TextStyles.getBold(
                                      16,
                                      color: AppColors.colorBlack,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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
    setState(() {
      isLoading = false;
    });
  }

  gotoRcptInsp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ScreenRcptInspHead(),
      ),
    );
  }

  gotoJobInsp() {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("In development"),
        backgroundColor: AppColors.colorAssent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
