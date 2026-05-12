class PermitModel {
  
  final int? id;
  final String permitNumber;
  final String fullName;
  final String permitType;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  // Store creation and update timestamps.

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
  // Constructor used to create a PermitModel object.

  bool get isValid {
    final now = DateTime.now();
    return now.isAfter(startDate) &&
        now.isBefore(endDate.add(const Duration(days: 1)));
  }
  // Checks if the permit is currently valid.
  // Adds one extra day so the permit remains valid until the end of the expiry date.

  bool get isExpired {
    return DateTime.now().isAfter(endDate.add(const Duration(days: 1)));
  }
  // Checks whether the permit has expired.

  bool get isNotYetActive {
    return DateTime.now().isBefore(startDate);
  }
  // Checks if the permit start date has not been reached yet.

  int get daysRemaining {
    final now = DateTime.now();
    return endDate.difference(now).inDays;
  }
  // Calculates the remaining days until permit expiry.
  // Returns a negative value if the permit is expired.

  String get statusText {
    if (isValid) return 'Valid';
    if (isExpired) return 'Expired';
    if (isNotYetActive) return 'Not Yet Active';
    return 'Unknown';
  }
  // Returns the permit status as readable text for the UI.

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
  // Validates the permit number.
  // Ensures the value is not empty and contains only letters and numbers.

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
  // Validates the full name.
  // Allows English letters, Arabic letters, and spaces only.

  static String? validateDateRange(
      DateTime? startDate,
      DateTime? endDate,
      ) {
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
  // Validates the permit date range.

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
  //Map a collection of key-value pairs.
  // Converts the PermitModel object into JSON format.
  // Used for database storage and APIs.

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
  // Creates a PermitModel object from JSON data.

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
  // Creates a modified copy of the current object without changing the original one.
//علامه الاستفهام اذا يسار يعني الشي جديد اذا مو جديد يمين 
  @override
  String toString() {
    return 'PermitModel(id: $id, permitNumber: $permitNumber, fullName: $fullName, '
        'permitType: $permitType, status: $statusText)';
  }
  // Overrides the default object printing behavior for debugging and logging.
}