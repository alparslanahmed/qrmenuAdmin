import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/main.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController taxOfficeController = TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_validatePasswords);
    passwordConfirmController.addListener(_validatePasswords);
  }

  void _validatePasswords() {
    setState(() {
      _isButtonDisabled = passwordController.text != passwordConfirmController.text;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kayıt Ol'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Ad Soyad'),
              controller: nameController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'İşletme Adı'),
              controller: businessNameController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Vergi Dairesi'),
              controller: taxOfficeController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Vergi Numarası'),
              controller: taxNumberController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Adres'),
              controller: addressController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Telefon Numarası'),
              controller: phoneController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Eposta'),
              controller: emailController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Şifre'),
              controller: passwordController,
              obscureText: true,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Şifre Tekrar'),
              controller: passwordConfirmController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isButtonDisabled ? null : () async {
                final error = await mainProvider.register({
                  'name': nameController.text,
                  'business_name': businessNameController.text,
                  'tax_office': taxOfficeController.text,
                  'tax_number': taxNumberController.text,
                  'address': addressController.text,
                  'phone': phoneController.text,
                  'email': emailController.text,
                  'password': passwordController.text,
                  'password_confirm': passwordConfirmController.text,
                });
                
                if (!mounted) return;
                
                if (error != '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(error)),
                  );
                } else {
                  context.go('/login');
                }
              },
              child: const Text('Kayıt Ol'),
            ),
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('Zaten hesabın var mı? Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}
