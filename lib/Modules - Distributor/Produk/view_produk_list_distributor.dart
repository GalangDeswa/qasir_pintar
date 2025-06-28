import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import 'controller_produk_list_distributor.dart';

class ProdukListDistributor extends GetView<ProdukListDistributorController> {
  const ProdukListDistributor({super.key});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: 7,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              height: 120,
              color: Colors.red,
            ),
            Text('qwe')
          ],
        );
      },
    );
    ;
  }
}
