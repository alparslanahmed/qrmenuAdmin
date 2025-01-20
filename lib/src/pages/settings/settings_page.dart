import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../providers/main.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ayarlar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            mainProvider.user != null ? QrImageView(
              data: dotenv.env['APP_URL']! + "/" +mainProvider.user!.businessSlug,
              version: QrVersions.auto,
              backgroundColor: Colors.white,
            ) : Text('QR kod oluşturulamadı.'),
            // Add more settings options here
          ],
        ),
      ),
    );
  }
}
