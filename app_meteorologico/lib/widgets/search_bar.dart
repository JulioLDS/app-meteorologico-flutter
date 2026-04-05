import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String) onSearch;
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Buscar cidade (ex: São Paulo)',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.clear();
              onClear?.call();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            onSearch(value.trim());
            FocusScope.of(context).unfocus(); // Fecha teclado
          }
        },
      ),
    );
  }
}