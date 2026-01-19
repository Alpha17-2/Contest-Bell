import 'dart:io';
import 'package:contest_bell/utils/endpoints.dart';
import 'package:dio/dio.dart';

/// HTTP Service class that handles all API requests for Codeforces API
class HttpService {
  static late Dio _dio;

  // Connection timeout in milliseconds (increased for better reliability)
  static const int connectTimeout = 60000; // 60 seconds
  static const int receiveTimeout = 60000; // 60 seconds
  static const int sendTimeout = 60000; // 60 seconds

  /// Initialize the HTTP service
  static Future<void> initialize() async {
    _dio = Dio();

    // Configure Dio options
    _dio.options = BaseOptions(
      baseUrl: BASEURL,
      connectTimeout: Duration(milliseconds: connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      sendTimeout: Duration(milliseconds: sendTimeout),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // Add interceptors for logging
    _dio.interceptors.add(_createInterceptor());
  }

  /// Create request/response interceptor
  static Interceptor _createInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('🚀 REQUEST: ${options.method} ${options.path}');
        print('📤 Headers: ${options.headers}');
        if (options.data != null) {
          print('📤 Data: ${options.data}');
        }

        handler.next(options);
      },
      onResponse: (response, handler) {
        print(
          '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}',
        );
        print('📥 Data: ${response.data}');
        handler.next(response);
      },
      onError: (error, handler) {
        print(
          '❌ ERROR: ${error.response?.statusCode} ${error.requestOptions.path}',
        );
        print('❌ Message: ${error.message}');

        handler.next(error);
      },
    );
  }

  /// GET request
  static Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// POST request
  static Future<Response> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PUT request
  static Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// PATCH request
  static Future<Response> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// DELETE request
  static Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Upload file
  static Future<Response> uploadFile(
    String endpoint,
    File file, {
    String fieldName = 'file',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(file.path, filename: fileName),
        ...?data,
      });

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Upload multiple files
  static Future<Response> uploadMultipleFiles(
    String endpoint,
    List<File> files, {
    String fieldName = 'files',
    Map<String, dynamic>? data,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      Map<String, dynamic> formDataMap = {};

      for (int i = 0; i < files.length; i++) {
        String fileName = files[i].path.split('/').last;
        formDataMap['${fieldName}[$i]'] = await MultipartFile.fromFile(
          files[i].path,
          filename: fileName,
        );
      }

      if (data != null) {
        formDataMap.addAll(data);
      }

      FormData formData = FormData.fromMap(formDataMap);

      final response = await _dio.post(
        endpoint,
        data: formData,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Download file
  static Future<Response> downloadFile(
    String endpoint,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.download(
        endpoint,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  /// Handle Dio errors
  static HttpException _handleDioError(DioException error) {
    String message;
    int statusCode = 0;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        message =
            'Connection timeout. The server took too long to respond. Please check your internet connection and try again.';
        break;
      case DioExceptionType.sendTimeout:
        message =
            'Send timeout. Please check your internet connection and try again.';
        break;
      case DioExceptionType.receiveTimeout:
        message =
            'Receive timeout. The server took too long to send data. Please try again.';
        break;
      case DioExceptionType.badResponse:
        statusCode = error.response?.statusCode ?? 0;
        message = _getErrorMessage(error.response?.data, statusCode);
        break;
      case DioExceptionType.cancel:
        message = 'Request was cancelled.';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection. Please check your network settings.';
        break;
      case DioExceptionType.unknown:
        message = 'An unexpected error occurred. Please try again.';
        break;
      default:
        message = 'Something went wrong. Please try again.';
    }

    return HttpException(message, statusCode);
  }

  /// Extract error message from response
  static String _getErrorMessage(dynamic data, int statusCode) {
    if (data is Map<String, dynamic>) {
      // Try common error message fields
      if (data.containsKey('message')) {
        return data['message'].toString();
      } else if (data.containsKey('error')) {
        return data['error'].toString();
      } else if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        } else if (errors is Map) {
          return errors.values.first.toString();
        }
      }
    }

    // Fallback to status code based messages
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Forbidden. You don\'t have permission to access this resource.';
      case 404:
        return 'Resource not found.';
      case 422:
        return 'Validation error. Please check your input.';
      case 500:
        return 'Internal server error. Please try again later.';
      case 502:
        return 'Bad gateway. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }

  /// Get Dio instance for advanced usage
  static Dio get dio => _dio;
}

/// Custom HTTP Exception
class HttpException implements Exception {
  final String message;
  final int statusCode;

  const HttpException(this.message, [this.statusCode = 0]);

  @override
  String toString() => 'HttpException: $message (Status: $statusCode)';
}
