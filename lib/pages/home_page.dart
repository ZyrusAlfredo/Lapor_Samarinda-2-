import 'package:flutter/material.dart';
import '../models/laporan.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<LaporanInfrastruktur> laporanList = [];

  /// AMBIL DATA DARI SUPABASE
  Future<void> fetchLaporan() async {

    final data = await supabase
        .from('laporan')
        .select()
        .order('tanggal', ascending: false);

    setState(() {
      laporanList = data
          .map<LaporanInfrastruktur>((e) => LaporanInfrastruktur.fromJson(e))
          .toList();
    });

  }

  @override
  void initState() {
    super.initState();
    fetchLaporan();
  }

  /// STATISTIK
  int get totalLaporan => laporanList.length;

  int get selesai =>
      laporanList.where((l) => l.status == "Selesai").length;

  int get proses =>
      laporanList.where((l) => l.status == "Proses").length;

  Widget buildStatCard(String title, int value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKategori(
      BuildContext context, String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/list",
          arguments: title,
        );
      },
      child: SizedBox(
        width: 90,
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 34,
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData getKategoriIcon(String kategori) {
    switch (kategori) {
      case "Jalan & Transportasi":
        return Icons.alt_route;
      case "Lampu Jalanan":
        return Icons.lightbulb;
      case "Kebersihan & Sampah":
        return Icons.delete;
      default:
        return Icons.report_problem;
    }
  }

  Color getKategoriColor(String kategori) {
    switch (kategori) {
      case "Jalan & Transportasi":
        return Colors.brown;
      case "Lampu Jalanan":
        return Colors.orange;
      case "Kebersihan & Sampah":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Proses":
        return Colors.orange;
      case "Selesai":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: RefreshIndicator(
        onRefresh: fetchLaporan,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 33, 147, 77),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// BARIS ATAS (LOGO + BUTTON)
                    Row(
                      children: [

                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.asset(
                            "assets/images/LogoKaltim.png",
                            width: 70,
                          ),
                        ),

                        const SizedBox(width: 4),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 182, 164, 0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Lapor",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(width: 4),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 154, 10, 0),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Samarinda",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const Spacer(),

                        /// DARK MODE
                        IconButton(
                          icon: const Icon(Icons.dark_mode, color: Colors.white),
                          onPressed: () {
                            themeController.toggleTheme();
                          },
                        ),

                        /// LOGOUT
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () async {
                            await supabase.auth.signOut();

                            if (!context.mounted) return;

                            Navigator.pushReplacementNamed(context, "/");
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 1),

                    Padding(
                      padding: const EdgeInsets.only(left: 74),
                      child: const Text(
                        "Laporkan dan Buat Samarinda Jauh Lebih Baik",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Divider(
                      color: Colors.white.withOpacity(0.3),
                    ),

                    const SizedBox(height: 10),

                    /// STATISTIK
                    Row(
                      children: [
                        buildStatCard("Total", totalLaporan),
                        buildStatCard("Selesai", selesai),
                        buildStatCard("Proses", proses),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// TOMBOL LAPOR
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.warning),
                        label: const Text(
                          "Laporkan Sekarang",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {

                          final result = await Navigator.pushNamed(context, "/form");

                          if (result == true) {
                            fetchLaporan();
                          }

                        },
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// KATEGORI
                    const Text(
                      "Kategori Fasilitas",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildKategori(context,"Jalan & Transportasi",Icons.alt_route,Colors.brown),
                        buildKategori(context,"Lampu Jalanan",Icons.lightbulb,Colors.orange),
                        buildKategori(context,"Kebersihan & Sampah",Icons.delete,Colors.green),
                      ],
                    ),

                    const SizedBox(height: 25),

                    /// LAPORAN TERBARU
                    const Text(
                      "Laporan Terbaru",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    /// LIST LAPORAN
                    ...laporanList.map((laporan) {

                      final icon = getKategoriIcon(laporan.kategori);
                      final color = getKategoriColor(laporan.kategori);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        child: ListTile(
                          leading: Icon(icon, color: color),
                          title: Text(
                            laporan.nama,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(laporan.lokasi),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: getStatusColor(laporan.status)
                                  .withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              laporan.status,
                              style: TextStyle(
                                color: getStatusColor(laporan.status),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              "/detail",
                              arguments: laporan,
                            );

                            if (result == true) {
                              fetchLaporan();
                            }
                          },
                        ),
                      );
                    }),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}