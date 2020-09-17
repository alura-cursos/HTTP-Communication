import 'package:bytebank/model/contact.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bytebank/database/app_database.dart';
class ContactDao{

  static const String tableSql ='CREATE TABLE $_tableName('
      'id INTEGER PRIMARY KEY, '
      'name TEXT, '
      'account_number INTEGER)';
  static const String _tableName = 'contacts';
  static const String _name = 'name';
  static const String _id = 'id';
  static const String _accountNumber = 'account_number';

  Future<int> save(Contact contact) async{
    final Database db = await getDatabase();
    return _toMap(contact, db);
  }

  Future<int> _toMap(Contact contact, Database db) {
    final Map<String, dynamic> contactsMap = Map();
    contactsMap[_name] = contact.name;
    contactsMap[_accountNumber] = contact.accountNumber;
    return db.insert(_tableName, contactsMap);
  }
  Future<List<Contact>> findAll() async{
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    return _toList(result);
  }

  List<Contact> _toList(List<Map<String, dynamic>> result) {
    final List<Contact> contacts = List();
    for(Map<String, dynamic> row in result){
      final Contact contact = Contact(
          row[_id],
          row[_name],
          row[_accountNumber]
      );
      contacts.add(contact);
    }
    return contacts;
  }
}