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
    Map<String, dynamic> transactionMap = _toMap(transaction);
    final String transactionJson  = jsonEncode(transactionMap);
    final Response response = await client.post(baseUrl, headers: {
      'password': '1000',
      'Content-type': 'application/json',
    },body: transactionJson);
    // we need to return something here: return transaction;
  }

  Map<String, dynamic> _toMap(Transaction transaction) {
    final Map<String,dynamic> transactionMap = {
      'value': transaction.value,
      'contact': {
        'name': transaction.contact.name,
        'accountNumber': transaction.contact.accountNumber
      }
    };
    return transactionMap;
  }
}