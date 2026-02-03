import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/routing/app_routes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Splash Page',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const Text('Welcome to the App!', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                context.go(AppRoutes.menu);
              },
              child: const Text(
                'Menu',
                style: TextStyle(fontSize: 16, color: Colors.orange),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
