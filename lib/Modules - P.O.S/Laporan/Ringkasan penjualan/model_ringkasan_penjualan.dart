class ReportSummary {
  final double totalPenjualan; // Total sales amount
  final double totalKeuntungan; // Total profit amount
  final int totalTransaksi; // Total number of transactions
  final int totalProdukTerjual;
  final double totalJumlahBeban;
  final int
      totalBeban; // Average transaction value// Total quantity of products sold

  ReportSummary({
    required this.totalPenjualan,
    required this.totalKeuntungan,
    required this.totalTransaksi,
    required this.totalProdukTerjual,
    required this.totalJumlahBeban,
    required this.totalBeban,
  });

  // Factory constructor to map from SQL result
  factory ReportSummary.fromJsondb(Map<String, Object?> json) {
    return ReportSummary(
      totalBeban: (json['total_beban'] as num?)?.toInt() ?? 0,
      totalJumlahBeban: (json['total_jumlah_beban'] as num?)?.toDouble() ?? 0.0,
      totalPenjualan: (json['total_penjualan'] as num?)?.toDouble() ?? 0.0,
      totalKeuntungan: (json['total_keuntungan'] as num?)?.toDouble() ?? 0.0,
      totalTransaksi: (json['total_transaksi'] as int?) ?? 0,
      totalProdukTerjual: (json['produk_terjual'] as int?) ?? 0,
    );
  }
}
