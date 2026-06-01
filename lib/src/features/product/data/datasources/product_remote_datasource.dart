import 'package:flutter_bloc_ca/src/features/product/data/models/models.dart';
import '../../../../core/api/api_helper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/logger.dart';

sealed class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProduct();
  Future<void> createProduct(CreateProductModel model);
  Future<void> updateProduct(UpdateProductModel model);
  Future<void> deleteProduct(DeleteProductModel model);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  // ignore: unused_field
  final ApiHelper _helper;
  const ProductRemoteDataSourceImpl(this._helper);

  // Static list of products to simulate persistent database storage across lifecycle events
  static final List<ProductModel> _mockProducts = [
    const ProductModel(
      productId: "1",
      name: "Standard Package",
      price: 15000,
    ),
    const ProductModel(
      productId: "2",
      name: "Premium Option",
      price: 45000,
    ),
    const ProductModel(
      productId: "3",
      name: "Enterprise Solutions",
      price: 90000,
    ),
  ];

  @override
  Future<List<ProductModel>> fetchProduct() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      return List.from(_mockProducts);
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<void> createProduct(CreateProductModel model) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final newProduct = ProductModel(
        productId: "prod_${DateTime.now().millisecondsSinceEpoch}",
        name: model.name ?? "",
        price: model.price ?? 0,
      );
      _mockProducts.add(newProduct);
      return;
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<void> deleteProduct(DeleteProductModel model) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      _mockProducts.removeWhere((p) => p.productId == model.productId);
      return;
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }

  @override
  Future<void> updateProduct(UpdateProductModel model) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      final index = _mockProducts.indexWhere((p) => p.productId == model.productId);
      if (index != -1) {
        _mockProducts[index] = ProductModel(
          productId: model.productId ?? "",
          name: model.name ?? _mockProducts[index].name ?? "",
          price: model.price ?? _mockProducts[index].price ?? 0,
        );
      }
      return;
    } catch (e) {
      logger.e(e);
      throw ServerException();
    }
  }
}
