import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/main.dart';

class PasswordReset extends StatefulWidget {
  /// The navigation shell and container for the branch Navigators.
  final GoRouterState state;

  /// Constructs an [ScaffoldWithNavBar].
  const PasswordReset({
    required this.state,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('PasswordReset'));

  @override
  _PasswordResetState createState() => _PasswordResetState(state);
}

class _PasswordResetState extends State<PasswordReset> {
  GoRouterState state;

  _PasswordResetState(this.state);

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordAgainController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    final code = state.uri.queryParameters['token'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifre Sıfırla'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Yeni Şifre'),
              controller: passwordController,
              obscureText: true,
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Yeni Şifre Tekrar'),
              controller: passwordAgainController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pass = passwordController.text;
                final pass2 = passwordAgainController.text;

                if (pass != pass2) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Başarısız!'),
                        content: const Text('Şifreler eşleşmiyor.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                final error = await mainProvider.reset_password(code!, pass);
                if (error != '') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Başarısız!'),
                        content: Text(error),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Başarılı!'),
                        content: Text("Şifreniz sıfırlandı."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  context.go('/');
                }
              },
              child: const Text('Sıfırla'),
            ),
          ],
        ),
      ),
    );
  }
}
