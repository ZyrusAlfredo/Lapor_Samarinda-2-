import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../main.dart';
import '../models/laporan.dart';

class FormLaporanPage extends StatefulWidget {
  final LaporanInfrastruktur? laporan;

  const FormLaporanPage({super.key, this.laporan});

  @override
  State<FormLaporanPage> createState() => _FormLaporanPageState();
}

class _FormLaporanPageState extends State<FormLaporanPage> {

  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final lokasiController = TextEditingController();
  final deskripsiController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  List<File> images = [];

  String? kategori;
  String? status;

  /// FOTO LAMA
  String? existingFoto1;
  String? existingFoto2;

  final kategoriList = [
    "Jalan & Transportasi",
    "Lampu Jalanan",
    "Kebersihan & Sampah"
  ];

  @override
  void initState() {
    super.initState();

    if (widget.laporan != null) {
      namaController.text = widget.laporan!.nama;
      lokasiController.text = widget.laporan!.lokasi;
      deskripsiController.text = widget.laporan!.deskripsi;
      kategori = widget.laporan!.kategori;
      status = widget.laporan!.status;

      existingFoto1 = widget.laporan!.foto;
      existingFoto2 = widget.laporan!.fotoSelesai;
    }
  }

  Future<String?> uploadFoto(File image) async {
    try {

      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}.jpg";

      final path = "laporan/$fileName";

      await supabase.storage
          .from("laporan-foto")
          .upload(path, image);

      final imageUrl = supabase.storage
          .from("laporan-foto")
          .getPublicUrl(path);

      return imageUrl;

    } catch (e) {
      debugPrint("Upload error: $e");
      return null;
    }
  }

  Future<void> pickImage(ImageSource source) async {

    if (images.length >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Maksimal 2 foto")),
      );
      return;
    }

    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (image != null) {
      setState(() {
        images.add(File(image.path));
      });
    }
  }

  void showImageSource() {

    showModalBottomSheet(
      context: context,
      builder: (context) {

        return SafeArea(
          child: Wrap(
            children: [

              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Ambil dari Kamera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Pilih dari Galeri"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),

            ],
          ),
        );
      },
    );
  }

  Widget buildExistingImage(String url, VoidCallback onDelete) {

    return Stack(
      children: [

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            url,
            width: 90,
            height: 90,
            fit: BoxFit.cover,
          ),
        ),

        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: onDelete,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final bool isEdit = widget.laporan != null;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SingleChildScrollView(
        child: Column(
          children: [

            /// HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xFF0E8A5A),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      const Icon(Icons.report_problem,
                          color: Colors.white, size: 28),

                      const SizedBox(width: 10),

                      Text(
                        isEdit ? "Edit Laporan" : "Laporkan Segera",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Laporkan Kerusakan Fasilitas di Samarinda",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),

                ],
              ),
            ),

            /// FORM
            Padding(
              padding: const EdgeInsets.all(20),

              child: Form(
                key: _formKey,

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "Nama Infrastruktur",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 6),

                    TextFormField(
                      controller: namaController,
                      decoration: const InputDecoration(
                        hintText: "Contoh: Jalanan Rusak",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Wajib Diisi";
                        }
                        if (value.length < 5) {
                          return "Nama terlalu singkat";
                        }
                        if (value.length > 100) {
                          return "Nama terlalu panjang";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Lokasi",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 6),

                    TextFormField(
                      controller: lokasiController,
                      decoration: const InputDecoration(
                        hintText: "Contoh: Jl. MT Haryono",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Wajib Diisi";
                        }
                        if (value.length < 5) {
                          return "Lokasi terlalu singkat";
                        }
                        if (value.length > 100) {
                          return "Lokasi terlalu panjang";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Kategori Fasilitas",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 6),

                    DropdownButtonFormField<String>(
                      initialValue: kategori,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: kategoriList.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          kategori = value;
                        });
                      },

                    ),
                    if (isEdit) ...[
                      const SizedBox(height: 20),
                      const Text(
                        "Status Laporan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      DropdownButtonFormField<String>(
                        value: status,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Proses",
                            child: Text("Proses"),
                          ),
                          DropdownMenuItem(
                            value: "Selesai",
                            child: Text("Selesai"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            status = value;
                          });
                        },
                      ),
                    ],

                    const Text(
                      "Deskripsi Kerusakan",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 6),

                    TextFormField(
                      controller: deskripsiController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: "Contoh: Sudah lebih 1 bulan jalanan berlobang",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Wajib Diisi";
                        }
                        if (value.length < 10) {
                          return "Deskripsi terlalu singkat";
                        }
                        if (value.length > 200) {
                          return "Deskripsi terlalu panjang";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Foto Kerusakan (Max 2)",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 10,
                      children: [

                        if (existingFoto1 != null)
                          buildExistingImage(existingFoto1!, () {
                            setState(() {
                              existingFoto1 = null;
                            });
                          }),

                        if (existingFoto2 != null)
                          buildExistingImage(existingFoto2!, () {
                            setState(() {
                              existingFoto2 = null;
                            });
                          }),

                        ...images.map((img) {
                          return Stack(
                            children: [

                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(10),
                                child: Image.file(
                                  img,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      images.remove(img);
                                    });
                                  },
                                  child: Container(
                                    decoration:
                                        const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),

                        if (images.length +
                                (existingFoto1 != null ? 1 : 0) +
                                (existingFoto2 != null ? 1 : 0) <
                            2)
                          GestureDetector(
                            onTap: showImageSource,
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              child: const Icon(Icons.add_a_photo),
                            ),
                          ),

                      ],
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.upload),

                        label: Text(
                          isEdit
                              ? "Update Laporan"
                              : "Unggah Laporan",
                        ),

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16),
                        ),

                        onPressed: () async {

                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          try {

                            /// KUMPULKAN FOTO FINAL
                            List<String?> finalFotos = [];

                            /// foto lama
                            if (existingFoto1 != null) finalFotos.add(existingFoto1);
                            if (existingFoto2 != null) finalFotos.add(existingFoto2);

                            /// upload foto baru
                            for (var img in images) {
                              final url = await uploadFoto(img);
                              finalFotos.add(url);
                            }

                            /// batasi max 2
                            if (finalFotos.length > 2) {
                              finalFotos = finalFotos.sublist(0, 2);
                            }

                            String? foto1 = finalFotos.isNotEmpty ? finalFotos[0] : null;
                            String? foto2 = finalFotos.length > 1 ? finalFotos[1] : null;

                            if (isEdit) {

                              /// UPDATE LAPORAN
                              await supabase
                                  .from('laporan')
                                  .update({
                                'nama': namaController.text,
                                'lokasi': lokasiController.text,
                                'kategori': kategori,
                                'deskripsi': deskripsiController.text,
                                'status': status,
                                'foto': foto1,
                                'foto_selesai': foto2,
                              })
                              .eq('id', widget.laporan!.id);

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Laporan berhasil diupdate"),
                                ),
                              );

                            } else {

                              /// INSERT LAPORAN BARU
                              await supabase.from('laporan').insert({
                                'nama': namaController.text,
                                'lokasi': lokasiController.text,
                                'kategori': kategori,
                                'deskripsi': deskripsiController.text,
                                'status': 'Proses',
                                'user_id': supabase.auth.currentUser!.id,
                                'tanggal': DateTime.now().toIso8601String(),
                                'foto': foto1,
                                'foto_selesai': foto2,
                              });

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Laporan berhasil dikirim"),
                                ),
                              );

                            }

                            Navigator.pop(context, true);

                          } catch (e) {

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Error: $e"),
                              ),
                            );

                          }

                        },
                      ),
                    ),

                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}