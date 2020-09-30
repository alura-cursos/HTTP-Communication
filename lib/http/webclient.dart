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

Client client =
    HttpClientWithInterceptor.build(interceptors: [LoggingInterceptor()]);
final String baseUrl = 'http://192.168.0.6:8080/transactions';

Future<List<Transaction>> findAll() async {
  final Response response =
      await client.get(baseUrl).timeout(Duration(seconds: 5));
  List<dynamic> decodedJson = jsonDecode(response.body);
  print('Decoded Json: $decodedJson');
  List<Transaction> transactions = List();
  for (Map<String, dynamic> element in decodedJson) {
    Map<String, dynamic> contactJson = element['contact'];
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

Future<Transaction> save(Transaction transaction) async {
  final Map<String,dynamic> transactionMap = {
    'value': transaction.value,
    'contact': {
      'name': transaction.contact.name,
      'accountNumber': transaction.contact.accountNumber
    }
  };
    final String transactionJson  = jsonEncode(transactionMap);
  final Response response = await client.post(baseUrl, headers: {
    'password': '1000',
    'Content-type': 'application/json',
  },body: transactionJson);
  return transaction;
}
