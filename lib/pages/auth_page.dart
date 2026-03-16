import 'package:flutter/material.dart';
import '../main.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool isLogin = true;

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  bool hidePassword = true;
  bool hideConfirm = true;

  bool agree = false;

  String? errorMessage;

  void switchPage(bool login) {
    setState(() {
      isLogin = login;
      errorMessage = null;

      usernameController.clear();
      passwordController.clear();
      confirmController.clear();
    });
  }

  Future<void> login() async {
    try {

      await supabase.auth.signInWithPassword(
        email: usernameController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, "/home");

    } catch (e) {

      setState(() {
        errorMessage = "Email atau Kata Sandi salah — silakan coba lagi";
      });

    }
  }

  Future<void> register() async {

    if (!agree) {
      setState(() {
        errorMessage = "Anda harus menyetujui Ketentuan Layanan";
      });
      return;
    }

    if (passwordController.text != confirmController.text) {
      setState(() {
        errorMessage = "Password tidak sama";
      });
      return;
    }

    try {

      await supabase.auth.signUp(
        email: usernameController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Akun berhasil dibuat")),
      );

      switchPage(true);

    } catch (e) {

      setState(() {
        errorMessage = e.toString();
      });

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// HEADER
            Row(
              children: [

                Image.asset(
                  "assets/images/LogoKaltim.png",
                  width: 50,
                ),

                const SizedBox(width: 2),

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
              ],
            ),

            const SizedBox(height: 30),

            /// TAB NAVIGATION
            Row(
              children: [

                Expanded(
                  child: GestureDetector(
                    onTap: () => switchPage(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isLogin ? Colors.green : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          "Masuk",
                          style: TextStyle(
                            color: isLogin ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: () => switchPage(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !isLogin ? Colors.green : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          "Daftar",
                          style: TextStyle(
                            color: !isLogin ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// TITLE
            Text(
              isLogin ? "Selamat datang kembali" : "Buat Akun Anda",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              isLogin
                  ? "Sebelum Memulai, Silahkan login terlebih dahulu."
                  : "Daftar Sekarang.",
              style: const TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            /// ERROR MESSAGE
            if (errorMessage != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [

                    const Icon(Icons.error, color: Colors.red),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            /// USERNAME
            const Text(
              "EMAIL",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                hintText: "masukkan email anda",
              ),
            ),

            const SizedBox(height: 20),

            /// PASSWORD
            const Text(
              "KATA SANDI",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            TextField(
              controller: passwordController,
              obscureText: hidePassword,
              decoration: InputDecoration(
                hintText: "masukkan kata sandi Anda",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
              ),
            ),

            /// CONFIRM PASSWORD
            if (!isLogin) ...[

              const SizedBox(height: 20),

              const Text(
                "KONFIRMASI KATA SANDI",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              TextField(
                controller: confirmController,
                obscureText: hideConfirm,
                decoration: InputDecoration(
                  hintText: "masukkan kembali kata sandi Anda",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hideConfirm
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        hideConfirm = !hideConfirm;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// CHECKBOX
              Row(
                children: [

                  Checkbox(
                    value: agree,
                    activeColor: Colors.green,
                    onChanged: (v) {
                      setState(() {
                        agree = v!;
                      });
                    },
                  ),

                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "Saya menyetujui ",
                        children: [

                          TextSpan(
                            text: "Ketentuan Layanan",
                            style: TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                          ),

                          TextSpan(text: " dan "),

                          TextSpan(
                            text: "Kebijakan Privasi",
                            style: TextStyle(
                              color: Colors.green,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],

            const SizedBox(height: 30),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: isLogin ? login : register,
                child: Text(
                  isLogin ? "Masuk" : "Buat Akun",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}