import 'package:flutter_test/flutter_test.dart';
import 'package:hajj_companion/models/permit_model.dart';
import 'package:hajj_companion/services/permit_service.dart';
import 'package:hajj_companion/database/app_database.dart';

void main() {
  late PermitService permitService;
  late AppDatabase database;

  setUp(() async {
    // Create in-memory database for testing
    database = AppDatabase();
    permitService = PermitService(database);
  });

  tearDown(() async {
    await database.close();
  });

  group('PermitService CRUD Operations', () {
    test('savePermit - saves permit with encryption', () async {
      final permit = PermitModel(
        permitNumber: 'HAJJ2026TEST',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 15),
      );

      final id = await permitService.savePermit(permit);
      expect(id, greaterThan(0));
    });

    test('getPermit - retrieves saved permit', () async {
      final permit = PermitModel(
        permitNumber: 'HAJJ2026TEST',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 15),
      );

      await permitService.savePermit(permit);
      final retrieved = await permitService.getPermit();

      expect(retrieved, isNotNull);
      expect(retrieved!.permitNumber, 'HAJJ2026TEST');
      expect(retrieved.fullName, 'Test User');
      expect(retrieved.permitType, 'Hajj');
    });

    test('updatePermit - updates existing permit', () async {
      final permit = PermitModel(
        permitNumber: 'HAJJ2026TEST',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 15),
      );

      await permitService.savePermit(permit);
      final retrieved = await permitService.getPermit();

      final updated = retrieved!.copyWith(
        fullName: 'Updated User',
        permitType: 'Umrah',
      );

      final result = await permitService.updatePermit(updated);
      expect(result, true);

      final updatedPermit = await permitService.getPermit();
      expect(updatedPermit!.fullName, 'Updated User');
      expect(updatedPermit.permitType, 'Umrah');
    });

    test('deletePermit - removes permit', () async {
      final permit = PermitModel(
        permitNumber: 'HAJJ2026TEST',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 15),
      );

      await permitService.savePermit(permit);
      final saved = await permitService.getPermit();
      expect(saved, isNotNull);

      await permitService.deletePermit(saved!.id!);
      final deleted = await permitService.getPermit();
      expect(deleted, isNull);
    });

    test('hasPermit - checks permit existence', () async {
      expect(await permitService.hasPermit(), false);

      final permit = PermitModel(
        permitNumber: 'HAJJ2026TEST',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 15),
      );

      await permitService.savePermit(permit);
      expect(await permitService.hasPermit(), true);
    });

    test('watchPermit - streams permit changes', () async {
      final stream = permitService.watchPermit();

      expect(
        stream,
        emitsInOrder([
          null, // Initially no permit
          isA<PermitModel>(), // After save
        ]),
      );

      // Trigger save after a delay
      Future.delayed(const Duration(milliseconds: 100), () async {
        final permit = PermitModel(
          permitNumber: 'HAJJ2026TEST',
          fullName: 'Test User',
          permitType: 'Hajj',
          startDate: DateTime(2026, 6, 1),
          endDate: DateTime(2026, 6, 15),
        );
        await permitService.savePermit(permit);
      });
    });
  });

  group('PermitService Validation', () {
    test('isPermitValid - validates permit dates', () {
      final validPermit = PermitModel(
        permitNumber: 'HAJJ2026TEST',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 30)),
      );

      expect(permitService.isPermitValid(validPermit), true);

      final expiredPermit = PermitModel(
        permitNumber: 'HAJJ2025TEST',
        fullName: 'Test User',
        permitType: 'Hajj',
        startDate: DateTime.now().subtract(const Duration(days: 60)),
        endDate: DateTime.now().subtract(const Duration(days: 2)),
      );

      expect(permitService.isPermitValid(expiredPermit), false);
    });
  });

  group('PermitService Encryption', () {
    test('encryption/decryption maintains data integrity', () async {
      final originalPermit = PermitModel(
        permitNumber: 'HAJJ2026TEST123',
        fullName: 'Ahmed Mohammed',
        permitType: 'Hajj',
        startDate: DateTime(2026, 6, 1, 10, 30),
        endDate: DateTime(2026, 6, 15, 18, 45),
      );

      await permitService.savePermit(originalPermit);
      final retrieved = await permitService.getPermit();

      expect(retrieved, isNotNull);
      expect(retrieved!.permitNumber, originalPermit.permitNumber);
      expect(retrieved.fullName, originalPermit.fullName);
      expect(retrieved.permitType, originalPermit.permitType);
      expect(
        retrieved.startDate.toString(),
        originalPermit.startDate.toString(),
      );
      expect(retrieved.endDate.toString(), originalPermit.endDate.toString());
    });

    test('encrypted data cannot be read directly from database', () async {
      final permit = PermitModel(
        permitNumber: 'SECRETHAJJ2026',
        fullName: 'Secret User',
        permitType: 'Hajj',
        startDate: DateTime(2026, 6, 1),
        endDate: DateTime(2026, 6, 15),
      );

      await permitService.savePermit(permit);

      // Get raw permit from database
      final rawPermit = await database.getPermit();
      expect(rawPermit, isNotNull);
      expect(rawPermit!.encryptedData, isNotNull);
      expect(rawPermit.encryptedData!.isNotEmpty, true);

      // Encrypted data should not contain plain text permit number
      expect(rawPermit.encryptedData!.contains('SECRETHAJJ2026'), false);
    });
  });
}
