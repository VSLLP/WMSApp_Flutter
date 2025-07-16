import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/core/screen_background.dart';
import 'package:epicor/src/view/core/screen_network.dart';

class ScreenProfile extends StatefulWidget {
  const ScreenProfile({super.key});

  @override
  State<ScreenProfile> createState() => _ScreenProfileState();
}

class _ScreenProfileState extends State<ScreenProfile> {
  bool isLoading = true;
  bool isSubmit = false;
  bool isCam = false;

  String userId = "";

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
                            'My Profile',
                            style: TextStyles.getBold(
                              22,
                              color: AppColors.colorWhite,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              color: Colors.transparent,
                              child: Center(
                                child: Icon(
                                  Icons.verified_user_rounded,
                                  size: 28,
                                  color: AppColors.colorPrimary,
                                ),
                              ),
                            ),
                            Text(
                              userId,
                              style: TextStyles.getBold(
                                18,
                                color: AppColors.colorTertiary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              color: Colors.transparent,
                              child: Center(
                                child: Icon(
                                  Icons.person,
                                  size: 28,
                                  color: AppColors.colorPrimary,
                                ),
                              ),
                            ),
                            Text(
                              "WMSManager WMSManager",
                              style: TextStyles.getBold(
                                16,
                                color: AppColors.colorTertiary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              color: Colors.transparent,
                              child: Center(
                                child: Icon(
                                  Icons.email_rounded,
                                  size: 28,
                                  color: AppColors.colorPrimary,
                                ),
                              ),
                            ),
                            Text(
                              "",
                              style: TextStyles.getBold(
                                18,
                                color: AppColors.colorTertiary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              color: Colors.transparent,
                              child: Center(
                                child: Icon(
                                  Icons.call,
                                  size: 28,
                                  color: AppColors.colorPrimary,
                                ),
                              ),
                            ),
                            Text(
                              "",
                              style: TextStyles.getBold(
                                18,
                                color: AppColors.colorTertiary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              color: Colors.transparent,
                              child: Center(
                                child: Icon(
                                  Icons.camera,
                                  size: 28,
                                  color: AppColors.colorPrimary,
                                ),
                              ),
                            ),
                            Text(
                              "Camera Scan",
                              style: TextStyles.getBold(
                                18,
                                color: AppColors.colorTertiary,
                              ),
                            ),
                            Expanded(child: Container()),
                            Switch(
                              value: isCam,
                              onChanged: (val) => {saveCamera(val)},
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!isSubmit) {
                              logout();
                            }
                          },
                          child: Container(
                            height: 38,
                            width: 100,
                            decoration: BoxDecoration(
                              color: AppColors.colorWhite,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.colorTansprent40,
                                  blurRadius: 2,
                                  offset: const Offset(-2, -2),
                                )
                              ],
                            ),
                            child: Center(
                              child: isSubmit
                                  ? Lottie.asset(
                                      'assets/anim/anim-btnLoading.json',
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8.0,
                                      ),
                                      child: Text(
                                        'Logout',
                                        style: TextStyles.getBold(
                                          14,
                                          color: AppColors.colorPrimary,
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "App Version v1.0.11",
                    style: TextStyles.getRegularScund(12),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Build Date: 16, Jul 2025",
                    style: TextStyles.getRegularScund(12),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "@Copyright 2022 All Rights resserve",
                    style: TextStyles.getRegularScund(14),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('assets/images/aadya_logo.png'),
                        width: 100,
                      ),
                      Text(
                        "Aadya Web Services",
                        style: TextStyles.getRegularScund(14),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
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
    userId = await sharedPref.getString("userName");
    isCam = await sharedPref.getBool("isCam");
    setState(() {
      isLoading = false;
    });
  }

  saveCamera(bool value) async {
    await sharedPref.setBool("isCam", value);
    if (value) {
      final status = await Permission.camera.request().isGranted;
      if (!status) {
        showError(
          "Permission error",
          "Please allow camera permission in order use the barcode scanner!",
        );
      }
    }
    setState(() {
      isCam = value;
    });
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

  logout() async {
    await sharedPref.deleteAll();
  }
}
