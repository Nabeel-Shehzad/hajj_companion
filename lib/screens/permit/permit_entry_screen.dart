import 'package:flutter/material.dart';
import '../../services/permit_service.dart';
import '../../models/permit_model.dart';
import '../../database/app_database.dart';
import '../../main.dart';
import 'permit_display_screen.dart';

class PermitEntryScreen extends StatefulWidget {
  final PermitModel? existingPermit;

  const PermitEntryScreen({super.key, this.existingPermit});

  @override
  State<PermitEntryScreen> createState() => _PermitEntryScreenState();
}

class _PermitEntryScreenState extends State<PermitEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _permitNumberController = TextEditingController();
  final _fullNameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _permitType = 'Hajj';
  late final _permitService = PermitService(AppDatabase());
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill form if editing existing permit
    if (widget.existingPermit != null) {
      _permitNumberController.text = widget.existingPermit!.permitNumber;
      _fullNameController.text = widget.existingPermit!.fullName;
      _permitType = widget.existingPermit!.permitType;
      _startDate = widget.existingPermit!.startDate;
      _endDate = widget.existingPermit!.endDate;
    }
  }

  @override
  void dispose() {
    _permitNumberController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = LanguageProvider.of(context);
    final tr = provider?.localizations;
    final isArabic = provider?.language == 'Arabic';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingPermit != null
              ? (isArabic
                    ? '\u062a\u0639\u062f\u064a\u0644 \u0645\u0639\u0644\u0648\u0645\u0627\u062a \u0627\u0644\u062a\u0635\u0631\u064a\u062d'
                    : 'Edit Permit Information')
              : (tr?.enterPermitInfo ?? 'Enter Permit Information'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Permit Type Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr?.permitType ?? 'Permit Type',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      SegmentedButton<String>(
                        segments: [
                          ButtonSegment(
                            value: 'Hajj',
                            label: Text(tr?.hajj ?? 'Hajj'),
                            icon: const Icon(Icons.mosque),
                          ),
                          ButtonSegment(
                            value: 'Umrah',
                            label: Text(tr?.umrah ?? 'Umrah'),
                            icon: const Icon(Icons.star_half),
                          ),
                        ],
                        selected: {_permitType},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _permitType = newSelection.first;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Permit Number
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _permitNumberController,
                    decoration: InputDecoration(
                      labelText: tr?.permitNumber ?? 'Permit Number',
                      hintText:
                          tr?.enterPermitNumber ?? 'Enter your permit number',
                      prefixIcon: const Icon(Icons.confirmation_number),
                      border: const OutlineInputBorder(),
                      helperText: '5-20 alphanumeric characters',
                    ),
                    maxLength: 20,
                    textCapitalization: TextCapitalization.characters,
                    validator: PermitModel.validatePermitNumber,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Full Name
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: tr?.fullName ?? 'Full Name',
                      hintText: tr?.enterFullName ?? 'Enter your full name',
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                      helperText: 'Letters and spaces only (2-50 characters)',
                    ),
                    maxLength: 50,
                    textCapitalization: TextCapitalization.words,
                    validator: PermitModel.validateFullName,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Validity Period
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr?.validityPeriod ?? 'Validity Period',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      // Start Date
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(tr?.startDate ?? 'Start Date'),
                        subtitle: Text(
                          _startDate != null
                              ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                              : (tr?.selectStartDate ?? 'Select start date'),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now().subtract(
                              const Duration(days: 30),
                            ),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) {
                            setState(() {
                              _startDate = date;
                            });
                          }
                        },
                      ),
                      const Divider(),
                      // End Date
                      ListTile(
                        leading: const Icon(Icons.event),
                        title: Text(tr?.endDate ?? 'End Date'),
                        subtitle: Text(
                          _endDate != null
                              ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                              : (tr?.selectEndDate ?? 'Select end date'),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _startDate ?? DateTime.now(),
                            firstDate: _startDate ?? DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) {
                            setState(() {
                              _endDate = date;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton.icon(
                onPressed: _isSaving ? null : _savePermit,
                icon: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  _isSaving
                      ? (tr?.saving ?? 'Saving...')
                      : (tr?.savePermitInfo ?? 'Save Permit Information'),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _savePermit() async {
    final provider = LanguageProvider.of(context);
    final tr = provider?.localizations;
    final isArabic = provider?.language == 'Arabic';

    if (_formKey.currentState!.validate()) {
      // Validate dates with enhanced validation
      final dateError = PermitModel.validateDateRange(_startDate, _endDate);
      if (dateError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(dateError),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
          ),
        );
        return;
      }

      setState(() {
        _isSaving = true;
      });

      try {
        // Create permit model
        final permit = PermitModel(
          id: widget.existingPermit?.id,
          permitNumber: _permitNumberController.text.trim(),
          fullName: _fullNameController.text.trim(),
          permitType: _permitType,
          startDate: _startDate!,
          endDate: _endDate!,
        );

        // Save or update permit using service (with encryption)
        if (widget.existingPermit != null) {
          await _permitService.updatePermit(permit);
        } else {
          await _permitService.savePermit(permit);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.existingPermit != null
                    ? (isArabic
                          ? 'تم تحديث التصريح بنجاح!'
                          : 'Permit updated successfully!')
                    : (tr?.permitSavedSuccess ??
                          'Permit saved successfully with encryption!'),
              ),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to permit display screen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const PermitDisplayScreen(),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${tr?.errorSavingPermit ?? "Error saving permit"}: $e',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    }
  }
}
