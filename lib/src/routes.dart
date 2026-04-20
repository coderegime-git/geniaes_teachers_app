import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'screens/about_us_screen.dart';
import 'screens/agora_call/join_channel_audio.dart';
import 'screens/agora_call/join_channel_video.dart';
import 'screens/appointment_detail_screen.dart';
import 'screens/appointment_history_screen.dart';
import 'screens/blog_detail_screen.dart';
import 'screens/blogs_screen.dart';
import 'screens/booked_service_detail_screen.dart';
import 'screens/booked_services_screen.dart';
import 'screens/contact_us_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/invitations_screen.dart';
import 'screens/languages_screen.dart';
import 'screens/live_service_chat_screen.dart';
import 'screens/teacher_profile_setup_screen.dart';
import 'screens/live_chat_screen.dart';
import 'screens/payment_detail_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/teacher_profile_screen.dart';
import 'screens/subscription_pricing_plan_screen.dart';
import 'screens/wallet_screen.dart';
import 'widgets/bottom_navigation_widget.dart';

appRoutes() => [
      GetPage(name: '/splashscreen', page: () => const SplashScreen()),
      GetPage(name: '/introscreen', page: () => const IntroScreen()),
      GetPage(name: '/homescreen', page: () => const BottomNavigationWidget()),
      GetPage(
          name: '/teacherprofilescreen',
          page: () => const TeacherProfileScreen()),
      GetPage(
          name: '/teacherprofilesetupscreen',
          page: () => const TeacherProfileSetupScreen()),
      // GetPage(
      //     name: '/notificationsscreen',
      //     page: () => const NotificationsScreen()),
      GetPage(
          name: '/invitationsscreen', page: () => const InvitationsScreen()),
      GetPage(
          name: '/userprofilescreen', page: () => const TeacherProfileScreen()),
      GetPage(name: '/contactusscreen', page: () => const ContactUsScreen()),
      GetPage(name: '/aboutusscreen', page: () => const AboutUsScreen()),
      GetPage(
          name: '/appointmenthistoryscreen',
          page: () => const AppointmentHistoryScreen()),
      GetPage(
          name: '/appointmenthistorydetailscreen',
          page: () => const AppointmentDetailScreen()),
      GetPage(name: '/walletscreen', page: () => const WalletScreen()),
      GetPage(
          name: '/pricingplanscreen',
          page: () => const SubscriptionPricingPlanScreen()),
      GetPage(
          name: '/paymentdetailscreen',
          page: () => const PaymentDetailScreen()),
      GetPage(name: '/blogsscreen', page: () => const BlogsScreen()),
      GetPage(name: '/blogdetailscreen', page: () => BlogDetailScreen()),

      // GetPage(name: '/eventsscreen', page: () => const EventsScreen()),
      // GetPage(name: '/eventdetailscreen', page: () => EventDetailScreen()),
      GetPage(name: '/signinscreen', page: () => SigninScreen()),
      GetPage(name: '/signupscreen', page: () => SignupScreen()),
      // GetPage(
      //     name: '/scheduleappslots',
      //     page: () => const AppointmentScheduleWidget()),
      GetPage(name: '/videocallscreen', page: () => const JoinChannelVideo()),
      GetPage(name: '/audiocallscreen', page: () => const JoinChannelAudio()),
      GetPage(name: '/livechatscreen', page: () => const LiveChatScreen()),
      GetPage(
          name: '/forgotpasswordscreen', page: () => ForgotPasswordScreen()),
      GetPage(
          name: '/privacypolicyscreen',
          page: () => const PrivacyPolicyScreen()),
      GetPage(name: '/languagesscreen', page: () => const LanguagesScreen()),
      GetPage(
          name: '/bookedservicesscreen',
          page: () => const BookedServicesScreen()),
      GetPage(
          name: '/bookedservicedetailscreen',
          page: () => const BookedServiceDetailScreen()),
      GetPage(
          name: '/liveservicechatscreen',
          page: () => const LiveServiceChatScreen()),
    ];

class PageRoutes {
  static const String splashScreen = '/splashscreen';
  static const String introScreen = '/introscreen';
  static const String homeScreen = '/homescreen';
  static const String teacherProfileScreen = '/teacherprofilescreen';
  static const String teacherProfileSetupScreen = '/teacherprofilesetupscreen';
  static const String notificationsScreen = '/notificationsscreen';
  static const String invitationsScreen = '/invitationsscreen';
  static const String userProfileScreen = '/userprofilescreen';
  static const String contactusScreen = '/contactusscreen';
  static const String aboutusScreen = '/aboutusscreen';
  static const String appointmentHistoryScreen = '/appointmenthistoryscreen';
  static const String appointmentHistoryDetailScreen =
      '/appointmenthistorydetailscreen';
  static const String walletScreen = '/walletscreen';
  static const String pricingPlanScreen = '/pricingplanscreen';
  static const String paymentDetailScreen = '/paymentdetailscreen';
  static const String blogsScreen = '/blogsscreen';
  static const String blogDetailScreen = '/blogdetailscreen';
  static const String eventsScreen = '/eventsscreen';
  static const String eventDetailScreen = '/eventdetailscreen';
  static const String signinScreen = '/signinscreen';
  static const String signupScreen = '/signupscreen';
  static const String videoCallScreen = '/videocallscreen';
  static const String audioCallScreen = '/audiocallscreen';
  // static const String scheduleAppSlots = '/scheduleappslots';
  static const String liveChatScreen = '/livechatscreen';
  static const String forgotPasswordScreen = '/forgotpasswordscreen';
  static const String privacyPolicyScreen = '/privacypolicyscreen';
  static const String languagesScreen = '/languagesscreen';
  static const String bookedServicesScreen = '/bookedservicesscreen';
  static const String bookedServiceDetailScreen = '/bookedservicedetailscreen';
  static const String liveServiceChatScreen = '/liveservicechatscreen';

  Map<String, WidgetBuilder> appRoutes() {
    return {
      splashScreen: (context) => const SplashScreen(),
      introScreen: (context) => const IntroScreen(),
      homeScreen: (context) => const BottomNavigationWidget(),
      teacherProfileScreen: (context) => const TeacherProfileScreen(),
      teacherProfileSetupScreen: (context) => const TeacherProfileSetupScreen(),
      // notificationsScreen: (context) => const NotificationsScreen(),
      invitationsScreen: (context) => const InvitationsScreen(),
      userProfileScreen: (context) => const TeacherProfileScreen(),
      contactusScreen: (context) => const ContactUsScreen(),
      aboutusScreen: (context) => const AboutUsScreen(),
      appointmentHistoryScreen: (context) => const AppointmentHistoryScreen(),
      appointmentHistoryDetailScreen: (context) =>
          const AppointmentDetailScreen(),
      walletScreen: (context) => const WalletScreen(),
      pricingPlanScreen: (context) => const SubscriptionPricingPlanScreen(),
      paymentDetailScreen: (context) => const PaymentDetailScreen(),
      blogsScreen: (context) => const BlogsScreen(),
      blogDetailScreen: (context) => BlogDetailScreen(),
      // eventsScreen: (context) => const EventsScreen(),
      // eventDetailScreen: (context) => EventDetailScreen(),
      signinScreen: (context) => SigninScreen(),
      signupScreen: (context) => SignupScreen(),
      // scheduleAppSlots: (context) => const AppointmentScheduleWidget(),
      videoCallScreen: (context) => const JoinChannelVideo(),
      audioCallScreen: (context) => const JoinChannelAudio(),
      liveChatScreen: (context) => const LiveChatScreen(),
      forgotPasswordScreen: (context) => ForgotPasswordScreen(),
      privacyPolicyScreen: (context) => const PrivacyPolicyScreen(),
      languagesScreen: (context) => const LanguagesScreen(),
      bookedServicesScreen: (context) => const BookedServicesScreen(),
      bookedServiceDetailScreen: (context) => const BookedServiceDetailScreen(),
      liveServiceChatScreen: (context) => const LiveServiceChatScreen(),
    };
  }
}
