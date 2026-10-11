class Temperatures {
  final List<Datum> data;

  Temperatures({required this.data});
}

class Datum {
  final int lpaMId;
  final String emPCode;
  final String paydate;
  final int producTCode;
  final int liquidatioNProductAchievement;
  final String remarks;

  Datum({
    required this.lpaMId,
    required this.emPCode,
    required this.paydate,
    required this.producTCode,
    required this.liquidatioNProductAchievement,
    required this.remarks,
  });
}
