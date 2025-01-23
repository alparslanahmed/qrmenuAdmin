import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/main.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    final appLink = dotenv.env['APP_URL']! + "/" +
        mainProvider.user!.businessSlug;

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
              data: appLink,
              version: QrVersions.auto,
              backgroundColor: Colors.white,
            ) : Text('QR kod oluşturulamadı.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse(appLink);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  throw 'Could not launch $appLink';
                }
              },
              child: Text('Menüyü Görüntüle'),
            ),
          ],
        ),
      ),
    );
  }
}
