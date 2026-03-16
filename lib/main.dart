import 'package:flutter/material.dart';
import 'package:lapor_samarinda/pages/auth_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/laporan.dart';
import 'pages/laporan_list_page.dart';
import 'pages/form_laporan_page.dart';
import 'pages/detail_laporan_page.dart';
import 'pages/home_page.dart';

import 'theme/app_theme.dart';
import 'theme/theme_controller.dart';

final supabase = Supabase.instance.client;

/// THEME CONTROLLER GLOBAL
final themeController = ThemeController();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const LaporSamarinda());
}

class LaporSamarinda extends StatelessWidget {
  const LaporSamarinda({super.key});

  @override
  Widget build(BuildContext context) {

    /// AnimatedBuilder agar UI rebuild saat theme berubah
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, child) {

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Lapor Samarinda',

          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,

          /// THEME MODE DARI CONTROLLER
          themeMode: themeController.themeMode,

          home: const AuthPage(),

          routes: {
            "/home": (context) => const HomePage(),
            "/list": (context) => const LaporanListPage(),
            "/form": (context) => const FormLaporanPage(),
            "/detail": (context) {
              final laporan =
                  ModalRoute.of(context)!.settings.arguments as LaporanInfrastruktur;

              return DetailLaporanPage(laporan: laporan);
            },
          },
        );
      },
    );
  }
}