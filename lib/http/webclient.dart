import 'dart:convert';

import 'package:bytebank/model/contact.dart';
import 'package:bytebank/model/transactions.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({RequestData data}) async {
    print('Request \n');
    print('URL: ${data.url}');
    print('Headers: ${data.headers}');
    print('Body: ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData data}) async {
    print('Response \n');
    print('Status Code: ${data.statusCode}');
    print('Headers: ${data.headers}');
    print('Body: ${data.body}');
    return data;
  }
}

Future<List<Transaction>> findAll() async {
  Client client =
      HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);
  final Response response =
      await client.get('http://192.168.0.6:8080/transactions');
  List<dynamic> decodedJson = jsonDecode(response.body);
  print('Decoded Json: $decodedJson');
  List<Transaction> transactions = List();
  for (Map<String, dynamic> element in decodedJson) {
    Map<String,dynamic> contactJson = element['contact'];
    final Transaction transaction = Transaction(
      element['value'],
      Contact(
        0,
        contactJson['name'],
        contactJson['accountNumber'],
      ),
    );
    transactions.add(transaction);
  }
  return transactions;
}
