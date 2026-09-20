/// Starter payload model. Add typed fields when the API contract is available.
class FarmerConnectivityEntryModel {
  final Map<String, dynamic> data;

  FarmerConnectivityEntryModel({Map<String, dynamic> data = const {}})
    : data = Map<String, dynamic>.unmodifiable(data);

  factory FarmerConnectivityEntryModel.fromJson(Map<String, dynamic> json) =>
      FarmerConnectivityEntryModel(data: json);

  Map<String, dynamic> toJson() => Map<String, dynamic>.from(data);
}
