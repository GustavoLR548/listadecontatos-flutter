import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:listadecontatos/models/contato.dart';
import 'package:listadecontatos/provider/contatos.dart';
import 'package:listadecontatos/screens/contato/birthday/BirthdayEditor.dart';
import 'package:listadecontatos/widgets/contato/contato_card.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class BirthdayScaffold extends StatefulWidget {
  static const routeName = '/birthday-scaffold';

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

  void updateSelectedEvents(DateTime d) => this._selectedEvents =
      Provider.of<Contatos>(context, listen: false).getContatoByBirthdayDay(d);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário de Aniversariantes'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TableCalendar<Contato>(
                  daysOfWeekStyle: DaysOfWeekStyle(
                    dowTextFormatter: (date, locale) =>
                        DateFormat.E(locale).format(date)[0].toUpperCase(),
                  ),
                  selectedDayPredicate: (day) =>
                      isSameDay(this._selectedDay, day),
                  onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                    setState(() {
                      this._selectedDay = selectedDay;
                      this._focusedDay = focusedDay;
                      // update `_focusedDay` here as well

                      updateSelectedEvents(_selectedDay);
                    });
                  },
                  eventLoader: (day) =>
                      Provider.of<Contatos>(context, listen: false)
                          .getContatoByBirthdayDay(day),
                  locale: 'pt_PT',
                  headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor)),
                  calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      selectedDecoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red)),
                  focusedDay: _focusedDay,
                  firstDay: DateTime(_focusedDay.year, 1, 1),
                  lastDay: DateTime(_focusedDay.year, 12, 31)),
            ),
            _selectedEvents.length == 0
                ? Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Nenhum contato faz aniversário \n neste dia',
                      textAlign: TextAlign.center,
                    ))
                : ListView.builder(
                    itemCount: _selectedEvents.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (ctx, index) => ContatoCard(
                          Key(_selectedEvents[index].id),
                          _selectedEvents[index],
                          () async {
                            await Navigator.of(context)
                                .push(MaterialPageRoute<void>(
                                    builder: (context) => BirthdayEditor(
                                          initialValue: _selectedEvents[index],
                                        )));
                            setState(() {
                              updateSelectedEvents(_selectedDay);
                            });
                          },
                          showBirthday: true,
                        )),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (context) => BirthdayEditor()));
          setState(() {
            updateSelectedEvents(_selectedDay);
          });
        },
      ),
    );
  }
}
