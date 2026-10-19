import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/home_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/partner_dashboard_provider.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

class ServiceAtEaseApp extends StatelessWidget {
  const ServiceAtEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => PartnerDashboardProvider()),
      ],
      child: MaterialApp.router(
        title: 'serviceAtEase',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

/// Backwards compatibility aliases
typedef UrbanGoApp = ServiceAtEaseApp;
typedef ServiGoApp = ServiceAtEaseApp;
