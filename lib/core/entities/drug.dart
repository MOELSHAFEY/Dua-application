import 'package:equatable/equatable.dart';

class Drug extends Equatable {
  final String id;
  final String name;
  final String price;
  final String image;
  final String? info;

  const Drug({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.info,
  });

  @override
  List<Object?> get props => [id, name, price, image, info];
}
