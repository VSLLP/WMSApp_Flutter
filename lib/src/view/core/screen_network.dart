import 'package:epicor/core_packages.dart';
import 'package:epicor/src/config/enums/connectivity_status.dart';

class ScreenNetwork extends StatelessWidget {
  final Widget child;

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  ScreenNetwork({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if (connectionStatus == ConnectivityStatus.WiFi ||
        connectionStatus == ConnectivityStatus.Cellular) {
      return child;
    }
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.colorWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 148,
                height: 148,
                decoration: BoxDecoration(
                  color: AppColors.colorGray100,
                  borderRadius: BorderRadius.circular(75),
                ),
                child: Icon(
                  Icons.wifi_off,
                  color: AppColors.colorPrimary,
                  size: 48,
                ),
              ),
              const SizedBox(
                height: 28,
              ),
              Text(
                "No internet connection",
                style: TextStyles.getBold(16),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.colorPrimary,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      "Try Again",
                      style: TextStyles.getRegularScund(
                        12,
                        color: AppColors.colorPrimary,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
