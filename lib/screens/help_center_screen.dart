import 'package:flutter/material.dart';
import '../main.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _msgController = TextEditingController();
  String _selectedCategory = 'Claim Query';
  bool _isSubmitting = false;

  final List<Map<String, String>> _faqs = [
    {
      'question': 'How long does the inspection take?',
      'answer': 'Most inspections are completed within 24 to 48 hours of filing a claim. Our local technician will contact you to verify details.'
    },
    {
      'question': 'What devices are supported?',
      'answer': 'We support all major smartphones, tablets, smartwatches, and laptops, including Apple, Samsung, Google, Dell, HP, and Lenovo.'
    },
    {
      'question': 'Can I transfer my policy?',
      'answer': 'Yes, you can transfer your policy to another device or user by contacting support with your serial numbers.'
    },
    {
      'question': 'How is payment processed for claims?',
      'answer': 'Approved repair costs are reimbursed directly to your linked UPI address or bank account within 3 business days.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _submitSupportRequest() {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _nameController.clear();
        _emailController.clear();
        _msgController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Support request sent! We will reply within 4 hours.'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF051124) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: isDark ? Colors.white : AppColors.ipackBlue, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Help & Support',
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.ipackBlue,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: isDark ? AppColors.ipackOrange : AppColors.ipackBlue,
          unselectedLabelColor: isDark ? Colors.white38 : Colors.grey[500],
          indicatorColor: isDark ? AppColors.ipackOrange : AppColors.ipackBlue,
          indicatorWeight: 2.5,
          tabs: const [
            Tab(text: 'FAQs'),
            Tab(text: 'Contact Us'),
            Tab(text: 'About'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFaqsTab(isDark),
          _buildContactTab(isDark),
          _buildAboutTab(isDark),
        ],
      ),
    );
  }

  Widget _buildFaqsTab(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _faqs.length,
      itemBuilder: (context, index) {
        final faq = _faqs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
            ),
          ),
          child: ExpansionTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.transparent,
            collapsedBackgroundColor: Colors.transparent,
            title: Text(
              faq['question']!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isDark ? Colors.white : AppColors.ipackBlue,
              ),
            ),
            childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            children: [
              Text(
                faq['answer']!,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContactTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SEND SUPPORT MESSAGE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                color: isDark ? Colors.white38 : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your name' : null,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: _getInputDecoration('Your Name', Icons.person_outline, isDark),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please enter your email' : null,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: _getInputDecoration('Email Address', Icons.email_outlined, isDark),
            ),
            const SizedBox(height: 16),
            // Category Dropdown
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              dropdownColor: isDark ? AppColors.darkSurface : Colors.white,
              decoration: _getInputDecoration('Query Category', Icons.category_outlined, isDark),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
              onChanged: (val) {
                if (val != null) setState(() => _selectedCategory = val);
              },
              items: ['Claim Query', 'Policy Billing', 'Device Support', 'General Query'].map((cat) {
                return DropdownMenuItem(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _msgController,
              maxLines: 4,
              validator: (value) => value == null || value.trim().isEmpty ? 'Please write your query' : null,
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: _getInputDecoration('Write your query here...', Icons.chat_bubble_outline_rounded, isDark),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitSupportRequest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? AppColors.ipackOrange : AppColors.ipackBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Submit Request',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.ipackBlue.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.ipackOrange,
              size: 48,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'i-Pack v2.4.0',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.ipackBlue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Securing Devices, Securing Livelihoods',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
              ),
            ),
            child: Column(
              children: [
                _buildAboutRow('Author', 'Avinash Magar', isDark),
                const Divider(height: 24, thickness: 0.5),
                _buildAboutRow('Security Protocol', '256-Bit SSL Encryption', isDark),
                const Divider(height: 24, thickness: 0.5),
                _buildAboutRow('Compliance Cert', 'ISO-27001 Certified', isDark),
                const Divider(height: 24, thickness: 0.5),
                _buildAboutRow('Licensing Code', 'IRDAI-REG-47291', isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutRow(String label, String value, bool isDark) {
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

  InputDecoration _getInputDecoration(String hint, IconData icon, bool isDark) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,
        color: isDark ? Colors.white38 : Colors.grey[500],
        size: 20,
      ),
      hintText: hint,
      hintStyle: TextStyle(
        color: isDark ? Colors.white38 : Colors.grey[400],
        fontSize: 14,
      ),
      filled: true,
      fillColor: isDark ? Colors.white.withValues(alpha: 0.04) : Colors.grey[100],
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
        borderSide: const BorderSide(
          color: AppColors.ipackOrange,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
