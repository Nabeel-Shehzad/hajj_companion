import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:hajj_companion/core/database/app_database.dart';
import 'package:hajj_companion/core/services/permit_service.dart';
import 'package:hajj_companion/core/models/permit_model.dart';
import 'package:hajj_companion/wear/screens/permit/wear_permit_entry_screen.dart';

class WearPermitDisplayScreen extends StatefulWidget {
  const WearPermitDisplayScreen({super.key});

  @override
  State<WearPermitDisplayScreen> createState() =>
      _WearPermitDisplayScreenState();
}

class _WearPermitDisplayScreenState extends State<WearPermitDisplayScreen> {
  final _database = AppDatabase.instance;
  late final _permitService = PermitService(_database);
  PermitModel? _permit;
  bool _isLoading = true;
  bool _showQR = true;

  @override
  void initState() {
    super.initState();
    _loadPermit();
  }

  Future<void> _loadPermit() async {
    setState(() => _isLoading = true);
    final permit = await _permitService.getPermit();
    setState(() {
      _permit = permit;
      _isLoading = false;
    });
  }

  Color _getStatusColor() {
    if (_permit == null) return Colors.grey;
    if (_permit!.isValid) return Colors.green;
    if (_permit!.isExpired) return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isRound =
        screenSize.width == screenSize.height && screenSize.width >= 300;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF00A651)),
              const SizedBox(height: 16),
              Text('Loading...', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      );
    }

    if (_permit == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(isRound ? 24.0 : 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.badge_outlined,
                  size: 48,
                  color: Colors.white.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'No Permit',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Add permit manually\non this watch',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WearPermitEntryScreen(),
                      ),
                    );
                    if (result == true && mounted) {
                      _loadPermit();
                    }
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Permit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A651),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Phone and watch\npermits are independent',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showQR = !_showQR;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [const Color(0xFF006B3E).withOpacity(0.3), Colors.black],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isRound ? 12.0 : 10.0),
              child: Column(
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _permit!.isValid ? Icons.check_circle : Icons.warning,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _permit!.statusText,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // QR Code or Details
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _showQR
                        ? _buildQRCodeSection(isRound)
                        : _buildDetailsSection(isRound),
                  ),

                  const SizedBox(height: 8),

                  // Tap to toggle hint
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app,
                          size: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Tap to ${_showQR ? "show details" : "show QR"}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQRCodeSection(bool isRound) {
    final qrSize = isRound ? 140.0 : 160.0;

    return Column(
      key: const ValueKey('qr'),
      children: [
        // Bismillah
        const Text(
          'بِسْمِ اللهِ',
          style: TextStyle(fontSize: 13, color: Color(0xFFD4AF37)),
        ),
        const SizedBox(height: 4),

        // Permit Type
        Text(
          '${_permit!.permitType} Permit',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),

        // QR Code
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD4AF37).withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: QrImageView(
            data: _permit!.permitNumber,
            version: QrVersions.auto,
            size: qrSize,
            backgroundColor: Colors.white,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
          ),
        ),
        const SizedBox(height: 12),

        // Permit Number
        Text(
          _permit!.permitNumber,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
            color: Color(0xFFD4AF37),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsSection(bool isRound) {
    return Column(
      key: const ValueKey('details'),
      children: [
        // Full Name
        _buildInfoRow(Icons.person, 'Name', _permit!.fullName),
        const SizedBox(height: 12),

        // Permit Number
        _buildInfoRow(Icons.badge, 'Permit', _permit!.permitNumber),
        const SizedBox(height: 12),

        // Dates — split across two rows to prevent truncation on narrow screens
        _buildInfoRow(
          Icons.calendar_today,
          'From',
          _formatDate(_permit!.startDate),
        ),
        const SizedBox(height: 8),
        _buildInfoRow(
          Icons.event,
          'Until',
          _formatDate(_permit!.endDate),
        ),
        const SizedBox(height: 12),

        // Days Remaining
        if (_permit!.isValid && _permit!.daysRemaining > 0)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _permit!.daysRemaining < 7
                  ? Colors.orange.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${_permit!.daysRemaining} days remaining',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _permit!.daysRemaining < 7
                    ? Colors.orange
                    : Colors.green,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFD4AF37)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
