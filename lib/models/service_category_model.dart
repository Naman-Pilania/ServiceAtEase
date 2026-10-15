import 'package:flutter/material.dart';
import 'service_model.dart';

class ServiceCategory {
  final String id;
  final String name;
  final IconData icon;
  final String description;
  final Color color;
  final List<ServiceModel> services;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.color,
    this.services = const [],
  });
}
