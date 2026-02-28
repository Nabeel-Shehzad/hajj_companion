import 'package:flutter/material.dart';
import 'package:hajj_companion/core/database/app_database.dart';
import 'package:hajj_companion/core/services/permit_service.dart';
import 'package:hajj_companion/core/models/permit_model.dart';

class WearPermitEntryScreen extends StatefulWidget {
  const WearPermitEntryScreen({super.key});

  @override
  State<WearPermitEntryScreen> createState() => _WearPermitEntryScreenState();
}

class _WearPermitEntryScreenState extends State<WearPermitEntryScreen> {
  final _permitNumberController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _permitType = 'Hajj';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isSaving = false;

  late final _permitService = PermitService(AppDatabase.instance);

  @override
  void dispose() {
    _permitNumberController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final initialDate = isStartDate
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now().add(const Duration(days: 30)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF00A651),
              onPrimary: Colors.white,
              surface: Color(0xFF1A1A1A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _savePermit() async {
    // Validation
    if (_permitNumberController.text.trim().isEmpty) {
      _showMessage('Enter permit number', isError: true);
      return;
    }
    if (_fullNameController.text.trim().isEmpty) {
      _showMessage('Enter full name', isError: true);
      return;
    }
    if (_startDate == null || _endDate == null) {
      _showMessage('Select both dates', isError: true);
      return;
    }
    if (_endDate!.isBefore(_startDate!)) {
      _showMessage('End date must be after start', isError: true);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final permit = PermitModel(
        permitNumber: _permitNumberController.text.trim(),
        fullName: _fullNameController.text.trim(),
        permitType: _permitType,
        startDate: _startDate!,
        endDate: _endDate!,
      );

      await _permitService.savePermit(permit);

      if (mounted) {
        _showMessage('Permit saved!');
        Navigator.pop(context, true); // Return true to refresh previous screen
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Save failed: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : const Color(0xFF00A651),
        duration: Duration(seconds: isError ? 3 : 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isRound = screenSize.width == screenSize.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Permit'), centerTitle: true),
      body: _isSaving
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF00A651)),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isRound ? 16.0 : 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Permit Number
                    Text(
                      'Permit Number',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _permitNumberController,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'ABC123456',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Full Name
                    Text(
                      'Full Name',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _fullNameController,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Your name',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Permit Type
                    Text('Type', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: _TypeChip(
                            label: 'Hajj',
                            isSelected: _permitType == 'Hajj',
                            onTap: () => setState(() => _permitType = 'Hajj'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _TypeChip(
                            label: 'Umrah',
                            isSelected: _permitType == 'Umrah',
                            onTap: () => setState(() => _permitType = 'Umrah'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Dates
                    Text(
                      'Valid From',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    _DateButton(
                      date: _startDate,
                      onTap: () => _selectDate(context, true),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Valid Until',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    _DateButton(
                      date: _endDate,
                      onTap: () => _selectDate(context, false),
                    ),
                    const SizedBox(height: 20),

                    // Save Button
                    ElevatedButton(
                      onPressed: _savePermit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A651),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Save Permit'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00A651) : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF00A651) : Colors.grey.shade700,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade400,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  final DateTime? date;
  final VoidCallback onTap;

  const _DateButton({required this.date, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade700),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null
                  ? '${date!.day}/${date!.month}/${date!.year}'
                  : 'Select date',
              style: TextStyle(
                fontSize: 14,
                color: date != null ? Colors.white : Colors.grey.shade500,
              ),
            ),
            Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }
}
