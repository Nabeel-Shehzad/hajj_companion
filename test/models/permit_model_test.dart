import 'package:flutter_test/flutter_test.dart';
import 'package:hajj_companion/core/models/permit_model.dart';

void main() {
  group('PermitModel Validation Tests', () {
    test('validatePermitNumber - valid permit number', () {
      expect(PermitModel.validatePermitNumber('ABC12345'), null);
      expect(PermitModel.validatePermitNumber('HAJJ2026'), null);
      expect(PermitModel.validatePermitNumber('12345'), null);
    });

    test('validatePermitNumber - invalid permit number', () {
      expect(
        PermitModel.validatePermitNumber(''),
        'Please enter permit number',
      );
      expect(
        PermitModel.validatePermitNumber('ABC'),
        'Permit number must be at least 5 characters',
      );
      expect(
        PermitModel.validatePermitNumber('ABC-123'),
        'Permit number must contain only letters and numbers',
      );
      expect(
        PermitModel.validatePermitNumber('A' * 21),
        'Permit number must be 20 characters or less',
      );
    });

    test('validateFullName - valid names', () {
      expect(PermitModel.validateFullName('John Doe'), null);
      expect(PermitModel.validateFullName('محمد أحمد'), null);
      expect(PermitModel.validateFullName('Sarah Al Fahad'), null);
    });

    test('validateFullName - invalid names', () {
      expect(PermitModel.validateFullName(''), 'Please enter your full name');
      expect(
        PermitModel.validateFullName('A'),
        'Name must be at least 2 characters',
      );
      expect(
        PermitModel.validateFullName('A' * 51),
        'Name must be 50 characters or less',
      );
      expect(
        PermitModel.validateFullName('John123'),
        'Name must contain only letters and spaces',
      );
    });

    test('validateDateRange - valid date ranges', () {
      final start = DateTime(2026, 6, 1);
      final end = DateTime(2026, 6, 15);
      expect(PermitModel.validateDateRange(start, end), null);
    });

    test('validateDateRange - invalid date ranges', () {
      final start = DateTime(2026, 6, 1);
      final end = DateTime(2026, 5, 31);

      expect(
        PermitModel.validateDateRange(null, end),
        'Please select both start and end dates',
      );
      expect(
        PermitModel.validateDateRange(start, end),
        'End date must be after start date',
      );
      expect(
        PermitModel.validateDateRange(start, start),
        'Permit must be valid for at least 1 day',
      );
      expect(
        PermitModel.validateDateRange(
          start,
          start.add(const Duration(days: 366)),
        ),
        'Permit period cannot exceed 365 days',
      );
    });
  });

  group('PermitModel Status Tests', () {
    test('isValid - permit is currently valid', () {
      final permit = PermitModel(
        permitNumber: 'HAJJ2026',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 30)),
      );

      expect(permit.isValid, true);
      expect(permit.isExpired, false);
      expect(permit.isNotYetActive, false);
    });

    test('isExpired - permit has expired', () {
      final permit = PermitModel(
        permitNumber: 'HAJJ2025',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        endDate: DateTime.now().subtract(const Duration(days: 2)),
      );

      expect(permit.isExpired, true);
      expect(permit.isValid, false);
      expect(permit.isNotYetActive, false);
    });

    test('isNotYetActive - permit not yet valid', () {
      final permit = PermitModel(
        permitNumber: 'HAJJ2027',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime.now().add(const Duration(days: 30)),
        endDate: DateTime.now().add(const Duration(days: 60)),
      );

      expect(permit.isNotYetActive, true);
      expect(permit.isValid, false);
      expect(permit.isExpired, false);
    });

    test('daysRemaining - calculate correctly', () {
      final permit = PermitModel(
        permitNumber: 'HAJJ2026',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 10)),
      );

      expect(permit.daysRemaining, 10);
    });

    test('statusText - returns correct status', () {
      final validPermit = PermitModel(
        permitNumber: 'HAJJ2026',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 30)),
      );

      final expiredPermit = PermitModel(
        permitNumber: 'HAJJ2025',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        endDate: DateTime.now().subtract(const Duration(days: 2)),
      );

      expect(validPermit.statusText, 'Valid');
      expect(expiredPermit.statusText, 'Expired');
    });
  });

  group('PermitModel JSON Serialization Tests', () {
    test('toJson - converts model to JSON correctly', () {
      final permit = PermitModel(
        id: 1,
        permitNumber: 'HAJJ2026',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 15),
      );

      final json = permit.toJson();

      expect(json['id'], 1);
      expect(json['permitNumber'], 'HAJJ2026');
      expect(json['fullName'], 'Test User');
      expect(json['permitType'], 'Hajj');
      expect(json['startDate'], '2026-06-01T00:00:00.000');
      expect(json['endDate'], '2026-06-15T00:00:00.000');
    });

    test('fromJson - creates model from JSON correctly', () {
      final json = {
        'id': 1,
        'permitNumber': 'HAJJ2026',
        'fullName': 'Test User',
        'permitType': 'Hajj',
        'startDate': '2026-06-01T00:00:00.000',
        'endDate': '2026-06-15T00:00:00.000',
      };

      final permit = PermitModel.fromJson(json);

      expect(permit.id, 1);
      expect(permit.permitNumber, 'HAJJ2026');
      expect(permit.fullName, 'Test User');
      expect(permit.permitType, 'Hajj');
      expect(permit.startDate, DateTime(2026, 6, 1));
      expect(permit.endDate, DateTime(2026, 6, 15));
    });

    test('copyWith - creates copy with updated fields', () {
      final original = PermitModel(
        id: 1,
        permitNumber: 'HAJJ2026',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 15),
      );

      final updated = original.copyWith(
        fullName: 'Updated User',
        permitType: 'Umrah',
      );

      expect(updated.id, 1);
      expect(updated.permitNumber, 'HAJJ2026');
      expect(updated.fullName, 'Updated User');
      expect(updated.permitType, 'Umrah');
    });
  });
}
