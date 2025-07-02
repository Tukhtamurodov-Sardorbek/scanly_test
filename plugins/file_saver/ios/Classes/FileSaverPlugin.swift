import Flutter
import UIKit
import Photos

public class FileSaverPlugin: NSObject, FlutterPlugin {
  var result: FlutterResult?;
  let errorMessage = "Failed to save, please check whether the permission is enabled"

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "file_saver", binaryMessenger: registrar.messenger())
    let instance = FileSaverPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    self.result = result
    if (call.method == "getPlatformVersion") {
        result("iOS " + UIDevice.current.systemVersion)
    } else if (call.method == "saveMultipleFiles") {
        let args = call.arguments as! Dictionary<String, Any>
        let dataList = args["dataList"] as! [FlutterStandardTypedData]
        let fileNameList = args["fileNameList"] as! [String]
        let mimeTypeList = args["mimeTypeList"] as! [String]
        saveMultipleFiles(dataList: dataList, fileNameList: fileNameList, mimeTypeList: mimeTypeList)
        result(nil)
    } else if (call.method == "saveImageToGallery") {
        let arguments = call.arguments as? [String: Any] ?? [String: Any]()
        guard let imageData = (arguments["imageBytes"] as? FlutterStandardTypedData)?.data,
            let image = UIImage(data: imageData),
            let quality = arguments["quality"] as? Int,
            let _ = arguments["name"],
            let isReturnImagePath = arguments["isReturnImagePathOfIOS"] as? Bool
            else { return }
        let newImage = image.jpegData(compressionQuality: CGFloat(quality / 100))!
        saveImage(UIImage(data: newImage) ?? image, isReturnImagePath: isReturnImagePath)
    } else if (call.method == "saveFileToGallery") {
        guard let arguments = call.arguments as? [String: Any],
            let path = arguments["file"] as? String,
            let _ = arguments["name"],
            let isReturnFilePath = arguments["isReturnPathOfIOS"] as? Bool else { return }
        if (isImageFile(filename: path)) {
            saveImageAtFileUrl(path, isReturnImagePath: isReturnFilePath)
        } else {
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
                saveVideo(path, isReturnImagePath: isReturnFilePath)
            }
        }
    } else {
        result(FlutterMethodNotImplemented)
    }
  }

  private func saveMultipleFiles(dataList: [FlutterStandardTypedData], fileNameList: [String], mimeTypeList: [String]) {
    if let vc = UIApplication.shared.keyWindow?.rootViewController {
        var temporaryFileURLList:[URL] = []

        let count = dataList.count
        var i = 0
        while i < count {
            let data = dataList[i]
            let fileName = fileNameList[i]
            let temporaryFolder = URL(fileURLWithPath: NSTemporaryDirectory())
            let temporaryFileURL = temporaryFolder.appendingPathComponent(fileName)
            temporaryFileURLList.append(temporaryFileURL)

            do {
                try data.data.write(to: temporaryFileURL)
            } catch {
               print(error)
            }

            i = i + 1
        }

        let activityController = UIActivityViewController(activityItems: temporaryFileURLList, applicationActivities: nil)
        activityController.excludedActivityTypes = [.airDrop, .postToTwitter, .assignToContact, .postToFlickr, .postToWeibo, .postToTwitter]
        if let popOver = activityController.popoverPresentationController {
          popOver.sourceView = vc.view
          popOver.sourceRect = CGRect(x: vc.view.bounds.midX, y: vc.view.bounds.midY, width: 0, height: 0)
          popOver.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }

        vc.present(activityController, animated: true, completion: nil)
    }
  }

      func saveVideo(_ path: String, isReturnImagePath: Bool) {
          if !isReturnImagePath {
              UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(didFinishSavingVideo(videoPath:error:contextInfo:)), nil)
              return
          }
          var videoIds: [String] = []

          PHPhotoLibrary.shared().performChanges( {
              let req = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL.init(fileURLWithPath: path))
              if let videoId = req?.placeholderForCreatedAsset?.localIdentifier {
                  videoIds.append(videoId)
              }
          }, completionHandler: { [unowned self] (success, error) in
              DispatchQueue.main.async {
                  if (success && videoIds.count > 0) {
                      let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: videoIds, options: nil)
                      if (assetResult.count > 0) {
                          let videoAsset = assetResult[0]
                          PHImageManager().requestAVAsset(forVideo: videoAsset, options: nil) { (avurlAsset, audioMix, info) in
                              if let urlStr = (avurlAsset as? AVURLAsset)?.url.absoluteString {
                                  self.saveResult(isSuccess: true, filePath: urlStr)
                              }
                          }
                      }
                  } else {
                      self.saveResult(isSuccess: false, error: self.errorMessage)
                  }
              }
          })
      }

      func saveImage(_ image: UIImage, isReturnImagePath: Bool) {
          if !isReturnImagePath {
              UIImageWriteToSavedPhotosAlbum(image, self, #selector(didFinishSavingImage(image:error:contextInfo:)), nil)
              return
          }

          var imageIds: [String] = []

          PHPhotoLibrary.shared().performChanges( {
              let req = PHAssetChangeRequest.creationRequestForAsset(from: image)
              if let imageId = req.placeholderForCreatedAsset?.localIdentifier {
                  imageIds.append(imageId)
              }
          }, completionHandler: { [unowned self] (success, error) in
              DispatchQueue.main.async {
                  if (success && imageIds.count > 0) {
                      let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: imageIds, options: nil)
                      if (assetResult.count > 0) {
                          let imageAsset = assetResult[0]
                          let options = PHContentEditingInputRequestOptions()
                          options.canHandleAdjustmentData = { (adjustmeta)
                              -> Bool in true }
                          imageAsset.requestContentEditingInput(with: options) { [unowned self] (contentEditingInput, info) in
                              if let urlStr = contentEditingInput?.fullSizeImageURL?.absoluteString {
                                  self.saveResult(isSuccess: true, filePath: urlStr)
                              }
                          }
                      }
                  } else {
                      self.saveResult(isSuccess: false, error: self.errorMessage)
                  }
              }
          })
      }

      func saveImageAtFileUrl(_ url: String, isReturnImagePath: Bool) {
          if !isReturnImagePath {
              if let image = UIImage(contentsOfFile: url) {
                  UIImageWriteToSavedPhotosAlbum(image, self, #selector(didFinishSavingImage(image:error:contextInfo:)), nil)
              }
              return
          }

          var imageIds: [String] = []

          PHPhotoLibrary.shared().performChanges( {
              let req = PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: URL(string: url)!)
              if let imageId = req?.placeholderForCreatedAsset?.localIdentifier {
                  imageIds.append(imageId)
              }
          }, completionHandler: { [unowned self] (success, error) in
              DispatchQueue.main.async {
                  if (success && imageIds.count > 0) {
                      let assetResult = PHAsset.fetchAssets(withLocalIdentifiers: imageIds, options: nil)
                      if (assetResult.count > 0) {
                          let imageAsset = assetResult[0]
                          let options = PHContentEditingInputRequestOptions()
                          options.canHandleAdjustmentData = { (adjustmeta)
                              -> Bool in true }
                          imageAsset.requestContentEditingInput(with: options) { [unowned self] (contentEditingInput, info) in
                              if let urlStr = contentEditingInput?.fullSizeImageURL?.absoluteString {
                                  self.saveResult(isSuccess: true, filePath: urlStr)
                              }
                          }
                      }
                  } else {
                      self.saveResult(isSuccess: false, error: self.errorMessage)
                  }
              }
          })
      }
      /// finish saving，if has error，parameters error will not nill
      @objc func didFinishSavingImage(image: UIImage, error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
          saveResult(isSuccess: error == nil, error: error?.description)
      }

      @objc func didFinishSavingVideo(videoPath: String, error: NSError?, contextInfo: UnsafeMutableRawPointer?) {
          saveResult(isSuccess: error == nil, error: error?.description)
      }

      func saveResult(isSuccess: Bool, error: String? = nil, filePath: String? = nil) {
          var saveResult = SaveResultModel()
          saveResult.isSuccess = error == nil
          saveResult.errorMessage = error?.description
          saveResult.filePath = filePath
          result?(saveResult.toDic())
      }

      func isImageFile(filename: String) -> Bool {
          return filename.hasSuffix(".jpg")
              || filename.hasSuffix(".png")
              || filename.hasSuffix(".jpeg")
              || filename.hasSuffix(".JPEG")
              || filename.hasSuffix(".JPG")
              || filename.hasSuffix(".PNG")
              || filename.hasSuffix(".gif")
              || filename.hasSuffix(".GIF")
              || filename.hasSuffix(".heic")
              || filename.hasSuffix(".HEIC")
      }
}

public struct SaveResultModel: Encodable {
    var isSuccess: Bool!
    var filePath: String?
    var errorMessage: String?

    func toDic() -> [String:Any]? {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else { return nil }
        if (!JSONSerialization.isValidJSONObject(data)) {
            return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
        }
        return nil
    }
}
