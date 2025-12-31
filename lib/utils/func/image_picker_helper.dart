import 'package:image_picker/image_picker.dart';

Future<void> pickImageAndSetPath({
  required void Function(String path) onPathSelected,
  int? imageQuality,
}) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: imageQuality,
  );

  if (pickedFile != null) {
    onPathSelected(pickedFile.path);
  }
}
