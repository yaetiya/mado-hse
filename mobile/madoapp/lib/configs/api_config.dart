const isLocalApi = false;

class ApiConfig {
  static const String baseUrl = isLocalApi ? 'localhost:4731' : "mado.one";
  static Uri urlBuilder(String unencodedPath,
          [Map<String, dynamic>? queryParameters]) =>
      isLocalApi
          ? Uri.http(baseUrl, unencodedPath, queryParameters)
          : Uri.https(baseUrl, 'api/' + unencodedPath, queryParameters);
}
