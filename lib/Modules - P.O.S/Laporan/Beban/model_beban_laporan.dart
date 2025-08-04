class BebanReportSummary {
  final String namaBeban;
  final String idKaryawan;
  final int countEntries;
  final double totalAmount;
  final String namaKaryawan;
  final DateTime tanggal; // make final

  BebanReportSummary({
    required this.namaBeban,
    required this.idKaryawan,
    required this.countEntries,
    required this.totalAmount,
    required this.tanggal,
    required this.namaKaryawan,
  });

  factory BebanReportSummary.fromJsondb(Map<String, dynamic> json) {
    // 1) Extract the raw date string
    final rawDate = json['tanggal_beban'] as String?;

    // 2) Parse it into a DateTime (fallback to epoch if null/invalid)
    final parsedDate = rawDate != null
        ? DateTime.tryParse(rawDate) ?? DateTime.fromMillisecondsSinceEpoch(0)
        : DateTime.fromMillisecondsSinceEpoch(0);

    return BebanReportSummary(
      namaBeban: json['nama_beban'] as String? ?? '',
      namaKaryawan: json['nama_karyawan'] as String? ?? '',
      idKaryawan: json['id_karyawan'] as String? ?? '',
      countEntries: (json['count_entries'] as num?)?.toInt() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      tanggal: parsedDate,
    );
  }
}
