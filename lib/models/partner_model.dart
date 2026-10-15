class PartnerModel {
  final String id;
  final String name;
  final String phone;
  final String? profileImage;
  final double rating;
  final int totalReviews;
  final int completedJobs;
  final bool isOnline;
  final String categoryId;
  final List<String> serviceIds;
  final double distanceKm;
  final String address;
  final int experienceYears;
  final String about;
  final double priceMultiplier;

  const PartnerModel({
    required this.id,
    required this.name,
    required this.phone,
    this.profileImage,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.completedJobs = 0,
    this.isOnline = false,
    required this.categoryId,
    this.serviceIds = const [],
    this.distanceKm = 0.0,
    this.address = '',
    this.experienceYears = 0,
    this.about = '',
    this.priceMultiplier = 1.0,
  });

  PartnerModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? profileImage,
    double? rating,
    int? totalReviews,
    int? completedJobs,
    bool? isOnline,
    String? categoryId,
    List<String>? serviceIds,
    double? distanceKm,
    String? address,
    int? experienceYears,
    String? about,
    double? priceMultiplier,
  }) {
    return PartnerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      completedJobs: completedJobs ?? this.completedJobs,
      isOnline: isOnline ?? this.isOnline,
      categoryId: categoryId ?? this.categoryId,
      serviceIds: serviceIds ?? this.serviceIds,
      distanceKm: distanceKm ?? this.distanceKm,
      address: address ?? this.address,
      experienceYears: experienceYears ?? this.experienceYears,
      about: about ?? this.about,
      priceMultiplier: priceMultiplier ?? this.priceMultiplier,
    );
  }
}
