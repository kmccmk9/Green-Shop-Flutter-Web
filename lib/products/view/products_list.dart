import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_shopping/products/bloc/product_bloc.dart';
import 'package:flutter_web_shopping/products/widgets/product_list_item.dart';

import '../widgets/bottom_loader.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController..removeListener(_onScroll)..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<ProductBloc>().add(ProductFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    final double width = screenSize.width;
    
    return BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          switch (state.status) {
            case ProductStatus.failure:
              return const Center(child: Text('Failed to fetch products'));
            case ProductStatus.success:
              if (state.products.isEmpty) {
                return const Center(child: Text('No more products'));
              }
              return width < 800 ?
              ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return index >= state.products.length ? BottomLoader() : ProductListItem(product: state.products[index]);
                  },
                itemCount: state.hasReachedMax ? state.products.length : state.products.length + 1,
                controller: _scrollController,
              ) :
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  return index >= state.products.length ? BottomLoader() : ProductListItem(product: state.products[index]);
                }
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}