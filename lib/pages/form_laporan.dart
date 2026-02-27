import 'package:flutter/material.dart';
import '../models/laporan.dart';

class FormLaporan extends StatefulWidget{
  final LaporanInfrastruktur? laporan;

  const FormLaporan({super.key, this.laporan});

  @override
  State<FormLaporan> createState() => _FormLaporanState();
}

class _FormLaporanState extends State<FormLaporan>{
  final TextEditingController namaController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

    @override
  void initState(){
    super.initState();

    if(widget.laporan != null){
      namaController.text = widget.laporan!.nama;
      lokasiController.text = widget.laporan!.lokasi;
      deskripsiController.text = widget.laporan!.deskripsi;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: const Text(
              "Tambah Laporan Baru",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 144, 35, 35),
            elevation: 4,
            ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                labelText: "Nama Infrastruktur",
                hintText: "Contoh: Lampu Jembatan Mahakam",
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: lokasiController,
              decoration: const InputDecoration(
                labelText: "Lokasi",
                hintText: "Contoh: Jl. M. Yamin, Samarinda",
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: deskripsiController,
              decoration: const InputDecoration(
                labelText: "Deskripsi Kerusakan",
                hintText: "Contoh: Lampu mati total sejak 2 hari",
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){
                  final laporanBaru = LaporanInfrastruktur(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    nama: namaController.text,
                    lokasi: lokasiController.text,
                    deskripsi: deskripsiController.text,
                    tanggal: DateTime.now(),
                  );
                  Navigator.pop(context, laporanBaru);
                },
                child: const Text("Simpan Laporan"),
              ),
            )
          ],
        ),
      ),
    );
  }
}