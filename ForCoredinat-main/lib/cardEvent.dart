import 'package:first_app/model/eventlist.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:first_app/localdb/database.dart';

class CardEvent extends StatefulWidget {
  final EventDaily currentEvent;
  final HiveLocalDB localDb;
  const CardEvent(
      {required this.currentEvent, required this.localDb, super.key});

  @override
  State<CardEvent> createState() => _CardEventState();
}

class _CardEventState extends State<CardEvent> {
  TextEditingController myController = TextEditingController();
  @override
  void initState() {
    super.initState();
    myController.text = widget.currentEvent.eventDesc;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 2),
      elevation: 1,
      color: Colors.white,
      child: ListTile(
        leading: IconButton(
          onPressed: () {
            widget.currentEvent.isCompile = !widget.currentEvent.isCompile;
            widget.localDb.updateTask(widget.currentEvent);
            setState(() {});
          },
          icon: Icon(
              color: widget.currentEvent.isCompile ? Colors.green : Colors.red,
              widget.currentEvent.isCompile
                  ? Icons.check_box_rounded
                  : Icons.radio_button_unchecked),
        ),
        title: widget.currentEvent.isCompile
            ? Text(
                widget.currentEvent.eventDesc,
                style: TextStyle(
                    decoration: widget.currentEvent.isCompile
                        ? TextDecoration.lineThrough
                        : TextDecoration.none),
              )
            : TextField(
                controller: myController,
                autofocus: false,
                decoration: const InputDecoration(border: InputBorder.none),
                onSubmitted: (value) {
                  if (value.length > 3) {
                    widget.currentEvent.eventDesc = value;
                    widget.localDb.updateTask(widget.currentEvent);
                  } else {
                    _showSnackBar(context, "Lütfen etkinlik giriniz");
                  }
                },
              ),
        trailing: Text(
          DateFormat(' MMM d, y hh:mm a').format(widget.currentEvent.eventDate),
        ),
      ),
    );
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
