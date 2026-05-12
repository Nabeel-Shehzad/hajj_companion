import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:crypto/crypto.dart';
import '../database/app_database.dart';
import '../models/permit_model.dart';

class PermitService {
  final AppDatabase _database;
  //كتبنا فاينل  لان ما نبي نغير الداتابيس بعد انشاء السيرفس 
  late final encrypt.Encrypter _encrypter;
  late final encrypt.IV _iv;

  PermitService(this._database) {
    _initEncryption();
  }

  void _initEncryption() {
    // Generate encryption key from app secret (NFR-12: AES-256)
    const secret = 'hajj_companion_secret_key_2025_v1.0';
    //fromUtf8: Converts the secret string into bytes for hashing.
    //sha256: Hashes the secret using SHA-256 to create a 32-byte key.
    //substring(0, 32): Ensures the key is exactly 32 bytes for AES-256.
    final key = encrypt.Key.fromUtf8( sha256.convert(utf8.encode(secret)).toString().substring(0, 32), );
//initializes AES encryption by generating a secure key from a secret string and preparing the IV and encrypter.
    _iv = encrypt.IV.fromLength(16);
    _encrypter = encrypt.Encrypter(encrypt.AES(key));
  }


// Encrypts the permit data to ensure sensitive information is protected in storage.
  String _encryptData(String data) {
    return _encrypter.encrypt(data, iv: _iv).base64;
    //Encrypts permit data before storing it in the local database
  }
String _decryptData(String encryptedData) {
  return _encrypter.decrypt64(encryptedData, iv: _iv);
  //Decrypts the encrypted permit data back to its original readable format
}

Future<int> savePermit(PermitModel permit) async {
  final permitJson = jsonEncode(permit.toJson());// Convert the permit object to JSON string for encryption.
  final encryptedData = _encryptData(permitJson);// Encrypt the permit data before saving to the database.

 final companion = PermitsCompanion.insert(
    ////converts the permit object to JSON, encrypts it, deletes any old permit, and saves the new permit in the local database.

    permitNumber: permit.permitNumber,
    fullName: permit.fullName,
    permitType: permit.permitType,
    startDate: permit.startDate,
    endDate: permit.endDate,
    encryptedData: Value(encryptedData),
    createdAt: Value(DateTime.now()),
    updatedAt: Value(DateTime.now()),
  );

  // The app stores one permit only, so the old permit is removed first.
  await _database.deleteAllPermits();

  // Insert the new encrypted permit into the local database.
  return await _database.insertPermit(companion);
  //converts the permit object to JSON, encrypts it, deletes any old permit, and saves the new permit in the local database.
}


Future<PermitModel?> getPermit() async {
  //Retrieves the stored permit from the local database and checks that the encrypted data can be decrypted correctly.
  //async: Indicates that this function performs asynchronous operations, allowing it to use 'await' for database calls.
  final permit = await _database.getPermit();
  if (permit == null) {
    return null;
  }
  if (permit.encryptedData != null && permit.encryptedData!.isNotEmpty) {
    try {
      final decryptedJson = _decryptData(permit.encryptedData!);
      jsonDecode(decryptedJson);
      // If decryption and JSON parsing succeed, we can trust the data integrity.
    } catch (e) {
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


Stream<PermitModel?> watchPermit() {
  //stream: Allows continuous listening for changes in the permit data, enabling real-time updates in the app when the permit information is modified.
  return _database.watchPermit().map((permit) {
    if (permit == null) {
      return null;
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
  });
}

Future<bool> updatePermit(PermitModel permit) async {
  //Updates an existing permit by encrypting the updated data and saving the new values in the local database
  if (permit.id == null) {
    return false;
  }

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
    //value: Used to indicate that the field should be updated with the provided value. In this case, it updates the 'updatedAt' timestamp to the current time whenever the permit is updated.
  );
  return await _database.updatePermit(companion);
}


// Delete permit by ID
Future<int> deletePermit(int id) async {
  return await _database.deletePermit(id);
}

// Check if a permit already exists
Future<bool> hasPermit() async {
  final permit = await _database.getPermit();
  return permit != null;
}

// Check if the permit is currently valid
bool isPermitValid(PermitModel permit) {
  final now = DateTime.now();
  return now.isAfter(permit.startDate) && now.isBefore(permit.endDate);
}
}