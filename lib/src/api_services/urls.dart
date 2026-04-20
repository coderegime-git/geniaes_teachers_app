import '../config/app_configs.dart';

final String baseUrl = AppConfigs.baseUrl;
final String apiBaseUrl = AppConfigs.apiBaseUrl;
final String mediaUrl = AppConfigs.mediaUrl;

///---fcm
const String fcmService = 'https://fcm.googleapis.com/fcm/send';

///---auth
// String signUpWithEmailURL = apiBaseUrl + 'signup-email';
String signUpWithEmailURL = '${apiBaseUrl}auth/register';
String signInWithEmailURL = '${apiBaseUrl}auth/login';
String socialLoginURL = '${apiBaseUrl}auth/social_login';
String loginWithOtpURL = '${apiBaseUrl}login-signup';
String signOutURL = '${apiBaseUrl}auth/logout';
String deleteAccountURL = '${apiBaseUrl}auth/delete_account';

///---logged-in-user
String getLoggedInUserUrl = '${apiBaseUrl}auth/user';

String contactUsUrl = '${apiBaseUrl}contact';

///---payment-method
String paymentMethodUrl = '${apiBaseUrl}execute-payment';
String jazzCashPaymentUrl = '${apiBaseUrl}makeJazzcashPayment';
// String getAppointmentPaymentStatusUrl = baseUrl + 'getAppointmentStatus';
String getPaymentMethodsUrl = '${apiBaseUrl}payment_methods';

//---edit-or-update-profile
String editUserProfileURL = '${apiBaseUrl}teachers/update_general_info';
// String editUserProfileExperienceURL = apiBaseUrl + 'teachers/teacher_experiences';
String addEditUserProfileEducationURL =
    '${apiBaseUrl}teachers/teacher_educations';
String addEditUserProfileCertificateURL =
    '${apiBaseUrl}teachers/teacher_certifications';
String addEditUserProfileExperienceURL =
    '${apiBaseUrl}teachers/teacher_experiences';
String addEditUserProfilePodcastURL = '${apiBaseUrl}teachers/teacher_podcasts';
String addEditUserProfileEventURL = '${apiBaseUrl}teachers/teacher_events';
String addEditUserProfileBlogURL = '${apiBaseUrl}teachers/teacher_posts';

//---get-profile-certificate
String getUserProfileCertificateURL =
    '${apiBaseUrl}teachers/teacher_certifications';
//---get-profile-experiences
String getUserProfileExperiencesURL =
    '${apiBaseUrl}teachers/teacher_experiences';
//---get-profile-Education
String getUserProfileEducationsURL = '${apiBaseUrl}teachers/teacher_educations';
//---get-profile-Podcasts
String getUserProfilePodcastsURL = '${apiBaseUrl}teachers/teacher_podcasts';
//---get-profile-Events
String getUserProfileEventsURL = '${apiBaseUrl}teachers/teacher_events';
//---get-profile-Blogs
String getUserProfileBlogsURL = '${apiBaseUrl}teachers/teacher_posts';

// Social Info
String getSocialInfoURL    = '${apiBaseUrl}teachers/get_social_info';
String updateSocialInfoURL = '${apiBaseUrl}teachers/update_social_info';

// Calendly
String getCalendlyURL    = '${apiBaseUrl}teachers/get_calendly';
String updateCalendlyURL = '${apiBaseUrl}teachers/update_calendly';

///---consultant-profile-by-id
String getTeacherProfileUrl = '${apiBaseUrl}teachers/';
String getMentorProfileForMenteeUrl = '${apiBaseUrl}get-mentor-details';

String mentorChangeAppointmentStatusUrl =
    '${apiBaseUrl}changeAppointmentStatus';

///---get-appointment-counts
String getAppointmentCountUrl = '${apiBaseUrl}mentorAppointmentCount';
String getAppointmentCountForMentorUrl = '${apiBaseUrl}appointment-count';

///---featured
String getFeaturedEvents = '${apiBaseUrl}featured_events';
String getFeaturedTeachers = '${apiBaseUrl}featured_teachers';

///---all listings
String getAllTeachers = '${apiBaseUrl}filter_teachers';
String getAllBlogsPosts = '${apiBaseUrl}filter_posts';
String getAllEvents = '${apiBaseUrl}filter_events';

///---categories
String getTeacherCategoriesURL = '${apiBaseUrl}teacher_categories';

// Broadcast Categories
String getBroadcastCategoriesURL = '${apiBaseUrl}broadcast_categories';

// Event Categories
String getEventCategoriesURL = '${apiBaseUrl}event_categories';

///---top-rated
String getTopRatedConsultantURL = '${apiBaseUrl}topRatedMentors';

///---categories-with-mentor
String getCategoriesWithMentorURL = '${apiBaseUrl}categories/with/mentors';

///---book-appointment
String getScheduleAvailableDaysURL =
    '${apiBaseUrl}get-scheduled-available-days';
String getScheduleSlotsForMenteeUrl = '${apiBaseUrl}get-date-schedule';
String bookAppointmentUrl = '${apiBaseUrl}bookAppointment';

///---appointment-log-user
String getUserAllAppointmentsURL = '${apiBaseUrl}all-status-menteeAppointments';
String getConsultantAllAppointmentsURL =
    '${apiBaseUrl}all-status-mentorAppointments';
String fileAttachmentUrl = '${apiBaseUrl}appointment-attachments';
String mentorArchivedAppointmentUrl =
    '${apiBaseUrl}mentor/archieved-appointment';
String mentorUnArchivedAppointmentUrl =
    '${apiBaseUrl}mentor/unarchieved-appointment';

///---appointment-log-user
String getAppointmentsDetailURL = '${apiBaseUrl}appointmentDetails';

/// Blogs
String categoriesBlogUrl = '${apiBaseUrl}categoriesBlogs';
String blogCategoriesUrl = '${apiBaseUrl}blogCategories';
String createConsultantBlogUrl = '${apiBaseUrl}create_consultant_blog';
String consultantBlogUrl = '${apiBaseUrl}consultant_blogs';
String blogDetailUrl = '${apiBaseUrl}blogDetail';
String updateConsultantBlogUrl = '${apiBaseUrl}update_consultant_blog';
String deleteConsultantBlogUrl = '${apiBaseUrl}delete_consultant_blog';

///---teacher-reviews
String getTeacherReviews = '${apiBaseUrl}filter_teacher_reviews';

/// wallet
String getWalletBalanceURL = '${apiBaseUrl}get_current_balance';
String getWalletTransactionURL = '${apiBaseUrl}get_wallet_transactions';
String getWalletWithdrawalURL = '${apiBaseUrl}get_wallet_withdrawls';
String withdrawAmountURL = '${apiBaseUrl}withdraw_amount';

/// rating
String createRatingUrl = '${apiBaseUrl}create-rating';
String getExistRatingUrl = '${apiBaseUrl}rating-exist-appointment';

///---agora
String getAgoraTokenUrl = '${apiBaseUrl}teachers/api_generate_agora_token';

///---Make Agora Call
String makeAgoraCall = '${apiBaseUrl}teachers/api_make_agora_call';

///--- Send Call Notification
String sendCallNotification = '${apiBaseUrl}teachers/api_send_notification';

///---send-message
String sendSMSUrl = '${apiBaseUrl}send-sms';

///---get-device-id
String fcmUpdateUrl = '${apiBaseUrl}fcm-store-token';
String fcmGetUrl = '${apiBaseUrl}fcm-get-tokens';

///---chat messages
String getMessagesUrl = '${apiBaseUrl}teachers/api_get_chat_messages/';
String sendMessageUrl = '${apiBaseUrl}teachers/api_send_chat_message';

///---service chat messages
String getServiceMessagesUrl =
    '${apiBaseUrl}teachers/api_get_service_chat_messages/';
String sendServiceMessageUrl =
    '${apiBaseUrl}teachers/api_service_send_chat_message';

///---reset-password
String forgotPasswordUrl = '${apiBaseUrl}auth/forgot_password';
String newPasswordUrl = '${apiBaseUrl}reset-password';

/// All Settings
String getAllSettingUrl = '${apiBaseUrl}settings';

/// All Languages
String getAllLanguagesUrl = '${apiBaseUrl}get_all_languages';

/// Get Terms and Conditions
String getTermsConditionsUrl = '${apiBaseUrl}terms_conditions';

// Generate Appointment Schedule Slots Teacher
String generateAppointmentScheduleSlotsUrl =
    '${apiBaseUrl}teachers/save_appointment_schedules';

// Generate Appointment Schedule Slots for Single Day Teacher
String generateAppointmentScheduleSlotsForSingleDayUrl =
    '${apiBaseUrl}teachers/add_new_appointment_schedules';

// Get Appointment Commission
String getAppointmentScheduleCommissionUrl =
    '${apiBaseUrl}teachers/get_appointment_commission';

String deleteAppointmentScheduleSlotsUrl =
    '${apiBaseUrl}teachers/delete_appointment_slots';

// Get Appointment Schedule Slots Teacher
String getAppointmentScheduleSlotsUrl =
    '${apiBaseUrl}teachers/api_appointment_schedules';

// Get Teacher Appointment History
String getTeacherAppointmentHistory =
    "${apiBaseUrl}teachers/get_filter_appointment_logs";

// Get Teacher Booked Services History
String getTeacherBookedServices =
    "${apiBaseUrl}teachers/get_filter_booked_services";

// Update Appointment Status Code
String updateAppointmentStatusCodeURL =
    "${apiBaseUrl}teachers/update_appointment_status/";

// Update Booked Service Status Code
String updateBookedServiceStatusCodeURL =
    "${apiBaseUrl}teachers/update_booked_service_status/";

// Content Pages URls
String contentPagesURL = "${apiBaseUrl}company_page";

// Open Web View For Pricing Plan
String webViewForPricingPlanURL = "${baseUrl}pricing/teacher";
