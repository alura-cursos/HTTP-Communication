import 'dart:convert';

import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/model/contact.dart';
import 'package:bytebank/model/transactions.dart';
import 'package:http/http.dart';

class TransactionsWebClient{
  Future<List<Transaction>> findAll() async {
    final Response response =
    await client.get(baseUrl).timeout(Duration(seconds: 5));
    List<Transaction> transactions = _toTransactions(response);
    return transactions;
  }

  List<Transaction> _toTransactions(Response response) {
    List<dynamic> decodedJson = jsonDecode(response.body);
    print('Decoded Json: $decodedJson');
    List<Transaction> transactions = List();
    for (Map<String, dynamic> transactionJson in decodedJson) {
      transactions.add(Transaction.fromJson(transactionJson));
    }
    return transactions;
  }

  Future<Transaction> save(Transaction transaction) async {

    final String transactionJson  = jsonEncode(transaction.toJson());
    final Response response = await client.post(baseUrl, headers: {
      'password': '1000',
      'Content-type': 'application/json',
    },body: transactionJson);
    return transaction;
  }
}