import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/booking_model.dart';

class BookingProvider extends ChangeNotifier {
  final List<BookingModel> _bookings = List.from(MockData.bookings);
  String? _selectedServiceId;
  String? _selectedPartnerId;
  String? _selectedTimeSlot;
  DateTime _selectedDate = DateTime.now();
  String _address = MockData.currentUser.address;
  String _notes = '';

  List<BookingModel> get bookings => _bookings;
  String? get selectedServiceId => _selectedServiceId;
  String? get selectedPartnerId => _selectedPartnerId;
  String? get selectedTimeSlot => _selectedTimeSlot;
  DateTime get selectedDate => _selectedDate;
  String get address => _address;
  String get notes => _notes;

  List<BookingModel> get upcomingBookings => _bookings
      .where((b) =>
          b.status == BookingStatus.confirmed ||
          b.status == BookingStatus.pending ||
          b.status == BookingStatus.inProgress)
      .toList()
    ..sort((a, b) => a.bookingDate.compareTo(b.bookingDate));

  List<BookingModel> get completedBookings => _bookings
      .where((b) => b.status == BookingStatus.completed)
      .toList()
    ..sort((a, b) => b.bookingDate.compareTo(a.bookingDate));

  List<BookingModel> get cancelledBookings => _bookings
      .where((b) => b.status == BookingStatus.cancelled)
      .toList()
    ..sort((a, b) => b.bookingDate.compareTo(a.bookingDate));

  List<String> get availableTimeSlots => [
    '9:00 AM - 9:30 AM',
    '9:30 AM - 10:00 AM',
    '10:00 AM - 10:30 AM',
    '10:30 AM - 11:00 AM',
    '11:00 AM - 11:30 AM',
    '11:30 AM - 12:00 PM',
    '1:00 PM - 1:30 PM',
    '1:30 PM - 2:00 PM',
    '2:00 PM - 2:30 PM',
    '2:30 PM - 3:00 PM',
    '3:00 PM - 3:30 PM',
    '4:00 PM - 4:30 PM',
    '4:30 PM - 5:00 PM',
    '5:00 PM - 5:30 PM',
    '5:30 PM - 6:00 PM',
  ];

  void selectService(String serviceId) {
    _selectedServiceId = serviceId;
    notifyListeners();
  }

  void selectPartner(String partnerId) {
    _selectedPartnerId = partnerId;
    notifyListeners();
  }

  void selectTimeSlot(String timeSlot) {
    _selectedTimeSlot = timeSlot;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void setAddress(String address) {
    _address = address;
    notifyListeners();
  }

  void setNotes(String notes) {
    _notes = notes;
    notifyListeners();
  }

  BookingModel createBooking({
    required String categoryId,
    required double amount,
  }) {
    final booking = BookingModel(
      id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
      customerId: MockData.currentUser.id,
      partnerId: _selectedPartnerId!,
      serviceId: _selectedServiceId!,
      categoryId: categoryId,
      status: BookingStatus.confirmed,
      bookingDate: _selectedDate,
      timeSlot: _selectedTimeSlot!,
      totalAmount: amount,
      address: _address,
      notes: _notes.isNotEmpty ? _notes : null,
      createdAt: DateTime.now(),
    );

    _bookings.insert(0, booking);
    _resetSelections();
    notifyListeners();
    return booking;
  }

  void cancelBooking(String bookingId) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index] = _bookings[index].copyWith(
        status: BookingStatus.cancelled,
      );
      notifyListeners();
    }
  }

  void _resetSelections() {
    _selectedServiceId = null;
    _selectedPartnerId = null;
    _selectedTimeSlot = null;
    _selectedDate = DateTime.now();
    _notes = '';
  }
}
