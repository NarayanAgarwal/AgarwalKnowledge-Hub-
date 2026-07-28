import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/auth_repository_impl.dart';
import 'core/services/firestore_repository_impl.dart';
import 'core/services/storage_repository_impl.dart';
import 'core/services/notification_service.dart';
import 'core/services/download_provider.dart';
import 'core/services/favorites_provider.dart';
import 'core/services/progress_provider.dart';
import 'core/services/library_provider.dart';
import 'core/services/audio_provider.dart';
import 'core/services/academic_provider.dart';
import 'core/services/enterprise_provider.dart';
import 'core/models/user_profile.dart';
import 'features/auth/viewmodels/auth_viewmodel.dart';
import 'features/dashboard/viewmodels/dashboard_viewmodel.dart';
import 'features/settings/viewmodels/settings_viewmodel.dart';
import 'features/web_panel/viewmodels/web_panel_viewmodel.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Scaffolding Repositories
  final authRepo = AuthRepositoryImpl();
  final firestoreRepo = FirestoreRepositoryImpl();
  final storageRepo = StorageRepositoryImpl();
  final notificationService = NotificationService();

  try {
    // Attempt Firebase initialization
    await Firebase.initializeApp();
    notificationService.initialize();
  } catch (e) {
    // If Firebase configuration is missing or throws error, we execute in mock mode
    print("Firebase not configured. Launching Agarwal Knowledge Hub in mock mode: $e");
    
    // Enable Mock fallbacks
    authRepo.enableMockMode(UserProfile(
      uid: "student_user_123",
      role: "Student",
      name: "Aman Agarwal",
      phone: "+919876543210",
      email: "aman@agarwal.com",
      address: "Mithapur, Patna",
      userClass: "Class 5",
      rollNumber: "12",
      gender: "Male",
      dob: "2015-02-10",
      admissionNumber: "ADM2026512",
      school: "Agarwal Knowledge Hub",
      parentName: "Suresh Agarwal",
      parentMobile: "+919876543220",
      emergencyContact: "+919876543221",
      profilePhotoUrl: "",
      createdDate: DateTime.now(),
      lastLogin: DateTime.now(),
    ));
    firestoreRepo.enableMockMode();
    storageRepo.enableMockMode();
    notificationService.enableMockMode();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel(authRepo)),
        ChangeNotifierProvider(create: (_) => DashboardViewModel(firestoreRepo)),
        ChangeNotifierProvider(create: (_) => DownloadProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => WebPanelViewModel(firestoreRepo)),
        ChangeNotifierProvider(create: (_) => LibraryProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
        ChangeNotifierProvider(create: (_) => AcademicProvider()),
        ChangeNotifierProvider(create: (_) => EnterpriseProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Agarwal Knowledge Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}
