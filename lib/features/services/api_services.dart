import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:health_action_plan/features/services/navigation_services.dart';
import 'package:health_action_plan/features/services/shared_preferences.dart';

/// Enum to define the HTTP methods supported by [ApiService].
enum ApiMethod { get, post, delete, update, patch }

/// A service class to handle API requests using [Dio].
class ApiService {
  static Map errorResponse = {};
  static Dio dio = Dio();

  /// Initializes [Dio] with authentication headers.
  ///
  /// [token] and [refreshToken] are required for setting up the headers.
  static Future<void> dioInitializerAndSetter({
    required String token,
    required String refreshToken,
  }) async {
    if (token.length > 5) {
      final pref = await SharedPreferencesService.prefs;
      await pref.setString("token", token);
      await pref.setString("refresh", refreshToken);
    }
  }

  /// Removes the saved token from shared preferences and [Dio] headers.
  ///
  /// This should be called when logging out or when the token expires.
  static Future<void> tokenRemover() async {
    var prefs = await SharedPreferencesService.prefs;

    prefs.remove('token');
    dio.options.headers["Authorization"] = "";
    log("Token removed");
  }

  /// Sets up and executes an API request using [Dio].
  ///
  /// [method] specifies the HTTP method to use.
  /// [url] is the endpoint for the request.
  /// [data] and [queryParameters] are optional parameters for the request.
  /// [onSendProgress] and [onReceiveProgress] are optional callbacks for progress reporting.
  /// [options] provides additional [Dio] options.
  /// [dbPtr] and [bUrl] provide additional headers and base URL respectively.
  ///
  /// Returns the [Response] of the request or `null` if an error occurs.
  static Future<Response<dynamic>?> apiMethodSetup({
    required ApiMethod method,
    required String url,
    var data,
    var queryParameters,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
    Options? options,
    String? dbPtr,
    String? bUrl,
  }) async {
    final pref = await SharedPreferencesService.prefs;

    String? baseURL = pref.getString('url');
    String dbptr = pref.getString('dbptr') ?? "";

    final finalBaseUrl = bUrl ?? baseURL;
    if (finalBaseUrl == null) {
      log(
        "API ERROR: Base URL is null. Ensure it is passed to the Launcher or saved in SharedPreferences.",
      );
      return null;
    }

    dio.options.baseUrl = finalBaseUrl;
    dio.options.connectTimeout = const Duration(seconds: 120);
    dio.options.receiveTimeout = const Duration(seconds: 120);
    dio.options.headers["db_ptr"] = dbPtr ?? dbptr;

    // Pass the user's NuraId (real_id) supplied by the host as the `realId`
    // header so the backend can attribute every request to the user.
    final realId = pref.getString("realId") ?? "";
    if (realId.isNotEmpty) {
      dio.options.headers["realId"] = realId;
    }
    log('Outgoing realId request header: "$realId"');

    if (!dio.interceptors.any((e) => e is TokenInterceptor)) {
      dio.interceptors.add(TokenInterceptor(dio));
    }

    if (options != null && options.headers?["Authorization"] != null) {
      dio.options.headers["Authorization"] = options.headers?["Authorization"];
    }
    log('Url: $baseURL');
    log(dio.options.headers.toString());

    if (!dio.interceptors.any((e) => e is LogInterceptor)) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          requestHeader: true,
          responseBody: true,
          responseHeader: true,
        ),
      );
    }

    try {
      Response? response;
      switch (method) {
        case ApiMethod.get:
          log('Headers: $data');
          response = data != null
              ? await dio.get(
                  url,
                  queryParameters: data,
                  options:
                      options ??
                      Options(receiveTimeout: const Duration(minutes: 2)),
                )
              : await dio.get(
                  url,
                  options:
                      options ??
                      Options(receiveTimeout: const Duration(minutes: 2)),
                );
          break;
        case ApiMethod.post:
          response = await dio.post(
            url,
            data: data,
            queryParameters: queryParameters,
            options:
                options ?? Options(receiveTimeout: const Duration(minutes: 2)),
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;

        case ApiMethod.delete:
          response = await dio.delete(url);
          break;
        case ApiMethod.update:
          response = await dio.put(
            url,
            data: data,
            queryParameters: queryParameters,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case ApiMethod.patch:
          response = await dio.patch(
            url,
            data: data,
            queryParameters: queryParameters,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;
      }
      return response;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      final errorInfo = {
        "url": url,
        "method": method.name,
        "statusCode": statusCode,
        "message": e.message,
        "responseData": responseData.toString(),
      };

      log("API ERROR: $errorInfo");

      if (statusCode == 500) {
        log("Server error (500)");
      } else if (e.type == DioExceptionType.receiveTimeout) {
        showSnackBar(scaffoldMessengerKey.currentContext!, 'Receive Timeout');
      } else if (e.type == DioExceptionType.connectionTimeout) {
        showSnackBar(
          scaffoldMessengerKey.currentContext!,
          'Connection Timeout',
        );
      } else if (e.error is SocketException) {
        errorResponse["status"] = "101";
        errorResponse["message"] = "Internet error";
        log(errorResponse.toString());
      } else {
        log("Unknown API error");
      }
    }
    return null;
  }
}

class TokenInterceptor extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  TokenInterceptor(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    /// Skip auth logic for login/refresh APIs
    if (options.extra["skipAuth"] == true) {
      return handler.next(options);
    }

    final pref = await SharedPreferencesService.prefs;
    final token = pref.getString('token');
    final guestToken = pref.getString('NotLoggedInToken');

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    } else if (guestToken != null && guestToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $guestToken';
    }

    options.headers['Content-Type'] = 'application/json';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.extra["skipAuth"] == true) {
      return handler.next(err);
    }

    return super.onError(err, handler);
  }

  Future<void> _retryWithNewToken(
    DioException err,
    ErrorInterceptorHandler handler,
    String token,
  ) async {
    try {
      final requestOptions = err.requestOptions;

      final retryResponse = await dio.request(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: Options(
          method: requestOptions.method,
          headers: {
            ...requestOptions.headers,
            "Authorization": "Bearer $token",
          },
          extra: requestOptions.extra,
        ),
      );
      return handler.resolve(retryResponse);
    } catch (e) {
      log("Unknown API error: $e");
    }
    return handler.next(err);
  }
}

Timer? _throttle;

void throttledCall(
  Function fn, {
  Duration duration = const Duration(seconds: 1),
}) {
  if (_throttle?.isActive ?? false) return;
  _throttle = Timer(duration, () {});
  fn();
}
