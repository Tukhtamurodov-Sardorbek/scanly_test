import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:scanly_test/di/injector.config.dart';
import 'package:scanly_test/src/app/app_bloc/di/module.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
