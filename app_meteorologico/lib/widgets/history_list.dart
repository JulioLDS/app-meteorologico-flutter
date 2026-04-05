import 'package:flutter/material.dart';

class HistoryList extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const HistoryList({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text(
            'Nenhum registro histórico encontrado',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: history.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final item = history[index];
        final date = DateTime.tryParse(item['recorded_at'] ?? '');
        
        return ListTile(
          leading: const Icon(Icons.history, color: Colors.blue),
          title: Text('${item['temperature']}°C • ${item['humidity']}% umidade'),
          subtitle: Text(
            date != null 
                ? '${date.day}/${date.month} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'
                : 'Data desconhecida',
          ),
          dense: true,
        );
      },
    );
  }
}