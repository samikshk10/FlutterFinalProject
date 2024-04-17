import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/widgets/globalwidget/flashmessage.dart';
import 'package:get/utils.dart';

/// This is an abstract class with member functions to pick files (image/pdf) one at a time.
abstract class ETFilePicker {
  /// Lets the user select an image via a `Gallery` or other `Photo Viewing Applications`.
  static Future<PlatformFile?> selectAnImage(BuildContext context) async =>
      await _selectAFile(context, FileType.image);

  /// Lets the user select a file
  ///
  /// Accepts all kinds of files on return value although the allowed extension is `pdf` only.
  static Future<PlatformFile?> selectADocumentFile(
          BuildContext context) async =>
      await _selectAFile(context, FileType.custom, extensions: ['pdf']);

  /// This is a function where everything to pick a file happens.
  ///
  /// Give a type of the file you want to pick. - Example: FileType.image | FileType.any
  ///
  /// On `type: FileType.custom`, it is a requirement to give at least 1 `extensions`.
  static Future<PlatformFile?> _selectAFile(BuildContext context, FileType type,
      {List<String> extensions = const []}) async {
    assert(type != FileType.custom || extensions.isNotEmpty,
        "FileType.custom but allowedExtensions.length = 0");
    try {
      PlatformFile file = (await FilePicker.platform
              .pickFiles(type: type, allowedExtensions: extensions))!
          .files
          .first;
      if (_checkSize(file)) return file;
    } on UnsupportedError catch (err) {
      FlashMessage.show(context, message: err.message.toString());
    } catch (err) {
      print(err);
      FlashMessage.show(context, message: err.toString());
    }
    return null; // Return null if an error occurred
  }

  /// Checks if the size (bytes) of the file is within 10MB.
  static bool _checkSize(PlatformFile file) {
    if (file.size.isLowerThan(10485760)) return true;
    throw UnsupportedError('File size must be less than 10MB.');
  }
}
