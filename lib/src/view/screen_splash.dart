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
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt > 32) {
        loadData();
      } else {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();
        if (statuses[Permission.storage] == PermissionStatus.granted) {
          loadData();
        } else {
          SystemNavigator.pop();
        }
      }
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
