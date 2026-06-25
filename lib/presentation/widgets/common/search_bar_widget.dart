import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;

  const SearchBarWidget({super.key, required this.onSearch});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Search for food, restaurant...',
        hintStyle: context.textTheme.bodyMedium?.copyWith(
          color: Colors.grey[400],
        ),
        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
        suffixIcon: _controller.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  _controller.clear();
                  widget.onSearch('');
                  setState(() {});
                },
                child: Icon(Icons.clear, color: Colors.grey[400]),
              )
            : null,
        filled: true,
        fillColor: context.isDarkMode ? Colors.grey[800] : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: (value) {
        setState(() {});
        widget.onSearch(value);
      },
    );
  }
}
