abstract class EntryRepository {
  int get runTimes;

  Future<bool> saveRunTimes();

  Future<bool> clearStorage();
}
