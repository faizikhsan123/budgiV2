import 'package:budgi/app/bahasa/translate.dart';
import 'package:budgi/app/controllers/auth_controller.dart';
import 'package:budgi/app/controllers/connectivity_controller.dart';
import 'package:budgi/app/controllers/page_index_controller.dart';
import 'package:budgi/app/modules/login/controllers/login_controller.dart';
import 'package:budgi/app/modules/profile/controllers/profile_controller.dart';
import 'package:budgi/app/modules/scan_bill/controllers/scan_bill_controller.dart';
import 'package:budgi/app/modules/transaksi/controllers/transaksi_controller.dart';
import 'package:budgi/app/modules/widgets/connectivity_wrapper.dart';
import 'package:budgi/app/modules/widgets/loading_awal.dart';
import 'package:budgi/firebase_options.dart';
import 'package:budgi/introduction.dart';
import 'package:budgi/splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(NyApp());
}

class NyApp extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);
  final pageC = Get.put(PageIndexController(), permanent: true);
  final loginC = Get.put(LoginController(), permanent: true);
  final connectivityC = Get.put(ConnectivityController(), permanent: true);
  final profileC = Get.put(ProfileController(), permanent: true);
  final scanC = Get.put(ScanBillController(), permanent: true);
  final transaksiC = Get.put(TransaksiController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Budgi",
      home: SplashGate(),
      getPages: AppPages.routes,
      translations: MyTranslate(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      builder: (context, child) => ConnectivityWrapper(child: child!),
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
    if (!mounted) return;

    final onboardingDone = GetStorage().read('onboarding_done') ?? false;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => onboardingDone ? AuthWrapper() : OnboardingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Splashscreen();
}

class AuthWrapper extends StatefulWidget {
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final _connectivityC = Get.find<ConnectivityController>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  bool _hasRedirected = false;

  @override
  void initState() {
    super.initState();
    _init();

    // Listen koneksi dari ConnectivityController yang sudah ada
    ever(_connectivityC.isOffline, (offline) {
      if (!offline && !_hasRedirected) _redirect();
    });
  }

  Future<void> _init() async {
    setState(() => _isLoading = true);
    await _connectivityC.checkInitial();
    setState(() => _isLoading = false);

    if (!_connectivityC.isOffline.value) await _redirect();
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
      final balance = doc.data()?["balance"];
      _hasRedirected = true;

      if (!doc.exists || doc.data() == null) {
        Get.offAllNamed(Routes.LOGIN);
      } else if (balance == null) {
        Get.offAllNamed(Routes.COMPLETE_BALANCE);
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    } catch (_) {
      if (mounted) setState(() => _connectivityC.isOffline.value = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child:loading_awal()));
    }

    return Obx(() {
      if (_connectivityC.isOffline.value) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.wifi_off_rounded,
                  size: 72,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'no_connection'.tr,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  'check_connection'.tr,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: _init,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text('try_again'.tr),
                ),
              ],
            ),
          ),
        );
      }
      return const Scaffold(body: Center(child: loading_awal()));
    });
  }
}
