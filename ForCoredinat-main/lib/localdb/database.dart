import 'package:first_app/model/eventlist.dart';
import 'package:hive/hive.dart';

class HiveLocalDB {
  late Box<EventDaily> _eventBox;
  HiveLocalDB() {
    _eventBox = Hive.box<EventDaily>("events");
  }

  Future<void> addEvent(EventDaily event) async {
    await _eventBox.put(event.id, event);
  }

  Future<void> delEvent(EventDaily event) async {
    await _eventBox.delete(event.id);
  }

  Future<List<EventDaily>> getAllEvent() async {
    List<EventDaily> allEvent = <EventDaily>[];
    allEvent = _eventBox.values.toList();

    if (allEvent.isNotEmpty) {
      allEvent.sort((a, b) => a.eventDate.compareTo(b.eventDate));
    }
    return allEvent;
  }

  Future<EventDaily?> getID(int id) async {
    if (_eventBox.containsKey(id)) {
      return _eventBox.get(id);
    } else {
      return null;
    }
  }

  Future<void> updateTask(EventDaily event) async {
    if (_eventBox.containsKey(event.id)) {
      await _eventBox.put(event.id, event);
    }
  }
}
