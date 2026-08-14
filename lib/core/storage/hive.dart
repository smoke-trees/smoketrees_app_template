import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> initialize() async {
    //Initializing Hive
    await Hive.initFlutter();
    // if (!Hive.isAdapterRegistered(1)) {
    //   Hive.registerAdapter<User>(UserAdapter());
    // }
    // if (!Hive.isAdapterRegistered(2)) {
    //   Hive.registerAdapter<City>(CityAdapter());
    // }
    // await Hive.openBox<User?>('userBox');
  }
}
