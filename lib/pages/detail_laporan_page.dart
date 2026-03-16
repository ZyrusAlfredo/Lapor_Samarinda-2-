import 'package:flutter/material.dart';
import '../models/laporan.dart';
import '../main.dart';
import 'form_laporan_page.dart';

class DetailLaporanPage extends StatefulWidget {
  final LaporanInfrastruktur laporan;

  const DetailLaporanPage({
    super.key,
    required this.laporan,
  });

  @override
  State<DetailLaporanPage> createState() => _DetailLaporanPageState();
}

class _DetailLaporanPageState extends State<DetailLaporanPage> {

  int currentIndex = 0;

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

  List<String> getFotoList() {
    List<String> fotoList = [];

    if (widget.laporan.foto != null && widget.laporan.foto!.isNotEmpty) {
      fotoList.add(widget.laporan.foto!);
    }

    if (widget.laporan.fotoSelesai != null &&
        widget.laporan.fotoSelesai!.isNotEmpty) {
      fotoList.add(widget.laporan.fotoSelesai!);
    }

    return fotoList;
  }

  @override
  Widget build(BuildContext context) {

    final laporan = widget.laporan;
    final fotoList = getFotoList();

    /// CEK PEMILIK LAPORAN
    final currentUserId = supabase.auth.currentUser?.id;
    final isOwner = laporan.userId == currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Laporan"),
        backgroundColor: const Color.fromARGB(255, 33, 147, 77),
        foregroundColor: Colors.white,
      ),

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      /// TOMBOL EDIT + HAPUS (HANYA MILIK SENDIRI)
      bottomNavigationBar: isOwner
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [

                  /// EDIT
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text("Edit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {

                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FormLaporanPage(laporan: laporan),
                          ),
                        );

                        if (!context.mounted) return;

                        if (result == true) {
                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// HAPUS
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: const Text("Hapus"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {

                        final confirm = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Hapus Laporan"),
                              content: const Text(
                                "Apakah Anda yakin ingin menghapus laporan ini?",
                              ),
                              actions: [

                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: const Text("Batal"),
                                ),

                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: const Text(
                                    "Hapus",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm == true) {

                          await supabase
                              .from('laporan')
                              .delete()
                              .eq('id', laporan.id);

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Laporan berhasil dihapus"),
                            ),
                          );

                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          : null,

      /// BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// NAMA
            Text(
              laporan.nama,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            /// STATUS
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: getStatusColor(laporan.status)
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                laporan.status,
                style: TextStyle(
                  color: getStatusColor(laporan.status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// FOTO
            const Text(
              "Foto Bukti",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            if (fotoList.isNotEmpty)
              Column(
                children: [

                  SizedBox(
                    height: 250,

                    child: PageView.builder(
                      itemCount: fotoList.length,

                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },

                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),

                          child: Image.network(
                            fotoList[index],
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      fotoList.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentIndex == index ? 12 : 8,
                        height: currentIndex == index ? 12 : 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentIndex == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).dividerColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              const Text("Tidak ada foto"),

            const SizedBox(height: 20),

            const Text(
              "Lokasi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(laporan.lokasi),

            const SizedBox(height: 20),

            const Text(
              "Kategori",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(laporan.kategori),

            const SizedBox(height: 20),

            const Text(
              "Deskripsi Kerusakan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              laporan.deskripsi,
              style: const TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 20),

            const Text(
              "Tanggal Laporan",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 4),

            Text(
              "${laporan.tanggal.day}/${laporan.tanggal.month}/${laporan.tanggal.year}",
            ),

            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}