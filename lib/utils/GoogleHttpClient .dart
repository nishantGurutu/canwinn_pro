import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;

class GoogleHttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleHttpClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }

  @override
  void close() {
    _client.close();
  }
}

Future<void> fetchCalendarEvents() async {
  // final GoogleSignIn googleSignIn = GoogleSignIn(
  //   scopes: ["https://www.googleapis.com/auth/calendar.readonly"],
  // );

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '451996737352-ddcripaln5822oo1m4aqsse6ppshe47f.apps.googleusercontent.com',
    scopes: <String>[
      'https://www.googleapis.com/auth/calendar.readonly', // Read-only access
    ],
  );

  // const List<String> scopes = <String>[
  //   'email',
  //   'https://www.googleapis.com/auth/contacts.readonly',
  // ];

  // GoogleSignIn googleSignIn = GoogleSignIn(
  //   // Optional clientId
  //   // clientId: 'your-client_id.apps.googleusercontent.com',
  //   scopes: scopes,
  // );

  GoogleSignInAccount? account = await googleSignIn.signIn();
  if (account != null) {}
  // Get the user's Google account details
  // You can use account.displayName, account.email, etc.

  // final account = await googleSignIn.signIn();
  // if (account == null) return;

  final authHeaders = await account!.authHeaders;
  final client = GoogleHttpClient(authHeaders);
  final calendarApi = calendar.CalendarApi(client);

  final events = await calendarApi.events.list(
    "primary",
    // maxResults: 10,
    // orderBy: "startTime",
    // singleEvents: true,
    // timeMin: DateTime.now().toUtc(),
  );

  for (var event in events.items!) {
    print("Event: ${event.summary}, Start: ${event.start?.dateTime}");
    print("Event fetching data from callender app ${event.start?.dateTime}");
  }
}
