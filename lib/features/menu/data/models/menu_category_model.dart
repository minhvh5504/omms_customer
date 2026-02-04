import '../../domain/entities/menu_category.dart';

class MenuCategoryModel extends MenuCategory {
  MenuCategoryModel({required super.id, required super.name});

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    return MenuCategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  static List<MenuCategoryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => MenuCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
