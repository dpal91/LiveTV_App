import 'package:flutter/material.dart';

class SearchBarPannel extends StatelessWidget {
  final Function(String) onSearchChanged;

  const SearchBarPannel({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      textInputAction: TextInputAction.search,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade800,
        hintText: 'Search...',
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onSearchChanged,
    );
  }
}
