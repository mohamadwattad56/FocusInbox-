import 'package:image_picker/image_picker.dart';

class CxMediaUtils {

  static Future<XFile?> loadGalleryImage() async {
    ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

}