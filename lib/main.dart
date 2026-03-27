import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/modules/login/controllers/login_controller.dart';
import 'package:budgi/firebase_options.dart';
import 'package:budgi/splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(NyApp());
}

class NyApp extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);
  final pageC = Get.put(PageIndexController(), permanent: true);
  final loginC = Get.put(LoginController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Budgi",
      home: SplashGate(), // 👈 Mulai dari sini
      getPages: AppPages.routes,
    );
  }
}

class SplashGate extends StatefulWidget {
  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  @override
  void initState() {
    super.initState();
    _goToAuth();
  }

  Future<void> _goToAuth() async {
    await Future.delayed(const Duration(seconds:3)); // ⏱️ Durasi splash
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => AuthWrapper()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Splashscreen(); // 👈 Nama class splash screen kamu
  }
}

class AuthWrapper extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Connectivity connectivity = Connectivity();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: connectivity.onConnectivityChanged,
      builder: (context, connSnapshot) {
        if (connSnapshot.hasData &&
            connSnapshot.data!.contains(ConnectivityResult.none)) {
          return const Scaffold(
            body: Center(child: Text("❌ Tidak ada koneksi internet")),
          );
        }

        return StreamBuilder<User?>(
          stream: auth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAllNamed(Routes.HOME);
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAllNamed(Routes.LOGIN);
              });
            }

            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }
}