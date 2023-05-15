import 'package:requests/requests.dart';

class API {
  static const host = 'https://ymcc-event.hmtaupnyk.com/api';
  static const apiKey = 'vivatambang';

  static attend(String enc, String eventId) async {
    var map = <String, dynamic>{};
    map['API_KEY'] = apiKey;
    map['enc'] = enc;
    map['event_id'] = eventId;
    var r = await Requests.post("$host/attend", body: map);
    if (r.statusCode == 404) {
      return {
        'status_code': 404,
        'message': "presence_id or event_id not found"
      };
    } else {
      return r.json();
    }
  }

  static getEvent() async {
    var map = <String, dynamic>{};
    map['API_KEY'] = apiKey;
    var r = await Requests.post("$host/get_events", body: map);
    return r.json();
  }

  static getEventPresence(String eventId) async {
    var map = <String, dynamic>{};
    map['API_KEY'] = apiKey;
    map['event_id'] = eventId;
    var r = await Requests.post("$host/get_event_presence", body: map);
    if (r.statusCode == 404) {
      return {'status_code': 404, 'message': "event_id not found"};
    } else {
      return r.json();
    }
  }
}
