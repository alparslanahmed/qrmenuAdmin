import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/main.dart';

class TabsLayout extends StatefulWidget {
  final Widget child;
  final GoRouterState state;

  const TabsLayout({
    Key? key,
    required this.child,
    required this.state,
  }) : super(key: key);

  @override
  State<TabsLayout> createState() => _TabsLayoutState();
}

class _TabsLayoutState extends State<TabsLayout> {
  int _calculateSelectedIndex(String location) {
    if (location.startsWith('/settings')) return 0;
    if (location.startsWith('/home')) return 1;
    if (location.startsWith('/profile')) return 2;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);

    return Scaffold(
      body: mainProvider.user!.isEmailVerified
          ? widget.child
          : _buildVerificationForm(context),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _calculateSelectedIndex(widget.state.matchedLocation),
        onTap: (int index) {
          switch (index) {
            case 0:
              context.go('/settings');
              break;
            case 1:
              context.go('/home');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildVerificationForm(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    final verificationToken = widget.state.uri.queryParameters['verification_token'];
    if (verificationToken != null) {
      return FutureBuilder<String>(
        future: mainProvider.verify_email(verificationToken),
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
                  ElevatedButton(
                    onPressed: () async {
                      mainProvider.resend_verification_code();
                      // Handle error if needed
                    },
                    child: const Text('Doğrulama E-postasını Tekrar Gönder'),
                  ),
                ],
              ),
            );
          }
          
          // Only show success when we have data and it's empty (no error)
          return const Center(
            child: Text('Email başarıyla doğrulandı!'),
          );
        },
      );
    }else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(35.0),
              child: Text('Devam edebilmek için lütfen e-posta adresinizi doğrulayın. E-posta adresinize gönderilen doğrulama bağlantısına tıklayarak hesabınızı doğrulayabilirsiniz.'),
            ),
            ElevatedButton(
              onPressed: () async {
                final error = await mainProvider.resend_verification_code();
                if (!mounted) return;
                
                if (error != '') {
                  if (!context.mounted) return;
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
                } else {
                  if (!context.mounted) return;
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Gönderildi.'),
                        content: const Text("Kod gönderildi."),
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
                }
              },
              child: const Text('Doğrulama E-postasını Tekrar Gönder'),
            ),
          ],
        ),
      );
    }
  }
}
