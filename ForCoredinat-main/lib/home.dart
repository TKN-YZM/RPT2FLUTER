import 'package:first_app/cardEvent.dart';
import 'package:first_app/localdb/database.dart';
import 'package:first_app/model/eventlist.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  late List<EventDaily> eventList; //Oluşturulan & oluşturulacak event listesi
  late HiveLocalDB _localDb; //Hive için oluşturduğum sınıf
  @override
  void initState() {
    super.initState();
    eventList = <EventDaily>[];
    _localDb = HiveLocalDB();
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "My Todo App",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              ),
            ),
            IconButton(
              onPressed: () {
                _showDialog(context);
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: eventList.isNotEmpty
            ? ListView.builder(
                itemCount: eventList.length,
                itemBuilder: (BuildContext context, int index) {
                  EventDaily currentEvent = eventList[index];
                  return Dismissible( //kartın kaydırıma & silme işlemi için
                      background: const Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                      key: Key(currentEvent.id.toString()),
                      onDismissed: (direction) {
                        _localDb.delEvent(currentEvent);
                        eventList.removeAt(index);
                        _showSnackBar(context, "Event başarıyla silindi");
                        setState(() {});
                      },
                      child: CardEvent(
                        currentEvent: currentEvent,
                        localDb: _localDb,
                      ));
                })
            : const Center());
  }

  //Yeni görev&event ekleme işlemleri
  Future<void> _showDialog(BuildContext context) {
    DateTime? dateTime;
    final myController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yeni Görev Ekleme'),
          content: TextField(
            decoration: const InputDecoration(
                hintText: "Görevi Tanımla", border: InputBorder.none),
            controller: myController,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ekle'),
              onPressed: () async {
                if (myController.text.length > 3) {
                  //Tarih&saat seçimi
                  dateTime = await showOmniDateTimePicker(context: context);
                  var newEvent = EventDaily(
                      id: eventList.length + 10,
                      eventDesc: myController.text,
                      eventDate: dateTime!,
                      isCompile: false);
                  _localDb.addEvent(newEvent);
                  eventList.add(newEvent);

                  setState(() {});
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Vazgeç'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadEvents() async {
    eventList = await _localDb.getAllEvent();
    setState(() {});
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Mesajın ekranda kalma süresi
      ),
    );
  }
}
