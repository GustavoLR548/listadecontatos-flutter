import 'package:flutter/material.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/provider/contatos.dart';
import 'package:listadecontatos/screens/contato/birthday/BirthdayEditor.dart';
import 'package:listadecontatos/widgets/contato/contato_card.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class BirthdayScaffold extends StatefulWidget {
  @override
  _BirthdayScaffoldState createState() => _BirthdayScaffoldState();
}

class _BirthdayScaffoldState extends State<BirthdayScaffold> {
  late DateTime _selectedDay;
  late List<Contato> _selectedEvents;
  bool hasInitiaded = false;
  DateTime _focusedDay = DateTime.now();

  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!hasInitiaded) {
      _selectedDay = _focusedDay;
      _selectedEvents = Provider.of<Contatos>(context, listen: false)
          .getContatoByBirthdayDay(_selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário de Aniversariantes'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(8),
              child: TableCalendar<Contato>(
                  selectedDayPredicate: (day) {
                    return isSameDay(this._selectedDay, day);
                  },
                  onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                    setState(() {
                      this._selectedDay = selectedDay;
                      this._focusedDay = focusedDay;
                      // update `_focusedDay` here as well

                      this._selectedEvents =
                          Provider.of<Contatos>(context, listen: false)
                              .getContatoByBirthdayDay(_selectedDay);
                    });
                  },
                  eventLoader: (day) =>
                      Provider.of<Contatos>(context, listen: false)
                          .getContatoByBirthdayDay(day),
                  locale: 'pt_PT',
                  headerStyle: HeaderStyle(
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor)),
                  calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).accentColor),
                      selectedDecoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).accentColor)),
                  focusedDay: today,
                  firstDay: DateTime(today.year, 1, 0),
                  lastDay: DateTime(today.year, 12, 31)),
            ),
            ListView.builder(
                itemCount: _selectedEvents.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (ctx, index) => ContatoCard(
                      Key(_selectedEvents[index].id),
                      _selectedEvents[index],
                      () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (context) => BirthdayEditor(
                                  initialValue: _selectedEvents[index],
                                )));
                      },
                      showBirthday: true,
                    )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (context) => BirthdayEditor()));
        },
      ),
    );
  }
}
