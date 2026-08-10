class SystemSettings {
  // 1. General Settings
  final String appName;
  final String instituteName;
  final String logoUrl;
  final String iconUrl;
  final String faviconUrl;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String aboutApp;
  final String copyrightText;
  final String country;
  final String timeZone;
  final String currency;
  final String dateFormat;
  final String timeFormat;
  final String defaultLanguage;

  // 2. Appearance & Branding
  final String themeMode; // 'light' | 'dark' | 'system'
  final String primaryColorHex;
  final String secondaryColorHex;
  final String accentColorHex;
  final String dashboardTheme;
  final String sidebarStyle;
  final String loginBrandingTitle;
  final String loginBackgroundUrl;
  final String loginPageLogoUrl;
  final bool animationsEnabled;
  final bool smoothTransitions;
  final String uiDensity; // 'Comfortable' | 'Compact'
  final double borderRadius;
  final String cardStyle; // '3D' | 'Flat' | 'Glassmorphism'

  // 3. Security Settings
  final bool twoFactorAuthEnabled;
  final int sessionTimeoutMinutes;
  final int maxLoginAttempts;
  final int accountLockoutMinutes;
  final bool suspiciousLoginDetection;
  final String passwordPolicy; // 'Simple' | 'Medium' | 'Strong'
  final bool reAuthRequired;

  // 4. Authentication Settings
  final bool mobileLoginEnabled;
  final bool realOtpEnabled;
  final bool emailLoginEnabled;
  final bool passwordLoginEnabled;
  final bool googleLoginEnabled;
  final bool guestLoginEnabled;
  final bool rememberLogin;
  final bool autoLogin;
  final bool forgotPasswordEnabled;
  final int otpExpirySeconds;
  final int resendOtpSeconds;

  // 5. Notification Settings
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool smsNotificationsEnabled;
  final bool whatsAppNotificationsEnabled;
  final String notificationSound;
  final bool systemAlertsEnabled;
  final bool maintenanceAlertsEnabled;
  final bool securityAlertsEnabled;

  // 6. Language & Localization
  final String numberFormat;

  // 7. AI Configuration
  final bool aiFeaturesEnabled;
  final bool aiTutorEnabled;
  final bool aiDoubtSolverEnabled;
  final bool imageQuestionEnabled;
  final bool voiceQuestionEnabled;
  final bool aiQuizGeneratorEnabled;
  final bool aiContentGeneratorEnabled;
  final int freeUserDailyLimit;
  final int premiumUserDailyLimit;
  final bool aiVoiceEnabled;
  final String voiceGender; // 'Male' | 'Female' | 'Default'
  final bool voiceAutoPlay;
  final double speechSpeed;
  final double voiceVolume;

  // 8. Monetization
  final bool monetizationEnabled;
  final bool premiumSystemEnabled;
  final int freeTrialDays;
  final List<Map<String, dynamic>> subscriptionPlans;
  final bool adsEnabled;
  final bool bannerAdsEnabled;
  final bool rewardedAdsEnabled;
  final bool couponSystemEnabled;
  final bool referralSystemEnabled;
  final String paymentGatewayStatus; // 'Active' | 'Sandbox' | 'Inactive'

  // 9. Maintenance & Updates
  final bool maintenanceModeEnabled;
  final String maintenanceMessage;
  final String scheduledMaintenanceTime;
  final String currentAppVersion;
  final String latestAppVersion;
  final String minSupportedVersion;
  final bool forceUpdateEnabled;
  final String updateMessage;
  final String playStoreLink;
  final String appStoreLink;
  final String websiteLink;
  final String privacyPolicyLink;
  final String termsConditionsLink;

  // 10. Backup & Data
  final bool autoBackupEnabled;
  final String backupSchedule; // 'Daily' | 'Weekly' | 'Monthly'
  final List<Map<String, dynamic>> backupHistory;
  final int dataRetentionDays;

  SystemSettings({
    required this.appName,
    required this.instituteName,
    required this.logoUrl,
    required this.iconUrl,
    required this.faviconUrl,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.aboutApp,
    required this.copyrightText,
    required this.country,
    required this.timeZone,
    required this.currency,
    required this.dateFormat,
    required this.timeFormat,
    required this.defaultLanguage,
    required this.themeMode,
    required this.primaryColorHex,
    required this.secondaryColorHex,
    required this.accentColorHex,
    required this.dashboardTheme,
    required this.sidebarStyle,
    required this.loginBrandingTitle,
    required this.loginBackgroundUrl,
    required this.loginPageLogoUrl,
    required this.animationsEnabled,
    required this.smoothTransitions,
    required this.uiDensity,
    required this.borderRadius,
    required this.cardStyle,
    required this.twoFactorAuthEnabled,
    required this.sessionTimeoutMinutes,
    required this.maxLoginAttempts,
    required this.accountLockoutMinutes,
    required this.suspiciousLoginDetection,
    required this.passwordPolicy,
    required this.reAuthRequired,
    required this.mobileLoginEnabled,
    required this.realOtpEnabled,
    required this.emailLoginEnabled,
    required this.passwordLoginEnabled,
    required this.googleLoginEnabled,
    required this.guestLoginEnabled,
    required this.rememberLogin,
    required this.autoLogin,
    required this.forgotPasswordEnabled,
    required this.otpExpirySeconds,
    required this.resendOtpSeconds,
    required this.pushNotificationsEnabled,
    required this.emailNotificationsEnabled,
    required this.smsNotificationsEnabled,
    required this.whatsAppNotificationsEnabled,
    required this.notificationSound,
    required this.systemAlertsEnabled,
    required this.maintenanceAlertsEnabled,
    required this.securityAlertsEnabled,
    required this.numberFormat,
    required this.aiFeaturesEnabled,
    required this.aiTutorEnabled,
    required this.aiDoubtSolverEnabled,
    required this.imageQuestionEnabled,
    required this.voiceQuestionEnabled,
    required this.aiQuizGeneratorEnabled,
    required this.aiContentGeneratorEnabled,
    required this.freeUserDailyLimit,
    required this.premiumUserDailyLimit,
    required this.aiVoiceEnabled,
    required this.voiceGender,
    required this.voiceAutoPlay,
    required this.speechSpeed,
    required this.voiceVolume,
    required this.monetizationEnabled,
    required this.premiumSystemEnabled,
    required this.freeTrialDays,
    required this.subscriptionPlans,
    required this.adsEnabled,
    required this.bannerAdsEnabled,
    required this.rewardedAdsEnabled,
    required this.couponSystemEnabled,
    required this.referralSystemEnabled,
    required this.paymentGatewayStatus,
    required this.maintenanceModeEnabled,
    required this.maintenanceMessage,
    required this.scheduledMaintenanceTime,
    required this.currentAppVersion,
    required this.latestAppVersion,
    required this.minSupportedVersion,
    required this.forceUpdateEnabled,
    required this.updateMessage,
    required this.playStoreLink,
    required this.appStoreLink,
    required this.websiteLink,
    required this.privacyPolicyLink,
    required this.termsConditionsLink,
    required this.autoBackupEnabled,
    required this.backupSchedule,
    required this.backupHistory,
    required this.dataRetentionDays,
  });

  factory SystemSettings.defaultSettings() {
    return SystemSettings(
      appName: 'Agarwal Knowledge Hub',
      instituteName: 'Agarwal Knowledge Hub',
      logoUrl: '',
      iconUrl: '',
      faviconUrl: '',
      address: 'Mithapur, Patna, Bihar, India',
      phone: '+919876543210',
      email: 'info@agarwalknowledgehub.com',
      website: 'https://agarwalknowledgehub.com',
      aboutApp: 'Professional CBSE & Bihar Board Education ERP Portal & AI doubtful solver.',
      copyrightText: '© 2026 Agarwal Knowledge Hub. All Rights Reserved.',
      country: 'India',
      timeZone: 'IST (UTC+5:30)',
      currency: 'INR (₹)',
      dateFormat: 'yyyy-MM-dd',
      timeFormat: '12-Hour (hh:mm AM/PM)',
      defaultLanguage: 'English',
      themeMode: 'system',
      primaryColorHex: '1E3C72',
      secondaryColorHex: 'FF5E36',
      accentColorHex: 'FFC107',
      dashboardTheme: 'Classic Blue',
      sidebarStyle: 'Modern Glass',
      loginBrandingTitle: 'Agarwal Knowledge Hub Learning Portal',
      loginBackgroundUrl: '',
      loginPageLogoUrl: '',
      animationsEnabled: true,
      smoothTransitions: true,
      uiDensity: 'Comfortable',
      borderRadius: 16.0,
      cardStyle: 'Glassmorphism',
      twoFactorAuthEnabled: false,
      sessionTimeoutMinutes: 30,
      maxLoginAttempts: 5,
      accountLockoutMinutes: 15,
      suspiciousLoginDetection: true,
      passwordPolicy: 'Medium',
      reAuthRequired: true,
      mobileLoginEnabled: true,
      realOtpEnabled: false,
      emailLoginEnabled: true,
      passwordLoginEnabled: true,
      googleLoginEnabled: true,
      guestLoginEnabled: false,
      rememberLogin: true,
      autoLogin: true,
      forgotPasswordEnabled: true,
      otpExpirySeconds: 60,
      resendOtpSeconds: 30,
      pushNotificationsEnabled: true,
      emailNotificationsEnabled: true,
      smsNotificationsEnabled: false,
      whatsAppNotificationsEnabled: false,
      notificationSound: 'Default Chime',
      systemAlertsEnabled: true,
      maintenanceAlertsEnabled: true,
      securityAlertsEnabled: true,
      numberFormat: '1,23,456.78 (Indian)',
      aiFeaturesEnabled: true,
      aiTutorEnabled: true,
      aiDoubtSolverEnabled: true,
      imageQuestionEnabled: true,
      voiceQuestionEnabled: true,
      aiQuizGeneratorEnabled: true,
      aiContentGeneratorEnabled: true,
      freeUserDailyLimit: 5,
      premiumUserDailyLimit: 100,
      aiVoiceEnabled: true,
      voiceGender: 'Female',
      voiceAutoPlay: false,
      speechSpeed: 1.0,
      voiceVolume: 0.8,
      monetizationEnabled: false,
      premiumSystemEnabled: false,
      freeTrialDays: 7,
      subscriptionPlans: [
        {
          'name': 'Basic Free',
          'price': '0',
          'duration': 'Lifetime',
          'description': 'Access basic doubt solver & lecture notes.',
          'features': '5 AI doubts daily, standard quizzes',
          'trial': '0',
          'active': true,
          'badge': 'FREE',
        },
        {
          'name': 'Premium Scholar',
          'price': '499',
          'duration': '1 Month',
          'description': 'Unlimited doubt answers with audio voices.',
          'features': '100 AI doubts daily, premium reports, custom tests',
          'trial': '7',
          'active': true,
          'badge': 'BEST VALUE',
        }
      ],
      adsEnabled: false,
      bannerAdsEnabled: false,
      rewardedAdsEnabled: false,
      couponSystemEnabled: false,
      referralSystemEnabled: false,
      paymentGatewayStatus: 'Sandbox',
      maintenanceModeEnabled: false,
      maintenanceMessage: 'System is currently undergoing scheduled maintenance. Please check back in a few minutes.',
      scheduledMaintenanceTime: '',
      currentAppVersion: '1.2.0',
      latestAppVersion: '1.2.0',
      minSupportedVersion: '1.0.0',
      forceUpdateEnabled: false,
      updateMessage: 'A new secure upgrade is available. Please update the application to continue.',
      playStoreLink: 'https://play.google.com/store',
      appStoreLink: 'https://apps.apple.com',
      websiteLink: 'https://agarwalknowledgehub.com',
      privacyPolicyLink: 'https://agarwalknowledgehub.com/privacy',
      termsConditionsLink: 'https://agarwalknowledgehub.com/terms',
      autoBackupEnabled: true,
      backupSchedule: 'Daily',
      backupHistory: [
        {
          'id': 'bak_001',
          'date': '2026-08-09 04:00 AM',
          'size': '4.8 MB',
          'status': 'Completed',
          'creator': 'System Scheduler',
          'type': 'Automatic Daily',
          'restoreAvailable': true,
        },
        {
          'id': 'bak_002',
          'date': '2026-08-10 12:15 PM',
          'size': '5.1 MB',
          'status': 'Completed',
          'creator': 'Super Admin',
          'type': 'Manual Cloud Backup',
          'restoreAvailable': true,
        }
      ],
      dataRetentionDays: 365,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'appName': appName,
      'instituteName': instituteName,
      'logoUrl': logoUrl,
      'iconUrl': iconUrl,
      'faviconUrl': faviconUrl,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'aboutApp': aboutApp,
      'copyrightText': copyrightText,
      'country': country,
      'timeZone': timeZone,
      'currency': currency,
      'dateFormat': dateFormat,
      'timeFormat': timeFormat,
      'defaultLanguage': defaultLanguage,
      'themeMode': themeMode,
      'primaryColorHex': primaryColorHex,
      'secondaryColorHex': secondaryColorHex,
      'accentColorHex': accentColorHex,
      'dashboardTheme': dashboardTheme,
      'sidebarStyle': sidebarStyle,
      'loginBrandingTitle': loginBrandingTitle,
      'loginBackgroundUrl': loginBackgroundUrl,
      'loginPageLogoUrl': loginPageLogoUrl,
      'animationsEnabled': animationsEnabled,
      'smoothTransitions': smoothTransitions,
      'uiDensity': uiDensity,
      'borderRadius': borderRadius,
      'cardStyle': cardStyle,
      'twoFactorAuthEnabled': twoFactorAuthEnabled,
      'sessionTimeoutMinutes': sessionTimeoutMinutes,
      'maxLoginAttempts': maxLoginAttempts,
      'accountLockoutMinutes': accountLockoutMinutes,
      'suspiciousLoginDetection': suspiciousLoginDetection,
      'passwordPolicy': passwordPolicy,
      'reAuthRequired': reAuthRequired,
      'mobileLoginEnabled': mobileLoginEnabled,
      'realOtpEnabled': realOtpEnabled,
      'emailLoginEnabled': emailLoginEnabled,
      'passwordLoginEnabled': passwordLoginEnabled,
      'googleLoginEnabled': googleLoginEnabled,
      'guestLoginEnabled': guestLoginEnabled,
      'rememberLogin': rememberLogin,
      'autoLogin': autoLogin,
      'forgotPasswordEnabled': forgotPasswordEnabled,
      'otpExpirySeconds': otpExpirySeconds,
      'resendOtpSeconds': resendOtpSeconds,
      'pushNotificationsEnabled': pushNotificationsEnabled,
      'emailNotificationsEnabled': emailNotificationsEnabled,
      'smsNotificationsEnabled': smsNotificationsEnabled,
      'whatsAppNotificationsEnabled': whatsAppNotificationsEnabled,
      'notificationSound': notificationSound,
      'systemAlertsEnabled': systemAlertsEnabled,
      'maintenanceAlertsEnabled': maintenanceAlertsEnabled,
      'securityAlertsEnabled': securityAlertsEnabled,
      'numberFormat': numberFormat,
      'aiFeaturesEnabled': aiFeaturesEnabled,
      'aiTutorEnabled': aiTutorEnabled,
      'aiDoubtSolverEnabled': aiDoubtSolverEnabled,
      'imageQuestionEnabled': imageQuestionEnabled,
      'voiceQuestionEnabled': voiceQuestionEnabled,
      'aiQuizGeneratorEnabled': aiQuizGeneratorEnabled,
      'aiContentGeneratorEnabled': aiContentGeneratorEnabled,
      'freeUserDailyLimit': freeUserDailyLimit,
      'premiumUserDailyLimit': premiumUserDailyLimit,
      'aiVoiceEnabled': aiVoiceEnabled,
      'voiceGender': voiceGender,
      'voiceAutoPlay': voiceAutoPlay,
      'speechSpeed': speechSpeed,
      'voiceVolume': voiceVolume,
      'monetizationEnabled': monetizationEnabled,
      'premiumSystemEnabled': premiumSystemEnabled,
      'freeTrialDays': freeTrialDays,
      'subscriptionPlans': subscriptionPlans,
      'adsEnabled': adsEnabled,
      'bannerAdsEnabled': bannerAdsEnabled,
      'rewardedAdsEnabled': rewardedAdsEnabled,
      'couponSystemEnabled': couponSystemEnabled,
      'referralSystemEnabled': referralSystemEnabled,
      'paymentGatewayStatus': paymentGatewayStatus,
      'maintenanceModeEnabled': maintenanceModeEnabled,
      'maintenanceMessage': maintenanceMessage,
      'scheduledMaintenanceTime': scheduledMaintenanceTime,
      'currentAppVersion': currentAppVersion,
      'latestAppVersion': latestAppVersion,
      'minSupportedVersion': minSupportedVersion,
      'forceUpdateEnabled': forceUpdateEnabled,
      'updateMessage': updateMessage,
      'playStoreLink': playStoreLink,
      'appStoreLink': appStoreLink,
      'websiteLink': websiteLink,
      'privacyPolicyLink': privacyPolicyLink,
      'termsConditionsLink': termsConditionsLink,
      'autoBackupEnabled': autoBackupEnabled,
      'backupSchedule': backupSchedule,
      'backupHistory': backupHistory,
      'dataRetentionDays': dataRetentionDays,
    };
  }

  factory SystemSettings.fromMap(Map<String, dynamic> map) {
    final def = SystemSettings.defaultSettings();
    return SystemSettings(
      appName: map['appName'] ?? def.appName,
      instituteName: map['instituteName'] ?? def.instituteName,
      logoUrl: map['logoUrl'] ?? def.logoUrl,
      iconUrl: map['iconUrl'] ?? def.iconUrl,
      faviconUrl: map['faviconUrl'] ?? def.faviconUrl,
      address: map['address'] ?? def.address,
      phone: map['phone'] ?? def.phone,
      email: map['email'] ?? def.email,
      website: map['website'] ?? def.website,
      aboutApp: map['aboutApp'] ?? def.aboutApp,
      copyrightText: map['copyrightText'] ?? def.copyrightText,
      country: map['country'] ?? def.country,
      timeZone: map['timeZone'] ?? def.timeZone,
      currency: map['currency'] ?? def.currency,
      dateFormat: map['dateFormat'] ?? def.dateFormat,
      timeFormat: map['timeFormat'] ?? def.timeFormat,
      defaultLanguage: map['defaultLanguage'] ?? def.defaultLanguage,
      themeMode: map['themeMode'] ?? def.themeMode,
      primaryColorHex: map['primaryColorHex'] ?? def.primaryColorHex,
      secondaryColorHex: map['secondaryColorHex'] ?? def.secondaryColorHex,
      accentColorHex: map['accentColorHex'] ?? def.accentColorHex,
      dashboardTheme: map['dashboardTheme'] ?? def.dashboardTheme,
      sidebarStyle: map['sidebarStyle'] ?? def.sidebarStyle,
      loginBrandingTitle: map['loginBrandingTitle'] ?? def.loginBrandingTitle,
      loginBackgroundUrl: map['loginBackgroundUrl'] ?? def.loginBackgroundUrl,
      loginPageLogoUrl: map['loginPageLogoUrl'] ?? def.loginPageLogoUrl,
      animationsEnabled: map['animationsEnabled'] ?? def.animationsEnabled,
      smoothTransitions: map['smoothTransitions'] ?? def.smoothTransitions,
      uiDensity: map['uiDensity'] ?? def.uiDensity,
      borderRadius: (map['borderRadius'] ?? def.borderRadius).toDouble(),
      cardStyle: map['cardStyle'] ?? def.cardStyle,
      twoFactorAuthEnabled: map['twoFactorAuthEnabled'] ?? def.twoFactorAuthEnabled,
      sessionTimeoutMinutes: map['sessionTimeoutMinutes'] ?? def.sessionTimeoutMinutes,
      maxLoginAttempts: map['maxLoginAttempts'] ?? def.maxLoginAttempts,
      accountLockoutMinutes: map['accountLockoutMinutes'] ?? def.accountLockoutMinutes,
      suspiciousLoginDetection: map['suspiciousLoginDetection'] ?? def.suspiciousLoginDetection,
      passwordPolicy: map['passwordPolicy'] ?? def.passwordPolicy,
      reAuthRequired: map['reAuthRequired'] ?? def.reAuthRequired,
      mobileLoginEnabled: map['mobileLoginEnabled'] ?? def.mobileLoginEnabled,
      realOtpEnabled: map['realOtpEnabled'] ?? def.realOtpEnabled,
      emailLoginEnabled: map['emailLoginEnabled'] ?? def.emailLoginEnabled,
      passwordLoginEnabled: map['passwordLoginEnabled'] ?? def.passwordLoginEnabled,
      googleLoginEnabled: map['googleLoginEnabled'] ?? def.googleLoginEnabled,
      guestLoginEnabled: map['guestLoginEnabled'] ?? def.guestLoginEnabled,
      rememberLogin: map['rememberLogin'] ?? def.rememberLogin,
      autoLogin: map['autoLogin'] ?? def.autoLogin,
      forgotPasswordEnabled: map['forgotPasswordEnabled'] ?? def.forgotPasswordEnabled,
      otpExpirySeconds: map['otpExpirySeconds'] ?? def.otpExpirySeconds,
      resendOtpSeconds: map['resendOtpSeconds'] ?? def.resendOtpSeconds,
      pushNotificationsEnabled: map['pushNotificationsEnabled'] ?? def.pushNotificationsEnabled,
      emailNotificationsEnabled: map['emailNotificationsEnabled'] ?? def.emailNotificationsEnabled,
      smsNotificationsEnabled: map['smsNotificationsEnabled'] ?? def.smsNotificationsEnabled,
      whatsAppNotificationsEnabled: map['whatsAppNotificationsEnabled'] ?? def.whatsAppNotificationsEnabled,
      notificationSound: map['notificationSound'] ?? def.notificationSound,
      systemAlertsEnabled: map['systemAlertsEnabled'] ?? def.systemAlertsEnabled,
      maintenanceAlertsEnabled: map['maintenanceAlertsEnabled'] ?? def.maintenanceAlertsEnabled,
      securityAlertsEnabled: map['securityAlertsEnabled'] ?? def.securityAlertsEnabled,
      numberFormat: map['numberFormat'] ?? def.numberFormat,
      aiFeaturesEnabled: map['aiFeaturesEnabled'] ?? def.aiFeaturesEnabled,
      aiTutorEnabled: map['aiTutorEnabled'] ?? def.aiTutorEnabled,
      aiDoubtSolverEnabled: map['aiDoubtSolverEnabled'] ?? def.aiDoubtSolverEnabled,
      imageQuestionEnabled: map['imageQuestionEnabled'] ?? def.imageQuestionEnabled,
      voiceQuestionEnabled: map['voiceQuestionEnabled'] ?? def.voiceQuestionEnabled,
      aiQuizGeneratorEnabled: map['aiQuizGeneratorEnabled'] ?? def.aiQuizGeneratorEnabled,
      aiContentGeneratorEnabled: map['aiContentGeneratorEnabled'] ?? def.aiContentGeneratorEnabled,
      freeUserDailyLimit: map['freeUserDailyLimit'] ?? def.freeUserDailyLimit,
      premiumUserDailyLimit: map['premiumUserDailyLimit'] ?? def.premiumUserDailyLimit,
      aiVoiceEnabled: map['aiVoiceEnabled'] ?? def.aiVoiceEnabled,
      voiceGender: map['voiceGender'] ?? def.voiceGender,
      voiceAutoPlay: map['voiceAutoPlay'] ?? def.voiceAutoPlay,
      speechSpeed: (map['speechSpeed'] ?? def.speechSpeed).toDouble(),
      voiceVolume: (map['voiceVolume'] ?? def.voiceVolume).toDouble(),
      monetizationEnabled: map['monetizationEnabled'] ?? def.monetizationEnabled,
      premiumSystemEnabled: map['premiumSystemEnabled'] ?? def.premiumSystemEnabled,
      freeTrialDays: map['freeTrialDays'] ?? def.freeTrialDays,
      subscriptionPlans: List<Map<String, dynamic>>.from(
        (map['subscriptionPlans'] ?? def.subscriptionPlans).map((item) => Map<String, dynamic>.from(item))
      ),
      adsEnabled: map['adsEnabled'] ?? def.adsEnabled,
      bannerAdsEnabled: map['bannerAdsEnabled'] ?? def.bannerAdsEnabled,
      rewardedAdsEnabled: map['rewardedAdsEnabled'] ?? def.rewardedAdsEnabled,
      couponSystemEnabled: map['couponSystemEnabled'] ?? def.couponSystemEnabled,
      referralSystemEnabled: map['referralSystemEnabled'] ?? def.referralSystemEnabled,
      paymentGatewayStatus: map['paymentGatewayStatus'] ?? def.paymentGatewayStatus,
      maintenanceModeEnabled: map['maintenanceModeEnabled'] ?? def.maintenanceModeEnabled,
      maintenanceMessage: map['maintenanceMessage'] ?? def.maintenanceMessage,
      scheduledMaintenanceTime: map['scheduledMaintenanceTime'] ?? def.scheduledMaintenanceTime,
      currentAppVersion: map['currentAppVersion'] ?? def.currentAppVersion,
      latestAppVersion: map['latestAppVersion'] ?? def.latestAppVersion,
      minSupportedVersion: map['minSupportedVersion'] ?? def.minSupportedVersion,
      forceUpdateEnabled: map['forceUpdateEnabled'] ?? def.forceUpdateEnabled,
      updateMessage: map['updateMessage'] ?? def.updateMessage,
      playStoreLink: map['playStoreLink'] ?? def.playStoreLink,
      appStoreLink: map['appStoreLink'] ?? def.appStoreLink,
      websiteLink: map['websiteLink'] ?? def.websiteLink,
      privacyPolicyLink: map['privacyPolicyLink'] ?? def.privacyPolicyLink,
      termsConditionsLink: map['termsConditionsLink'] ?? def.termsConditionsLink,
      autoBackupEnabled: map['autoBackupEnabled'] ?? def.autoBackupEnabled,
      backupSchedule: map['backupSchedule'] ?? def.backupSchedule,
      backupHistory: List<Map<String, dynamic>>.from(
        (map['backupHistory'] ?? def.backupHistory).map((item) => Map<String, dynamic>.from(item))
      ),
      dataRetentionDays: map['dataRetentionDays'] ?? def.dataRetentionDays,
    );
  }

  SystemSettings copyWith({
    String? appName,
    String? instituteName,
    String? logoUrl,
    String? iconUrl,
    String? faviconUrl,
    String? address,
    String? phone,
    String? email,
    String? website,
    String? aboutApp,
    String? copyrightText,
    String? country,
    String? timeZone,
    String? currency,
    String? dateFormat,
    String? timeFormat,
    String? defaultLanguage,
    String? themeMode,
    String? primaryColorHex,
    String? secondaryColorHex,
    String? accentColorHex,
    String? dashboardTheme,
    String? sidebarStyle,
    String? loginBrandingTitle,
    String? loginBackgroundUrl,
    String? loginPageLogoUrl,
    bool? animationsEnabled,
    bool? smoothTransitions,
    String? uiDensity,
    double? borderRadius,
    String? cardStyle,
    bool? twoFactorAuthEnabled,
    int? sessionTimeoutMinutes,
    int? maxLoginAttempts,
    int? accountLockoutMinutes,
    bool? suspiciousLoginDetection,
    String? passwordPolicy,
    bool? reAuthRequired,
    bool? mobileLoginEnabled,
    bool? realOtpEnabled,
    bool? emailLoginEnabled,
    bool? passwordLoginEnabled,
    bool? googleLoginEnabled,
    bool? guestLoginEnabled,
    bool? rememberLogin,
    bool? autoLogin,
    bool? forgotPasswordEnabled,
    int? otpExpirySeconds,
    int? resendOtpSeconds,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? smsNotificationsEnabled,
    bool? whatsAppNotificationsEnabled,
    String? notificationSound,
    bool? systemAlertsEnabled,
    bool? maintenanceAlertsEnabled,
    bool? securityAlertsEnabled,
    String? numberFormat,
    bool? aiFeaturesEnabled,
    bool? aiTutorEnabled,
    bool? aiDoubtSolverEnabled,
    bool? imageQuestionEnabled,
    bool? voiceQuestionEnabled,
    bool? aiQuizGeneratorEnabled,
    bool? aiContentGeneratorEnabled,
    int? freeUserDailyLimit,
    int? premiumUserDailyLimit,
    bool? aiVoiceEnabled,
    String? voiceGender,
    bool? voiceAutoPlay,
    double? speechSpeed,
    double? voiceVolume,
    bool? monetizationEnabled,
    bool? premiumSystemEnabled,
    int? freeTrialDays,
    List<Map<String, dynamic>>? subscriptionPlans,
    bool? adsEnabled,
    bool? bannerAdsEnabled,
    bool? rewardedAdsEnabled,
    bool? couponSystemEnabled,
    bool? referralSystemEnabled,
    String? paymentGatewayStatus,
    bool? maintenanceModeEnabled,
    String? maintenanceMessage,
    String? scheduledMaintenanceTime,
    String? currentAppVersion,
    String? latestAppVersion,
    String? minSupportedVersion,
    bool? forceUpdateEnabled,
    String? updateMessage,
    String? playStoreLink,
    String? appStoreLink,
    String? websiteLink,
    String? privacyPolicyLink,
    String? termsConditionsLink,
    bool? autoBackupEnabled,
    String? backupSchedule,
    List<Map<String, dynamic>>? backupHistory,
    int? dataRetentionDays,
  }) {
    return SystemSettings(
      appName: appName ?? this.appName,
      instituteName: instituteName ?? this.instituteName,
      logoUrl: logoUrl ?? this.logoUrl,
      iconUrl: iconUrl ?? this.iconUrl,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      aboutApp: aboutApp ?? this.aboutApp,
      copyrightText: copyrightText ?? this.copyrightText,
      country: country ?? this.country,
      timeZone: timeZone ?? this.timeZone,
      currency: currency ?? this.currency,
      dateFormat: dateFormat ?? this.dateFormat,
      timeFormat: timeFormat ?? this.timeFormat,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      themeMode: themeMode ?? this.themeMode,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      secondaryColorHex: secondaryColorHex ?? this.secondaryColorHex,
      accentColorHex: accentColorHex ?? this.accentColorHex,
      dashboardTheme: dashboardTheme ?? this.dashboardTheme,
      sidebarStyle: sidebarStyle ?? this.sidebarStyle,
      loginBrandingTitle: loginBrandingTitle ?? this.loginBrandingTitle,
      loginBackgroundUrl: loginBackgroundUrl ?? this.loginBackgroundUrl,
      loginPageLogoUrl: loginPageLogoUrl ?? this.loginPageLogoUrl,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      smoothTransitions: smoothTransitions ?? this.smoothTransitions,
      uiDensity: uiDensity ?? this.uiDensity,
      borderRadius: borderRadius ?? this.borderRadius,
      cardStyle: cardStyle ?? this.cardStyle,
      twoFactorAuthEnabled: twoFactorAuthEnabled ?? this.twoFactorAuthEnabled,
      sessionTimeoutMinutes: sessionTimeoutMinutes ?? this.sessionTimeoutMinutes,
      maxLoginAttempts: maxLoginAttempts ?? this.maxLoginAttempts,
      accountLockoutMinutes: accountLockoutMinutes ?? this.accountLockoutMinutes,
      suspiciousLoginDetection: suspiciousLoginDetection ?? this.suspiciousLoginDetection,
      passwordPolicy: passwordPolicy ?? this.passwordPolicy,
      reAuthRequired: reAuthRequired ?? this.reAuthRequired,
      mobileLoginEnabled: mobileLoginEnabled ?? this.mobileLoginEnabled,
      realOtpEnabled: realOtpEnabled ?? this.realOtpEnabled,
      emailLoginEnabled: emailLoginEnabled ?? this.emailLoginEnabled,
      passwordLoginEnabled: passwordLoginEnabled ?? this.passwordLoginEnabled,
      googleLoginEnabled: googleLoginEnabled ?? this.googleLoginEnabled,
      guestLoginEnabled: guestLoginEnabled ?? this.guestLoginEnabled,
      rememberLogin: rememberLogin ?? this.rememberLogin,
      autoLogin: autoLogin ?? this.autoLogin,
      forgotPasswordEnabled: forgotPasswordEnabled ?? this.forgotPasswordEnabled,
      otpExpirySeconds: otpExpirySeconds ?? this.otpExpirySeconds,
      resendOtpSeconds: resendOtpSeconds ?? this.resendOtpSeconds,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      smsNotificationsEnabled: smsNotificationsEnabled ?? this.smsNotificationsEnabled,
      whatsAppNotificationsEnabled: whatsAppNotificationsEnabled ?? this.whatsAppNotificationsEnabled,
      notificationSound: notificationSound ?? this.notificationSound,
      systemAlertsEnabled: systemAlertsEnabled ?? this.systemAlertsEnabled,
      maintenanceAlertsEnabled: maintenanceAlertsEnabled ?? this.maintenanceAlertsEnabled,
      securityAlertsEnabled: securityAlertsEnabled ?? this.securityAlertsEnabled,
      numberFormat: numberFormat ?? this.numberFormat,
      aiFeaturesEnabled: aiFeaturesEnabled ?? this.aiFeaturesEnabled,
      aiTutorEnabled: aiTutorEnabled ?? this.aiTutorEnabled,
      aiDoubtSolverEnabled: aiDoubtSolverEnabled ?? this.aiDoubtSolverEnabled,
      imageQuestionEnabled: imageQuestionEnabled ?? this.imageQuestionEnabled,
      voiceQuestionEnabled: voiceQuestionEnabled ?? this.voiceQuestionEnabled,
      aiQuizGeneratorEnabled: aiQuizGeneratorEnabled ?? this.aiQuizGeneratorEnabled,
      aiContentGeneratorEnabled: aiContentGeneratorEnabled ?? this.aiContentGeneratorEnabled,
      freeUserDailyLimit: freeUserDailyLimit ?? this.freeUserDailyLimit,
      premiumUserDailyLimit: premiumUserDailyLimit ?? this.premiumUserDailyLimit,
      aiVoiceEnabled: aiVoiceEnabled ?? this.aiVoiceEnabled,
      voiceGender: voiceGender ?? this.voiceGender,
      voiceAutoPlay: voiceAutoPlay ?? this.voiceAutoPlay,
      speechSpeed: speechSpeed ?? this.speechSpeed,
      voiceVolume: voiceVolume ?? this.voiceVolume,
      monetizationEnabled: monetizationEnabled ?? this.monetizationEnabled,
      premiumSystemEnabled: premiumSystemEnabled ?? this.premiumSystemEnabled,
      freeTrialDays: freeTrialDays ?? this.freeTrialDays,
      subscriptionPlans: subscriptionPlans ?? this.subscriptionPlans,
      adsEnabled: adsEnabled ?? this.adsEnabled,
      bannerAdsEnabled: bannerAdsEnabled ?? this.bannerAdsEnabled,
      rewardedAdsEnabled: rewardedAdsEnabled ?? this.rewardedAdsEnabled,
      couponSystemEnabled: couponSystemEnabled ?? this.couponSystemEnabled,
      referralSystemEnabled: referralSystemEnabled ?? this.referralSystemEnabled,
      paymentGatewayStatus: paymentGatewayStatus ?? this.paymentGatewayStatus,
      maintenanceModeEnabled: maintenanceModeEnabled ?? this.maintenanceModeEnabled,
      maintenanceMessage: maintenanceMessage ?? this.maintenanceMessage,
      scheduledMaintenanceTime: scheduledMaintenanceTime ?? this.scheduledMaintenanceTime,
      currentAppVersion: currentAppVersion ?? this.currentAppVersion,
      latestAppVersion: latestAppVersion ?? this.latestAppVersion,
      minSupportedVersion: minSupportedVersion ?? this.minSupportedVersion,
      forceUpdateEnabled: forceUpdateEnabled ?? this.forceUpdateEnabled,
      updateMessage: updateMessage ?? this.updateMessage,
      playStoreLink: playStoreLink ?? this.playStoreLink,
      appStoreLink: appStoreLink ?? this.appStoreLink,
      websiteLink: websiteLink ?? this.websiteLink,
      privacyPolicyLink: privacyPolicyLink ?? this.privacyPolicyLink,
      termsConditionsLink: termsConditionsLink ?? this.termsConditionsLink,
      autoBackupEnabled: autoBackupEnabled ?? this.autoBackupEnabled,
      backupSchedule: backupSchedule ?? this.backupSchedule,
      backupHistory: backupHistory ?? this.backupHistory,
      dataRetentionDays: dataRetentionDays ?? this.dataRetentionDays,
    );
  }
}
