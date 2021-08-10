import 'package:get_it/get_it.dart';
import 'package:litt/api_service.dart';

GetIt locator = GetIt.instance;



/*
* This is commonly used to register things like showing a dialog, 
* integrating an API
*/
void setupLocator() {
  locator.registerLazySingleton(() => APIService());
}
