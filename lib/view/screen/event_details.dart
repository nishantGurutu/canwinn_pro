/*import 'package:calendar_view/calendar_view.dart';
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
        //  initialDay: DateTime(2023),
          initialDay: widget.event.date,
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
}*/

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:task_management/constant/color_constant.dart';
import 'package:task_management/constant/text_constant.dart';
import 'package:task_management/model/callender_eventList_model.dart';

class EventDetails extends StatefulWidget {
  final String eventName;
  final RxList<CallenderEventData> eventList;
  final CalendarEventData<Object?> event;

  const EventDetails({
    super.key,
    required this.eventName,
    required this.eventList,
    required this.event,
  });

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late final EventController _eventController;

  @override
  void initState() {
    super.initState();

    _eventController = EventController();
    _eventController.addAll(
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
          title: event.eventName!,
          description: event.eventName ?? "",
          startTime: targetDate,
          endTime: targetDate.add(Duration(hours: 1)),
        );
      }).toList(),
    );
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  String formatTime(DateTime dt) {
    return DateFormat.Hm().format(dt); // "13:00"
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
        controller: _eventController,
        child: DayView(
          controller: _eventController,
          initialDay: widget.event.date,
          showVerticalLine: true,
          showLiveTimeLineInAllDays: false,
          minDay: DateTime(1990),
          maxDay: DateTime(2050),
          heightPerMinute: 1,
          eventArranger: SideEventArranger(maxWidth: double.infinity),
          onEventTap: (events, date) => print(events),
          onEventDoubleTap: (events, date) => print(events),
          onEventLongTap: (events, date) => print(events),
          onDateLongPress: (date) => print(date),
          startHour: 5,
          endHour: 23,
          dayTitleBuilder: (date) {
            return Text(
              '$date',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            );
          },
          eventTileBuilder: (date, events, boundry, start, end) {
            return Column(
              children: events.map((event) {
                return IntrinsicHeight(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            event.title ?? '',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Flexible(
                          child: Text(
                            '${formatTime(event.startTime!)} - ${formatTime(event.endTime!)}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
          fullDayEventBuilder: (events, date) {
            return Column(
              children: events.map((e) => Text(e.title.toString())).toList(),
            );
          },
          keepScrollOffset: true,
        ),
      ),
    );
  }
}
