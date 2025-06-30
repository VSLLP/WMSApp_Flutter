import 'package:epicor/core_packages.dart';

import 'package:epicor/src/view/auth/screen_login.dart';
import 'package:epicor/src/view/core/screen_network.dart';

import 'package:device_info_plus/device_info_plus.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  String uid = "";

  int qusSize = 0;

  bool isAuth = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenNetwork(
      child: Scaffold(
        backgroundColor: AppColors.colorWhite,
        body: Column(
          children: [
            Expanded(
              child: SizedBox(
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/splash.svg",
                    semanticsLabel: 'Logo',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> loadData() async {
    isAuth = await sharedPref.getBool("userStatus");
    Timer(const Duration(seconds: 2), onDoneLoading);
  }

  requestPermissions() async {
    bool permissionGrant = false;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;
      if (sdkInt <= 32) {
        final status = await Permission.storage.request().isGranted;
        permissionGrant = status;
      } else {
        permissionGrant = true;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request().isGranted;
      permissionGrant = status;
    }

    if (!permissionGrant) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Permission Required"),
          content: const Text(
            "Storage permission was not granted. The app will now close.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      loadData();
    }
    setState(() {});
  }

  Future<void> onDoneLoading() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const ScreenLogin()),
    );
  }
}
