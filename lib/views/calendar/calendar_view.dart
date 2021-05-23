import 'package:carcassonne/views/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:carcassonne/views/widgets/app_bar.dart';
import 'package:carcassonne/views/widgets/app_inkwell.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:carcassonne/views/widgets/auth_widget.dart';
import 'package:carcassonne/views/widgets/comment_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:carcassonne/views/widgets/loading_widget.dart';
import 'package:carcassonne/net/place_api.dart';
import 'package:provider/provider.dart';
import 'package:carcassonne/models/city_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:carcassonne/net/city_api.dart';


  

class CustomCalendarView extends StatefulWidget {
  final String id;
  final String placeId;

  CustomCalendarView({Key key, this.id, this.placeId}) : super(key: key);

  @override
  _CustomCalendarViewState createState() => _CustomCalendarViewState();
}

class _CustomCalendarViewState extends State<CustomCalendarView> {
  bool loading = false;
  List<dynamic> _events = null;



  List<Meeting> _getDataSource() {
    print(_events.length);
    final List<Meeting> meetings = _events.map((event) {
    
      final DateTime startTime = DateTime.parse(event['startDate']);
      final DateTime endTime = DateTime.parse(event['endDate']);
    
      return Meeting(
          event['title'], startTime, endTime, Color(int.parse(event['color'] ?? '0xFF960f1f')), false);
    }).toList();
    return meetings;
  }


  void fetchEvents(context) async {
    if (mounted) {
      setState(() {
        loading = true;
      });
    }
    var cityModel = Provider.of<CityModel>(context, listen: false);

    var event = await CarcassonneCityApi.getEventOfCitie(cityModel.id);
    if (mounted) {
      setState(() {
        _events = event;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    new Future.delayed(Duration.zero, () async {
      fetchEvents(context);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    if (loading == true) {
      return Scaffold(
          appBar: CustomAppBar(title: 'Calendar'), body: LoadingAnnimation());
    }

    return Scaffold(
        appBar: CustomAppBar(title: 'Calendar'),
        body: SfCalendar(
          view: CalendarView.month,
          monthViewSettings: MonthViewSettings(showAgenda: true),
          dataSource: MeetingDataSource(_getDataSource()),
        ));
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
