import '../entities/drug.dart';

class DrugModel extends Drug {
  const DrugModel({
    required super.id,
    required super.name,
    required super.price,
    required super.image,
    super.info,
  });

  factory DrugModel.fromJson(Map<String, dynamic> json) {
    return DrugModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      price: json['price']?.toString() ?? '0',
      image: json['image'] ?? '',
      info: json['info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'info': info,
    };
  }
}
