import 'package:flutter/material.dart';

class Responsive {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static bool isMobile(BuildContext context) {
    return getScreenWidth(context) < 768;
  }

  static bool isTablet(BuildContext context) {
    return getScreenWidth(context) >= 768 && getScreenWidth(context) < 1024;
  }

  static bool isDesktop(BuildContext context) {
    return getScreenWidth(context) >= 1024;
  }

  // Responsive font sizes
  static double getResponsiveFontSize(BuildContext context, double mobileSize) {
    final width = getScreenWidth(context);
    if (width < 768) {
      return mobileSize;
    } else if (width < 1024) {
      return mobileSize * 1.2;
    } else {
      return mobileSize * 1.4;
    }
  }

  // Responsive padding
  static double getResponsivePadding(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < 768) {
      return 16.0;
    } else if (width < 1024) {
      return 24.0;
    } else {
      return 32.0;
    }
  }

  // Responsive margin
  static double getResponsiveMargin(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < 768) {
      return 16.0;
    } else if (width < 1024) {
      return 32.0;
    } else {
      return 48.0;
    }
  }

  // Responsive border radius
  static double getResponsiveBorderRadius(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < 768) {
      return 8.0;
    } else if (width < 1024) {
      return 12.0;
    } else {
      return 16.0;
    }
  }

  // Responsive icon size
  static double getResponsiveIconSize(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < 768) {
      return 24.0;
    } else if (width < 1024) {
      return 32.0;
    } else {
      return 40.0;
    }
  }

  // Responsive spacing
  static double getResponsiveSpacing(BuildContext context) {
    final width = getScreenWidth(context);
    if (width < 768) {
      return 8.0;
    } else if (width < 1024) {
      return 12.0;
    } else {
      return 16.0;
    }
  }
}
