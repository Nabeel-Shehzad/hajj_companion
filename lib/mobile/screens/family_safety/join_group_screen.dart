import 'package:flutter/material.dart';
import 'package:hajj_companion/core/services/device_id_service.dart';
import 'package:hajj_companion/core/services/family_group_service.dart';
import 'qr_scanner_screen.dart';

class JoinGroupScreen extends StatefulWidget {
  final DeviceIdService deviceIdService;
  final FamilyGroupService groupService;

  const JoinGroupScreen({
    super.key,
    required this.deviceIdService,
    required this.groupService,
  });

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _joinCodeController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _isChild = false;
  bool _isJoining = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill display name if already set
    final existingName = widget.deviceIdService.getDisplayName();
    if (existingName != null) {
      _displayNameController.text = existingName;
    }
  }

  @override
  void dispose() {
    _joinCodeController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Family Group'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.group_add, size: 64, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Join a Family Group',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter the join code provided by the group admin.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _joinCodeController,
                decoration: const InputDecoration(
                  labelText: 'Join Code',
                  hintText: 'e.g., ABC123',
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(),
                  helperText: '6-character code from group admin',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the join code';
                  }
                  if (value.trim().length != 6) {
                    return 'Join code must be 6 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.characters,
                maxLength: 6,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _scanQRCode,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scan QR Code'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _displayNameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                  hintText: 'e.g., Fatima',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _isChild,
                onChanged: (value) {
                  setState(() => _isChild = value ?? false);
                },
                title: const Text('I am a child'),
                subtitle: const Text(
                  'Parents will receive alerts if you go too far away',
                ),
                activeColor: Colors.green,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isJoining ? null : _joinGroup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isJoining
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Join Group',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scanQRCode() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const QrScannerScreen()),
    );

    if (result != null && mounted) {
      setState(() {
        _joinCodeController.text = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scanned join code: $result'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _joinGroup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isJoining = true);

    try {
      final group = await widget.groupService.joinGroup(
        joinCode: _joinCodeController.text.trim(),
        displayName: _displayNameController.text.trim(),
        isChild: _isChild,
      );

      if (group == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid join code. Please check and try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Successfully joined ${group.groupName}!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error joining group: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isJoining = false);
      }
    }
  }
}
