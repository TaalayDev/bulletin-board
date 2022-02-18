import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/user_controller.dart';
import '../../../resources/theme.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'settings'.tr),
      body: GetBuilder<UserController>(builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              CustomCard(
                child: SizedBox(
                  width: double.infinity,
                  child: Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFc4c4c4),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          InkWell(
                            onTap: () => selectPickerSource(controller),
                            child: const _Avatar(),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: Get.theme.primary,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Feather.camera,
                                size: 15,
                                color: Get.theme.onPrimary,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text('Личные данные'),
              ),
              CustomCard(
                child: Column(
                  children: const [
                    ListTile(title: Text('Имя')),
                    Divider(height: 1),
                    ListTile(title: Text('Имя')),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void selectPickerSource(UserController controller) {
    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      controller.pickImage();
      return;
    }

    Get.bottomSheet(
      Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Feather.image),
              title: Text('Галерея'),
              onTap: () async {
                Get.back();
                controller.pickImage();
              },
            ),
            ListTile(
              leading: Icon(Feather.camera),
              title: Text('Камера'),
              onTap: () async {
                Get.back();
                controller.pickCameraImage();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) {
        if (controller.image != null) {
          if (kIsWeb) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: controller.image != null
                  ? Image.network(
                      controller.image!.path,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    )
                  : const SizedBox(),
            );
          }

          return ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: controller.image != null
                ? Image.file(
                    controller.image!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  )
                : const SizedBox(),
          );
        }

        if (controller.user?.avatar != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: AppNetworkImage(
              imageUrl: controller.user!.avatar!,
            ),
          );
        }

        return const Icon(
          Feather.user,
          color: Colors.white,
          size: 80,
        );
      },
    );
  }
}
