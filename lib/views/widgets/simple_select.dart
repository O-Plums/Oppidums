import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';

class SimpleSelect extends StatefulWidget {
  final String title;
  final String label;
  final Widget valueIcon;
  final List<S2Choice<String>> list;
  final String defaultValue;
  final Function onChange;

  SimpleSelect(
      {Key key,
      this.label,
      this.valueIcon,
      this.title,
      this.list,
      this.defaultValue,
      this.onChange})
      : super(key: key);

  @override
  _SimpleSelectState createState() => _SimpleSelectState();
}

class _SimpleSelectState extends State<SimpleSelect> {
  String _value;

  void _handleChange(state) {
    if (mounted) {
      setState(() {
        _value = state.value;
        widget.onChange(state.value);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _value = widget.defaultValue;
  }

  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          (Text(widget.label, style: TextStyle(fontSize: 16, color: Colors.white))),
        SmartSelect.single(
            tileBuilder: (context, state) {
              return InkWell(
                onTap: state.showModal,
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Row(
                    children: [
                      widget.valueIcon != null ? widget.valueIcon : Container(),
                      Text(state.valueDisplay,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))
                    ],
                  ),
                ),
              );
            },
            modalType: S2ModalType.bottomSheet,
            title: widget.title,
            value: _value,
            choiceItems: widget.list,
            onChange: _handleChange)
      ],
    );
  }
}
