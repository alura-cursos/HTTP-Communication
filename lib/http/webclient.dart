import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'inteceptors/logging_interceptor.dart';



final Client client =
    HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);
final String baseUrl = 'http://192.168.0.35:8080/transactions';


