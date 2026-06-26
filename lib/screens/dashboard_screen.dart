import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../utils/responsive.dart';
import '../providers/navigation_provider.dart';
import 'device_info_screen.dart';
import 'claims_screen.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.isMobile(context) ? 20 : 28,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreetingHeader(context, ref, isDark),
          const SizedBox(height: 24),
          _buildSearchBar(context, isDark),
          const SizedBox(height: 28),
          _buildProtectionScoreAndValueChart(context, isDark),
          const SizedBox(height: 28),
          _buildQuickActionsRow(context, ref, isDark),
          const SizedBox(height: 32),
          _buildUpcomingRenewals(context, isDark),
          const SizedBox(height: 32),
          if (Responsive.isDesktop(context))
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _buildActivePolicies(context, ref, isDark),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 2,
                  child: _buildRecentClaims(context, ref, isDark),
                ),
              ],
            )
          else ...[
            _buildActivePolicies(context, ref, isDark),
            const SizedBox(height: 28),
            _buildRecentClaims(context, ref, isDark),
          ],
          const SizedBox(height: 100), // Space to scroll past the bottom bar
        ],
      ),
    );
  }

  Widget _buildGreetingHeader(BuildContext context, WidgetRef ref, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning, Avinash',
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : AppColors.ipackBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your digital assets are 94% secure',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: isDark ? Colors.white54 : Colors.grey[600],
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            ref.read(navigationProvider.notifier).setNavItem(NavItem.profile);
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.ipackOrange : AppColors.ipackBlue,
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              child: Text(
                'AM',
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.ipackBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? Colors.white38 : Colors.grey[500],
            size: 20,
          ),
          hintText: 'Search active policies, claims & support...',
          hintStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.grey[400],
            fontSize: 13,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildProtectionScoreAndValueChart(BuildContext context, bool isDark) {
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;
    final isMobile = Responsive.isMobile(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SECURITY SUMMARY',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
          const SizedBox(height: 20),
          isMobile
              ? Column(
                  children: [
                    _buildProtectionScoreArc(isDark),
                    const SizedBox(height: 32),
                    _buildAssetChart(isDark),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildProtectionScoreArc(isDark)),
                    const SizedBox(width: 32),
                    Expanded(flex: 3, child: _buildAssetChart(isDark)),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildProtectionScoreArc(bool isDark) {
    return Row(
      children: [
        SizedBox(
          width: 90,
          height: 90,
          child: CustomPaint(
            painter: ArcPainter(score: 0.94, isDark: isDark),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '94%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    'Secure',
                    style: TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Coverage Level: Elite',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.ipackBlue,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'No immediate actions needed. All active policies running safely.',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: isDark ? Colors.white54 : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssetChart(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Insured Assets Value',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
            Text(
              '₹1,20,000',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.ipackOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 64,
          width: double.infinity,
          child: CustomPaint(
            painter: ChartLinePainter(isDark: isDark),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionsRow(BuildContext context, WidgetRef ref, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(
          context,
          'Insure New',
          Icons.add_moderator_outlined,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DeviceInfoScreen()),
            );
          },
          isDark,
        ),
        _buildActionItem(
          context,
          'File Claim',
          Icons.file_upload_outlined,
          () {
            ref.read(navigationProvider.notifier).setNavItem(NavItem.claims);
            // Wait brief moment and open file claim sheet
            Future.delayed(const Duration(milliseconds: 250), () {
              if (context.mounted) {
                ClaimsScreen.showFileClaimSheet(context, ref);
              }
            });
          },
          isDark,
        ),
        _buildActionItem(
          context,
          'Search Plans',
          Icons.search_rounded,
          () {
            ref.read(navigationProvider.notifier).setNavItem(NavItem.policies);
          },
          isDark,
        ),
        _buildActionItem(
          context,
          'Alert Logs',
          Icons.notifications_none_rounded,
          () {
            ref.read(navigationProvider.notifier).setNavItem(NavItem.notifications);
          },
          isDark,
        ),
      ],
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
    bool isDark,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.ipackOrange, size: 24),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingRenewals(BuildContext context, bool isDark) {
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'UPCOMING RENEWALS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Apple iPad Pro 11"',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.ipackBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Renewal due in 12 days • ₹299 / mo',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white54 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.ipackOrange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'PAY NOW',
                  style: TextStyle(
                    color: AppColors.ipackOrange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivePolicies(BuildContext context, WidgetRef ref, bool isDark) {
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Active Protection',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.ipackBlue,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                onPressed: () {
                  ref.read(navigationProvider.notifier).setNavItem(NavItem.policies);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey[50],
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.ipackOrange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.phone_iphone_rounded,
                    color: AppColors.ipackOrange,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Apple iPhone 15 Pro',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: isDark ? Colors.white : AppColors.ipackBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Policy ID: IPK-9842-8812',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white54 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentClaims(BuildContext context, WidgetRef ref, bool isDark) {
    final cardBg = isDark ? AppColors.darkSurface : Colors.white;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Claims History',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.ipackBlue,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                onPressed: () {
                  ref.read(navigationProvider.notifier).setNavItem(NavItem.claims);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.grey[50],
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'iPhone 14 Pro Screen',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: isDark ? Colors.white : AppColors.ipackBlue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Claimed ₹14,999 • Settled',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white54 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  final double score;
  final bool isDark;

  ArcPainter({required this.score, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 8.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track track paint (background circle arc)
    final trackPaint = Paint()
      ..color = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, trackPaint);

    // Active arc paint (progress)
    final arcPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppColors.ipackOrange, AppColors.ipackBlue],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double sweepAngle = 2 * math.pi * score;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ChartLinePainter extends CustomPainter {
  final bool isDark;

  ChartLinePainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // List of points representing valuation line
    final points = [
      Offset(0, height * 0.8),
      Offset(width * 0.25, height * 0.7),
      Offset(width * 0.5, height * 0.45),
      Offset(width * 0.75, height * 0.5),
      Offset(width, height * 0.2),
    ];

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) {
      final p0 = points[i - 1];
      final p1 = points[i];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p1.dx,
        p1.dy,
      );
    }

    // Shadow gradient under line
    final fillPath = Path()
      ..addPath(path, Offset.zero)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          AppColors.ipackOrange.withValues(alpha: 0.12),
          AppColors.ipackOrange.withValues(alpha: 0.0),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(0, 0, width, height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Border line paint
    final linePaint = Paint()
      ..color = AppColors.ipackOrange
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Glowing dot at the end of the line
    final lastPoint = points.last;
    final dotPaint = Paint()
      ..color = AppColors.ipackOrange
      ..style = PaintingStyle.fill;
    final glowPaint = Paint()
      ..color = AppColors.ipackOrange.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(lastPoint, 8, glowPaint);
    canvas.drawCircle(lastPoint, 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
