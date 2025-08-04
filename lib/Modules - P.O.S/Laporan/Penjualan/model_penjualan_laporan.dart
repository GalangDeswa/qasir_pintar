class SalesReport {
  final String uuid;
  final DateTime tanggal; // parsed from 'YYYY-MM-DD'
  final int totalTransactions;
  final int totalItemsSold;
  final double sumSubtotal;
  final double sumDiscount;
  final double sumTax;
  final double sumRevenue;
  final double sumPromo;
  final List<ProductSalesReport> details;

  SalesReport({
    required this.uuid,
    required this.tanggal,
    required this.totalTransactions,
    required this.totalItemsSold,
    required this.sumSubtotal,
    required this.sumDiscount,
    required this.sumTax,
    required this.sumRevenue,
    required this.details,
    required this.sumPromo,
  });

  factory SalesReport.fromJsondb(Map<String, dynamic> m) {
    return SalesReport(
      uuid: m['uuid'] as String,
      tanggal: DateTime.parse(m['tanggal'] as String),

      // 2) cast numeric values safely
      totalTransactions: (m['total_transactions'] as num).toInt(),
      totalItemsSold: (m['total_items_sold'] as num).toInt(),

      sumSubtotal: (m['sum_subtotal'] as num).toDouble(),
      sumDiscount: (m['sum_discount'] as num).toDouble(),
      sumTax: (m['sum_tax'] as num).toDouble(),
      sumRevenue: (m['sum_revenue'] as num).toDouble(),
      sumPromo: (m['sum_promo'] as num).toDouble(),

      details: [],
      //  uuid: m['p_uuid'] as String,
    );
  }
}

class ProductSalesReport {
  //final DateTime tanggal; // sale date
  final String? idProduk;
  final String? idPaket;
  final int totalQty; // how many units sold
  final double totalSales; // sum of detail_penjualan.total_harga
  final String? namaProduk;
  final String? namaPaket;
  final double subtotal;

  ProductSalesReport({
    // required this.tanggal,
    this.idProduk,
    required this.totalQty,
    required this.totalSales,
    this.namaProduk,
    this.idPaket,
    this.namaPaket,
    required this.subtotal,
  });

  factory ProductSalesReport.fromJsondb(Map<String, dynamic> m) {
    return ProductSalesReport(
      // parse the 'YYYY-MM-DD' string into DateTime
      //tanggal: DateTime.parse(m['tanggal'] as String),
      idProduk: m['id_produk'] as String,
      totalQty: (m['total_qty'] as num).toInt(),
      totalSales: (m['total_sales'] as num).toDouble(),
      namaProduk: m['nama_produk'] as String,
      idPaket: m['id_paket'] as String,
      namaPaket: m['nama_paket'] as String,
      subtotal: (m['subtotal'] as num).toDouble(),
    );
  }
}

class SummaryRow {
  final String uuid;
  final int totalTransactions;
  final int totalItemsSold;
  final double sumSubtotal;
  final double sumDiscount;
  final double sumTax;
  final double sumRevenue;
  final double sumPromo;

  SummaryRow({
    required this.uuid,
    required this.totalTransactions,
    required this.totalItemsSold,
    required this.sumSubtotal,
    required this.sumDiscount,
    required this.sumTax,
    required this.sumRevenue,
    required this.sumPromo,
  });

  factory SummaryRow.fromMap(Map<String, dynamic> m) => SummaryRow(
        uuid: m['uuid'] as String,
        totalTransactions: (m['totalTransactions'] as num).toInt(),
        totalItemsSold: (m['totalItemsSold'] as num).toInt(),
        sumSubtotal: (m['sumSubtotal'] as num).toDouble(),
        sumDiscount: (m['sumDiscount'] as num).toDouble(),
        sumTax: (m['sumTax'] as num).toDouble(),
        sumRevenue: (m['sumRevenue'] as num).toDouble(),
        sumPromo: (m['sumPromo'] as num).toDouble(),
      );
}
