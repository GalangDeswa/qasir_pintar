import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Widget/widget.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      await GetStorage().write('db_local', 'exist');
      print(
          'DB is ready---------------------------------------------------------->');
      return _db;
    } else {
      print(
          'DB is not ready, init DB---------------------------------------------------------------->');
      await GetStorage().write('db_local', 'new');
      _db = await initDb();
      return _db;
    }
  }

  initDb() async {
    print('init DB -------------------------------------------------------->');
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "qasir_pintar.db");
    bool dbExists = await File(path).exists();

    if (!dbExists) {
      // Copy from asset
      print('DB doesnt exits, copying DB----------------------------------->');
      ByteData data =
          await rootBundle.load(join("assets/database", "qasir_pintar.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }

    // Open the database and enable foreign key support
    var theDb = await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
    );

    return theDb;
  }

  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "qasir_pintar.db");
    //print(path);
    await databaseFactory.deleteDatabase(path);
    bool dbExists = await File(path).exists();
    if (dbExists == false) {
      print('db gada lagi');
      print(path);
    } else {
      print('db masih ada');
      print(path);
    }
  }

  // getProduk() async {
  //   var dbClient = await db;
  //   var list =
  //       await dbClient!.rawQuery('SELECT * FROM view_produk ORDER BY ID DESC');
  //   List<DataProduk> produk =
  //       list.isNotEmpty ? list.map((e) => DataProduk.fromJson(e)).toList() : [];
  //   print(produk);
  //   return produk;
  // }
  //
  // getProdukv2() async {
  //   var dbClient = await db;
  //   var list = await dbClient!.rawQuery('SELECT * FROM produk');
  //   List<DataProduk> produk =
  //       list.isNotEmpty ? list.map((e) => DataProduk.fromJson(e)).toList() : [];
  //   print(produk);
  //   return produk;
  // }
  //
  // addProduk(DataProduk produk) async {
  //   var dbClient = await db;
  //   var list = await dbClient!.insert('produk', produk.toMapForDb());
  //
  //   return list;
  // }
  //
  // updateProduk(DataProduk produk) async {
  //   var dbClient = await db;
  //   var list = await dbClient!.update('produk', produk.toMapForDb(),
  //       where: 'id = ?', whereArgs: [produk.id]);
  //
  //   return list;
  // }
  //
  // deleteProduk(int id) async {
  //   var dbClient = await db;
  //   var list =
  //       await dbClient!.delete('produk', where: 'id = ?', whereArgs: [id]);
  //   return list;
  // }

//-------------------------------------------------------------------------------------------

  FETCH(String query) async {
    try {
      var dbClient = await db;
      var queryDB = await dbClient!.rawQuery(query);
      //return queryDB;
      //return {'result': queryDB, 'error': null}; // Return result and no error
      return queryDB;
    } catch (e) {
      // Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
      // return {'result': null, 'error': e}; // Return result and no error
      return null;
    }
  }

  FETCHV2(String query, [List<dynamic>? params]) async {
    try {
      var dbClient = await db;
      // Use rawQuery with parameters if provided
      var queryDB = await dbClient!.rawQuery(query, params);
      return queryDB;
    } catch (e) {
      // Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
      return null;
    }
  }

  INSERT(String table, dynamic data) async {
    try {
      print(
          "-------------- inserting data : $table ----------------------------");
      var dbClient = await db;
      var query = await dbClient!.insert(table, data);
      print(
          "--------------Success! inserting data : $table ----------------------------");

      // return {'result': query, 'error': null}; // Return result and no error
      return query;
    } catch (e, stackTrace) {
      print('error DB------------------');
      print(e);
      print('error DB trace------------------');
      print(stackTrace);

      //Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
      // return {'result': null, 'error': e.toString()}; // Return error message
      return null;
    }
  }

  UPDATE(
      {required String table,
      required dynamic data,
      required dynamic id}) async {
    try {
      print(
          "-------------- Updating data : $table ----------------------------");
      var dbClient = await db;
      var query = await dbClient!
          .update(table, data, where: 'uuid = ?', whereArgs: [id]);

      // return {'result': query, 'error': null}; // Return result and no error
      return query;
    } catch (e, stackTrace) {
      print('---------------------------errorr-----------');
      print(e);
      print(stackTrace);
      // Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
      //   return {'result': null, 'error': e}; // Return result and no error
      return null;
    }
  }

  UPDATEDETAILPAKET(
      {required String table,
      required dynamic data,
      required dynamic id}) async {
    try {
      print(
          "-------------- Updating data : $table ----------------------------");
      var dbClient = await db;
      var query = await dbClient!
          .update(table, data, where: 'id_produk = ?', whereArgs: [id]);

      // return {'result': query, 'error': null}; // Return result and no error
      return query;
    } catch (e, stackTrace) {
      print('---------------------------errorr-----------');
      print(e);
      print(stackTrace);
      // Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
      //   return {'result': null, 'error': e}; // Return result and no error
      return null;
    }
  }

  Future<int> incrementQty({
    required String table,
    required int increment,
    required String id_produk,
  }) async {
    var dbClient = await db;
    return dbClient!.rawUpdate(
      'UPDATE $table SET stok = stok + ? WHERE id_produk = ?',
      [increment, id_produk],
    );
  }

  Future<int> decrementQty({
    required String table,
    required int decrement,
    required String id_produk,
  }) async {
    var dbClient = await db;
    return dbClient!.rawUpdate(
      'UPDATE $table SET stok = stok - ? WHERE id_produk = ?',
      [decrement, id_produk],
    );
  }

  UPDATEQTY(
      {required String table,
      required dynamic data,
      required dynamic id}) async {
    try {
      print(
          "-------------- Updating data : $table ----------------------------");
      var dbClient = await db;
      var query = await dbClient!
          .update(table, data, where: 'id_produk = ?', whereArgs: [id]);

      // return {'result': query, 'error': null}; // Return result and no error
      return query;
    } catch (e, stackTrace) {
      print('---------------------------errorr-----------');
      print(e);
      print(stackTrace);
      // Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
      //   return {'result': null, 'error': e}; // Return result and no error
      return null;
    }
  }

  DELETE({required String table, id}) async {
    try {
      var dbClient = await db;
      var query =
          await dbClient!.delete(table, where: 'uuid = ?', whereArgs: [id]);

      //return {'result': query, 'error': null}; // Return result and no error
      return query;
    } catch (e) {
      Get.back();
      Get.back();
      //Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
      print(e);
      //return {'result': null, 'error': e}; // Return result and no error
      return null;
    }
  }

  //TODO : edit/ delete klat beban || laporan

  softDelete({
    required String table,
    required String uuid,
    String idField = 'uuid',
  }) async {
    try {
      var dbClient = await db;
      var query = await dbClient!.update(
        table,
        {'aktif': 0},
        where: '$idField = ?',
        whereArgs: [uuid],
      );
      return query;
    } catch (e, stackTrace) {
      print('---------------------------errorr-----------');
      print(e);
      print(stackTrace);
      // Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
      //   return {'result': null, 'error': e}; // Return result and no error
      return null;
    }
  }

  softDeleteProduk({
    required String table,
    required String uuid,
    String idField = 'uuid',
  }) async {
    try {
      var dbClient = await db;
      var query = await dbClient!.update(
        table,
        {'tampilkan_di_produk': 0},
        where: '$idField = ?',
        whereArgs: [uuid],
      );
      return query;
    } catch (e, stackTrace) {
      print('---------------------------errorr-----------');
      print(e);
      print(stackTrace);
      // Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
      //   return {'result': null, 'error': e}; // Return result and no error
      return null;
    }
  }

  softDeletePaketProduk({
    required String table,
    required String uuid,
    String idField = 'uuid',
  }) async {
    try {
      var dbClient = await db;
      var query = await dbClient!.update(
        table,
        {'tampilkan_di_paket': 0},
        where: '$idField = ?',
        whereArgs: [uuid],
      );
      return query;
    } catch (e, stackTrace) {
      print('---------------------------errorr-----------');
      print(e);
      print(stackTrace);
      // Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
      //   return {'result': null, 'error': e}; // Return result and no error
      return null;
    }
  }

  DELETEDETAILPAKET({required String table, id}) async {
    try {
      var dbClient = await db;
      var query = await dbClient!
          .delete(table, where: 'id_produk = ?', whereArgs: [id]);

      //return {'result': query, 'error': null}; // Return result and no error
      return query;
    } catch (e) {
      Get.back();
      Get.back();
      //Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
      print(e);
      //return {'result': null, 'error': e}; // Return result and no error
      return null;
    }
  }

  UPDATEMEJA(
      {required String table,
      required dynamic data,
      required dynamic id}) async {
    try {
      var dbClient = await db;
      var query = await dbClient!
          .update(table, data, where: 'meja = ?', whereArgs: [id]);
      return query;
    } catch (e) {
      print('---------------------------errorr-----------');
      print(e);
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
    }
  }

  UPDATEMEJADETAILNOMORMEJA(
      {required String table,
      required dynamic data,
      required String id_meja}) async {
    try {
      var dbClient = await db;
      var query = await dbClient!
          .update(table, data, where: 'id_meja = ?', whereArgs: [id_meja]);
      return query;
    } catch (e) {
      print('---------------------------errorr-----------');
      print(e);
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
    }
  }

  UPDATEMEJASUBTOTAL(
      {required String table,
      required dynamic data,
      required dynamic id}) async {
    try {
      var dbClient = await db;
      var query = await dbClient!
          .update(table, data, where: 'meja = ?', whereArgs: [id]);
      return query;
    } catch (e) {
      print('---------------------------errorr-----------');
      print(e);
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
    }
  }

  DELETEMEJA(String table, int id) async {
    try {
      var dbClient = await db;
      var query =
          await dbClient!.delete(table, where: 'id = ?', whereArgs: [id]);
      return query;
    } catch (e) {
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
    }
  }

  DELETEMEJAITEMKOSONG(String table, String meja) async {
    try {
      var dbClient = await db;
      var query =
          await dbClient!.delete(table, where: 'meja = ?', whereArgs: [meja]);
      return query;
    } catch (e) {
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
    }
  }

  DELETEMEJADETAIL(String table, int id) async {
    try {
      var dbClient = await db;
      var query =
          await dbClient!.delete(table, where: 'id_meja = ?', whereArgs: [id]);
      return query;
    } catch (e) {
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
    }
  }

  DELETEITEMMEJADETAIL(String table, String idproduk, String idmeja) async {
    try {
      var dbClient = await db;
      var query = await dbClient!.delete(table,
          where: 'id_produk_local = ? AND id_meja = ?',
          whereArgs: [idproduk, idmeja]);
      return query;
    } catch (e) {
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
    }
  }

  UPDATEMEJADETAIL(
      {required String table,
      required dynamic data,
      required dynamic id}) async {
    try {
      var dbClient = await db;
      var query = await dbClient!
          .update(table, data, where: 'id_produk_local = ?', whereArgs: [id]);
      return query;
    } catch (e) {
      print('---------------------------errorr-----------');
      print(e);
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
    }
  }

  DELETEALL(String table) async {
    try {
      var dbClient = await db;
      var query = await dbClient!.delete(table);
      return query;
    } catch (e) {
      Get.back(closeOverlays: true);
      Get.showSnackbar(toast().bottom_snackbar_error('Error', e.toString()));
    }
  }
}
