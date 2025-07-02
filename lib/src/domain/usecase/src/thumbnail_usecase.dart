abstract class ThumbnailUsecase {
  Future<String?> generate(String imagePath, String directoryPath);

  Future<String> overwrite(String imagePath, String thumbPath);

  Future<String> replace(String imagePath, String oldThumbPath);
}
