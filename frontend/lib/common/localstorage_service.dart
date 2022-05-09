import 'package:localstorage/localstorage.dart';

class LocalstorageService {
  LocalstorageService._privateConstructor();
  static final LocalstorageService _instance = LocalstorageService._privateConstructor();
  factory LocalstorageService() {
    return _instance;
  }

  LocalStorage? _localstorage;

  void init(storageName) {
    _localstorage = new LocalStorage('${storageName}.json');
  }

  get localstorage => _localstorage;

  dynamic getItem(String key) {
    return _localstorage?.getItem(key);
  }

  void deleteItem(String key) {
    _localstorage?.deleteItem(key);
  }

  void setItem(String key, String value) {
    _localstorage?.setItem(key, value);
  }
}