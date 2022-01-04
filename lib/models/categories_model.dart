class CategoriesModel {
  bool? status;
  CategoriesAllDataModel? allData;

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    allData = CategoriesAllDataModel.fromJson(json['data']);
  }
}

class CategoriesAllDataModel {
  int? currentPage;
  List<CategoriesDataModel>? data = [];

  CategoriesAllDataModel.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    json['data'].forEach((elemnt) {
      data!.add(CategoriesDataModel(elemnt));
    });
  }
}

class CategoriesDataModel {
  int? id;
  String? name;
  String? image;

  CategoriesDataModel(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
