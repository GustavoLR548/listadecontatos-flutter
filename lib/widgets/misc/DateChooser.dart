import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateChooser extends StatefulWidget {
  final String initialValue;
  final void Function(String value) onChoose;
  DateChooser(this.initialValue, {required this.onChoose});
  @override
  _DateChooserState createState() => _DateChooserState();
}

class _DateChooserState extends State<DateChooser> {
  late String date;

  void initState() {
    super.initState();
    this.date = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Text(
              this.date == ''
                  ? 'Nenhuma data selecionada'
                  : 'Data selecionada : ' + _selectedDateInText(),
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
              onPressed: () => _chooseDate(context),
              child: Text('Escolha uma data'))
        ],
      ),
    );
  }

  String _selectedDateInText() =>
      DateFormat("dd/MM/yyyy").format(DateTime.parse(this.date));

  void _chooseDate(BuildContext ctx) {
    DateTime currTime = DateTime.now().add(Duration(days: 1));
    showDatePicker(
            context: context,
            locale: const Locale('pt', 'PT'),
            initialDate: currTime,
            firstDate: currTime,
            lastDate: DateTime(currTime.year + 1))
        .then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        this.date = pickedDate.toIso8601String();
      });
      widget.onChoose(this.date);
    });
  }
}
