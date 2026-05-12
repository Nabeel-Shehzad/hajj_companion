import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hajj_companion/core/services/permit_service.dart';
import 'package:hajj_companion/core/services/gesture_service.dart';
import 'package:hajj_companion/core/models/permit_model.dart';
import 'package:hajj_companion/core/database/app_database.dart';
import 'package:hajj_companion/core/providers/language_provider.dart';
import 'package:intl/intl.dart';
import 'permit_entry_screen.dart';

class PermitDisplayScreen extends StatefulWidget {
  const PermitDisplayScreen({super.key});

  @override
  State<PermitDisplayScreen> createState() => _PermitDisplayScreenState();
}

class _PermitDisplayScreenState extends State<PermitDisplayScreen> {
  late final _permitService = PermitService(AppDatabase.instance);
  late final _gestureService = GestureService();
  bool _gestureDetectionEnabled = false;
  bool _isGestureHighlighted = false;

  void initState() {
    super.initState();
    _loadGestureSettings();
    _initGestureDetection();
  }

  Future<void> _loadGestureSettings() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _gestureDetectionEnabled =
            prefs.getBool('gesture_detection_enabled') ?? false;
      });
    }

    // Start monitoring if it was previously enabled
    if (_gestureDetectionEnabled) {
      _gestureService.startMonitoring();
    }
  }

  Future<void> _saveGestureSettings(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('gesture_detection_enabled', enabled);
  }

  void _initGestureDetection() {
    // Listen to gesture events for mobile demo (shake phone = wrist raise)
    _gestureService.gestureStream.listen((gesture) {
      if (gesture == WristGesture.raised && _gestureDetectionEnabled) {
        _handleGestureDetected();
      }
    });
  }

  void _handleGestureDetected() {
    // Visual feedback - highlight the permit card briefly
    setState(() {
      _isGestureHighlighted = true;
    });

    // Show quick confirmation with haptic feedback
    _showQuickPermitDialog();

    // Reset highlight after animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isGestureHighlighted = false;
        });
      }
    });
  }

  void _showQuickPermitDialog() {
    // Haptic feedback (vibration) - simulating smartwatch feedback
    HapticFeedback.mediumImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '✅ Gesture Detected!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Permit auto-displayed (smartwatch mode)',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF006B3E),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _gestureService.dispose();
    super.dispose();
  }

  void _navigateToEdit(PermitModel? permit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PermitEntryScreen(existingPermit: permit),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = LanguageProvider.of(context);
    final tr = provider?.localizations;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr?.digitalPermitTitle ?? 'Digital Permit'),
        centerTitle: true,
        actions: [
          StreamBuilder<PermitModel?>(
            stream: _permitService.watchPermit(),
            builder: (context, snapshot) {
              return IconButton(
                icon: const Icon(Icons.share),
                onPressed: snapshot.hasData && snapshot.data != null
                    ? () {
                        final permit = snapshot.data!;
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: Text(tr?.share ?? 'Share Permit'),
                            content: Text(
                              '${tr?.permitNumber ?? 'Permit Number'}: ${permit.permitNumber}\n'
                              '${tr?.fullName ?? 'Name'}: ${permit.fullName}\n'
                              '${tr?.permitType ?? 'Type'}: ${permit.permitType}\n'
                              '${tr?.validFrom ?? 'Valid'}: ${DateFormat('dd/MM/yyyy').format(permit.startDate)} - ${DateFormat('dd/MM/yyyy').format(permit.endDate)}',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text(tr?.cancel ?? 'Close'),
                              ),
                            ],
                          ),
                        );
                      }
                    : null,
                tooltip: 'Share Permit',
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<PermitModel?>(
        stream: _permitService.watchPermit(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.badge_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    tr?.noPermitFound ?? 'No permit found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your Hajj or Umrah permit details',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _navigateToEdit(null),
                    icon: const Icon(Icons.add),
                    label: Text(tr?.addPermit ?? 'Add Permit'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      backgroundColor: const Color(0xFF006B3E),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          final permit = snapshot.data!;
          final dateFormat = DateFormat('dd/MM/yyyy');

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF006B3E).withOpacity(0.1),
                  Colors.white,
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Islamic Pattern Decoration
                    const Text(
                      '﷽',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color(0xFF006B3E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Permit Card with gesture highlight animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF006B3E), Color(0xFF008B4E)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _isGestureHighlighted
                                ? const Color(0xFFD4AF37).withOpacity(0.8)
                                : const Color(0xFF006B3E).withOpacity(0.4),
                            blurRadius: _isGestureHighlighted ? 30 : 20,
                            spreadRadius: _isGestureHighlighted ? 5 : 0,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Container(
                          padding: const EdgeInsets.all(28.0),
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: Column(
                            children: [
                              // Header
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(
                                      0xFFD4AF37,
                                    ).withOpacity(0.5),
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFD4AF37,
                                        ).withOpacity(0.3),
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFFD4AF37,
                                            ).withOpacity(0.5),
                                            blurRadius: 15,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.mosque,
                                        size: 32,
                                        color: Color(0xFFD4AF37),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            permit.permitType == 'Hajj'
                                                ? (tr?.hajjPermit ??
                                                      'Hajj Permit')
                                                : (tr?.umrahPermit ??
                                                      'Umrah Permit'),
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFFD4AF37),
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            tr?.kingdomOfSaudiArabia ??
                                                'Kingdom of Saudi Arabia',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // QR Code
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: const Color(0xFFD4AF37),
                                    width: 3,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(
                                        0xFFD4AF37,
                                      ).withOpacity(0.4),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: QrImageView(
                                  data: permit.permitNumber,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Permit Details with Islamic styling
                              _buildDetailRow(
                                context,
                                tr?.permitNumber ?? 'Permit Number',
                                permit.permitNumber,
                                Icons.confirmation_number,
                              ),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                context,
                                tr?.fullName ?? 'Full Name',
                                permit.fullName,
                                Icons.person,
                              ),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                context,
                                tr?.validFrom ?? 'Valid From',
                                dateFormat.format(permit.startDate),
                                Icons.calendar_today,
                              ),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                context,
                                tr?.validUntil ?? 'Valid Until',
                                dateFormat.format(permit.endDate),
                                Icons.event,
                              ),
                              const SizedBox(height: 28),

                              // Status Badge with dynamic color based on validity
                              _buildStatusBadge(permit, tr),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Instructions with Islamic design
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFD4AF37).withOpacity(0.1),
                            const Color(0xFF006B3E).withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFD4AF37,
                                  ).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF006B3E),
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                tr?.showAtCheckpoints ??
                                    'Show this screen to security officers at checkpoints',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: const Color(0xFF006B3E),
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                tr?.raiseWrist ??
                                    'Raise your wrist to quickly display your permit',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: const Color(0xFF8B4513)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Gesture Detection Toggle (Mobile Demo) - Enhanced UI
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _gestureDetectionEnabled
                                ? const Color(0xFF006B3E).withOpacity(0.1)
                                : Colors.grey.shade100,
                            _gestureDetectionEnabled
                                ? const Color(0xFFD4AF37).withOpacity(0.05)
                                : Colors.grey.shade50,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _gestureDetectionEnabled
                              ? const Color(0xFF006B3E)
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        boxShadow: _gestureDetectionEnabled
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF006B3E,
                                  ).withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _gestureDetectionEnabled
                                          ? const Color(0xFF006B3E)
                                          : Colors.grey.shade400,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _gestureDetectionEnabled
                                          ? Icons.sensors
                                          : Icons.sensors_off,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _gestureDetectionEnabled
                                              ? '🎯 Gesture Detection Active'
                                              : 'Gesture Detection',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: _gestureDetectionEnabled
                                                ? const Color(0xFF006B3E)
                                                : Colors.grey.shade700,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _gestureDetectionEnabled
                                              ? '📱 Shake your phone to test'
                                              : 'Enable to test gesture detection',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: _gestureDetectionEnabled
                                                ? const Color(0xFF8B4513)
                                                : Colors.grey.shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _gestureDetectionEnabled,
                                    onChanged: (value) async {
                                      setState(() {
                                        _gestureDetectionEnabled = value;
                                      });

                                      // Save the setting
                                      await _saveGestureSettings(value);

                                      if (value) {
                                        _gestureService.startMonitoring();
                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Row(
                                                children: [
                                                  Icon(
                                                    Icons.check_circle,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 12),
                                                  Expanded(
                                                    child: Text(
                                                      '✅ Gesture detection enabled! Shake your phone to test.',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              backgroundColor: Color(
                                                0xFF006B3E,
                                              ),
                                              duration: Duration(seconds: 3),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                        }
                                      } else {
                                        _gestureService.stopMonitoring();
                                      }
                                    },
                                    activeColor: const Color(0xFFD4AF37),
                                    activeTrackColor: const Color(0xFF006B3E),
                                  ),
                                ],
                              ),
                              if (_gestureDetectionEnabled) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFD4AF37,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(
                                        0xFFD4AF37,
                                      ).withOpacity(0.3),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.lightbulb_outline,
                                        color: Color(0xFF8B4513),
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '⌚ On smartwatch: Raise your wrist\n📱 On phone: Shake device gently',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade700,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Delete Button
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _showDeleteDialog(context, permit.id!),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red.shade50,
                                  Colors.red.shade100,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.red.shade300,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.red.shade700,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  tr?.deletePermit ?? 'Delete Permit',
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: StreamBuilder<PermitModel?>(
        stream: _permitService.watchPermit(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            onPressed: () => _navigateToEdit(snapshot.data),
            icon: const Icon(Icons.edit),
            label: const Text('Edit Permit'),
            backgroundColor: const Color(0xFF006B3E),
            foregroundColor: Colors.white,
          );
        },
      ),
    );
  }

  Future<void> _showDeleteDialog(BuildContext context, int permitId) async {
    final provider = LanguageProvider.of(context);
    final tr = provider?.localizations;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr?.deletePermit ?? 'Delete Permit'),
          content: Text(
            tr?.deletePermitConfirm ??
                'Are you sure you want to delete this permit? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(tr?.cancel ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(tr?.delete ?? 'Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      final provider = LanguageProvider.of(context);
      final tr = provider?.localizations;

      try {
        await _permitService.deletePermit(permitId);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                tr?.permitDeletedSuccess ?? 'Permit deleted successfully',
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${tr?.errorDeletingPermit ?? 'Error deleting permit'}: $e',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD4AF37).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFFD4AF37)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(PermitModel permit, dynamic tr) {
    Color badgeColor;
    Color textColor;
    IconData iconData;
    String statusText;

    if (permit.isValid) {
      badgeColor = const Color(0xFFD4AF37);
      textColor = const Color(0xFF006B3E);
      iconData = Icons.verified;
      statusText = tr?.validPermit ?? 'Valid Permit';
    } else if (permit.isExpired) {
      badgeColor = Colors.red.shade400;
      textColor = Colors.white;
      iconData = Icons.error_outline;
      statusText = 'Expired';
    } else if (permit.isNotYetActive) {
      badgeColor = Colors.orange.shade400;
      textColor = Colors.white;
      iconData = Icons.schedule;
      statusText = 'Not Yet Active';
    } else {
      badgeColor = Colors.grey.shade400;
      textColor = Colors.white;
      iconData = Icons.help_outline;
      statusText = 'Unknown Status';
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [badgeColor, badgeColor.withOpacity(0.8)],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: badgeColor.withOpacity(0.6),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconData, color: textColor, size: 24),
              const SizedBox(width: 10),
              Text(
                statusText,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        if (permit.isValid && permit.daysRemaining <= 7)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '${permit.daysRemaining} day${permit.daysRemaining == 1 ? '' : 's'} remaining',
              style: TextStyle(
                color: Colors.orange.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}
