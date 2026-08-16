import 'dart:io';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchPhone(String phone) async {
  final uri = Uri(
    scheme: 'tel',
    path: phone,
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    await EasyLoading.showError(
      'Phone calls are not available on this device.',
    );
  }
}

Future<void> launchEmail(String email) async {
  final uri = Uri(
    scheme: 'mailto',
    path: email,
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    await EasyLoading.showError(
      'No email app is configured on this device.',
    );
  }
}

Future<void> launchWebsite(String url) async {
  final formattedUrl =
      url.startsWith('http://') || url.startsWith('https://')
          ? url
          : 'https://$url';

  final uri = Uri.parse(formattedUrl);

  if (await canLaunchUrl(uri)) {
    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  } else {
    await EasyLoading.showError(
      'Unable to open the website. Please try again.',
    );
  }
}

Future<void> launchMap(double lat, double lng) async {
  if (Platform.isIOS) {
    // 1. Check if Google Maps app is installed
    final googleMapsUri = Uri.parse(
      'comgooglemaps://?daddr=$lat,$lng&directionsmode=driving',
    );

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
      return;
    }

    // 2. Fall back to Apple Maps (always available on iOS)
    final appleMapsUri = Uri.parse('https://maps.apple.com/?daddr=$lat,$lng');
    if (await canLaunchUrl(appleMapsUri)) {
      await launchUrl(appleMapsUri, mode: LaunchMode.externalApplication);
      return;
    }

    // 3. Neither available
    _showMapError();
  } else {
    // Android
    final googleMapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );
    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      _showMapError();
    }
  }
}

void _showMapError() {
  // Replace with your app's error handling (EasyLoading, snackbar, dialog, etc.)
  EasyLoading.showError('No maps application available');
}
