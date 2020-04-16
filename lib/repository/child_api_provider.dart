import 'package:babyindexmodule/model/body_request_child.dart';
import 'package:babyindexmodule/model/child_response.dart';
import 'package:babyindexmodule/util/logging_interceptor.dart';
import 'package:dio/dio.dart';

class ChildApiProvider {
  final String _endpoint = "/user/relative/list";
  Dio _dio;
  String token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJndXUudm4iLCJhdWQiOiI4NTgwNjA0MDgyODA2NTEzIiwic3ViIjoiNThlZjM3MTdkMjM5Y2YxNWIzNzUxOTUxIiwiZXhwIjoxNjAyNDg2NTYyfQ.hWPakFEOlGNxdxJFqc4VG-lkShuKXIZ6T7kXl0MOlS8";
  final String AUTHORIZATION = "Basic ODU4MDYwNDA4MjgwNjUxMzpkYndmZG44NXdrdndyNGdoZWp6a3E4OTNzM210N3J4dA==";

  ChildApiProvider() {
    BaseOptions options = BaseOptions(receiveTimeout: 5000, connectTimeout: 5000);
    options.baseUrl = "http://staging.auth.guu.vn";
    options.headers = {'Authorization': AUTHORIZATION};
    _dio = Dio(options);
    _dio.interceptors.add(LoggingInterceptor());
  }

  Future<ChildResponse> getChild() async {
    try {
      var childMap = BodyChild(token, "child").toJson();
      Response response = await _dio.post(_endpoint, data: childMap);
      return ChildResponse.fromJson(response.data);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
    }
  }

  String _handleError(Error error) {
    String errorDescription = "";
    if (error is DioError) {
      DioError dioError = error as DioError;
      switch (dioError.type) {
        case DioErrorType.CANCEL:
          errorDescription = "Request to API server was cancelled";
          break;
        case DioErrorType.CONNECT_TIMEOUT:
          errorDescription = "Connection timeout with API server";
          break;
        case DioErrorType.DEFAULT:
          errorDescription =
          "Connection to API server failed due to internet connection";
          break;
        case DioErrorType.RECEIVE_TIMEOUT:
          errorDescription = "Receive timeout in connection with API server";
          break;
        case DioErrorType.RESPONSE:
          errorDescription =
          "Received invalid status code: ${dioError.response.statusCode}";
          break;
        case DioErrorType.SEND_TIMEOUT:
          errorDescription = "Send timeout in connection with API server";
          break;
      }
    } else {
      errorDescription = "Unexpected error occured";
    }
    return errorDescription;
  }
}