import 'package:epicor/core_packages.dart';

class ScreenBackground extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ScreenBackground({
    super.key,
    required this.child,
    required this.isLoading,
  });

  @override
  State<ScreenBackground> createState() => _ScreenBackgroundState();
}

class _ScreenBackgroundState extends State<ScreenBackground> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned(
            top: -190,
            left: -100,
            child: Container(
              width: 380,
              height: 380,
              decoration: BoxDecoration(
                color: AppColors.colorPrimary,
                borderRadius: BorderRadius.circular(200),
              ),
            ),
          ),
          Positioned(
            top: -160,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                color: AppColors.colorAssent,
                borderRadius: BorderRadius.circular(200),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: AppColors.colorAssent,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
            child: widget.child,
          ),
          widget.isLoading
              ? Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppColors.colorTansprent40,
                  child: Center(
                    child: Lottie.asset(
                      'assets/anim/anim-bgLoading.json',
                      width: 100,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
