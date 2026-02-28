import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hajj_companion/core/models/permit_model.dart';
import 'package:hajj_companion/core/services/device_id_service.dart';

/// Syncs permits between phone and watch via Firebase Firestore
class PermitSyncService {
  final FirebaseFirestore _firestore;
  final DeviceIdService _deviceIdService;

  PermitSyncService(this._firestore, this._deviceIdService);

  /// Cloud collection path: users/{deviceId}/permit
  String get _permitPath => 'users';

  /// Save permit to cloud (called when saving on phone)
  Future<void> syncToCloud(PermitModel permit) async {
    try {
      final deviceId = await _deviceIdService.getDeviceId();
      await _firestore
          .collection(_permitPath)
          .doc(deviceId)
          .collection('permit')
          .doc('current')
          .set({
            'permitNumber': permit.permitNumber,
            'fullName': permit.fullName,
            'permitType': permit.permitType,
            'startDate': Timestamp.fromDate(permit.startDate),
            'endDate': Timestamp.fromDate(permit.endDate),
            'updatedAt': FieldValue.serverTimestamp(),
          });
      print('✅ Permit synced to cloud for device: $deviceId');
    } catch (e) {
      print('❌ Error syncing permit to cloud: $e');
      // Don't throw - allow offline operation
    }
  }

  /// Fetch permit from cloud (called on watch to get phone's permit)
  Future<PermitModel?> fetchFromCloud() async {
    try {
      final deviceId = await _deviceIdService.getDeviceId();
      final doc = await _firestore
          .collection(_permitPath)
          .doc(deviceId)
          .collection('permit')
          .doc('current')
          .get();

      if (!doc.exists) {
        print('ℹ️ No cloud permit found for device: $deviceId');
        return null;
      }

      final data = doc.data()!;
      final permit = PermitModel(
        id: 1, // Local DB ID (will be assigned when saved locally)
        permitNumber: data['permitNumber'] as String,
        fullName: data['fullName'] as String,
        permitType: data['permitType'] as String,
        startDate: (data['startDate'] as Timestamp).toDate(),
        endDate: (data['endDate'] as Timestamp).toDate(),
      );
      print('✅ Permit fetched from cloud for device: $deviceId');
      return permit;
    } catch (e) {
      print('❌ Error fetching permit from cloud: $e');
      return null;
    }
  }

  /// Delete permit from cloud
  Future<void> deleteFromCloud() async {
    try {
      final deviceId = await _deviceIdService.getDeviceId();
      await _firestore
          .collection(_permitPath)
          .doc(deviceId)
          .collection('permit')
          .doc('current')
          .delete();
      print('✅ Permit deleted from cloud for device: $deviceId');
    } catch (e) {
      print('❌ Error deleting permit from cloud: $e');
    }
  }

  /// Stream permits from cloud (real-time sync)
  Stream<PermitModel?> streamFromCloud() async* {
    final deviceId = await _deviceIdService.getDeviceId();

    await for (final snapshot
        in _firestore
            .collection(_permitPath)
            .doc(deviceId)
            .collection('permit')
            .doc('current')
            .snapshots()) {
      if (!snapshot.exists) {
        yield null;
        continue;
      }

      final data = snapshot.data()!;
      yield PermitModel(
        id: 1,
        permitNumber: data['permitNumber'] as String,
        fullName: data['fullName'] as String,
        permitType: data['permitType'] as String,
        startDate: (data['startDate'] as Timestamp).toDate(),
        endDate: (data['endDate'] as Timestamp).toDate(),
      );
    }
  }
}
