import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:universal_html/js.dart' as js;
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

  if (kIsWeb) {
    try {
      js.context.callMethod('eval', ["""
        if ('serviceWorker' in navigator) {
          navigator.serviceWorker.getRegistrations().then(function(registrations) {
            for (var i = 0; i < registrations.length; i++) {
              registrations[i].unregister();
            }
          });
        }
      """]);
    } catch (_) {}
  }

  // Scaffolding Repositories
  final authRepo = AuthRepositoryImpl();
  final firestoreRepo = FirestoreRepositoryImpl();
  final storageRepo = StorageRepositoryImpl();
  final notificationService = NotificationService();

  bool firebaseWebInitialized = false;
  if (kIsWeb) {
    const apiKey = String.fromEnvironment('FIREBASE_API_KEY');
    const projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
    const appId = String.fromEnvironment('FIREBASE_APP_ID');
    const authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
    const storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
    const messagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');

    String clean(String val) {
      var s = val.trim();
      if (s.startsWith('"') && s.endsWith('"')) {
        s = s.substring(1, s.length - 1);
      }
      if (s.startsWith("'") && s.endsWith("'")) {
        s = s.substring(1, s.length - 1);
      }
      return s.trim();
    }

    final cleanApiKey = clean(apiKey);
    final cleanProjectId = clean(projectId);
    final cleanAppId = clean(appId);
    final cleanAuthDomain = clean(authDomain);
    final cleanStorageBucket = clean(storageBucket);
    final cleanMessagingSenderId = clean(messagingSenderId);
    
    if (cleanApiKey.isNotEmpty && cleanProjectId.isNotEmpty && cleanAppId.isNotEmpty) {
      try {
        await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: cleanApiKey,
            projectId: cleanProjectId,
            appId: cleanAppId,
            authDomain: cleanAuthDomain.isNotEmpty ? cleanAuthDomain : null,
            storageBucket: cleanStorageBucket.isNotEmpty ? cleanStorageBucket : null,
            messagingSenderId: cleanMessagingSenderId.isNotEmpty ? cleanMessagingSenderId : "580236355762",
          ),
        );
        firebaseWebInitialized = true;
        print("Firebase successfully initialized on Web!");
      } catch (e) {
        print("Failed to initialize Firebase on Web: $e");
      }
    } else {
      print("No Firebase Web environment configurations found. Running in mock mode.");
    }
  }

  if (kIsWeb && !firebaseWebInitialized) {
    print("Launching Agarwal Knowledge Hub in mock mode.");
    authRepo.enableMockMode(UserProfile(
      uid: "student_user_123",
      role: "Student",
      name: "Narayan Agarwal",
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
  } else if (!kIsWeb) {
    try {
      // Attempt Firebase initialization for Mobile/Native
      await Firebase.initializeApp();
      notificationService.initialize();
    } catch (e) {
      // If Firebase configuration is missing or throws error, we execute in mock mode
      print("Firebase not configured. Launching in mock mode: $e");
      
      // Enable Mock fallbacks
      authRepo.enableMockMode(UserProfile(
        uid: "student_user_123",
        role: "Student",
        name: "Narayan Agarwal",
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
