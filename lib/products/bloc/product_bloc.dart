import 'dart:convert';
import 'dart:html';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_shopping/products/models/product.dart';
import 'package:http/http.dart' as http;

part 'product_event.dart';
part 'product_state.dart';

const _productLimit = 20;
const throttleDuration = Duration(milliseconds: 100);

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final http.Client httpClient;

  ProductBloc({required this.httpClient}) : super(const ProductState()) {
    on<ProductFetched>(_onProductFetched);
  }

  Future<void> _onProductFetched(ProductFetched event, Emitter<ProductState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == ProductStatus.initial) {
        final products = await _fetchProducts();
        return emit(state.copyWith(
          status: ProductStatus.success,
          products: products,
          hasReachedMax: false,
        ));
      }
      final products = await _fetchProducts(state.products.length);
      emit(products.isEmpty ? state.copyWith(hasReachedMax: true) :
          state.copyWith(
            status: ProductStatus.success,
            products: List.of(state.products)..addAll(products),
            hasReachedMax: false,
          )
      );
    } catch (_) {
      emit(state.copyWith(status: ProductStatus.failure));
    }
  }

  Future<List<Product>> _fetchProducts([int startIndex = 0]) async {
    final response = await httpClient.get(
      Uri.https('fakestoreapi.com', 'products', <String, String>{'limit':'$_productLimit'}),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((json) {
        return Product(
          id: json['id'] as int,
          category: json['category'] as String,
          description: json['description'] as String,
          imageUrl: json['image'] as String,
          price: json['price'] as double,
          rating: Rating(
            count: json['rating']['count'] as int,
            rate: json['rating']['rate'] as double,
          ),
          title: json['title'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching products');
  }
}