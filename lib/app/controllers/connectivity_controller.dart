import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  final _connectivity = Connectivity();
  final isOffline = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkInitial();
    _listenChanges();
  }

  Future<void> checkInitial() async {
    final result = await _connectivity.checkConnectivity();
    isOffline.value = result.contains(ConnectivityResult.none);
  }

  void _listenChanges() {
    _connectivity.onConnectivityChanged.listen((result) {
      isOffline.value = result.contains(ConnectivityResult.none);
    });
  }
}