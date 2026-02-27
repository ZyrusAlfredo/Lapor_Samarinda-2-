import 'package:flutter/material.dart';
import 'pages/halaman_utama.dart';

void main() {
  runApp(const LaporSamarinda());
}

class LaporSamarinda extends StatelessWidget {
  const LaporSamarinda({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lapor Samarinda',
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: const HalamanUtama(),
    );
  }
}