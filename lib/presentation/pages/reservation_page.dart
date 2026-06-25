import 'package:flutter/material.dart';

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _numberOfPeople = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Table Reservation'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Reserve Your Table',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),
            Card(
              child: ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text('${_selectedDate.toLocal()}'.split(' ')[0]),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    setState(() => _selectedDate = date);
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(_selectedTime.format(context)),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (time != null) {
                    setState(() => _selectedTime = time);
                  }
                },
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: Text('Number of People'),
                trailing: DropdownButton<int>(
                  value: _numberOfPeople,
                  items: List.generate(
                    8,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text('${index + 1} ${index == 0 ? 'Person' : 'People'}'),
                    ),
                  ).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _numberOfPeople = value);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reservation confirmed!')),
                );
              },
              child: const Text('Confirm Reservation'),
            ),
          ],
        ),
      ),
    );
  }
}
