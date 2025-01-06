import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router/src/state.dart';
import 'package:provider/provider.dart';
import 'package:qr_admin/src/providers/main.dart';

class VerificationPage extends StatefulWidget {
  final GoRouterState state;
  const VerificationPage({required GoRouterState this.state, super.key});

  @override
  _VerificationPageState createState() => _VerificationPageState(state);
}

class _VerificationPageState extends State<VerificationPage> {
  final _verificationCodeController = TextEditingController();
  final GoRouterState state;

  _VerificationPageState(this.state);

  @override
  void dispose() {
    _verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    final verificationToken = state.uri.queryParameters['token'];

    return FutureBuilder<String>(
      future: mainProvider.verify_email(verificationToken!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Show error if there's an error or if data contains an error message
        if (snapshot.hasError || (snapshot.hasData && snapshot.data!.isNotEmpty)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Text(snapshot.data ?? 'Doğrulama başarısız.'),
                ),
              ],
            ),
          );
        }

        // Only show success when we have data and it's empty (no error)
        return Column(
          children: [
            const Center(
              child: Text('Email başarıyla doğrulandı! Şimdi giriş yapabilirsiniz.'),
            ),
            ElevatedButton(
              onPressed: () async {
                context.go('/login');
              },
              child: const Text('Giriş Yap'),
            ),
          ],
        );

      },
    );
  }
}