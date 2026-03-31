import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/modules/login/controllers/login_controller.dart';
import 'package:budgi/firebase_options.dart';
import 'package:budgi/introduction.dart';
import 'package:budgi/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
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
      home: SplashGate(),
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
    _goToNext();
  }

  Future<void> _goToNext() async {
    await Future.delayed(const Duration(seconds: 3));

    final box = GetStorage();
    final onboardingDone = box.read('onboarding_done') ?? false;

    if (mounted) {
      if (!onboardingDone) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => OnboardingScreen()),
        );
      } else {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => AuthWrapper()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Splashscreen();
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();

  bool _isOffline = false;
  bool _isLoading = true;
  bool _hasRedirected = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasRedirected = false;
      });
    }

    final result = await _connectivity.checkConnectivity();
    final offline = result.contains(ConnectivityResult.none);

    if (mounted) {
      setState(() {
        _isOffline = offline;
        _isLoading = false;
      });
    }

    if (!offline) {
      await _redirect();
    }

    _connectivity.onConnectivityChanged.listen((result) async {
      final nowOffline = result.contains(ConnectivityResult.none);
      if (mounted) {
        setState(() => _isOffline = nowOffline);
      }
      if (!nowOffline && !_hasRedirected) {
        await _redirect();
      }
    });
  }

  Future<void> _redirect() async {
    if (_hasRedirected) return;

    final user = _auth.currentUser;

    if (user == null) {
      _hasRedirected = true;
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    try {
      final doc = await _firestore.collection("users").doc(user.uid).get();
      final data = doc.data();

      _hasRedirected = true;

      if (data == null) {
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      // ✅ Samakan dengan auth_controller — hanya cek phone & tanggal_lahir
      final phone = data["phone"];
      final tanggalLahir = data["tanggal_lahir"];
      final balance = data["balance"];

      if (phone == null || tanggalLahir == null) {
        Get.offAllNamed(Routes.COMPLETE_PROFILE);
        return;
      }

      if (balance == null) {
        Get.offAllNamed(Routes.COMPLETE_BALANCE);
        return;
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isOffline = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isOffline) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 72, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                "No Connection Internet",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              const Text(
                "Check your connection and try again",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _init,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Try Again"),
              ),
            ],
          ),
        ),
      );
    }

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
