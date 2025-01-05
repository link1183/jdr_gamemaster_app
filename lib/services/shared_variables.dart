class SharedVariables {
  static final SharedVariables _instance = SharedVariables._internal();
  factory SharedVariables() => _instance;
  SharedVariables._internal();

  String appFolderName = 'JDR Gamemaster App';
}
