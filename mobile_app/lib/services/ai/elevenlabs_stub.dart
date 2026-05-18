/// Stub for dart:io File when running on Web
class File {
  final String path;
  File(this.path);

  Future<bool> exists() async => false;
  Future<void> delete() async {}
  Future<void> writeAsBytes(List<int> bytes) async {}
}

/// Stub for Directory
class Directory {
  final String path;
  Directory(this.path);
}

/// Stub for getApplicationDocumentsDirectory
Future<dynamic> getApplicationDocumentsDirectory() async => null;
