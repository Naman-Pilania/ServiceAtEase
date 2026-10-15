class ServiceModel {
  final String id;
  final String name;
  final String categoryId;
  final String description;
  final double basePrice;
  final int durationMinutes;
  final String icon;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.basePrice,
    required this.durationMinutes,
    this.icon = '✂️',
  });
}
