import 'package:equatable/equatable.dart';

class PlayerEntity extends Equatable {
  const PlayerEntity({
    required this.name,
    this.orderNumber,
  });

  final String name;
  final String? orderNumber;

  PlayerEntity copyWith({
    String? name,
    String? orderNumber,
  }) {
    return PlayerEntity(
      name: name ?? this.name,
      orderNumber: orderNumber ?? this.orderNumber,
    );
  }

  @override
  List<Object?> get props => [name, orderNumber];
}
