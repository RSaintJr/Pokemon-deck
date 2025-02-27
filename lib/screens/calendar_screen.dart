import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  final Map<DateTime, List<String>> _events = {
    DateTime(2025, 1, 5): ['Torneio das Promessas: Um evento voltado para jovens talentos e iniciantes no Pokémon TCG, com o objetivo de descobrir e promover novos competidores.'],
    DateTime(2025, 1, 22): ['Liga de Clãs: Um campeonato exclusivo para clãs, onde equipes competem por prestígio e prêmios especiais.'],
    DateTime(2025, 2, 3): ['Master League: Uma competição internacional que reúne os melhores jogadores do mundo para disputar o título de Mestre.'],
    DateTime(2025, 4, 20): ['Evo Grand Slam: Um desafio global que testa as habilidades dos jogadores em diferentes formatos e estratégias.'],
    DateTime(2025, 6, 8): ['Classic Clans Combat: Um torneio tradicional que homenageia as raízes do Pokémon TCG, com foco em clãs e estratégias clássicas.'],
    DateTime(2025, 7, 6): ['Evo Grand Chateau: Um evento exclusivo realizado na Europa, com cenários deslumbrantes e competições de alto nível.'],
    DateTime(2025, 8, 3): ['Torneio Luso-Brasileiro: Uma competição amistosa entre jogadores do Brasil e Portugal, celebrando a comunidade lusófona do Pokémon TCG.'],
    DateTime(2025, 8, 31): ['Evo Premier League: A liga principal do ano, onde os melhores jogadores competem pelo título de Campeão da Premier League.'],
    DateTime(2025, 11, 1): ['Golden Classics: Uma competição histórica que revive os formatos e cartas clássicas do Pokémon TCG.'],
    DateTime(2025, 11, 21): ['Campeonato Internacional de Londres: O maior evento do ano, reunindo os melhores jogadores do mundo em uma competição épica.'],
    DateTime(2025, 6, 13): ['Campeonato Internacional de Nova Orleans: Um evento emocionante nos EUA, com competições intensas e uma atmosfera vibrante.'],
  };

  DateTime _selectedDay = DateTime(2025, 1, 1); 
  List<String> _selectedEvents = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now(); 
    _selectedDay = DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day); 
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendário de Torneios de Pokémon TCG')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2025, 1, 1),
            lastDay: DateTime(2025, 12, 31),
            focusedDay: _selectedDay,
            calendarFormat: CalendarFormat.month,
            eventLoader: (day) => _events[DateTime(day.year, day.month, day.day)] ?? [],
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = DateTime(selectedDay.year, selectedDay.month, selectedDay.day); 
                _selectedEvents = _events[_selectedDay] ?? [];
              });
            },
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final normalizedDay = DateTime(day.year, day.month, day.day);
                final isTournamentDay = _events.containsKey(normalizedDay);
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isTournamentDay ? Colors.redAccent : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isTournamentDay ? Colors.white : Colors.black,
                      fontWeight: isTournamentDay ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _selectedEvents.isEmpty
                ? const Center(child: Text('Nenhum evento neste dia.'))
                : ListView.builder(
                    itemCount: _selectedEvents.length,
                    itemBuilder: (context, index) {
                      final eventParts = _selectedEvents[index].split(":");
                      final eventName = eventParts[0].trim();
                      final eventDescription = eventParts.length > 1 ? eventParts[1].trim() : "Sem descrição.";
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(eventName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(eventDescription),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
