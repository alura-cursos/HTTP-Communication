
import 'package:http/http.dart';

void findAll() async {
  final Response response = await get('http://192.168.0.6:8080/transactions');
  print(response.body);
}