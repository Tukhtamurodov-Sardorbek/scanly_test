abstract class AppStorage {
  int get runTimes;

  Future<bool> saveRunTimes();

  Future<bool> clearStorage();
}
