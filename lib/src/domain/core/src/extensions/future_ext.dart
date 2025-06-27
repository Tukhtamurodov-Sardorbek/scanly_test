extension FutureZipX<T> on Future<T> {
  Future<(T, T2)> zipWith<T2>(Future<T2> future2) async {
    late T result1;
    late T2 result2;
    await Future.wait([
      then((it) => result1 = it),
      future2.then((it) => result2 = it),
    ]);
    return (result1, result2);
  }
}
