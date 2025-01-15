import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../../providers/main.dart';

class CategoryDetailPage extends StatefulWidget {
  final int categoryId;

  CategoryDetailPage({required this.categoryId});

  @override
  _CategoryDetailPageState createState() => _CategoryDetailPageState(this.categoryId);
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {

  final _categoryFormKey = GlobalKey<FormState>();
  final _productFormKey = GlobalKey<FormState>();
  final _categoryNameController = TextEditingController();
  final _productNameController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productDescriptionController = TextEditingController();

  Uint8List _categoryImage = Uint8List(0);
  Uint8List _productImage = Uint8List(0);

  final _categoryId;
  late Category _category = Category(id: 0, name: '', imageUrl: '', slug: '');
  List<Product> _products = [];

  _CategoryDetailPageState(this._categoryId);

  @override
  void initState() {
    super.initState();
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    mainProvider.getCategory(_categoryId).then((category) {
      setState(() {
        _category = category;
        _categoryNameController.text = _category.name;
      });
    });

    mainProvider.fetchProducts(_categoryId).then((products) {
      setState(() {
        _products = products;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_category.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Form(
                key: _categoryFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _categoryImage.isEmpty
                            ? Image.network(dotenv.env['API_URL']! + _category.imageUrl, height: 200)
                            : Image.memory(_categoryImage, height: 200),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _pickCategoryImage,
                          child: Text('Kategori Görseli Yükle'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _categoryNameController,
                      decoration: InputDecoration(
                        labelText: 'Kategori İsmi',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kategori İsmi Boş Bırakılamaz.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_categoryFormKey.currentState!.validate()) {
                          mainProvider.updateCategory(
                            _category.id,
                            _categoryNameController.text,
                            _categoryImage,
                          ).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Kategori Güncellendi.')),
                            );
                          });
                        }
                      },
                      child: Text('Kategoriyi Güncelle'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Text("Ürünler", style: TextStyle(fontSize: 20)),
              SizedBox(height: 40),
              Form(
                key: _productFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ürün Oluştur", style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _productImage.isEmpty
                            ? Text('Görsel seçilmedi.')
                            : Image.memory(_productImage, height: 200),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _pickProductImage,
                          child: Text('Ürün Görseli Yükle'),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _productNameController,
                      decoration: InputDecoration(
                        labelText: 'Ürün İsmi',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ürün ismi boş bırakılamaz.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _productDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Ürün Açıklaması',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ürün açıklaması boş bırakılamaz.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _productPriceController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        labelText: 'Ürün Fiyatı',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ürün fiyatı boş bırakılamaz.';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_productFormKey.currentState!.validate()) {
                          mainProvider.createProduct(
                            _category.id,
                            _productNameController.text,
                            _productDescriptionController.text,
                            double.parse(_productPriceController.text),
                            _productImage,
                          ).then((_) {
                            mainProvider.fetchProducts(_categoryId).then((products) {
                              setState(() {
                                _products = products;
                              });
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ürün oluşturuldu.')),
                            );
                          });
                        }
                      },
                      child: Text('Ürün oluştur'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              _products.isEmpty
                  ? Text('Bu kategoride ürün yok.')
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return InkWell(
                    onTap: () {
                      context.go('/product/${product.id}');
                    },
                    child: ListTile(
                      leading: product.imageUrl.isNotEmpty
                          ? Image.network(dotenv.env['API_URL']! + product.imageUrl, width: 50, height: 50)
                          : null,
                      title: Text(product.name),
                      subtitle: Text(product.price.toString() + ' TL'),

                    ),
                  );
                },
              ),
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  mainProvider.deleteCategory(
                    _category.id,
                  ).then((_) {
                    context.go('/home');
                  });
                },
                child: Text('Kategoriyi Sil'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickCategoryImage() async {
    final pickedFile = await ImagePickerWeb.getImageAsBytes();

    if (pickedFile != null) {
      setState(() {
        _categoryImage = pickedFile;
      });
    }
  }

  Future<void> _pickProductImage() async {
    final pickedFile = await ImagePickerWeb.getImageAsBytes();

    if (pickedFile != null) {
      setState(() {
        _productImage = pickedFile;
      });
    }
  }
}