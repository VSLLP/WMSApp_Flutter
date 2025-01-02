import 'package:epicor/core_packages.dart';
import 'package:epicor/src/config/enums/connectivity_status.dart';
import 'package:epicor/src/services/utils/connectivity_service.dart';
import 'package:epicor/src/view/screen_splash.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<ConnectivityStatus>(
          create: (context) =>
              ConnectivityService().connectionStatusController.stream,
          initialData: ConnectivityStatus.Offline,
        ),
      ],
      child: MaterialApp(
        title: 'Co Talk',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.colorPrimary,
          splashColor: Colors.transparent,
          highlightColor: AppColors.colorAssent,
          secondaryHeaderColor: AppColors.colorAssent,
          fontFamily: 'Roboto',
        ),
        home: const ScreenSplash(),
      ),
    );
  }
}
