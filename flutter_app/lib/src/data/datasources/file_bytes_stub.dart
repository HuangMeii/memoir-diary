/// Web fallback: a browser cannot read bytes from a filesystem path.
Future<List<int>> readFileBytes(String path) async {
  throw UnsupportedError(
    'Đọc file theo đường dẫn chỉ hỗ trợ trên mobile/desktop.',
  );
}
