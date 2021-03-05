import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final String label;
  final String placeholder;
  final String defaultValue;
  final Function onChange;
  final bool border;
  final bool password;
  final TextInputType keyboardType;

  InputText({Key key, this.label, this.placeholder, this.defaultValue, this.onChange, this.border = true, this.password = false, this.keyboardType = TextInputType.text}) : super(key: key);

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: widget.defaultValue);
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) (
            Text(widget.label, style: TextStyle(fontSize: 16))
        ),
        TextField(
          onChanged: widget.onChange,
          controller: _controller,
          decoration: InputDecoration(
              hintText: widget.placeholder,
              border: widget.border ? UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)) : InputBorder.none,
          ),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          obscureText: widget.password,
          enableSuggestions: widget.password,
          autocorrect: widget.password,
          keyboardType: widget.keyboardType,
        )
      ],
    );
  }
}
