class SchemeModel {
  final String schemeId;
  final String name;
  final String description;
  final String eligibility;
  final String ministry;
  final String status;
  final String startDate;
  final String endDate;
  final Map<String, String> geography;

  SchemeModel({
    required this.schemeId,
    required this.name,
    required this.description,
    required this.eligibility,
    required this.ministry,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.geography,
  });

  factory SchemeModel.fromFirestore(String docId, Map<String, dynamic> data) {
    // Extract geography map
    Map<String, String> geoMap = {};
    if (data['geography'] != null && data['geography'] is Map) {
      final geo = data['geography'] as Map;
      geoMap = {
        'country': geo['country']?.toString() ?? 'India',
        'state': geo['state']?.toString() ?? 'All',
        'district': geo['district']?.toString() ?? 'All',
      };
    }

    return SchemeModel(
      schemeId: data['scheme_id'] ?? docId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      eligibility: data['eligibility'] ?? '',
      ministry: data['ministry'] ?? '',
      status: data['status'] ?? 'active',
      startDate: data['start_date'] ?? '',
      endDate: data['end_date'] ?? '',
      geography: geoMap,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'scheme_id': schemeId,
      'name': name,
      'description': description,
      'eligibility': eligibility,
      'ministry': ministry,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'geography': geography,
    };
  }

  factory SchemeModel.fromJson(Map<String, dynamic> json) {
    Map<String, String> geoMap = {};
    if (json['geography'] != null && json['geography'] is Map) {
      final geo = json['geography'] as Map;
      geoMap = {
        'country': geo['country']?.toString() ?? 'India',
        'state': geo['state']?.toString() ?? 'All',
        'district': geo['district']?.toString() ?? 'All',
      };
    }

    return SchemeModel(
      schemeId: json['scheme_id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      eligibility: json['eligibility'] ?? '',
      ministry: json['ministry'] ?? '',
      status: json['status'] ?? 'active',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      geography: geoMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheme_id': schemeId,
      'name': name,
      'description': description,
      'eligibility': eligibility,
      'ministry': ministry,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'geography': geography,
    };
  }

  // Helper method to get category from ministry
  String get category {
    final ministryLower = ministry.toLowerCase();
    if (ministryLower.contains('agriculture') ||
        ministryLower.contains('farmer')) {
      return 'Agriculture';
    } else if (ministryLower.contains('health')) {
      return 'Health';
    } else if (ministryLower.contains('education')) {
      return 'Education';
    } else if (ministryLower.contains('housing') ||
        ministryLower.contains('urban')) {
      return 'Housing';
    } else if (ministryLower.contains('social') ||
        ministryLower.contains('welfare')) {
      return 'Social Welfare';
    }
    return 'Other';
  }

  // Helper method for display location
  String get location {
    if (geography['state'] == 'All' && geography['district'] == 'All') {
      return 'All India';
    } else if (geography['district'] == 'All') {
      return geography['state'] ?? 'All India';
    }
    return '${geography['district']}, ${geography['state']}';
  }

  // Check if scheme is active
  bool get isActive => status.toLowerCase() == 'active';
}
