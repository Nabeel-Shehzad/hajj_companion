import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hajj_companion/core/services/device_id_service.dart';
import 'package:hajj_companion/core/services/family_group_service.dart';

class WearJoinGroupScreen extends StatefulWidget {
  const WearJoinGroupScreen({super.key});

  @override
  State<WearJoinGroupScreen> createState() => _WearJoinGroupScreenState();
}

class _WearJoinGroupScreenState extends State<WearJoinGroupScreen> {
  final _joinCodeController = TextEditingController();
  final _displayNameController = TextEditingController();
  bool _isChild = false;
  bool _isJoining = false;
  bool _servicesReady = false;

  FamilyGroupService? _groupService;
  DeviceIdService? _deviceIdService;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    _deviceIdService = DeviceIdService(prefs);
    _groupService = FamilyGroupService(
      FirebaseFirestore.instance,
      _deviceIdService!,
      prefs,
    );

    // Pre-fill name if already saved
    final existingName = _deviceIdService!.getDisplayName();
    if (existingName != null && mounted) {
      _displayNameController.text = existingName;
    }

    if (mounted) setState(() => _servicesReady = true);
  }

  @override
  void dispose() {
    _joinCodeController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _joinGroup() async {
    final code = _joinCodeController.text.trim().toUpperCase();
    final name = _displayNameController.text.trim();

    if (code.length != 6) {
      _showSnack('Enter 6-character code', isError: true);
      return;
    }
    if (name.length < 2) {
      _showSnack('Enter your name (2+ chars)', isError: true);
      return;
    }

    setState(() => _isJoining = true);

    try {
      final group = await _groupService!.joinGroup(
        joinCode: code,
        displayName: name,
        isChild: _isChild,
      );

      if (!mounted) return;

      if (group == null) {
        _showSnack('Code not found. Check and retry.', isError: true);
      } else {
        _showSnack('Joined ${group.groupName}!');
        // Short delay so the snackbar is visible before popping
        await Future.delayed(const Duration(milliseconds: 800));
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) _showSnack('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 11)),
        backgroundColor: isError ? Colors.red : const Color(0xFF00A651),
        duration: Duration(seconds: isError ? 3 : 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isRound =
        screenSize.width == screenSize.height && screenSize.width >= 300;

    if (!_servicesReady || _isJoining) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(color: Color(0xFF00A651)),
              const SizedBox(height: 12),
              Text(
                _isJoining ? 'Joining...' : 'Loading...',
                style: const TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isRound ? 24.0 : 14.0,
            vertical: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Join Group',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.group_add,
                    size: 18,
                    color: Color(0xFF2E8B57),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Join Code field
              _buildLabel('Join Code (6 chars)'),
              const SizedBox(height: 4),
              TextField(
                controller: _joinCodeController,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  color: Color(0xFF00A651),
                ),
                decoration: InputDecoration(
                  hintText: 'ABC123',
                  hintStyle: TextStyle(
                    letterSpacing: 2,
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF00A651)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
                maxLength: 6,
                buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                    Text(
                      '$currentLength/6',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
              ),
              const SizedBox(height: 12),

              // Display Name field
              _buildLabel('Your Name'),
              const SizedBox(height: 4),
              TextField(
                controller: _displayNameController,
                style: const TextStyle(fontSize: 13, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g. Fatima',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF00A651)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),

              // Child toggle
              GestureDetector(
                onTap: () => setState(() => _isChild = !_isChild),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: _isChild
                        ? Colors.orange.withOpacity(0.15)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isChild
                          ? Colors.orange.withOpacity(0.5)
                          : Colors.white.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isChild ? Icons.child_care : Icons.person,
                        size: 16,
                        color: _isChild ? Colors.orange : Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Joining as a child',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: _isChild
                                    ? Colors.orange
                                    : Colors.white70,
                              ),
                            ),
                            Text(
                              'Parents get alerts if you go far',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isChild
                              ? Colors.orange
                              : Colors.transparent,
                          border: Border.all(
                            color: _isChild
                                ? Colors.orange
                                : Colors.white.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: _isChild
                            ? const Icon(
                                Icons.check,
                                size: 12,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Join button
              ElevatedButton(
                onPressed: _joinGroup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E8B57),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Join Group',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        color: Colors.white.withOpacity(0.6),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
