import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final box = Hive.box('users');
    final user = _username.text.trim();
    final savedPass = box.get(user);

    if (savedPass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username belum terdaftar!"), backgroundColor: Colors.red),
      );
    } else if (savedPass == _password.text) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', user);
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password salah!"), backgroundColor: Colors.red),
      );
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F8),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.movie_filter_outlined, size: 100, color: Colors.pink),
              const SizedBox(height: 20),
              const Text("Welcome to Movie List!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.pink)),
              const SizedBox(height: 50),
              TextFormField(
                controller: _username,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person, color: Colors.pink),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.pink)),
                ),
                validator: (v) => v!.trim().isEmpty ? "Username wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock, color: Colors.pink),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.pink)),
                ),
                validator: (v) => v!.isEmpty ? "Password wajib diisi" : null,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: _loading ? null : _login,
                  child: _loading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                child: const Text("Belum punya akun? Daftar di sini", style: TextStyle(color: Colors.pink)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}