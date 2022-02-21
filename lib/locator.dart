import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:meetmeyou_app/helper/dynamic_links_api.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/models/group_detail.dart';
import 'package:meetmeyou_app/models/multiple_date_option.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/calendarProvider.dart';
import 'package:meetmeyou_app/provider/calendar_settings_provider.dart';
import 'package:meetmeyou_app/provider/choose_event_provider.dart';
import 'package:meetmeyou_app/provider/create_event_provider.dart';
import 'package:meetmeyou_app/provider/event_attending_provider.dart';
import 'package:meetmeyou_app/provider/event_detail_provider.dart';
import 'package:meetmeyou_app/provider/event_discussion_provider.dart';
import 'package:meetmeyou_app/provider/event_invite_friends_provider.dart';
import 'package:meetmeyou_app/provider/group_contacts_provider.dart';
import 'package:meetmeyou_app/provider/contacts_provider.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/provider/edit_Contact_Provider.dart';
import 'package:meetmeyou_app/provider/create_edit_group_provider.dart';
import 'package:meetmeyou_app/provider/edit_profile_provider.dart';
import 'package:meetmeyou_app/provider/group_description_provider.dart';
import 'package:meetmeyou_app/provider/home_page_provider.dart';
import 'package:meetmeyou_app/provider/introduction_provider.dart';
import 'package:meetmeyou_app/provider/invite_friends_provider.dart';
import 'package:meetmeyou_app/provider/login_option_provider.dart';
import 'package:meetmeyou_app/provider/login_provider.dart';
import 'package:meetmeyou_app/provider/multiple_date_time_provider.dart';
import 'package:meetmeyou_app/provider/my_account_provider.dart';
import 'package:meetmeyou_app/provider/contact_description_provider.dart';
import 'package:meetmeyou_app/provider/new_event_discussion_provider.dart';
import 'package:meetmeyou_app/provider/organize_event_card_provider.dart';
import 'package:meetmeyou_app/provider/rejected_invites_Provider.dart';
import 'package:meetmeyou_app/provider/search_profile_provider.dart';
import 'package:meetmeyou_app/provider/settings_provider.dart';
import 'package:meetmeyou_app/provider/signup_provider.dart';
import 'package:meetmeyou_app/provider/verify_provider.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';


GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AuthBase>(() => Auth());
  locator.registerLazySingleton<UserDetail>(() => UserDetail());
  locator.registerLazySingleton<GroupDetail>(() => GroupDetail());
  locator.registerLazySingleton<EventDetail>(() => EventDetail());
  locator.registerLazySingleton<CalendarDetail>(() => CalendarDetail());
  locator.registerLazySingleton<MultipleDateOption>(() => MultipleDateOption());
  locator.registerLazySingleton<DynamicLinksApi>(() => DynamicLinksApi());
  locator.registerFactoryParam<MMYEngine,User,String>((param1, param2) => MMY(param1));
  locator.registerFactory<IntroductionProvider>(() => IntroductionProvider());
  locator.registerFactory<LoginOptionProvider>(() => LoginOptionProvider());
  locator.registerFactory<VerifyProvider>(() => VerifyProvider());
  locator.registerFactory<SignUpProvider>(() => SignUpProvider());
  locator.registerFactory<LoginProvider>(() => LoginProvider());
  locator.registerFactory<EditProfileProvider>(() => EditProfileProvider());
  locator.registerFactory<MyAccountProvider>(()=> MyAccountProvider());
  locator.registerFactory<SettingsProvider>(()=> SettingsProvider());
  locator.registerFactory<DashboardProvider>(()=> DashboardProvider());
  locator.registerFactory<InviteFriendsProvider>(()=> InviteFriendsProvider());
  locator.registerFactory<ContactsProvider>(()=> ContactsProvider());
  locator.registerFactory<EditContactProvider>(()=> EditContactProvider());
  locator.registerFactory<RejectedInvitesProvider>(()=> RejectedInvitesProvider());
  locator.registerFactory<ContactDescriptionProvider>(()=> ContactDescriptionProvider());
  locator.registerFactory<SearchProfileProvider>(()=> SearchProfileProvider());
  locator.registerFactory<CreateEditGroupProvider>(()=> CreateEditGroupProvider());
  locator.registerFactory<GroupContactsProvider>(()=> GroupContactsProvider());
  locator.registerFactory<GroupDescriptionProvider>(()=> GroupDescriptionProvider());
  locator.registerFactory<CreateEventProvider>(() => CreateEventProvider());
  locator.registerFactory<EventInviteFriendsProvider>(() => EventInviteFriendsProvider());
  locator.registerFactory<HomePageProvider>(() => HomePageProvider());
  locator.registerFactory<EventDetailProvider>(() => EventDetailProvider());
  locator.registerFactory<EventAttendingProvider>(() => EventAttendingProvider());
  locator.registerFactory<CalendarProvider>(() => CalendarProvider());
  locator.registerFactory<CalendarSettingsProvider>(() => CalendarSettingsProvider());
  locator.registerFactory<ChooseEventProvider>(() => ChooseEventProvider());
  locator.registerFactory<EventDiscussionProvider>(() => EventDiscussionProvider());
  locator.registerFactory<OrganizeEventCardProvider>(() => OrganizeEventCardProvider());
  locator.registerFactory<MultipleDateTimeProvider>(() => MultipleDateTimeProvider());
  locator.registerFactory<NewEventDiscussionProvider>(() => NewEventDiscussionProvider());


  /*
 locator.registerLazySingleton<Dio>(() {
    Dio dio = new Dio();
    //dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    // dio.interceptors.add(AuthInterceptor());
    return dio;
  });*/
}
