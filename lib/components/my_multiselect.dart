import 'package:flutter/material.dart';

class MyMultiSelect extends StatefulWidget {
  final List<String> items;
  final Function(List<String>) onSelectionChanged;

  const MyMultiSelect({
    Key? key,
    required this.items,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<MyMultiSelect> createState() => _MyMultiSelectState();
}

class _MyMultiSelectState extends State<MyMultiSelect> {
  List<String> _selectedItems = [];

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
      widget.onSelectionChanged(_selectedItems); // Notifica al padre
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.items
          .map(
            (item) => CheckboxListTile(
              title: Text(item),
              value: _selectedItems.contains(item),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (isChecked) {
                _itemChange(item, isChecked!);
              },
            ),
          )
          .toList(),
    );
  }
}
