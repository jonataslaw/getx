import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
              "https://upload.wikimedia.org/wikipedia/en/e/ed/Nobel_Prize.png",
            ),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Scaffold(
            backgroundColor: Colors.black.withValues(alpha: 0.6),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              title: Text(
                'nobel_by_country'.tr,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 28),
                onPressed: () {
                  Get.snackbar(
                    'New Feature',
                    'Coming soon!',
                    snackPosition: SnackPosition.bottom,
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    colorText: Colors.black,
                    borderRadius: 10,
                    duration: Duration(seconds: 3),
                    animationDuration: Duration(milliseconds: 500),
                    boxShadows: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  );
                },
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            Colors.blueAccent.withValues(alpha: 0.8),
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 8,
                        shadowColor: Colors.blueAccent.withValues(alpha: 0.5),
                      ),
                      onPressed: () {
                        Get.updateLocale(Get.locale?.languageCode == 'en'
                            ? const Locale('pt', 'BR')
                            : const Locale('en', 'EN'));
                      },
                      child: Text(
                        'update_language'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 18,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: controller.obx(
                        (state) {
                          return ListView.builder(
                            itemCount: state.length,
                            itemBuilder: (context, index) {
                              final country = state[index];
                              return Card(
                                elevation: 8,
                                margin: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                color: Colors.white.withValues(alpha: 0.9),
                                child: ListTile(
                                  onTap: () async {
                                    final data = await Get.toNamed(
                                        '/home/details',
                                        arguments: country);
                                    if (data != null) Get.log(data);
                                  },
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 16),
                                  leading: Hero(
                                    tag: 'flag_${country.countryCode}',
                                    child: CircleAvatar(
                                      radius: 32,
                                      backgroundImage: NetworkImage(
                                        "https://flagpedia.net/data/flags/normal/${country.countryCode.toLowerCase()}.png",
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    country.country,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 20,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      color: Colors.blueAccent, size: 24),
                                ),
                              );
                            },
                          );
                        },
                        onLoading: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                        onError: (error) => Center(
                          child: Text(
                            'Error: $error',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
