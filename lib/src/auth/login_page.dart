import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_admin/src/auth/register_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Yap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'E-posta'),
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle login logic
              },
              child: Text('Giriş Yap'),
            ),
            TextButton(
              onPressed: () {
                context.go('/register');
              },
              child: Text('Hesabınız yok mu? Kayıt Olun.'),
            ),
          ],
        ),
      ),
    );
  }
}