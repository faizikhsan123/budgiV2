import 'package:budgi/app/controllers/connectivity_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectivityWrapper extends StatelessWidget {
  final Widget child;
  const ConnectivityWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final connectivityC = Get.find<ConnectivityController>();

    return Obx(() {
      if (!connectivityC.isOffline.value) return child;

      return Stack(
        children: [
          child,
          Positioned.fill(
            child: Material(
              color: Colors.black.withOpacity(0.85),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        size: 64,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'no_connection'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'check_connection'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: connectivityC.checkInitial,
                        icon: const Icon(Icons.refresh_rounded),
                        label: Text('try_again'.tr),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}