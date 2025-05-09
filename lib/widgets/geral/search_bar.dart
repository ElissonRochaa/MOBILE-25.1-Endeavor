import 'package:flutter/material.dart';

class SearchFilterBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String) onSearch;
  final VoidCallback? onFilterTap;

  const SearchFilterBar({
    super.key,
    required this.controller,
    required this.onSearch,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: SearchBar(
          controller: controller,
          elevation: const WidgetStatePropertyAll(8),
          backgroundColor: WidgetStatePropertyAll(
            Theme.of(context).colorScheme.onTertiary,
          ),
          onSubmitted: onSearch,
          trailing: [
            if (onFilterTap != null)
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: onFilterTap,
              ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => onSearch(controller.text.trim()),
            ),
          ],
        ),
      ),
    );
  }
}
