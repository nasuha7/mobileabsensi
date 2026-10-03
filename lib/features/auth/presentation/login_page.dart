import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../dosen/home/dosen_dashboard_page.dart';
import '../../mahasiswa/home/mahasiswa_dashboard_page.dart';
import '../../../shared/data/dummy_data.dart';

enum UserRole { mahasiswa, dosen }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _idCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  UserRole _role = UserRole.mahasiswa;
  bool _hide = true;

  bool get _isDosen => _role == UserRole.dosen;

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    final akun = _isDosen ? DummyData.akunDosen : DummyData.akunMahasiswa;
    final cocok = _idCtrl.text.trim() == akun['id'] &&
        _passCtrl.text == akun['password'];

    if (!cocok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID atau password salah')),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            _isDosen ? const DosenDashboardPage() : const MahasiswaDashboardPage(),
      ),
    );
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(children: [
                        const Icon(Icons.qr_code_2, color: AppColors.accent, size: 44),
                        const SizedBox(height: 8),
                        Text(
                          _isDosen ? 'Absensi QR Dosen' : 'Absensi QR Mahasiswa',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 24),
                    SegmentedButton<UserRole>(
                      segments: const [
                        ButtonSegment(value: UserRole.mahasiswa, label: Text('Mahasiswa'), icon: Icon(Icons.school_outlined)),
                        ButtonSegment(value: UserRole.dosen, label: Text('Dosen'), icon: Icon(Icons.badge_outlined)),
                      ],
                      selected: {_role},
                      onSelectionChanged: (s) => setState(() => _role = s.first),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _idCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: _isDosen ? 'Email / NIDN' : 'Email / NIM',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Isi ${_isDosen ? 'email atau NIDN' : 'email atau NIM'}'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passCtrl,
                      obscureText: _hide,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(_hide ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _hide = !_hide),
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Isi password' : null,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _login,
                      child: Text(_isDosen ? 'Masuk' : 'Login'),
                    ),
                    TextButton(
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fitur reset password belum tersedia')),
                      ),
                      child: const Text('Lupa password?'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
