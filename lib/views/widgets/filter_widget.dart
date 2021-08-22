import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class WidgetFilters extends StatefulWidget {
  final List<Map<String, dynamic>> filters;
  final int defaultIndex;
  final void Function(int) onFilterSelected;

  final Color selectedBackgroundColor;
  final Color selectedBorderColor;
  final Color selectedTextColor;

  final Color unselectedBackgroundColor;
  final Color unselectedBorderColor;
  final Color unselectedTextColor;

  WidgetFilters({
    Key key,
    @required this.filters,
    this.defaultIndex: 0,
    this.onFilterSelected,
    this.selectedBackgroundColor: const Color(0xff4db9c2),
    this.selectedBorderColor: const Color(0xff4db9c2),
    this.selectedTextColor: Colors.white,
    this.unselectedBackgroundColor: const Color(0xffF4F4F4),
    this.unselectedBorderColor: const Color(0xffC4C4C4),
    this.unselectedTextColor: Colors.black,
  }) : super(key: key);

  @override
  _WidgetFiltersState createState() => _WidgetFiltersState();
}

class _WidgetFiltersState extends State<WidgetFilters> {
  int selectedIndex = 0;

  void selectItem(int index) {
    if (mounted) {
      setState(() {
        selectedIndex = index;
      });
    }
    if (widget.onFilterSelected != null) {
      widget.onFilterSelected(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...widget.filters.asMap().entries.map((entry) {
                  int id = entry.key;
                  dynamic item = entry.value;
                  bool selected = selectedIndex == id;
                  return Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 15, left: 10),
                    child: Container(
                        decoration: BoxDecoration(
                            color: selected ? widget.selectedBackgroundColor : widget.unselectedBackgroundColor,
                            borderRadius: BorderRadius.circular(15.0)),
                        child: OutlineButton(
                            child: Text(FlutterI18n.translate(context, item['label']),
                                style:
                                    TextStyle(color: selected ? widget.selectedTextColor : widget.unselectedTextColor)),
                            onPressed: () {
                              selectItem(id);
                            },
                            borderSide: BorderSide(
                                color: selected ? widget.selectedBorderColor : widget.unselectedBorderColor, width: 1),
                            color: Colors.white,
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)))),
                  );
                }),
              ],
            )));
  }
}
