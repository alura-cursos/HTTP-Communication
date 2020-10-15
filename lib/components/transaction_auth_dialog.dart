import 'package:flutter/material.dart';

class TransactionsAuthDialog extends StatefulWidget {
  final Function(String password) onConfirm;
  TransactionsAuthDialog({@required this.onConfirm});

  @override
  _TransactionsAuthDialogState createState() => _TransactionsAuthDialogState();
}

class _TransactionsAuthDialogState extends State<TransactionsAuthDialog> {
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Authenticate'),
      content: TextField(
        controller: _passwordController,
        obscureText: true,
        maxLength: 4,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
        style: TextStyle(fontSize: 64, letterSpacing: 32),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
      ),
      actions: [
        FlatButton(
          onPressed: () {
            print('It is totally Cancelled');
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        FlatButton(
          onPressed: () {
            widget.onConfirm(_passwordController.text);
            Navigator.pop(context);
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }
}
