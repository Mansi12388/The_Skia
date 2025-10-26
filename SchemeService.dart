import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:parivartan/CommonMan_Module/GovermentSchemesProvide/SchemeModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SchemeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collectionName = 'goverment_scheme';
  static const String cacheKey = 'cached_schemes';

  Future<List<SchemeModel>> fetchSchemes() async {
    try {
      print('Fetching schemes from Firebase...');

      final querySnapshot = await _firestore
          .collection(collectionName)
          .where('status', isEqualTo: 'active')
          .get();

      if (querySnapshot.docs.isEmpty) {
        print(
          'No schemes found in Firebase, loading from cache or sample data',
        );
        return await _loadCachedSchemesOrSample();
      }

      final schemes = querySnapshot.docs.map((doc) {
        return SchemeModel.fromFirestore(doc.id, doc.data());
      }).toList();

      print('Fetched ${schemes.length} schemes from Firebase');

      await _cacheSchemes(schemes);

      return schemes;
    } catch (e) {
      print('Error fetching schemes from Firebase: $e');
      return await _loadCachedSchemesOrSample();
    }
  }

  Future<void> _cacheSchemes(List<SchemeModel> schemes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final schemesJson = schemes.map((s) => s.toJson()).toList();
      await prefs.setString(cacheKey, json.encode(schemesJson));
      print('Schemes cached successfully');
    } catch (e) {
      print('Error caching schemes: $e');
    }
  }

  Future<List<SchemeModel>> _loadCachedSchemesOrSample() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(cacheKey);
      if (cachedData != null) {
        print('Loading schemes from cache');
        final List<dynamic> data = json.decode(cachedData);
        return data.map((json) => SchemeModel.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading cached schemes: $e');
    }

    print('Loading sample schemes');
    return _getSampleSchemes();
  }

  List<SchemeModel> _getSampleSchemes() {
    return [
      SchemeModel(
        schemeId: 'SCH001',
        name: 'PM-KISAN',
        description:
            'Income support to all farmer families for financial stability.',
        eligibility: 'Small and marginal farmers owning land.',
        ministry: 'Ministry of Agriculture and Farmers Welfare',
        status: 'active',
        startDate: '2019-02-24',
        endDate: '2030-12-31',
        geography: {'country': 'India', 'state': 'All', 'district': 'All'},
      ),
      SchemeModel(
        schemeId: 'SCH002',
        name: 'Ayushman Bharat',
        description:
            'Health insurance scheme providing coverage of ₹5 lakhs per family per year.',
        eligibility: 'Economically vulnerable families as per SECC database.',
        ministry: 'Ministry of Health and Family Welfare',
        status: 'active',
        startDate: '2018-09-23',
        endDate: '2030-12-31',
        geography: {'country': 'India', 'state': 'All', 'district': 'All'},
      ),
      SchemeModel(
        schemeId: 'SCH003',
        name: 'Pradhan Mantri Awas Yojana',
        description:
            'Housing for All scheme providing affordable housing to urban poor.',
        eligibility: 'EWS/LIG/MIG categories without pucca house.',
        ministry: 'Ministry of Housing and Urban Affairs',
        status: 'active',
        startDate: '2015-06-25',
        endDate: '2030-12-31',
        geography: {'country': 'India', 'state': 'All', 'district': 'All'},
      ),
      SchemeModel(
        schemeId: 'SCH004',
        name: 'Beti Bachao Beti Padhao',
        description:
            'Campaign to address the declining Child Sex Ratio and related issues of women empowerment.',
        eligibility: 'All girl children and their families.',
        ministry: 'Ministry of Women and Child Development',
        status: 'active',
        startDate: '2015-01-22',
        endDate: '2030-12-31',
        geography: {'country': 'India', 'state': 'All', 'district': 'All'},
      ),
      SchemeModel(
        schemeId: 'SCH005',
        name: 'National Education Policy',
        description:
            'Comprehensive framework to guide the development of education in India.',
        eligibility: 'All students in educational institutions.',
        ministry: 'Ministry of Education',
        status: 'active',
        startDate: '2020-07-29',
        endDate: '2030-12-31',
        geography: {'country': 'India', 'state': 'All', 'district': 'All'},
      ),
    ];
  }

  List<SchemeModel> filterByCategory(
    List<SchemeModel> schemes,
    String category,
  ) {
    if (category.toLowerCase() == 'all') return schemes;
    return schemes
        .where((s) => s.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  List<SchemeModel> searchSchemes(List<SchemeModel> schemes, String query) {
    if (query.isEmpty) return schemes;
    final lowerQuery = query.toLowerCase();
    return schemes.where((scheme) {
      return scheme.name.toLowerCase().contains(lowerQuery) ||
          scheme.description.toLowerCase().contains(lowerQuery) ||
          scheme.ministry.toLowerCase().contains(lowerQuery) ||
          scheme.category.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<void> addScheme(SchemeModel scheme) async {
    try {
      await _firestore.collection(collectionName).add(scheme.toFirestore());
      print('Scheme added successfully');
    } catch (e) {
      print('Error adding scheme: $e');
      rethrow;
    }
  }

  Future<void> updateScheme(String id, SchemeModel scheme) async {
    try {
      await _firestore
          .collection(collectionName)
          .doc(id)
          .update(scheme.toFirestore());
      print('Scheme updated successfully');
    } catch (e) {
      print('Error updating scheme: $e');
      rethrow;
    }
  }

  Future<void> deleteScheme(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
      print('Scheme deleted successfully');
    } catch (e) {
      print('Error deleting scheme: $e');
      rethrow;
    }
  }
}
