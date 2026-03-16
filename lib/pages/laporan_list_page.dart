import 'package:flutter/material.dart';
import '../main.dart';
import '../models/laporan.dart';

class LaporanListPage extends StatefulWidget {
  const LaporanListPage({super.key});

  @override
 State<LaporanListPage> createState() => _LaporanListPageState();
}

class _LaporanListPageState extends State<LaporanListPage> {

  late Future<List<Map<String, dynamic>>> futureLaporan;
  String? kategoriFilter;

  Future<List<Map<String, dynamic>>> fetchLaporan(String? kategori) async {

    final query = supabase.from('laporan').select();

    final data = kategori == null
        ? await query.order('tanggal', ascending: false)
        : await query
            .eq('kategori', kategori)
            .order('tanggal', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    kategoriFilter =
        ModalRoute.of(context)!.settings.arguments as String?;

    futureLaporan = fetchLaporan(kategoriFilter);
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
        return Colors.orange;

      case "Lampu Jalanan":
        return Colors.yellow.shade700;

      case "Kebersihan & Sampah":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {

    final currentUserId = supabase.auth.currentUser?.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          kategoriFilter ?? "Semua Laporan",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 147, 77),
        foregroundColor: Colors.white,
      ),

      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureLaporan,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada laporan"));
          }

          List<Map<String, dynamic>> laporan = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: laporan.length,
            itemBuilder: (context, index) {

              final item = laporan[index];

              final kategori = item['kategori'] ?? "";
              final color = getKategoriColor(kategori);

              Color statusColor = Colors.orange;

              if (item['status'] == "Selesai") {
                statusColor = Colors.green;
              }

              bool isOwner = item['user_id'] == currentUserId;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black12),
                ),
                child: ListTile(

                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      getKategoriIcon(kategori),
                      color: color,
                    ),
                  ),

                  title: Text(
                    item['nama'] ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(item['lokasi'] ?? ""),

                      const SizedBox(height: 2),

                      Text(
                        kategori,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),

                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text(
                        item['status'] ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),

                      if (isOwner)
                        const Text(
                          "Laporan Anda",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),

                  onTap: () {

                    final laporanData = LaporanInfrastruktur.fromJson(item);

                    Navigator.pushNamed(
                      context,
                      "/detail",
                      arguments: laporanData,
                    );

                  },
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        child: const Icon(Icons.add),
        onPressed: () async {

          final result = await Navigator.pushNamed(context, "/form");

          if (result == true) {
            setState(() {
              futureLaporan = fetchLaporan(kategoriFilter);
            });
          }
        },
      ),
    );
  }
}