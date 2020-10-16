import 'dart:convert';
import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/model/transactions.dart';
import 'package:http/http.dart';

class TransactionsWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(baseUrl);
    List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((dynamic element) {
      return Transaction.fromJson(element);
    }).toList();
  }

  Future<Transaction> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());
    final Response response = await client.post(baseUrl,
        headers: {
          'password': password,
          'Content-type': 'application/json',
        },
        body: transactionJson);
    if(response.statusCode == 200){
      return Transaction.fromJson(jsonDecode(response.body));
    }
    throw HttpException(_statusCodeResponses[response.statusCode]);
  }
  final Map<int,String> _statusCodeResponses = {
    400 : 'You forgot the value',
    401 : 'The password is wrong. Please try again'
};

}

class HttpException implements Exception{
  final String message;

  HttpException(this.message);
}