import 'package:bizreh_admin/features/auth/models/user_model.dart';
import 'package:bizreh_admin/utils/storageService/storage_service.dart';
import 'package:bizreh_admin/utils/consts/const_key.dart';

Future<UserModel> getUser() async {
  Map<String, dynamic>? jasonUser = StorageService().getJson(StorageKey.user);
  if (jasonUser == null) {
    throw Exception('User not found');
  }
  final user = UserModel.fromJson(jasonUser);
  return user;
}
