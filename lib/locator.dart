import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:meetmeyou_app/models/user_detail.dart';
import 'package:meetmeyou_app/provider/dashboard_provider.dart';
import 'package:meetmeyou_app/provider/edit_profile_provider.dart';
import 'package:meetmeyou_app/provider/introduction_provider.dart';
import 'package:meetmeyou_app/provider/login_option_provider.dart';
import 'package:meetmeyou_app/provider/login_provider.dart';
import 'package:meetmeyou_app/provider/my_account_provider.dart';
import 'package:meetmeyou_app/provider/settings_provider.dart';
import 'package:meetmeyou_app/provider/signup_provider.dart';
import 'package:meetmeyou_app/provider/verify_provider.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';


GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AuthBase>(() => Auth());
  locator.registerLazySingleton<UserDetail>(() => UserDetail());
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

  /*
 locator.registerLazySingleton<Dio>(() {
    Dio dio = new Dio();
    //dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    // dio.interceptors.add(AuthInterceptor());
    return dio;
  });*/
}
