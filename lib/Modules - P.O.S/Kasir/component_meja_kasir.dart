import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qasir_pintar/Config/config.dart';
import 'package:qasir_pintar/Modules - P.O.S/Kasir/controller_kasir.dart';

class Meja extends GetView<KasirController> {
  const Meja({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.cyanAccent,
      padding: EdgeInsets.all(10),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisExtent: context.res_height / 4.0,
              maxCrossAxisExtent: context.res_width / 2.0,
              childAspectRatio: 1 / 1,
              crossAxisSpacing: 1,
              mainAxisSpacing: 15),
          itemCount: controller.meja.length,
          itemBuilder: (BuildContext context, index) {
            var x = controller.meja;
            return GestureDetector(
              onTap: () {},
              child: Card(
                color: Colors.white,
                margin: EdgeInsets.all(5),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(x[index]),
                          Text('5'),
                          Icon(Icons.people)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
