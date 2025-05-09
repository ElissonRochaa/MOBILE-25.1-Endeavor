import 'package:flutter/material.dart';

class SearchBarHome extends StatelessWidget {
  const SearchBarHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SearchBar(
                leading: Icon(Icons.search, size: 24, color: Colors.grey[600]),
                padding: WidgetStatePropertyAll(EdgeInsets.all(8)),
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).colorScheme.surface,
                ),
                shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                    side: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                trailing: [
                  Icon(Icons.reorder, size: 24, color: Colors.grey[600]),
                ],
            );
  }
}