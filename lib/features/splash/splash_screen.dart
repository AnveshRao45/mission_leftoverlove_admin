import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_leftoverlove_admin/core/theme/theme.dart';
import 'package:mission_leftoverlove_admin/features/splash/splash_controller.dart';
import 'package:mission_leftoverlove_admin/route/app_router.dart';
import 'package:mission_leftoverlove_admin/utils/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const id = AppRoutes.splashScreen;
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      navigate(); // Delaying navigation until after the build phase
    });
  }

  @override
  void didChangeDependencies() {
    print("SPLASH : didChangedependencies");
    super.didChangeDependencies();
  }

  navigate() async {
    ref.read(splashRef).checkAndRedirect(ref);
  }

  @override
  Widget build(BuildContext context) {
    print("SPLASH: build method called");
    return Scaffold(
      body: Stack(
        children: [
          // Positioned.fill(
          //   // child: Image.network(
          //   //   'https://img.freepik.com/free-photo/world-health-day-celebration-with-healthy-food_23-2151183736.jpg?t=st=1734865904~exp=1734869504~hmac=1c0a514828e5be2c8a9013f014e4a2ea4a45eea4c007f61a4d4a421bc7a33cad&w=826', // Replace with your image path
          //   //   fit: BoxFit.cover,
          //   // ),
          // ),
          Center(
            child: Container(
                margin: const EdgeInsets.only(bottom: 48),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(48),
                ),
                height: 50.h,
                width: 80.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   "assets/logo.png",
                    //   scale: 12,
                    // ),
                    Text(
                      "Leftoverlove",
                      style: TextStyle(
                          fontSize: 24.sp,
                          color: secondaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Turning Surplus into Smiles!",
                      style: TextStyle(
                          color: secondaryColor, fontWeight: FontWeight.bold),
                    ),
                    sbh(16),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
