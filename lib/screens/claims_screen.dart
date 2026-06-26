import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../utils/responsive.dart';

class ClaimItem {
  final String id;
  final String title;
  final String device;
  final String date;
  final String status;
  final double repairCost;
  final int stepIndex; // 0: Filed, 1: Inspected, 2: Approved, 3: Settled

  ClaimItem({
    required this.id,
    required this.title,
    required this.device,
    required this.date,
    required this.status,
    required this.repairCost,
    required this.stepIndex,
  });
}

// Riverpod Provider for Claims List State
final claimsListProvider = StateNotifierProvider<ClaimsNotifier, List<ClaimItem>>((ref) {
  return ClaimsNotifier();
});

class ClaimsNotifier extends StateNotifier<List<ClaimItem>> {
  ClaimsNotifier() : super([
    ClaimItem(
      id: 'CLM-78401',
      title: 'Screen Cracks Repair',
      device: 'Apple iPhone 15 Pro',
      date: '12 Jun 2026',
      status: 'Settled',
      repairCost: 8999.00,
      stepIndex: 3,
    ),
    ClaimItem(
      id: 'CLM-89412',
      title: 'Liquid Spill Recovery',
      device: 'Samsung Galaxy Buds 2 Pro',
      date: '24 Jun 2026',
      status: 'Approved',
      repairCost: 3500.00,
      stepIndex: 2,
    ),
  ]);

  void addClaim(ClaimItem claim) {
    state = [claim, ...state];
  }
}

class ClaimsScreen extends ConsumerStatefulWidget {
  const ClaimsScreen({super.key});

  static void showFileClaimSheet(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewClaimSheet(
        onClaimCreated: (newClaim) {
          ref.read(claimsListProvider.notifier).addClaim(newClaim);
        },
        isDark: isDark,
      ),
    );
  }

  @override
  ConsumerState<ClaimsScreen> createState() => _ClaimsScreenState();
}

class _ClaimsScreenState extends ConsumerState<ClaimsScreen> {
  ClaimItem? _selectedClaim;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final claims = ref.watch(claimsListProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: Responsive.isMobile(context)
          ? AppBar(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'My Claims',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded),
                  onPressed: () => ClaimsScreen.showFileClaimSheet(context, ref),
                ),
              ],
            )
          : null,
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: _buildClaimsList(context, claims, isDark),
          ),
          if (!Responsive.isMobile(context) && _selectedClaim != null)
            Expanded(
              flex: 2,
              child: _buildClaimDetailsPanel(context, _selectedClaim!, isDark),
            ),
        ],
      ),
    );
  }

  Widget _buildClaimsList(BuildContext context, List<ClaimItem> claims, bool isDark) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.isMobile(context) ? 20 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!Responsive.isMobile(context)) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Claims Center',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'File claims, upload documents, and track reimbursement progress',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: isDark ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => ClaimsScreen.showFileClaimSheet(context, ref),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('File New Claim'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: claims.length,
            itemBuilder: (context, index) {
              final claim = claims[index];
              final isSelected = _selectedClaim?.id == claim.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.secondary
                        : (isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!),
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  type: MaterialType.canvas,
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(23),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(20),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        claim.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: isDark ? Colors.white : AppColors.primary,
                        ),
                      ),
                      _buildStatusPill(claim.status),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        claim.device,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Filed on: ${claim.date}',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark ? Colors.white38 : Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Est. Cost: ₹${NumberFormat('#,##,###').format(claim.repairCost)}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      _selectedClaim = claim;
                    });
                    if (Responsive.isMobile(context)) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.85,
                          maxChildSize: 0.9,
                          minChildSize: 0.5,
                          builder: (context, controller) {
                            return Container(
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkSurface : Colors.white,
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                              ),
                              child: SingleChildScrollView(
                                controller: controller,
                                child: _buildClaimDetailsPanel(context, claim, isDark),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClaimDetailsPanel(BuildContext context, ClaimItem claim, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Claim Tracker',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),
              Text(
                claim.id,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white38 : Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTimeline(claim.stepIndex, isDark),
          const SizedBox(height: 28),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 24),
          Text(
            'CLAIM DETAILS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 14),
          _buildDetailRow('Device Insured', claim.device, isDark),
          const SizedBox(height: 12),
          _buildDetailRow('Issue Description', claim.title, isDark),
          const SizedBox(height: 12),
          _buildDetailRow('Estimated Repair Cost', '₹${NumberFormat('#,##,###').format(claim.repairCost)}', isDark),
          const SizedBox(height: 12),
          _buildDetailRow('Filing Date', claim.date, isDark),
          const SizedBox(height: 28),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 24),
          Text(
            'UPLOADED DOCUMENTS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          _buildDocumentPreview('damage_receipt.pdf', 'PDF File • 1.2 MB', isDark),
          const SizedBox(height: 12),
          _buildDocumentPreview('device_screen.jpg', 'Image File • 4.3 MB', isDark),
        ],
      ),
    );
  }

  Widget _buildTimeline(int stepIndex, bool isDark) {
    final steps = ['Filed', 'Inspected', 'Approved', 'Settled'];
    return Column(
      children: List.generate(steps.length, (index) {
        final isCompleted = index <= stepIndex;
        final isLast = index == steps.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? AppColors.secondary : Colors.transparent,
                    border: Border.all(
                      color: isCompleted ? AppColors.secondary : (isDark ? Colors.white38 : Colors.grey[300]!),
                      width: 2.0,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 40,
                    color: isCompleted ? AppColors.secondary : (isDark ? Colors.white12 : Colors.grey[200]!),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isCompleted
                          ? (isDark ? Colors.white : AppColors.primary)
                          : (isDark ? Colors.white38 : Colors.grey[500]),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getTimelineStepDescription(index),
                    style: TextStyle(
                      fontSize: 11,
                      color: isCompleted
                          ? (isDark ? Colors.white70 : Colors.grey[600])
                          : (isDark ? Colors.white24 : Colors.grey[400]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  String _getTimelineStepDescription(int index) {
    switch (index) {
      case 0:
        return 'Claim registered successfully on network.';
      case 1:
        return 'Local technician verified hardware integrity.';
      case 2:
        return 'Reimbursement cost approved by audit panel.';
      default:
        return 'Amount disbursed to linked UPI account.';
    }
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white54 : Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentPreview(String name, String meta, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.insert_drive_file_outlined,
            color: AppColors.secondary,
            size: 24,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  meta,
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? Colors.white38 : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'settled':
        color = Colors.green;
        break;
      case 'approved':
        color = AppColors.secondary;
        break;
      default:
        color = AppColors.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class NewClaimSheet extends StatefulWidget {
  final ValueChanged<ClaimItem> onClaimCreated;
  final bool isDark;

  const NewClaimSheet({
    super.key,
    required this.onClaimCreated,
    required this.isDark,
  });

  @override
  State<NewClaimSheet> createState() => _NewClaimSheetState();
}

class _NewClaimSheetState extends State<NewClaimSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  String _selectedDevice = 'Apple iPhone 15 Pro';
  bool _isUploadingDoc = false;
  bool _docUploaded = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      final newClaim = ClaimItem(
        id: 'CLM-${math.Random().nextInt(90000) + 10000}',
        title: _titleController.text.trim(),
        device: _selectedDevice,
        date: DateFormat('dd MMM yyyy').format(DateTime.now()),
        status: 'Filed',
        repairCost: double.tryParse(_costController.text) ?? 4500.0,
        stepIndex: 0,
      );

      widget.onClaimCreated(newClaim);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Claim Raised Successfully! Ticket: ${newClaim.id}'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + keyboardPadding,
      ),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: widget.isDark ? Colors.white24 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'File New Claim',
                style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: widget.isDark ? Colors.white : AppColors.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Enter repair details and attach service invoice or photos.',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.isDark ? Colors.white54 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              // Device Selector
              DropdownButtonFormField<String>(
                initialValue: _selectedDevice,
                dropdownColor: widget.isDark ? AppColors.darkSurface : Colors.white,
                style: TextStyle(
                  color: widget.isDark ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
                decoration: _getInputDecoration('Select Covered Device', Icons.phone_iphone_rounded),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedDevice = val);
                },
                items: ['Apple iPhone 15 Pro', 'Samsung Galaxy Buds 2 Pro', 'Apple iPad Pro 11"'].map((device) {
                  return DropdownMenuItem(value: device, child: Text(device));
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Issue description
              TextFormField(
                controller: _titleController,
                style: TextStyle(color: widget.isDark ? Colors.white : Colors.black87),
                decoration: _getInputDecoration('Brief Issue Description (e.g. Broken screen)', Icons.edit_note_rounded),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter description' : null,
              ),
              const SizedBox(height: 16),
              // Estimated cost
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: widget.isDark ? Colors.white : Colors.black87),
                decoration: _getInputDecoration('Estimated Cost (₹)', Icons.currency_rupee_rounded),
                validator: (val) => val == null || val.trim().isEmpty ? 'Please enter estimated cost' : null,
              ),
              const SizedBox(height: 24),
              // Mock File uploader
              Text(
                'ATTACH PROOF (RECEIPT / INVOICE)',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: widget.isDark ? Colors.white38 : Colors.grey[500],
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  if (_docUploaded) return;
                  setState(() => _isUploadingDoc = true);
                  Future.delayed(const Duration(milliseconds: 1200), () {
                    if (!mounted) return;
                    setState(() {
                      _isUploadingDoc = false;
                      _docUploaded = true;
                    });
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: widget.isDark ? Colors.white.withValues(alpha: 0.02) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _docUploaded
                          ? Colors.green
                          : (widget.isDark ? Colors.white12 : Colors.grey[300]!),
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      if (_isUploadingDoc) ...[
                        const CircularProgressIndicator(strokeWidth: 2),
                        const SizedBox(height: 12),
                        const Text('Uploading document...', style: TextStyle(fontSize: 11)),
                      ] else if (_docUploaded) ...[
                        const Icon(Icons.check_circle_rounded, color: Colors.green, size: 36),
                        const SizedBox(height: 8),
                        const Text('invoice_repair.pdf attached', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green)),
                      ] else ...[
                        Icon(Icons.cloud_upload_outlined, color: AppColors.secondary, size: 36),
                        const SizedBox(height: 8),
                        const Text('Tap to upload PDF or Image proof', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Submit button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isDark ? AppColors.secondary : AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Submit Claim Request',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _getInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,
        color: widget.isDark ? Colors.white38 : Colors.grey[500],
        size: 20,
      ),
      hintText: hint,
      hintStyle: TextStyle(
        color: widget.isDark ? Colors.white38 : Colors.grey[400],
        fontSize: 13,
      ),
      filled: true,
      fillColor: widget.isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.secondary,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
