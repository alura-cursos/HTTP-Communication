import 'dart:convert';
import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/model/transactions.dart';
import 'package:http/http.dart';

class TransactionsWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response =
        await client.get(baseUrl).timeout(Duration(seconds: 5));
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
    if(response.statusCode == 400){
      throw Exception('There was an Exceptional Error: You forgot the value');
    }
    if(response.statusCode == 401){
      throw Exception('There was an Exceptional Error: The password is wrong, try again');
    }
    return Transaction.fromJson(jsonDecode(response.body));
  }
}
