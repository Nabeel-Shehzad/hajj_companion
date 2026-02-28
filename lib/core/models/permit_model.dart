class PermitModel {
  final int? id;
  final String permitNumber;
  final String fullName;
  final String permitType;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PermitModel({
    this.id,
    required this.permitNumber,
    required this.fullName,
    required this.permitType,
    required this.startDate,
    required this.endDate,
    this.createdAt,
    this.updatedAt,
  });

  /// Check if permit is currently valid
  bool get isValid {
    final now = DateTime.now();
    return now.isAfter(startDate) &&
        now.isBefore(endDate.add(const Duration(days: 1)));
  }

  /// Check if permit has expired
  bool get isExpired {
    return DateTime.now().isAfter(endDate.add(const Duration(days: 1)));
  }

  /// Check if permit is not yet active
  bool get isNotYetActive {
    return DateTime.now().isBefore(startDate);
  }

  /// Get days remaining until expiry (negative if expired)
  int get daysRemaining {
    final now = DateTime.now();
    return endDate.difference(now).inDays;
  }

  /// Get permit status as string
  String get statusText {
    if (isValid) return 'Valid';
    if (isExpired) return 'Expired';
    if (isNotYetActive) return 'Not Yet Active';
    return 'Unknown';
  }

  /// Validate permit number format (alphanumeric, 5-20 chars)
  static String? validatePermitNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter permit number';
    }
    if (value.length < 5) {
      return 'Permit number must be at least 5 characters';
    }
    if (value.length > 20) {
      return 'Permit number must be 20 characters or less';
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
      return 'Permit number must contain only letters and numbers';
    }
    return null;
  }

  /// Validate full name (letters and spaces only, 2-50 chars)
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.length > 50) {
      return 'Name must be 50 characters or less';
    }
    if (!RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$').hasMatch(value)) {
      return 'Name must contain only letters and spaces';
    }
    return null;
  }

  /// Validate date range
  static String? validateDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return 'Please select both start and end dates';
    }
    if (endDate.isBefore(startDate)) {
      return 'End date must be after start date';
    }
    if (endDate.difference(startDate).inDays < 1) {
      return 'Permit must be valid for at least 1 day';
    }
    if (endDate.difference(startDate).inDays > 365) {
      return 'Permit period cannot exceed 365 days';
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'permitNumber': permitNumber,
      'fullName': fullName,
      'permitType': permitType,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory PermitModel.fromJson(Map<String, dynamic> json) {
    return PermitModel(
      id: json['id'] as int?,
      permitNumber: json['permitNumber'] as String,
      fullName: json['fullName'] as String,
      permitType: json['permitType'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  PermitModel copyWith({
    int? id,
    String? permitNumber,
    String? fullName,
    String? permitType,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PermitModel(
      id: id ?? this.id,
      permitNumber: permitNumber ?? this.permitNumber,
      fullName: fullName ?? this.fullName,
      permitType: permitType ?? this.permitType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'PermitModel(id: $id, permitNumber: $permitNumber, fullName: $fullName, '
        'permitType: $permitType, status: $statusText)';
  }
}
