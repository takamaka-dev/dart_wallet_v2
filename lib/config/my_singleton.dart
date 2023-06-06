class MySingleton {
  static final MySingleton _instance = MySingleton._privateConstructor();

  MySingleton._privateConstructor();

  static MySingleton get instance => _instance;
}
