import 'package:flutter/material.dart';

class TextInputWidget extends StatefulWidget {
  final Function(String) callback;

  const TextInputWidget(this.callback, {Key? key}) : super(key: key);

  @override
  _TextInputWidgetState createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void click() {
    FocusScope.of(context).unfocus();
    widget.callback(controller.text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: const Icon(Icons.message),
            labelText: "Type a message:",
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              splashColor: Colors.blueAccent,
              tooltip: "Post message",
              onPressed: click,
            )));
  }
}
