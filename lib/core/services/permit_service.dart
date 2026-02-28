import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import '../database/app_database.dart';
import '../models/permit_model.dart';

class PermitService {
  final AppDatabase _database;
  late final encrypt.Encrypter _encrypter;
  late final encrypt.IV _iv;

  PermitService(this._database) {
    _initEncryption();
  }

  void _initEncryption() {
    // Generate encryption key from app secret (NFR-12: AES-256)
    const secret = 'hajj_companion_secret_key_2025_v1.0';
    final key = encrypt.Key.fromUtf8(
      sha256.convert(utf8.encode(secret)).toString().substring(0, 32),
    );
    _iv = encrypt.IV.fromLength(16);
    _encrypter = encrypt.Encrypter(encrypt.AES(key));
  }

  String _encryptData(String data) {
    return _encrypter.encrypt(data, iv: _iv).base64;
  }

  String _decryptData(String encryptedData) {
    return _encrypter.decrypt64(encryptedData, iv: _iv);
  }

  // FR-01: Save permit information
  Future<int> savePermit(PermitModel permit) async {
    // Encrypt sensitive data
    final permitJson = jsonEncode(permit.toJson());
    final encryptedData = _encryptData(permitJson);

    final companion = PermitsCompanion.insert(
      permitNumber: permit.permitNumber,
      fullName: permit.fullName,
      permitType: permit.permitType,
      startDate: permit.startDate,
      endDate: permit.endDate,
      encryptedData: Value(encryptedData),
      createdAt: Value(DateTime.now()),
      updatedAt: Value(DateTime.now()),
    );

    // Delete existing permit and insert new one (single permit app)
    await _database.deleteAllPermits();
    return await _database.insertPermit(companion);
  }

  // FR-02: Get stored permit with decryption validation
  Future<PermitModel?> getPermit() async {
    final permit = await _database.getPermit();
    if (permit == null) return null;

    // Validate encrypted data integrity if available
    if (permit.encryptedData != null && permit.encryptedData!.isNotEmpty) {
      try {
        final decryptedJson = _decryptData(permit.encryptedData!);
        // Verify decryption is successful (data integrity check)
        jsonDecode(decryptedJson);
      } catch (e) {
        // Encryption integrity check failed
        print('Warning: Permit data integrity check failed - $e');
      }
    }

    return PermitModel(
      id: permit.id,
      permitNumber: permit.permitNumber,
      fullName: permit.fullName,
      permitType: permit.permitType,
      startDate: permit.startDate,
      endDate: permit.endDate,
      createdAt: permit.createdAt,
      updatedAt: permit.updatedAt,
    );
  }

  // FR-02: Watch permit changes (reactive)
  Stream<PermitModel?> watchPermit() {
    return _database.watchPermit().map((permit) {
      if (permit == null) return null;
      return PermitModel(
        id: permit.id,
        permitNumber: permit.permitNumber,
        fullName: permit.fullName,
        permitType: permit.permitType,
        startDate: permit.startDate,
        endDate: permit.endDate,
        createdAt: permit.createdAt,
        updatedAt: permit.updatedAt,
      );
    });
  }

  // Update permit
  Future<bool> updatePermit(PermitModel permit) async {
    if (permit.id == null) return false;

    final permitJson = jsonEncode(permit.toJson());
    final encryptedData = _encryptData(permitJson);

    final companion = PermitsCompanion(
      id: Value(permit.id!),
      permitNumber: Value(permit.permitNumber),
      fullName: Value(permit.fullName),
      permitType: Value(permit.permitType),
      startDate: Value(permit.startDate),
      endDate: Value(permit.endDate),
      encryptedData: Value(encryptedData),
      updatedAt: Value(DateTime.now()),
    );

    return await _database.updatePermit(companion);
  }

  // Delete permit
  Future<int> deletePermit(int id) async {
    return await _database.deletePermit(id);
  }

  // Check if permit exists
  Future<bool> hasPermit() async {
    final permit = await _database.getPermit();
    return permit != null;
  }

  // Validate permit dates
  bool isPermitValid(PermitModel permit) {
    final now = DateTime.now();
    return now.isAfter(permit.startDate) && now.isBefore(permit.endDate);
  }
}
