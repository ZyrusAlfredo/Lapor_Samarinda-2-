// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../models/laporan.dart';
import 'form_laporan.dart';

class HalamanUtama extends StatefulWidget{
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  List<LaporanInfrastruktur> daftarLaporan = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text(
        "Lapor Samarinda",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 174, 161, 41),
      elevation: 4,
      ),

      body: daftarLaporan.isEmpty
      ? const Center(child: Text("Belum Ada Laporan"))
      : ListView.builder(
        itemCount: daftarLaporan.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.note_alt, color: Color.fromARGB(255, 88, 83, 59)),
              title: Text(daftarLaporan[index].nama),
              subtitle: Text(daftarLaporan[index].lokasi),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue,),
                    onPressed: () async {
                      final hasilEdit = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormLaporan(laporan: daftarLaporan[index]),
                        ),
                      );

                      if (hasilEdit != null){
                        setState(() {
                          daftarLaporan[index] = hasilEdit;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: (){
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Hapus Laporan"),
                          content: const Text("Apakah Anda Yakin Ingin Menghapus Laporan Ini?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  daftarLaporan.removeAt(index);
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Laporan Berhasil Dihapus")),
                                );
                              },
                              child: const Text("Hapus", style: TextStyle(color: Colors.red)),
                            )
                          ],
                        )
                      );
                    }
                  )
                ],
              ),
              onTap: () async{
                final hasilEdit = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormLaporan(laporan: daftarLaporan[index]),
                  ),
                );

                if (hasilEdit != null) {
                  setState(() {
                    daftarLaporan[index] = hasilEdit;
                  });
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Laporan berhasil diperbarui!"),
                      backgroundColor: Colors.blue,
                    ),
                  );
                }

                if(hasilEdit != null){
                  setState(() {
                    daftarLaporan[index] = hasilEdit;
                  });
                }
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final hasil = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormLaporan()),
          );

          if (!mounted) return;

          if (hasil != null){
            setState((){
              daftarLaporan.add(hasil);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Laporan Berhasil Ditambahkan!"),
                backgroundColor: Colors.green,
            )
          );
          }
        },
        child: const Icon(Icons.add),
      )
    );
  }
}