import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/model/callender_eventList_model.dart';

class EventDetails extends StatefulWidget {
  final String eventName;
  final RxList<CallenderEventData> eventList;
  final CalendarEventData<Object?> event;
  const EventDetails(
      {super.key,
      required this.eventName,
      required this.eventList,
      required this.event});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String eventDate = '';
  String eventTitle = '';
  int eventYear = 0;

  @override
  void initState() {
    eventDate = widget.event.date.toString();
    eventTitle = widget.event.event.toString();
    print("init state event date value $eventDate");
    // List<>
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: SvgPicture.asset('assets/images/svg/back_arrow.svg'),
        ),
        title: Text(
          eventDetails,
          style: TextStyle(
            color: textColor,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: CalendarControllerProvider(
        controller: EventController()
          ..addAll(
            widget.eventList.map((event) {
              String dateInput = "${event.eventDate} ${event.eventTime}";
              List<String> splitDt = dateInput.split(" ");
              List<String> splitDt2 = splitDt.first.split('-');
              List<String> splitDt3 = splitDt[1].split(':');
              DateTime targetDate = DateTime(
                int.parse(splitDt2.last),
                int.parse(splitDt2[1]),
                int.parse(splitDt2.first),
                int.parse(splitDt3.first),
                int.parse(splitDt3.last),
                0,
              );
              return CalendarEventData<Object?>(
                date: targetDate,
                title: event.eventName ?? "",
                description: event.eventName ?? "",
              );
            }).toList(),
          ),
        child: DayView(
          controller: EventController(
            eventFilter: (date, events) {
              return events;
            },
          ),
          eventTileBuilder: (date, events, boundry, start, end) {
            // Return your widget to display as event tile.
            return Container(
              child: Text('$date'),
            );
          },
          fullDayEventBuilder: (events, date) {
            // Return your widget to display full day event view.
            return Container(
              child: Text('$date'),
            );
          },
          showVerticalLine: true, // To display live time line in day view.

          showLiveTimeLineInAllDays:
              false, // To display live time line in all pages in day view.
          minDay: DateTime(1990),
          maxDay: DateTime(2050),
          initialDay: DateTime(2019),
          heightPerMinute: 1, // height occupied by 1 minute time span.
          eventArranger: SideEventArranger(
              maxWidth: double
                  .infinity), // To define how simultaneous events will be arranged.
          onEventTap: (events, date) => print(events),
          onEventDoubleTap: (events, date) => print(events),
          onEventLongTap: (events, date) => print(events),
          onDateLongPress: (date) => print(date),
          startHour: 5,
          // endHour:20, // To set the end hour displayed
          // hourLinePainter: (lineColor, lineHeight, offset, minuteHeight, showVerticalLine, verticalLineOffset) {
          //     return //Your custom painter.
          // },
          dayTitleBuilder: (date) {
            return Text('$date');
          }, // To Hide day header

          keepScrollOffset:
              true, // To maintain scroll offset when the page changes
        ),

        // MonthView(
        // onEventTap: (event, date) {
        //   Get.to(() => EventDetails(eventName: event.title));
        // },
        // onCellTap: (events, date) {
        //   String formattedDate = DateFormat('dd-MM-yyyy').format(date);
        //   eventDateController.text = formattedDate.toString();
        //   showAlertDialog(context);
        // },
        // ),
      ),
    );
  }
}
