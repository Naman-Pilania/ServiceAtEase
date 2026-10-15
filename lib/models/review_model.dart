class ReviewModel {
  final String id;
  final String customerId;
  final String customerName;
  final String partnerId;
  final double rating;
  final String comment;
  final DateTime date;

  const ReviewModel({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.partnerId,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
