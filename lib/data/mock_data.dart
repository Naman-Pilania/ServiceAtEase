import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../models/partner_model.dart';
import '../models/review_model.dart';
import '../models/service_category_model.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';

class MockData {
  MockData._();

  // ─── Current User ─────────────────────────────────────────────
  static final UserModel currentUser = UserModel(
    id: 'user_001',
    name: 'Rahul Sharma',
    phone: '+91 98765 43210',
    email: 'rahul.sharma@email.com',
    address: '123, MG Road, Bangalore - 560001',
    createdAt: DateTime(2024, 1, 15),
  );

  // ─── Service Categories ───────────────────────────────────────
  static final List<ServiceCategory> categories = [
    ServiceCategory(
      id: 'cat_salon',
      name: 'Salon',
      icon: Icons.content_cut,
      description: 'Haircuts, styling & grooming',
      color: AppColors.categorySalon,
      services: salonServices,
    ),
    ServiceCategory(
      id: 'cat_beauty',
      name: 'Beauty',
      icon: Icons.face_retouching_natural,
      description: 'Facials, waxing & makeup',
      color: AppColors.categoryBeauty,
      services: beautyServices,
    ),
    ServiceCategory(
      id: 'cat_doctor',
      name: 'Doctor',
      icon: Icons.medical_services,
      description: 'Home consultations',
      color: AppColors.categoryDoctor,
      services: doctorServices,
    ),
    ServiceCategory(
      id: 'cat_plumber',
      name: 'Plumber',
      icon: Icons.plumbing,
      description: 'Pipes, taps & fixtures',
      color: AppColors.categoryPlumber,
      services: plumberServices,
    ),
    ServiceCategory(
      id: 'cat_electrician',
      name: 'Electrician',
      icon: Icons.electrical_services,
      description: 'Wiring, switches & repairs',
      color: AppColors.categoryElectrician,
      services: electricianServices,
    ),
    ServiceCategory(
      id: 'cat_cleaning',
      name: 'Cleaning',
      icon: Icons.cleaning_services,
      description: 'Home & office cleaning',
      color: AppColors.categoryCleaning,
      services: cleaningServices,
    ),
    ServiceCategory(
      id: 'cat_painter',
      name: 'Painter',
      icon: Icons.format_paint,
      description: 'Wall painting & polishing',
      color: AppColors.categoryPainter,
      services: painterServices,
    ),
    ServiceCategory(
      id: 'cat_carpenter',
      name: 'Carpenter',
      icon: Icons.handyman,
      description: 'Furniture & wood work',
      color: AppColors.categoryCarpenter,
      services: carpenterServices,
    ),
    ServiceCategory(
      id: 'cat_fitness',
      name: 'Fitness',
      icon: Icons.fitness_center,
      description: 'Personal trainers & yoga',
      color: AppColors.categoryFitness,
      services: fitnessServices,
    ),
    ServiceCategory(
      id: 'cat_tutor',
      name: 'Tutor',
      icon: Icons.school,
      description: 'Academic & skill tutoring',
      color: AppColors.categoryTutor,
      services: tutorServices,
    ),
    ServiceCategory(
      id: 'cat_pest',
      name: 'Pest Control',
      icon: Icons.bug_report,
      description: 'Pest removal & prevention',
      color: AppColors.categoryPestControl,
      services: pestServices,
    ),
    ServiceCategory(
      id: 'cat_appliance',
      name: 'Appliance',
      icon: Icons.kitchen,
      description: 'AC, fridge & washer repair',
      color: AppColors.categoryAppliance,
      services: applianceServices,
    ),
  ];

  // ─── Services by Category ────────────────────────────────────
  static final List<ServiceModel> salonServices = [
    const ServiceModel(id: 's_01', name: 'Haircut', categoryId: 'cat_salon', description: 'Professional haircut & styling', basePrice: 299, durationMinutes: 30, icon: '✂️'),
    const ServiceModel(id: 's_02', name: 'Beard Trim', categoryId: 'cat_salon', description: 'Beard shaping & trimming', basePrice: 149, durationMinutes: 15, icon: '🧔'),
    const ServiceModel(id: 's_03', name: 'Hair Color', categoryId: 'cat_salon', description: 'Global or highlight coloring', basePrice: 999, durationMinutes: 60, icon: '🎨'),
    const ServiceModel(id: 's_04', name: 'Head Massage', categoryId: 'cat_salon', description: 'Relaxing oil head massage', basePrice: 199, durationMinutes: 20, icon: '💆'),
    const ServiceModel(id: 's_05', name: 'Shave', categoryId: 'cat_salon', description: 'Clean shave with hot towel', basePrice: 99, durationMinutes: 15, icon: '🪒'),
  ];

  static final List<ServiceModel> beautyServices = [
    const ServiceModel(id: 's_06', name: 'Facial', categoryId: 'cat_beauty', description: 'Deep cleansing facial treatment', basePrice: 599, durationMinutes: 45, icon: '✨'),
    const ServiceModel(id: 's_07', name: 'Waxing', categoryId: 'cat_beauty', description: 'Full body or partial waxing', basePrice: 499, durationMinutes: 40, icon: '🌸'),
    const ServiceModel(id: 's_08', name: 'Makeup', categoryId: 'cat_beauty', description: 'Party or bridal makeup', basePrice: 1499, durationMinutes: 60, icon: '💄'),
    const ServiceModel(id: 's_09', name: 'Manicure', categoryId: 'cat_beauty', description: 'Nail shaping, buffing & polish', basePrice: 399, durationMinutes: 30, icon: '💅'),
    const ServiceModel(id: 's_10', name: 'Pedicure', categoryId: 'cat_beauty', description: 'Foot care & nail treatment', basePrice: 449, durationMinutes: 35, icon: '🦶'),
  ];

  static final List<ServiceModel> doctorServices = [
    const ServiceModel(id: 's_11', name: 'General Checkup', categoryId: 'cat_doctor', description: 'Full body health checkup', basePrice: 499, durationMinutes: 30, icon: '🩺'),
    const ServiceModel(id: 's_12', name: 'Physiotherapy', categoryId: 'cat_doctor', description: 'Physical therapy session', basePrice: 699, durationMinutes: 45, icon: '🏥'),
    const ServiceModel(id: 's_13', name: 'Dental Checkup', categoryId: 'cat_doctor', description: 'Oral examination & advice', basePrice: 399, durationMinutes: 20, icon: '🦷'),
  ];

  static final List<ServiceModel> plumberServices = [
    const ServiceModel(id: 's_14', name: 'Tap Repair', categoryId: 'cat_plumber', description: 'Fix leaking or broken taps', basePrice: 199, durationMinutes: 30, icon: '🔧'),
    const ServiceModel(id: 's_15', name: 'Pipe Fitting', categoryId: 'cat_plumber', description: 'New pipe installation', basePrice: 499, durationMinutes: 60, icon: '🪠'),
    const ServiceModel(id: 's_16', name: 'Drain Cleaning', categoryId: 'cat_plumber', description: 'Unclog drains & sewage lines', basePrice: 349, durationMinutes: 45, icon: '🚿'),
  ];

  static final List<ServiceModel> electricianServices = [
    const ServiceModel(id: 's_17', name: 'Switch Repair', categoryId: 'cat_electrician', description: 'Replace faulty switches & sockets', basePrice: 149, durationMinutes: 20, icon: '🔌'),
    const ServiceModel(id: 's_18', name: 'Fan Installation', categoryId: 'cat_electrician', description: 'Ceiling fan setup & wiring', basePrice: 299, durationMinutes: 45, icon: '💡'),
    const ServiceModel(id: 's_19', name: 'Wiring Work', categoryId: 'cat_electrician', description: 'New wiring & circuit fixes', basePrice: 599, durationMinutes: 90, icon: '⚡'),
  ];

  static final List<ServiceModel> cleaningServices = [
    const ServiceModel(id: 's_20', name: 'Full Home', categoryId: 'cat_cleaning', description: 'Complete home deep cleaning', basePrice: 1499, durationMinutes: 180, icon: '🏠'),
    const ServiceModel(id: 's_21', name: 'Kitchen Deep Clean', categoryId: 'cat_cleaning', description: 'Kitchen & chimney cleaning', basePrice: 799, durationMinutes: 90, icon: '🍳'),
    const ServiceModel(id: 's_22', name: 'Bathroom Clean', categoryId: 'cat_cleaning', description: 'Bathroom scrubbing & sanitization', basePrice: 499, durationMinutes: 45, icon: '🚿'),
  ];

  static final List<ServiceModel> painterServices = [
    const ServiceModel(id: 's_23', name: 'Room Painting', categoryId: 'cat_painter', description: 'Single room wall painting', basePrice: 2999, durationMinutes: 480, icon: '🖌️'),
    const ServiceModel(id: 's_24', name: 'Wall Texture', categoryId: 'cat_painter', description: 'Textured wall finish', basePrice: 4999, durationMinutes: 600, icon: '🎨'),
  ];

  static final List<ServiceModel> carpenterServices = [
    const ServiceModel(id: 's_25', name: 'Furniture Repair', categoryId: 'cat_carpenter', description: 'Fix broken furniture', basePrice: 399, durationMinutes: 60, icon: '🪑'),
    const ServiceModel(id: 's_26', name: 'Door Fitting', categoryId: 'cat_carpenter', description: 'Door installation & repair', basePrice: 599, durationMinutes: 90, icon: '🚪'),
  ];

  static final List<ServiceModel> fitnessServices = [
    const ServiceModel(id: 's_27', name: 'Personal Training', categoryId: 'cat_fitness', description: '1-on-1 fitness session', basePrice: 599, durationMinutes: 60, icon: '💪'),
    const ServiceModel(id: 's_28', name: 'Yoga Session', categoryId: 'cat_fitness', description: 'Home yoga & meditation', basePrice: 499, durationMinutes: 45, icon: '🧘'),
  ];

  static final List<ServiceModel> tutorServices = [
    const ServiceModel(id: 's_29', name: 'Math Tutor', categoryId: 'cat_tutor', description: 'Mathematics home tutoring', basePrice: 399, durationMinutes: 60, icon: '📐'),
    const ServiceModel(id: 's_30', name: 'Science Tutor', categoryId: 'cat_tutor', description: 'Physics, Chemistry, Biology', basePrice: 449, durationMinutes: 60, icon: '🔬'),
  ];

  static final List<ServiceModel> pestServices = [
    const ServiceModel(id: 's_31', name: 'Cockroach Control', categoryId: 'cat_pest', description: 'Cockroach gel & spray treatment', basePrice: 799, durationMinutes: 60, icon: '🪳'),
    const ServiceModel(id: 's_32', name: 'Termite Control', categoryId: 'cat_pest', description: 'Anti-termite chemical treatment', basePrice: 1499, durationMinutes: 120, icon: '🐛'),
  ];

  static final List<ServiceModel> applianceServices = [
    const ServiceModel(id: 's_33', name: 'AC Service', categoryId: 'cat_appliance', description: 'AC gas refill & deep clean', basePrice: 499, durationMinutes: 60, icon: '❄️'),
    const ServiceModel(id: 's_34', name: 'Washing Machine', categoryId: 'cat_appliance', description: 'Washer repair & servicing', basePrice: 399, durationMinutes: 45, icon: '🧺'),
    const ServiceModel(id: 's_35', name: 'Fridge Repair', categoryId: 'cat_appliance', description: 'Refrigerator troubleshooting', basePrice: 449, durationMinutes: 45, icon: '🧊'),
  ];

  // ─── All Services (flat list) ─────────────────────────────────
  static List<ServiceModel> get allServices => [
    ...salonServices,
    ...beautyServices,
    ...doctorServices,
    ...plumberServices,
    ...electricianServices,
    ...cleaningServices,
    ...painterServices,
    ...carpenterServices,
    ...fitnessServices,
    ...tutorServices,
    ...pestServices,
    ...applianceServices,
  ];

  static ServiceModel? getServiceById(String id) {
    try {
      return allServices.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  static ServiceCategory? getCategoryById(String id) {
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // ─── Partners ─────────────────────────────────────────────────
  static final List<PartnerModel> partners = [
    // Salon Partners
    const PartnerModel(id: 'p_01', name: 'Vikram Styles', phone: '+91 90001 10001', rating: 4.8, totalReviews: 234, completedJobs: 512, isOnline: true, categoryId: 'cat_salon', serviceIds: ['s_01', 's_02', 's_03', 's_04', 's_05'], distanceKm: 1.2, address: 'Koramangala, Bangalore', experienceYears: 8, about: 'Professional barber with 8+ years of experience. Specializing in modern cuts and beard styling.'),
    const PartnerModel(id: 'p_02', name: 'Arjun Barber', phone: '+91 90001 10002', rating: 4.5, totalReviews: 156, completedJobs: 340, isOnline: true, categoryId: 'cat_salon', serviceIds: ['s_01', 's_02', 's_05'], distanceKm: 2.5, address: 'Indiranagar, Bangalore', experienceYears: 5, about: 'Quick and efficient haircuts. Expert in fade cuts and traditional shaving.'),
    const PartnerModel(id: 'p_03', name: 'Ravi Grooming', phone: '+91 90001 10003', rating: 4.3, totalReviews: 89, completedJobs: 198, isOnline: false, categoryId: 'cat_salon', serviceIds: ['s_01', 's_03', 's_04'], distanceKm: 3.8, address: 'HSR Layout, Bangalore', experienceYears: 3, about: 'Passionate about hair styling and coloring. Trained at top salons.'),

    // Beauty Partners
    const PartnerModel(id: 'p_04', name: 'Priya Beauty Care', phone: '+91 90001 10004', rating: 4.9, totalReviews: 312, completedJobs: 678, isOnline: true, categoryId: 'cat_beauty', serviceIds: ['s_06', 's_07', 's_08', 's_09', 's_10'], distanceKm: 0.8, address: 'JP Nagar, Bangalore', experienceYears: 10, about: 'Certified beautician with expertise in bridal and party makeup. 10 years experience.'),
    const PartnerModel(id: 'p_05', name: 'Meera Glow Studio', phone: '+91 90001 10005', rating: 4.7, totalReviews: 198, completedJobs: 432, isOnline: true, categoryId: 'cat_beauty', serviceIds: ['s_06', 's_07', 's_09', 's_10'], distanceKm: 1.5, address: 'Whitefield, Bangalore', experienceYears: 7, about: 'Skin care specialist. Expert in facials and natural beauty treatments.'),
    const PartnerModel(id: 'p_06', name: 'Neha Makeover', phone: '+91 90001 10006', rating: 4.4, totalReviews: 76, completedJobs: 165, isOnline: false, categoryId: 'cat_beauty', serviceIds: ['s_08', 's_09'], distanceKm: 4.2, address: 'Electronic City, Bangalore', experienceYears: 4, about: 'Makeup artist specialized in HD and airbrush makeup techniques.'),

    // Doctor Partners
    const PartnerModel(id: 'p_07', name: 'Dr. Anil Kumar', phone: '+91 90001 10007', rating: 4.9, totalReviews: 423, completedJobs: 890, isOnline: true, categoryId: 'cat_doctor', serviceIds: ['s_11'], distanceKm: 2.0, address: 'Jayanagar, Bangalore', experienceYears: 15, about: 'MBBS, MD. 15 years of practice. Home visits for general health checkups.'),
    const PartnerModel(id: 'p_08', name: 'Dr. Sneha Physio', phone: '+91 90001 10008', rating: 4.6, totalReviews: 156, completedJobs: 320, isOnline: true, categoryId: 'cat_doctor', serviceIds: ['s_12'], distanceKm: 3.5, address: 'BTM Layout, Bangalore', experienceYears: 8, about: 'BPT, MPT Orthopedics. Expert in sports injuries and post-surgery rehabilitation.'),
    const PartnerModel(id: 'p_09', name: 'Dr. Raghav Dental', phone: '+91 90001 10009', rating: 4.7, totalReviews: 201, completedJobs: 456, isOnline: false, categoryId: 'cat_doctor', serviceIds: ['s_13'], distanceKm: 1.8, address: 'Marathahalli, Bangalore', experienceYears: 12, about: 'BDS, MDS. Home dental consultation and basic dental procedures.'),

    // Plumber Partners
    const PartnerModel(id: 'p_10', name: 'Suresh Plumbing', phone: '+91 90001 10010', rating: 4.5, totalReviews: 189, completedJobs: 410, isOnline: true, categoryId: 'cat_plumber', serviceIds: ['s_14', 's_15', 's_16'], distanceKm: 1.0, address: 'MG Road, Bangalore', experienceYears: 12, about: 'Expert plumber handling all types of plumbing issues. Quick and reliable service.'),
    const PartnerModel(id: 'p_11', name: 'Rajesh Pipes', phone: '+91 90001 10011', rating: 4.3, totalReviews: 98, completedJobs: 215, isOnline: true, categoryId: 'cat_plumber', serviceIds: ['s_14', 's_16'], distanceKm: 2.8, address: 'Yelahanka, Bangalore', experienceYears: 6, about: 'Specializing in drain cleaning and tap repairs. Affordable pricing.'),

    // Electrician Partners
    const PartnerModel(id: 'p_12', name: 'Kiran Electricals', phone: '+91 90001 10012', rating: 4.6, totalReviews: 167, completedJobs: 378, isOnline: true, categoryId: 'cat_electrician', serviceIds: ['s_17', 's_18', 's_19'], distanceKm: 1.5, address: 'Banashankari, Bangalore', experienceYears: 9, about: 'Licensed electrician. Expert in home wiring, fan installation, and circuit repairs.'),
    const PartnerModel(id: 'p_13', name: 'Mohan Power', phone: '+91 90001 10013', rating: 4.2, totalReviews: 72, completedJobs: 156, isOnline: false, categoryId: 'cat_electrician', serviceIds: ['s_17', 's_18'], distanceKm: 5.0, address: 'Hebbal, Bangalore', experienceYears: 4, about: 'Certified electrician for residential and small commercial setups.'),

    // Cleaning Partners
    const PartnerModel(id: 'p_14', name: 'SparkClean Pro', phone: '+91 90001 10014', rating: 4.8, totalReviews: 256, completedJobs: 560, isOnline: true, categoryId: 'cat_cleaning', serviceIds: ['s_20', 's_21', 's_22'], distanceKm: 0.5, address: 'Richmond Road, Bangalore', experienceYears: 6, about: 'Professional cleaning team. Eco-friendly products and thorough deep cleaning.'),
    const PartnerModel(id: 'p_15', name: 'CleanSweep', phone: '+91 90001 10015', rating: 4.4, totalReviews: 134, completedJobs: 290, isOnline: true, categoryId: 'cat_cleaning', serviceIds: ['s_20', 's_22'], distanceKm: 3.2, address: 'Sarjapur Road, Bangalore', experienceYears: 4, about: 'Affordable home and bathroom cleaning. We bring all supplies.'),

    // Fitness Partners
    const PartnerModel(id: 'p_16', name: 'Coach Rohit', phone: '+91 90001 10016', rating: 4.7, totalReviews: 145, completedJobs: 310, isOnline: true, categoryId: 'cat_fitness', serviceIds: ['s_27'], distanceKm: 2.0, address: 'Koramangala, Bangalore', experienceYears: 7, about: 'ACE certified personal trainer. Specializes in strength training and weight loss.'),
    const PartnerModel(id: 'p_17', name: 'Yoga with Anita', phone: '+91 90001 10017', rating: 4.9, totalReviews: 210, completedJobs: 450, isOnline: true, categoryId: 'cat_fitness', serviceIds: ['s_28'], distanceKm: 1.8, address: 'Indiranagar, Bangalore', experienceYears: 12, about: 'Certified yoga instructor. Hatha, Vinyasa, and meditation. Home sessions available.'),

    // Appliance Partners
    const PartnerModel(id: 'p_18', name: 'CoolTech AC', phone: '+91 90001 10018', rating: 4.5, totalReviews: 178, completedJobs: 398, isOnline: true, categoryId: 'cat_appliance', serviceIds: ['s_33'], distanceKm: 1.2, address: 'Malleshwaram, Bangalore', experienceYears: 8, about: 'AC specialist. Service, repair, and gas refill for all brands.'),
    const PartnerModel(id: 'p_19', name: 'FixIt Appliance', phone: '+91 90001 10019', rating: 4.3, totalReviews: 112, completedJobs: 245, isOnline: true, categoryId: 'cat_appliance', serviceIds: ['s_33', 's_34', 's_35'], distanceKm: 2.5, address: 'Rajajinagar, Bangalore', experienceYears: 5, about: 'Multi-brand appliance repair. AC, washing machine, refrigerator, and more.'),
  ];

  static List<PartnerModel> getPartnersByCategory(String categoryId) {
    return partners.where((p) => p.categoryId == categoryId).toList();
  }

  static List<PartnerModel> getOnlinePartnersByCategory(String categoryId) {
    return partners.where((p) => p.categoryId == categoryId && p.isOnline).toList();
  }

  static PartnerModel? getPartnerById(String id) {
    try {
      return partners.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // ─── Reviews ──────────────────────────────────────────────────
  static final List<ReviewModel> reviews = [
    ReviewModel(id: 'r_01', customerId: 'user_001', customerName: 'Rahul S.', partnerId: 'p_01', rating: 5.0, comment: 'Amazing haircut! Vikram is very skilled and professional. Highly recommend!', date: DateTime(2024, 10, 5)),
    ReviewModel(id: 'r_02', customerId: 'user_002', customerName: 'Amit K.', partnerId: 'p_01', rating: 4.5, comment: 'Great styling. On time and well-groomed. Will book again.', date: DateTime(2024, 10, 3)),
    ReviewModel(id: 'r_03', customerId: 'user_003', customerName: 'Sneha P.', partnerId: 'p_04', rating: 5.0, comment: 'Priya did my bridal makeup and it was absolutely stunning! Worth every penny.', date: DateTime(2024, 9, 28)),
    ReviewModel(id: 'r_04', customerId: 'user_004', customerName: 'Deepa M.', partnerId: 'p_04', rating: 4.8, comment: 'The facial was so relaxing and my skin felt amazing afterwards.', date: DateTime(2024, 9, 25)),
    ReviewModel(id: 'r_05', customerId: 'user_005', customerName: 'Venkat R.', partnerId: 'p_07', rating: 5.0, comment: 'Dr. Anil is very thorough in his checkup. Very knowledgeable doctor.', date: DateTime(2024, 10, 1)),
    ReviewModel(id: 'r_06', customerId: 'user_006', customerName: 'Kavitha L.', partnerId: 'p_14', rating: 4.7, comment: 'SparkClean did an incredible job. My entire house looks brand new!', date: DateTime(2024, 10, 4)),
    ReviewModel(id: 'r_07', customerId: 'user_007', customerName: 'Sunil G.', partnerId: 'p_10', rating: 4.5, comment: 'Fixed the leaking tap in 15 minutes. Very efficient plumber.', date: DateTime(2024, 9, 30)),
    ReviewModel(id: 'r_08', customerId: 'user_008', customerName: 'Meera J.', partnerId: 'p_17', rating: 5.0, comment: 'Anita is the best yoga instructor! Her sessions are calming yet challenging.', date: DateTime(2024, 10, 2)),
    ReviewModel(id: 'r_09', customerId: 'user_009', customerName: 'Ravi T.', partnerId: 'p_12', rating: 4.6, comment: 'Installed a ceiling fan perfectly. Clean work and reasonable price.', date: DateTime(2024, 9, 27)),
    ReviewModel(id: 'r_10', customerId: 'user_010', customerName: 'Pooja D.', partnerId: 'p_05', rating: 4.7, comment: 'Lovely facial treatment. Meera really knows her skincare products.', date: DateTime(2024, 10, 6)),
  ];

  static List<ReviewModel> getReviewsForPartner(String partnerId) {
    return reviews.where((r) => r.partnerId == partnerId).toList();
  }

  // ─── Bookings ─────────────────────────────────────────────────
  static final List<BookingModel> bookings = [
    BookingModel(id: 'bk_001', customerId: 'user_001', partnerId: 'p_01', serviceId: 's_01', categoryId: 'cat_salon', status: BookingStatus.confirmed, bookingDate: DateTime.now().add(const Duration(hours: 3)), timeSlot: '2:00 PM - 2:30 PM', totalAmount: 299, address: '123, MG Road, Bangalore', createdAt: DateTime.now()),
    BookingModel(id: 'bk_002', customerId: 'user_001', partnerId: 'p_04', serviceId: 's_06', categoryId: 'cat_beauty', status: BookingStatus.pending, bookingDate: DateTime.now().add(const Duration(days: 1)), timeSlot: '10:00 AM - 10:45 AM', totalAmount: 599, address: '123, MG Road, Bangalore', createdAt: DateTime.now().subtract(const Duration(hours: 2))),
    BookingModel(id: 'bk_003', customerId: 'user_001', partnerId: 'p_10', serviceId: 's_14', categoryId: 'cat_plumber', status: BookingStatus.completed, bookingDate: DateTime.now().subtract(const Duration(days: 2)), timeSlot: '11:00 AM - 11:30 AM', totalAmount: 199, address: '123, MG Road, Bangalore', notes: 'Kitchen tap leaking', createdAt: DateTime.now().subtract(const Duration(days: 3))),
    BookingModel(id: 'bk_004', customerId: 'user_001', partnerId: 'p_14', serviceId: 's_20', categoryId: 'cat_cleaning', status: BookingStatus.completed, bookingDate: DateTime.now().subtract(const Duration(days: 5)), timeSlot: '9:00 AM - 12:00 PM', totalAmount: 1499, address: '123, MG Road, Bangalore', createdAt: DateTime.now().subtract(const Duration(days: 6))),
    BookingModel(id: 'bk_005', customerId: 'user_001', partnerId: 'p_07', serviceId: 's_11', categoryId: 'cat_doctor', status: BookingStatus.cancelled, bookingDate: DateTime.now().subtract(const Duration(days: 1)), timeSlot: '4:00 PM - 4:30 PM', totalAmount: 499, address: '123, MG Road, Bangalore', notes: 'Had to cancel due to schedule conflict', createdAt: DateTime.now().subtract(const Duration(days: 2))),
    BookingModel(id: 'bk_006', customerId: 'user_001', partnerId: 'p_12', serviceId: 's_18', categoryId: 'cat_electrician', status: BookingStatus.inProgress, bookingDate: DateTime.now(), timeSlot: '11:00 AM - 11:45 AM', totalAmount: 299, address: '123, MG Road, Bangalore', notes: 'Bedroom ceiling fan', createdAt: DateTime.now().subtract(const Duration(hours: 5))),
  ];

  // ─── Promotions ───────────────────────────────────────────────
  static final List<Map<String, dynamic>> promotions = [
    {
      'title': '50% OFF on First Booking',
      'subtitle': 'Use code: FIRST50',
      'color': AppColors.primary,
    },
    {
      'title': 'Salon at Home',
      'subtitle': 'Starting ₹199 only',
      'color': AppColors.secondary,
    },
    {
      'title': 'Free Health Checkup',
      'subtitle': 'Book any doctor service',
      'color': AppColors.categoryDoctor,
    },
  ];
}
