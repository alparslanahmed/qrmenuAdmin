import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _passwordForm = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _businessForm = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _taxOfficeController = TextEditingController();
  final _taxNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    _updateControllers(mainProvider.user);

    mainProvider.addListener(() {
      _updateControllers(mainProvider.user);
    });
  }

  void _updateControllers(User? user) {
    _businessNameController.text = user?.businessName ?? '';
    _taxOfficeController.text = user?.taxOffice ?? '';
    _taxNumberController.text = user?.taxNumber ?? '';
    _addressController.text = user?.address ?? '';
    _phoneController.text = user?.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kullanıcı Bilgileri', style: TextStyle(fontSize: 20)),
              Text('${mainProvider.user?.name ?? 'Not logged in'}'),
              Text('${mainProvider.user?.email ?? 'Not logged in'}'),
              Form(
                key: _passwordForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _oldPasswordController,
                      decoration: InputDecoration(labelText: 'Eski Şifre'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen eski şifrenizi giriniz';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Yeni Şifre'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen şifre giriniz';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration:
                          InputDecoration(labelText: 'Yeni Şifre Tekrar'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen şifrenizi tekrar giriniz';
                        }
                        if (value != _passwordController.text) {
                          return 'Şifrler uyuşmuyor';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_passwordForm.currentState!.validate()) {
                          final request = await mainProvider.password_change(
                              _oldPasswordController.text,
                              _passwordController.text);
                          if (request == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                      Text('Şifre başarıyla güncellendi.')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(request)),
                            );
                          }
                        }
                      },
                      child: Text('Şifreyi Değiştir'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Text('İşletme Bilgileri', style: TextStyle(fontSize: 20)),
              Form(
                key: _businessForm,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _businessNameController,
                      decoration: InputDecoration(labelText: 'İşletme Adı'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen işletme adını giriniz';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _taxOfficeController,
                      decoration: InputDecoration(labelText: 'Vergi Dairesi'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen vergi dairesini giriniz';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _taxNumberController,
                      decoration: InputDecoration(labelText: 'Vergi Numarası'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen vergi numarasını giriniz';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(labelText: 'Adres'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen adres giriniz';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration:
                          InputDecoration(labelText: 'Telefon Numarası'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen telefon numarasını giriniz';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_businessForm.currentState!.validate()) {
                          final update = await mainProvider.update_profile({
                            'business_name': _businessNameController.text,
                            'tax_office': _taxOfficeController.text,
                            'tax_number': _taxNumberController.text,
                            'address': _addressController.text,
                            'phone': _phoneController.text,
                          });

                          if (update == '') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'İşletme bilgileri başarıyla güncellendi.')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(update)),
                            );
                          }
                        }
                      },
                      child: Text('İşletme Bilgilerini Güncelle'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  mainProvider.logout();
                  context.go('/login');
                },
                child: Text('Oturumu Kapat'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
