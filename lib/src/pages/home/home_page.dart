import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';

import '../../providers/main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _categoryFormKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();
  Uint8List _image = Uint8List(0);

  @override
  void initState() {
    super.initState();
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    mainProvider.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Kategoriler'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _categoryFormKey,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _image.isEmpty
                            ? Text('Görsel seçilmedi.')
                            : Image.memory(_image, height: 200),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Görsel Yükle'),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _categoryNameController,
                      decoration: InputDecoration(
                        labelText: 'Kategori Adı',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kategori adı boş olamaz';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_categoryFormKey.currentState!.validate()) {
                          mainProvider.createCategory(
                              _categoryNameController.text, _image).then((_) {
                                mainProvider.fetchCategories();
                                _categoryNameController.clear();
                                setState(() {
                                  _image = Uint8List(0);
                                });
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(error.toString()),
                              ),
                            );
                          });
                        }
                      },
                      child: Text('Kategori Ekle'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: mainProvider.categories.length,
                itemBuilder: (context, index) {
                  final category = mainProvider.categories[index];
                  return InkWell(
                    onTap: () {
                      context.go('/category/${category.id}');
                    },
                    child: ListTile(
                      leading: category.imageUrl.isNotEmpty
                          ? Image.network(dotenv.env['API_URL']! + category.imageUrl, width: 50, height: 50)
                          : null,
                      title: Text(category.name),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePickerWeb.getImageAsBytes();

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }
}
