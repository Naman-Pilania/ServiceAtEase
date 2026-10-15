import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/service_category_model.dart';
import '../models/partner_model.dart';

class HomeProvider extends ChangeNotifier {
  String _searchQuery = '';
  String? _selectedCategoryId;

  String get searchQuery => _searchQuery;
  String? get selectedCategoryId => _selectedCategoryId;

  List<ServiceCategory> get categories => MockData.categories;

  List<ServiceCategory> get filteredCategories {
    if (_searchQuery.isEmpty) return categories;
    return categories
        .where((c) =>
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.description.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<PartnerModel> get nearbyOnlinePartners {
    return MockData.partners
        .where((p) => p.isOnline)
        .toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  }

  List<PartnerModel> getOnlinePartnersForCategory(String categoryId) {
    return MockData.getOnlinePartnersByCategory(categoryId);
  }

  List<PartnerModel> getAllPartnersForCategory(String categoryId) {
    return MockData.getPartnersByCategory(categoryId);
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void selectCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }
}
