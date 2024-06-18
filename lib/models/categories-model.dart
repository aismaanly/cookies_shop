// ignore_for_file: file_names

class CategoriesModel {
  final String categoryId;
  final String categoryImg;
  final String categoryName;
  final dynamic createdAt;

  CategoriesModel({
    required this.categoryId,
    required this.categoryImg,
    required this.categoryName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryImg': categoryImg,
      'categoryName': categoryName,
      'createdAt': createdAt,
    };
  }

  factory CategoriesModel.fromMap(Map<String, dynamic> json) {
    return CategoriesModel(
      categoryId: json['categoryId'],
      categoryImg: json['categoryImg'],
      categoryName: json['categoryName'],
      createdAt: json['createdAt'],
    );
  }
}
