import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';
import 'theme.dart';
import 'app.dart';
import 'services/auth_service.dart';
import 'pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }
  runApp(const RedesignedApp());
}

class RedesignedApp extends StatefulWidget {
  const RedesignedApp({super.key});

  @override
  State<RedesignedApp> createState() => _RedesignedAppState();
}

class _RedesignedAppState extends State<RedesignedApp> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    // Artificial delay to show the splash screen for 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: const SplashPage(),
      );
    }

    return StreamBuilder(
      stream: AuthService().authState(),
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Laza',
          theme: buildTheme(),
          home: snapshot.connectionState == ConnectionState.waiting
              ? const SplashPage()
              : AppRoot(authUser: snapshot.data),
          onGenerateRoute: AppRoutes.onGenerateRoute,
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
