import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:monetization_module/monetization_module.dart';
import '../ui/glass_widgets.dart';
import 'fortune_cookie_screen.dart';
import 'tarot_screen.dart';
import 'test_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Dark Navy
      body: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8B5CF6).withOpacity(0.15), // Neon Purple
                boxShadow: [
                  BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.2), blurRadius: 100)
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4C1D95).withOpacity(0.2),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF4C1D95).withOpacity(0.2), blurRadius: 100)
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'home_title'.tr,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2.0,
                  ),
                ),
                Text(
                  'home_subtitle'.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 50),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      GlassCard(
                        onTap: () => Get.to(() => const FortuneCookieScreen()),
                        child: Row(
                          children: [
                            const Text('🥠', style: TextStyle(fontSize: 48)),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    'home_fortune_title'.tr, 
                                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    minFontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text('home_fortune_desc'.tr, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GlassCard(
                        onTap: () => Get.to(() => const TarotScreen()),
                        child: Row(
                          children: [
                            const Text('🔮', style: TextStyle(fontSize: 48)),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    'home_tarot_title'.tr, 
                                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    minFontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text('home_tarot_desc'.tr, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GlassCard(
                        onTap: () => Get.to(() => const TestScreen()),
                        child: Row(
                          children: [
                            const Text('📝', style: TextStyle(fontSize: 48)),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(
                                    'home_test_title'.tr, 
                                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    minFontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Text('home_test_desc'.tr, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: const AdBannerWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
