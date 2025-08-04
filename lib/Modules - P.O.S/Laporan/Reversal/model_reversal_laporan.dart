import 'package:intl/intl.dart';

class ReversalReportSummary {
  final DateTime tanggal; // the date of the cancellations
  final int countReversal; // how many transactions were cancelled
  final double totalReversedValue; // sum of total_bayar for those cancellations

  ReversalReportSummary({
    required this.tanggal,
    required this.countReversal,
    required this.totalReversedValue,
  });

  /// Build from one row of a `GROUP BY DATE(tanggal)` query
  factory ReversalReportSummary.fromJsondb(Map<String, Object?> json) {
    // 1) parse the date string into a DateTime
    final rawDate = json['tanggal'] as String?;
    final dt = rawDate != null
        ? DateTime.tryParse(rawDate) ?? DateTime.fromMillisecondsSinceEpoch(0)
        : DateTime.fromMillisecondsSinceEpoch(0);

    return ReversalReportSummary(
      tanggal: dt,
      countReversal: (json['count_reversal'] as num?)?.toInt() ?? 0,
      totalReversedValue:
          (json['total_reversed_value'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ReversalDetail {
  final String uuid;
  final String noFaktur;
  final DateTime tanggal;
  final String idKaryawan;
  final double totalBayar;

  ReversalDetail({
    required this.uuid,
    required this.noFaktur,
    required this.tanggal,
    required this.idKaryawan,
    required this.totalBayar,
  });

  factory ReversalDetail.fromJsondb(Map<String, Object?> json) {
    // parse date
    final raw = json['tanggal'] as String?;
    final dt = raw != null
        ? DateTime.tryParse(raw) ?? DateTime.fromMillisecondsSinceEpoch(0)
        : DateTime.fromMillisecondsSinceEpoch(0);

    return ReversalDetail(
      uuid: json['uuid'] as String? ?? '',
      noFaktur: json['no_faktur'] as String? ?? '',
      tanggal: dt,
      idKaryawan: json['id_karyawan'] as String? ?? '',
      totalBayar: (json['total_bayar'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
