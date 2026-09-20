class ProductMasterListModel {
  List<ProductData>? data;

  ProductMasterListModel({this.data});

  factory ProductMasterListModel.fromJson(Map<String, dynamic> json) {
    return ProductMasterListModel(
      data: json['data'] != null
          ? (json['data'] as List).map((v) => ProductData.fromJson(v)).toList()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ProductData {
  int? productCode;
  String? productName;
  String? isActive;
  dynamic productImages;

  ProductData(
      {this.productCode, this.productName, this.isActive, this.productImages});
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductData &&
        other.productCode == productCode &&
        other.productName == productName;
  }

  @override
  int get hashCode => productCode.hashCode ^ productName.hashCode;

  ProductData.fromJson(Map<String, dynamic> json) {
    productCode = json['producT_CODE'];
    productName = json['producT_NAME']; // Adjusted key
    isActive = json['isactive'];
    productImages = json['producT_IMAGES'];
  }

  Map<String, dynamic> toJson() {
    return {
      'producT_CODE': productCode,
      'producT_NAME': productName, // Adjusted key
      'isactive': isActive,
      'producT_IMAGES': productImages,
    };
  }
}
