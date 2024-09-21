import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PlayerEntity extends Equatable {
  const PlayerEntity({
    required this.name,
    this.orderNumber,
    this.color,
  });

  final String name;
  final String? orderNumber;
  final Color? color;

  PlayerEntity copyWith({
    String? name,
    String? orderNumber,
    Color? color,
  }) {
    return PlayerEntity(
      name: name ?? this.name,
      orderNumber: orderNumber ?? this.orderNumber,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [name, orderNumber, color];
}
