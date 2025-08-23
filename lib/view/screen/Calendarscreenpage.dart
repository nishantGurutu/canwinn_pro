import 'package:flutter/material.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Calendarscreenpage extends StatefulWidget {
  final String taskType;
  final String assignedType;
  final String? navigationType;
  final String? userId;

  const Calendarscreenpage(
      this.navigationType,
      this.userId, {
        super.key,
        required this.taskType,
        required this.assignedType,
      });

  @override
  State<Calendarscreenpage> createState() => _CalendarscreenpageState();
}

class _CalendarscreenpageState extends State<Calendarscreenpage> {
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  late tz.Location _india;

  bool _loading = true;
  List<Event> _events = [];
  double _zoomLevel = 1.0; // Default zoom level

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _india = tz.getLocation('Asia/Kolkata');
    _fetchTodayEvents();
  }

  Future<void> _deleteEvent(Event event) async {
    try {
      if (event.eventId == null || event.calendarId == null) {
        Fluttertoast.showToast(msg: "Cannot delete event: Missing event or calendar ID");
        debugPrint("Delete failed: eventId=${event.eventId}, calendarId=${event.calendarId}");
        return;
      }

      // Show confirmation dialog
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Delete Event"),
          content: Text("Are you sure you want to delete '${event.title ?? "Untitled Event"}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text("OK"),
            ),
          ],
        ),
      );

      if (shouldDelete != true) return;

      // Delete event from device calendar
      final result = await _deviceCalendarPlugin.deleteEvent(event.calendarId!, event.eventId!);
      if (result.isSuccess) {
        setState(() {
          _events.removeWhere((e) => e.eventId == event.eventId);
        });
        Fluttertoast.showToast(msg: "Event deleted successfully");
      } else {
        final errorMessage = result.errors?.isNotEmpty == true
            ? result.errors!.map((e) => e.errorMessage ?? "Unknown error").join(', ')
            : "Unknown error";
        Fluttertoast.showToast(msg: "Failed to delete event: $errorMessage");
        debugPrint("Delete failed: calendarId=${event.calendarId}, eventId=${event.eventId}, errors=$errorMessage");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error deleting event: $e", toastLength: Toast.LENGTH_LONG);
      debugPrint("Exception in deleteEvent: $e");
    }
  }

  Future<void> _updateEvent(Event event) async {
    try {
      if (event.eventId == null || event.calendarId == null) {
        Fluttertoast.showToast(msg: "Cannot update event: Missing event or calendar ID");
        debugPrint("Update failed: eventId=${event.eventId}, calendarId=${event.calendarId}");
        return;
      }

      // Check calendar permissions
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (!permissionsGranted.isSuccess) {
        Fluttertoast.showToast(msg: "Failed to check calendar permissions");
        debugPrint("Update failed: Permission check failed, errors=${permissionsGranted.errors}");
        return;
      }
      if (!permissionsGranted.data!) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
          Fluttertoast.showToast(msg: "Calendar permission denied. Please enable in device settings.");
          debugPrint("Update failed: Calendar permission denied");
          return;
        }
      }

      // Retrieve the original event from the calendar
      final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
        event.calendarId!,
        RetrieveEventsParams(eventIds: [event.eventId!]),
      );

      if (eventsResult?.data?.isEmpty ?? true) {
        Fluttertoast.showToast(msg: "Event not found. It may have been deleted.");
        debugPrint("Update failed: Event ID ${event.eventId} not found in calendar ${event.calendarId}");
        return;
      }

      final originalEvent = eventsResult!.data!.first;

      // Show update dialog
      await showDialog(
        context: context,
        builder: (ctx) {
          DateTime selectedDate = originalEvent.start!;
          TimeOfDay startTime = TimeOfDay(hour: originalEvent.start!.hour, minute: originalEvent.start!.minute);
          TimeOfDay endTime = TimeOfDay(hour: originalEvent.end!.hour, minute: originalEvent.end!.minute);
          TextEditingController titleCtrl = TextEditingController(text: originalEvent.title ?? "");

          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text("Update Event"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(labelText: "Event Title"),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text("Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}"),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (pickedDate != null) setDialogState(() => selectedDate = pickedDate);
                      },
                    ),
                    ListTile(
                      title: Text("Start Time: ${startTime.format(context)}"),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (pickedTime != null) setDialogState(() => startTime = pickedTime);
                      },
                    ),
                    ListTile(
                      title: Text("End Time: ${endTime.format(context)}"),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (pickedTime != null) setDialogState(() => endTime = pickedTime);
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (titleCtrl.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter title");
                        return;
                      }

                      final location = tz.getLocation('Asia/Kolkata');
                      final startDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        startTime.hour,
                        startTime.minute,
                      );
                      final endDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        endTime.hour,
                        endTime.minute,
                      );

                      if (endDateTime.isBefore(startDateTime) || endDateTime.isAtSameMomentAs(startDateTime)) {
                        Fluttertoast.showToast(msg: "End time must be after start time");
                        return;
                      }

                      // Update the original event safely
                      originalEvent.title = titleCtrl.text;
                      originalEvent.start = tz.TZDateTime.from(startDateTime, location);
                      originalEvent.end = tz.TZDateTime.from(endDateTime, location);
                      originalEvent.allDay = originalEvent.allDay ?? false;
                      originalEvent.description = originalEvent.description ?? "";
                      originalEvent.location = originalEvent.location ?? "";

                      try {
                        final result = await _deviceCalendarPlugin.createOrUpdateEvent(originalEvent);

                        if (result != null && result.isSuccess && result.data != null) {
                          debugPrint("Event updated successfully: eventId=${result.data}");
                          Navigator.pop(ctx);
                          Fluttertoast.showToast(msg: "Event updated successfully");
                          await _fetchTodayEvents();
                        } else {
                          final errorMessage = result?.errors?.isNotEmpty == true
                              ? result!.errors!.map((e) => e.errorMessage ?? "Unknown error").join(', ')
                              : "Unknown error while updating event";
                          Fluttertoast.showToast(msg: "Failed to update event: $errorMessage", toastLength: Toast.LENGTH_LONG);
                          debugPrint("Update failed: calendarId=${event.calendarId}, eventId=${event.eventId}, errors=$errorMessage");
                        }
                      } catch (e) {
                        Fluttertoast.showToast(msg: "Failed to update event: $e", toastLength: Toast.LENGTH_LONG);
                        debugPrint("Exception in updateEvent: $e");
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating event: $e", toastLength: Toast.LENGTH_LONG);
      debugPrint("Exception in updateEvent: $e");
    }
  }


  Future<void> _fetchTodayEvents() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (!permissionsGranted.isSuccess) {
        Fluttertoast.showToast(msg: "Failed to check calendar permissions");
        debugPrint("Fetch events failed: Permission check failed, errors=${permissionsGranted.errors}");
        setState(() => _loading = false);
        return;
      }
      if (!permissionsGranted.data!) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
          Fluttertoast.showToast(msg: "Calendar permission denied. Please enable in device settings.");
          debugPrint("Fetch events failed: Calendar permission denied");
          setState(() => _loading = false);
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      if (!calendarsResult.isSuccess) {
        Fluttertoast.showToast(msg: "Failed to retrieve calendars");
        debugPrint("Fetch events failed: Calendar retrieval failed, errors=${calendarsResult.errors}");
        setState(() => _loading = false);
        return;
      }

      final List<Calendar> calendars =
          calendarsResult.data?.cast<Calendar>().where((cal) => !(cal.isReadOnly ?? true)).toList() ?? [];

      if (calendars.isEmpty) {
        Fluttertoast.showToast(msg: "No writable calendars found");
        debugPrint("Fetch events failed: No writable calendars found");
        setState(() => _loading = false);
        return;
      }

      debugPrint("Available calendars: ${calendars.map((c) => 'id=${c.id}, name=${c.name}, account=${c.accountName}').join('; ')}");

      final now = tz.TZDateTime.now(_india);
      final todayStart = tz.TZDateTime(_india, now.year, now.month, now.day, 0, 0, 0);
      final todayEnd = tz.TZDateTime(_india, now.year, now.month, now.day, 23, 59, 59);

      List<Event> fetchedEvents = [];

      for (var cal in calendars) {
        final eventsResult = await _deviceCalendarPlugin.retrieveEvents(
          cal.id!,
          RetrieveEventsParams(
            startDate: todayStart.toUtc(),
            endDate: todayEnd.toUtc(),
          ),
        );

        final events = eventsResult?.data ?? [];
        for (var event in events) {
          event.calendarId = cal.id;
          if (event.start != null) {
            event.start = tz.TZDateTime.from(event.start!, _india);
          }
          if (event.end != null) {
            event.end = tz.TZDateTime.from(event.end!, _india);
          }
          debugPrint(
              "Fetched event: title=${event.title}, eventId=${event.eventId}, calendarId=${event.calendarId}, calendarName=${cal.name}, allDay=${event.allDay}");
          fetchedEvents.add(event);
        }
      }

      final uniqueEvents = <String, Event>{};
      for (var e in fetchedEvents) {
        if (e.title != null && e.start != null && e.eventId != null) {
          final startTime = tz.TZDateTime(_india, e.start!.year, e.start!.month, e.start!.day, e.start!.hour, e.start!.minute);
          final key = "${e.title}_${DateFormat('yyyy-MM-dd HH:mm').format(startTime)}";
          uniqueEvents[key] = e;
        }
      }

      setState(() {
        _events = uniqueEvents.values.toList();
        _loading = false;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Error fetching events: $e", toastLength: Toast.LENGTH_LONG);
      debugPrint("Exception in fetchTodayEvents: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _addEvent() async {
    try {
      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      if (!calendarsResult.isSuccess) {
        Fluttertoast.showToast(msg: "Failed to retrieve calendars");
        debugPrint("Add event failed: Calendar retrieval failed, errors=${calendarsResult.errors}");
        return;
      }

      final List<Calendar> calendars =
          calendarsResult.data?.cast<Calendar>().where((cal) => !(cal.isReadOnly ?? true)).toList() ?? [];

      if (calendars.isEmpty) {
        Fluttertoast.showToast(msg: "No writable calendars found");
        debugPrint("Add event failed: No writable calendars found");
        return;
      }

      final cal = calendars.first;
      final now = DateTime.now();
      DateTime selectedDate = now;
      TimeOfDay startTime = TimeOfDay.fromDateTime(now.add(const Duration(minutes: 5)));
      TimeOfDay endTime = TimeOfDay.fromDateTime(now.add(const Duration(hours: 1)));

      TextEditingController titleCtrl = TextEditingController();

      await showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text("New Event"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(labelText: "Event Title"),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text("Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}"),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (pickedDate != null) {
                          setDialogState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text("Start Time: ${startTime.format(context)}"),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: startTime,
                        );
                        if (pickedTime != null) {
                          setDialogState(() {
                            startTime = pickedTime;
                          });
                        }
                      },
                    ),
                    ListTile(
                      title: Text("End Time: ${endTime.format(context)}"),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: endTime,
                        );
                        if (pickedTime != null) {
                          setDialogState(() {
                            endTime = pickedTime;
                          });
                        }
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (titleCtrl.text.isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter title");
                        return;
                      }

                      final location = tz.getLocation('Asia/Kolkata');
                      final startDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        startTime.hour,
                        startTime.minute,
                      );
                      final endDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        endTime.hour,
                        endTime.minute,
                      );

                      if (endDateTime.isBefore(startDateTime) || endDateTime.isAtSameMomentAs(startDateTime)) {
                        Fluttertoast.showToast(msg: "End time must be after start time");
                        return;
                      }

                      final newEvent = Event(
                        cal.id,
                        title: titleCtrl.text,
                        start: tz.TZDateTime.from(startDateTime, location),
                        end: tz.TZDateTime.from(endDateTime, location),
                        allDay: false, // Explicitly set to false
                      );

                      debugPrint(
                        "Attempting to add event: "
                            "title=${newEvent.title}, "
                            "calendarId=${cal.id}, "
                            "calendarName=${cal.name}, "
                            "accountName=${cal.accountName}, "
                            "start=${newEvent.start}, "
                            "end=${newEvent.end}, "
                            "allDay=${newEvent.allDay}",
                      );

                      try {
                        final result = await _deviceCalendarPlugin.createOrUpdateEvent(newEvent);
                        debugPrint("Add result: isSuccess=${result?.isSuccess}, data=${result?.data}, errors=${result?.errors}");

                        if (result != null && result.isSuccess && result.data != null) {
                          debugPrint("Event added successfully: eventId=${result.data}");
                          Navigator.pop(ctx);
                          Fluttertoast.showToast(msg: "Event Added!");
                          await _fetchTodayEvents();
                        } else {
                          final errorMessage = result?.errors?.isNotEmpty == true
                              ? result!.errors!.map((e) => e.errorMessage ?? "Unknown platform error").join(', ')
                              : "Device calendar plugin ran into an issue. Please check calendar sync settings.";
                          Fluttertoast.showToast(
                              msg: "Failed to add event: $errorMessage",
                              toastLength: Toast.LENGTH_LONG);
                          debugPrint("Add event failed: calendarId=${cal.id}, errors=$errorMessage");
                        }
                      } catch (e) {
                        Fluttertoast.showToast(
                            msg: "Failed to add event: Platform error - $e",
                            toastLength: Toast.LENGTH_LONG);
                        debugPrint("Platform exception in addEvent: $e");
                      }
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      Fluttertoast.showToast(msg: "Error adding event: $e", toastLength: Toast.LENGTH_LONG);
      debugPrint("Exception in addEvent: $e");
    }
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel + 0.1).clamp(0.5, 2.0); // Increase zoom, limit to 2.0
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel - 0.1).clamp(0.5, 2.0); // Decrease zoom, limit to 0.5
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "📅 ${DateFormat('EEEE, d MMMM yyyy').format(tz.TZDateTime.now(_india))}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _events.isEmpty
          ? const Center(child: Text("No events for today", style: TextStyle(fontSize: 16, color: Colors.grey)))
          : GestureDetector(
        onScaleUpdate: (details) {
          setState(() {
            _zoomLevel = (_zoomLevel * details.scale).clamp(0.5, 2.0); // Pinch to zoom
          });
        },
        child: Transform.scale(
          scale: _zoomLevel,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.grey[100],
                  child: Stack(
                    children: [
                      // Hour markers
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 24,
                        itemBuilder: (context, index) {
                          final hour = index % 12 == 0 ? 12 : index % 12;
                          final period = index < 12 ? 'AM' : 'PM';
                          return Container(
                            height: 60 * _zoomLevel, // Adjust height for zoom
                            margin: const EdgeInsets.only(left: 8),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: Text(
                                    '$hour $period',
                                    style: TextStyle(fontSize: 12 * _zoomLevel, color: Colors.grey),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      // Event widgets
                      ..._events.asMap().entries.map((entry) {
                        final index = entry.key;
                        final event = entry.value;
                        if (event.start == null || event.end == null) return const SizedBox.shrink();
                        final now = tz.TZDateTime.now(_india);
                        final startTime = event.start!;
                        final endTime = event.end!;
                        final isPast = startTime.isBefore(now);

                        // Calculate base position and height
                        final startMinutes = startTime.hour * 60 + startTime.minute;
                        final endMinutes = endTime.hour * 60 + endTime.minute;
                        final durationMinutes = endMinutes - startMinutes;
                        final baseTopOffset = startMinutes * (60 / 60); // 60 pixels per hour
                        final height = durationMinutes * (60 / 60); // 60 pixels per hour

                        // Track occupied slots to prevent overlap
                        double topOffset = baseTopOffset;
                        int overlapCount = 0;
                        for (int i = 0; i < index; i++) {
                          final prevEvent = _events[i];
                          if (prevEvent.start != null && prevEvent.end != null) {
                            final prevStart = prevEvent.start!.hour * 60 + prevEvent.start!.minute;
                            final prevEnd = prevEvent.end!.hour * 60 + prevEvent.end!.minute;
                            if (!(endMinutes <= prevStart || startMinutes >= prevEnd)) {
                              overlapCount++;
                            }
                          }
                        }
                        topOffset += overlapCount * 40; // Shift by 40 pixels per overlapping event

                        return Positioned(
                          top: topOffset * _zoomLevel, // Adjust position for zoom
                          left: 76, // After hour markers
                          right: 16,
                          child: GestureDetector(
                            onLongPress: () => _deleteEvent(event), // Trigger delete on long press
                            onDoubleTap: () => _updateEvent(event), // Trigger update on double tap
                            child: IntrinsicWidth(
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 200),
                                height: (height < 30 ? 30 : height) * _zoomLevel, // Adjust height for zoom
                                decoration: BoxDecoration(
                                  color: isPast ? Colors.red[100] : Colors.blue[100],
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border(
                                    left: BorderSide(
                                      color: isPast ? Colors.red : Colors.blue,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event.title ?? "Untitled Event",
                                        style: TextStyle(
                                          fontSize: 14 * _zoomLevel, // Adjust font size for zoom
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black87,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "${DateFormat('h:mm a').format(startTime)} - ${DateFormat('h:mm a').format(endTime)}",
                                        style: TextStyle(fontSize: 12 * _zoomLevel, color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _zoomIn,
            backgroundColor: Colors.blue,
            mini: true,
            child: const Icon(Icons.zoom_in, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _zoomOut,
            backgroundColor: Colors.blue,
            mini: true,
            child: const Icon(Icons.zoom_out, color: Colors.white),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _addEvent,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}