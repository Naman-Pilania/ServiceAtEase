enum BookingStatus {
  pending,
  confirmed,
  inProgress,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.inProgress:
        return 'In Progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class BookingModel {
  final String id;
  final String customerId;
  final String partnerId;
  final String serviceId;
  final String categoryId;
  final BookingStatus status;
  final DateTime bookingDate;
  final String timeSlot;
  final double totalAmount;
  final String address;
  final String? notes;
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.customerId,
    required this.partnerId,
    required this.serviceId,
    required this.categoryId,
    this.status = BookingStatus.pending,
    required this.bookingDate,
    required this.timeSlot,
    required this.totalAmount,
    required this.address,
    this.notes,
    required this.createdAt,
  });

  BookingModel copyWith({
    String? id,
    String? customerId,
    String? partnerId,
    String? serviceId,
    String? categoryId,
    BookingStatus? status,
    DateTime? bookingDate,
    String? timeSlot,
    double? totalAmount,
    String? address,
    String? notes,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      partnerId: partnerId ?? this.partnerId,
      serviceId: serviceId ?? this.serviceId,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      bookingDate: bookingDate ?? this.bookingDate,
      timeSlot: timeSlot ?? this.timeSlot,
      totalAmount: totalAmount ?? this.totalAmount,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
