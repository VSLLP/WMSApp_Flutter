import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';
import 'package:epicor/src/view/rcpt/screen_asn_list.dart';

class ScreenRcptOption extends StatefulWidget {
  const ScreenRcptOption({super.key});

  @override
  State<ScreenRcptOption> createState() => _ScreenRcptOptionState();
}

class _ScreenRcptOptionState extends State<ScreenRcptOption> {
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
                            'Receipt Menu (GRN)',
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
                              gotoFactory();
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
                                    'Factory Receipt',
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
                              gotoBranch();
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
                                    'Branch Receipt',
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

  gotoFactory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ScreenAsnList(
          type: false,
        ),
      ),
    );
  }

  gotoBranch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ScreenAsnList(
          type: true,
        ),
      ),
    );
  }
}
