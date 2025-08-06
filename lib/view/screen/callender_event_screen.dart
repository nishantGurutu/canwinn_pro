import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:googleapis/calendar/v3.dart' as GoogleAPI;

class GoogleHttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleHttpClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }

  @override
  void close() => _client.close();
}

class CalendarEventScreen extends StatefulWidget {
  @override
  _CalendarEventScreenState createState() => _CalendarEventScreenState();
}

class _CalendarEventScreenState extends State<CalendarEventScreen> {
  GoogleSignInAccount? _account;
  List<calendar.Event> _events = [];

  // GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: [
  //     calendar.CalendarApi.calendarScope,
  //   ],
  // );

  // Future<void> login() async {
  //   await _googleSignIn.signOut();
  //   final user = await _googleSignIn.signIn();
  //   if (user == null) {
  //     return;
  //   }
  //   GoogleSignInAuthentication userAuth = await user.authentication;
  //   var credential = GoogleAuthProvider.credential(
  //       idToken: userAuth.idToken, accessToken: userAuth.accessToken);
  //   await FirebaseAuth.instance.signInWithCredential(credential);
  //   if (FirebaseAuth.instance.currentUser != null) {
  //     print('✅ Login successful: ${FirebaseAuth.instance.currentUser!.email}');
  //     print('✅ Login successful: 2 ${userAuth.accessToken}');
  //     print('✅ Login successful: 3 ${userAuth.idToken}');
  //     await apiCall(userAuth.accessToken);
  //   }
  // }
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      calendar.CalendarApi.calendarScope,
      calendar.CalendarApi.calendarEventsScope,
    ],
  );

  Future<void> login() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? user = await _googleSignIn.signIn();
      if (user == null) {
        print('❌ Sign-in cancelled by user');
        return;
      }

      final GoogleSignInAuthentication auth = await user.authentication;
      print('✅ Login successful: ${user.email}');
      print('✅ Access Token: ${auth.accessToken}');

      await apiCall(auth.accessToken);
    } catch (e) {
      print('❌ Sign-in error: $e');
    }
  }

  Future<void> apiCall(String? accessToken) async {
    if (accessToken == null) {
      print('❌ No access token available');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/calendar/v3/calendars/primary/events'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      if (response != null) {
        print('✅ API Response: ${response.body}');
      } else {
        print('❌ API Error: } - response.body}');
      }
    } catch (e) {
      print('❌ Error making API call: $e');
    }
  }

  // Future<void> _apiCall(String? accessToken) async {
  //   if (accessToken == null) {
  //     print('❌ No access token available');
  //     return;
  //   }

  //   try {
  //     // Create authenticated HTTP client
  //     final client = http.Client();
  //     final authClient =
  //         GoogleAuthClient({'Authorization': 'Bearer $accessToken'}, client);

  //     // Initialize Calendar API
  //     final calendarApi = CalendarApi(authClient);

  //     // Fetch primary calendar's events
  //     final events = await calendarApi.events.list(
  //       'primary',
  //       timeMin: DateTime.now().toUtc(), // Optional: filter events from now
  //       timeMax: DateTime.now()
  //           .add(Duration(days: 30))
  //           .toUtc(), // Optional: next 30 days
  //       maxResults: 10, // Optional: limit to 10 events
  //     );

  //     // Process events
  //     if (events.items != null && events.items!.isNotEmpty) {
  //       print('✅ Fetched ${eventsevents.items!.length} events:');
  //       for (var event in events.items!) {
  //         print(
  //             '  - ${event.summary}: ${event.summary}: ${event.start?.dateTime}');
  //       }
  //     } else {
  //       print('✅ No events found');
  //     }

  //     // Clean up
  //     authClient.close();
  //   } catch (e) {
  //     print('❌ Error fetching calendar events: $e');
  //   }
  // }

  Future<List<GoogleAPI.Event>> getGoogleEventsData() async {
    await _googleSignIn.disconnect();

    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('User cancelled sign-in');
    }

    print("Auth headers: ${await googleUser.authHeaders}");

    final GoogleHttpClient httpClient = GoogleHttpClient(
      await googleUser.authHeaders,
    );

    final GoogleAPI.CalendarApi calendarApi = GoogleAPI.CalendarApi(httpClient);
    print(
        "google callendar api data result ${calendarApi.events.list('primary')}");
    final GoogleAPI.Events calEvents = await calendarApi.events.list("primary");

    final List<GoogleAPI.Event> appointments = <GoogleAPI.Event>[];
    if (calEvents.items != null) {
      for (final event in calEvents.items!) {
        if (event.start == null) continue;
        appointments.add(event);
      }
    }

    return appointments;
  }

  Future<void> _openGoogleCalendar() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.intent.action.VIEW',
        data: 'content://com.android.calendar/time/',
        flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      try {
        await intent.launch();
        await Future.delayed(Duration(seconds: 5));
        await getGoogleEventsData();
      } catch (e) {
        print('Error launching Google Calendar: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open Google Calendar: $e')),
        );
      }
    } else {
      print('Opening Google Calendar not supported on this platform');
      await getGoogleEventsData();
    }
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.signInSilently().then((account) {
      if (account != null) {
        _account = account;
        getGoogleEventsData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google Calendar Events')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            InkWell(
              onTap: _openGoogleCalendar,
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/images/png/calendar_icon.png',
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: login,
              child: Text('Sync Calendar Events'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: _events.isEmpty
                  ? Center(child: Text('No events found'))
                  : ListView.builder(
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final event = _events[index];
                        final title = event.summary ?? 'No Title';
                        final startTime =
                            event.start?.dateTime ?? event.start?.date;
                        return ListTile(
                          title: Text(title),
                          subtitle: Text(
                            startTime != null
                                ? 'Start: ${startTime.toLocal()}'
                                : 'No start time',
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
