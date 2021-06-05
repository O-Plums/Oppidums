import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  final String label;
  final String placeholder;
  final String defaultValue;
  final Function onChange;
  final bool border;
  final bool password;
  final TextInputType keyboardType;
  final int maxLines;
  final InputDecoration customDecoration;

  InputText(
      {Key key,
      this.label,
      this.placeholder,
      this.defaultValue,
      this.customDecoration,
      this.onChange,
      this.border = true,
      this.password = false,
      this.maxLines,
      this.keyboardType = TextInputType.text})
      : super(key: key);

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
        if (widget.label != null)
          (Text(widget.label,
              style: TextStyle(fontSize: 16, color: Colors.white))),
        TextField(
          onChanged: widget.onChange,
          controller: _controller,
          decoration: widget.customDecoration ?? InputDecoration(
            
            hintStyle: TextStyle(color: Colors.white),
            hintText: widget.placeholder,
            border: widget.border
                ? UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white))
                : InputBorder.none,
          ),
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          obscureText: widget.password,
          enableSuggestions: widget.password,
          autocorrect: widget.password,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
        )
      ],
    );
  }
}
