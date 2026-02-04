import '../../domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  MenuItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price']?.toString() ?? '0',
      imageUrl: json['imageUrl']?.toString() ?? '',
    );
  }

  static List<MenuItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => MenuItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
