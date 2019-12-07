import 'package:chopper/chopper.dart';
import 'package:injector/injector.dart';
import 'package:registro_elettronico/data/db/dao/profile_dao.dart';
import 'package:registro_elettronico/data/db/moor_database.dart';
import 'package:registro_elettronico/data/network/service/api/chopper_api_services.dart';
import 'package:registro_elettronico/data/network/service/chopper_service.dart';
import 'package:registro_elettronico/data/repository/login_repository_impl.dart';
import 'package:registro_elettronico/domain/repository/login_repository.dart';

class AppInjector {
  static void init() {
    injectDatabase();
    injectService();
    injectRepository();
  }

  static void injectDatabase() {
    // main database
    Injector.appInstance.registerSingleton<AppDatabase>((injector) {
      return AppDatabase();
    });
    // daos
    Injector.appInstance.registerSingleton<ProfileDao>((injector) {
      return ProfileDao(injector.getDependency());
    });
  }

  static void injectRepository() {
    // repositoeries
    Injector.appInstance.registerSingleton((i) {
      LoginRepository loginRepository =
          LoginRepositoryImpl(i.getDependency(), i.getDependency());
      return loginRepository;
    });
  }

  static void injectService() {
    // services
    Injector.appInstance.registerSingleton<ChopperClient>((i) {
      return SpaggiariClient.i();
    });

    Injector.appInstance.registerSingleton((injector) {
      return LoginApiService.create();
    });
  }
}
