/// Starter payload model. Add typed fields when the API contract is available.
class RetailerDistributorVisitEntryModel {
  final Map<String, dynamic> data;

  RetailerDistributorVisitEntryModel({Map<String, dynamic> data = const {}})
    : data = Map<String, dynamic>.unmodifiable(data);

  factory RetailerDistributorVisitEntryModel.fromJson(
    Map<String, dynamic> json,
  ) => RetailerDistributorVisitEntryModel(data: json);

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(data);
}
