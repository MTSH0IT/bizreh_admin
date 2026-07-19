import 'package:bizreh_admin/utils/storageService/storage_service.dart';
import 'package:bizreh_admin/utils/consts/const_key.dart';

abstract class ITokenProvider {
  String? getToken();
  Future<void> setToken(String? token);
  Future<void> clearToken();
}

class TokenProvider implements ITokenProvider {
  final StorageService _storageService;

  TokenProvider({required StorageService storageService})
    : _storageService = storageService;

  @override
  String? getToken() {
    return _storageService.getString(StorageKey.token);
  }

  @override
  Future<void> setToken(String? token) async {
    if (token != null && token.isNotEmpty) {
      await _storageService.setString(StorageKey.token, token);
    } else {
      await clearToken();
    }
  }

  @override
  Future<void> clearToken() async {
    await _storageService.remove(StorageKey.token);
  }
}
