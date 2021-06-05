import 'package:flutter/material.dart';
import 'package:oppidum/views/widgets/app_bar.dart';
import 'package:oppidum/views/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:oppidum/models/city_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:oppidum/net/city_api.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

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

    var event = await OppidumCityApi.getEventOfCitie(cityModel.id);
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
          backgroundColor: Color(0xff101519),

          appBar: CustomAppBar(title: FlutterI18n.translate(context, "common.calendar.titleCalendar")), body: LoadingAnnimation());
    }

    return Scaffold(
          backgroundColor: Color(0xff101519),

        appBar: CustomAppBar(title: FlutterI18n.translate(context, "common.calendar.titleCalendar")),
        body:  SfCalendar(
          backgroundColor: Color(0xff101519),
         

          headerStyle: CalendarHeaderStyle(
          backgroundColor: Color(0xff101519),
          textStyle: TextStyle(color: Colors.white)
          ),
          viewHeaderStyle: ViewHeaderStyle(
          backgroundColor: Color(0xff101519),
                 dayTextStyle: TextStyle(color: Colors.white),
           dateTextStyle: TextStyle(color: Colors.white),
          ),
          todayTextStyle: TextStyle(color: Colors.white),
          todayHighlightColor: Color(0xfff6ac65),
          view: CalendarView.month,
          // monthViewSettings: MonthViewSettings(showAgenda: true),
          dataSource: MeetingDataSource(_getDataSource()),
  monthViewSettings: MonthViewSettings(
           dayFormat: 'EEE',
           numberOfWeeksInView: 4,
           appointmentDisplayCount: 2,
           showAgenda: true,
           monthCellStyle: MonthCellStyle(textStyle: TextStyle( color: Colors.white),
               trailingDatesTextStyle: TextStyle(
                   color: Colors.white),
               leadingDatesTextStyle: TextStyle(
                   color: Colors.white),
               ),
                agendaStyle: AgendaStyle(
             backgroundColor: Colors.transparent,
            appointmentTextStyle: TextStyle(color: Colors.white),
             dayTextStyle: TextStyle(color: Colors.white),
             dateTextStyle: TextStyle(color: Colors.white)
        ),
               ),
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
