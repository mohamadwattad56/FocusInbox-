class FiBackendConfig {
  static final FiBackendConfig _instance = FiBackendConfig._internal();

  FiBackendConfig._internal();

  factory FiBackendConfig() {
    return _instance;
  }

  final stage = "82.81.45.49" ;

  final dev = "127.0.0.1" ;///84.228.159.31

  String get host {
    return dev ;
  }

  final port = 5000 ;///7882

  final scheme = "http" ;

  final Duration timeout = const Duration(seconds: 20) ;

}

FiBackendConfig backendConfig = FiBackendConfig();