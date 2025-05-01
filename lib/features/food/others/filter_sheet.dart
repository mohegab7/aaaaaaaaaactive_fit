import 'package:flutter/material.dart';

class FilterSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;

  const FilterSheet({super.key, required this.onApplyFilters});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final _formKey = GlobalKey<FormState>();
  String? _dataType;
  double? _minCalories;
  double? _maxCalories;
  String _sortBy = 'relevance';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _dataType,
              decoration: const InputDecoration(labelText: 'Food Category'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All')),
                ...['Fruits and Fruit Juices', 'Vegetables and Vegetable Products', 'Dairy and Egg Products', 'Meats and Meat Products']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
              ],
              onChanged: (value) => setState(() => _dataType = value),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Min Calories'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _minCalories = double.tryParse(value),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Max Calories'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _maxCalories = double.tryParse(value),
                  ),
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: _sortBy,
              decoration: const InputDecoration(labelText: 'Sort By'),
              items: const [
                DropdownMenuItem(value: 'relevance', child: Text('Relevance')),
                DropdownMenuItem(value: 'lowerCalories', child: Text('Lower Calories First')),
                DropdownMenuItem(value: 'higherCalories', child: Text('Higher Calories First')),
              ],
              onChanged: (value) => setState(() => _sortBy = value!),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _applyFilters() {
    final filters = <String, dynamic>{};
    if (_dataType != null) filters['dataType'] = _dataType;
    if (_minCalories != null) filters['minCalories'] = _minCalories;
    if (_maxCalories != null) filters['maxCalories'] = _maxCalories;
    filters['sortBy'] = _sortBy;

    widget.onApplyFilters(filters);
    Navigator.pop(context);
  }
}