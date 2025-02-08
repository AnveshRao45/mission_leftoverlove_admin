import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mission_leftoverlove_admin/core/services/api_const.dart';
import 'package:mission_leftoverlove_admin/features/auth/auth_controller.dart';
import 'package:mission_leftoverlove_admin/features/splash/splash_screen.dart';
import 'package:mission_leftoverlove_admin/route/navigation.dart';
import 'package:mission_leftoverlove_admin/route/router.dart';
import 'package:mission_leftoverlove_admin/utils/utils.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: projectUrl,
    anonKey: anonPublic,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (p0, p1, p2) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: snackbarKey,
          navigatorKey: Navigation.instance.navigationKey,
          onGenerateRoute: AppRouter.generateRoute,
          theme: ThemeData(
            textTheme: GoogleFonts.robotoTextTheme(),
            //  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: SplashScreen(),
          // home: authState.when(
          //   data: (user) => user != null ? BottomNavScreen() : AuthScreen(),
          //   loading: () =>
          //       Scaffold(body: Center(child: CircularProgressIndicator())),
          //   error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),
          // ),
        );
      },
    );
  }
}

// supabase sign in using email and password
