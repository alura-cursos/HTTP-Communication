import 'dart:convert';
import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/model/transactions.dart';
import 'package:http/http.dart';

class TransactionsWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(baseUrl);
    List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((dynamic element) {
      return Transaction.fromJson(element);
    }).toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    await Future.delayed(Duration(seconds: 10));
    final String transactionJson = jsonEncode(transaction.toJson());
    final Response response = await client.post(baseUrl,
        headers: {
          'password': password,
          'Content-type': 'application/json',
        },
        body: transactionJson);
    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    }
    throw HttpException(_getMessage(response.statusCode));
  }

  String _getMessage(int statusCode) {
    if(_statusCodeResponses.containsKey(statusCode)) {
      return _statusCodeResponses[statusCode];
    }
    return 'Unknown HTTP Error';
  }


  final Map<int, String> _statusCodeResponses = {
    400: 'You forgot the value',
    401: 'The password is wrong. Please try again',
    409: 'This Transaction already exists'
  };
}

class HttpException implements Exception {
  final String message;

  HttpException(this.message);
}
