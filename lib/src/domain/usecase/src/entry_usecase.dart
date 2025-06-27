abstract class EntryUsecase {
  int get runTimes;

  Future<bool> saveRunTimes();

  Future<bool> clearStorage();
}
