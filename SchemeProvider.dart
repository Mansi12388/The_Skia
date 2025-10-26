import 'package:flutter/material.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/SchemeModel.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/SchemeService.dart';

class SchemeProvider with ChangeNotifier {
  final SchemeService _schemeService = SchemeService();

  List<SchemeModel> _allSchemes = [];
  List<SchemeModel> _filteredSchemes = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;
  String? _errorMessage;

  List<SchemeModel> get schemes => _filteredSchemes;
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<String> get categories => [
    'All',
    'Agriculture',
    'Education',
    'Health',
    'Housing',
    'Social Welfare',
  ];

  Future<void> loadSchemes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allSchemes = await _schemeService.fetchSchemes();
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load schemes. Please try again.';
      _isLoading = false;
      notifyListeners();
      print('Error in loadSchemes: $e');
    }
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<SchemeModel> result = _allSchemes;
    result = _schemeService.filterByCategory(result, _selectedCategory);
    result = _schemeService.searchSchemes(result, _searchQuery);
    _filteredSchemes = result;
  }
}
