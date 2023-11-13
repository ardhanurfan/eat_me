import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageTool {
  File? _imageFile;
  File? _croppedFile;
  CroppedFile? _croppedImage;

  File? get croppedImageFile => _croppedFile;

  Future pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      _imageFile = pickedImage != null ? File(pickedImage.path) : null;

      _croppedImage =
          await ImageCropper().cropImage(sourcePath: _imageFile!.path);
      _croppedFile = _croppedImage != null ? File(_croppedImage!.path) : null;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> uploadImage(File imageFile, String reference) async {
    try {
      String fileName = basename(imageFile.path);

      Reference storageReference =
          FirebaseStorage.instance.ref(reference).child(fileName);

      await storageReference.putFile(imageFile);
      return await storageReference.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future deleteImage(String url) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
    } catch (e) {
      rethrow;
    }
  }
}
