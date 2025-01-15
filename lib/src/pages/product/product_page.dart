import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/main.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  ProductDetailPage({required this.productId});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState(this.productId);
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final int _productId;
  final _productFormKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _productPriceController = TextEditingController();
  Uint8List _productImage = Uint8List(0);
  late Product _product = Product(id: 0, name: '', description: '', price: 0.0, imageUrl: '', slug: '', categoryId: 0);

  _ProductDetailPageState(this._productId);

  @override
  void initState() {
    super.initState();
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    mainProvider.getProduct(_productId).then((product) {
      setState(() {
        _product = product;
        _productNameController.text = _product.name;
        _productDescriptionController.text = _product.description;
        _productPriceController.text = _product.price.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _productFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _productImage.isNotEmpty
                    ? Image.memory(_productImage, height: 200)
                    : _product.imageUrl.isNotEmpty
                    ? Image.network(dotenv.env['API_URL']! + _product.imageUrl, height: 200)
                    : Text('Görsel bulunamadı'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickProductImage,
                  child: Text('Ürün Görseli Yükle'),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _productNameController,
                  decoration: InputDecoration(
                    labelText: 'Ürün İsmi',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ürün ismi boş olamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _productDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Ürün Açıklaması',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ürün açıklaması boş olamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _productPriceController,
                  decoration: InputDecoration(
                    labelText: 'Ürün Fiyatı',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ürün fiyatı boş olamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_productFormKey.currentState!.validate()) {
                      mainProvider.updateProduct(
                        _product.id,
                        _productNameController.text,
                        _productDescriptionController.text,
                        double.parse(_productPriceController.text),
                        _productImage,
                      ).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Ürün başarıyla güncellendi')),
                        );
                      });
                    }
                  },
                  child: Text('Ürün Güncelle'),
                ),
                SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    mainProvider.deleteProduct(
                      _product.id,
                    ).then((_) {
                      context.go('/category/${_product.categoryId}');
                    });
                  },
                  child: Text('Ürünü Sil'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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