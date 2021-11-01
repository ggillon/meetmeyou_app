import 'package:get_it/get_it.dart';
import 'package:meetmeyou_app/provider/introduction_provider.dart';
import 'package:meetmeyou_app/provider/login_option_provider.dart';
import 'package:meetmeyou_app/provider/login_provider.dart';
import 'package:meetmeyou_app/provider/signup_provider.dart';
import 'package:meetmeyou_app/provider/verify_provider.dart';
import 'package:meetmeyou_app/services/auth/auth.dart';


GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AuthBase>(() => Auth());
  locator.registerFactory<IntroductionProvider>(() => IntroductionProvider());
  locator.registerFactory<LoginOptionProvider>(() => LoginOptionProvider());
  locator.registerFactory<VerifyProvider>(() => VerifyProvider());
  locator.registerFactory<SignUpProvider>(() => SignUpProvider());
  locator.registerFactory<LoginProvider>(() => LoginProvider());

  /*
 locator.registerLazySingleton<Dio>(() {
    Dio dio = new Dio();
    //dio.interceptors.add(AuthInterceptor());
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    // dio.interceptors.add(AuthInterceptor());
    return dio;
  });*/
}
