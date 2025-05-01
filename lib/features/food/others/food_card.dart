import 'package:active_fit/features/food/others/food.dart';
import 'package:flutter/material.dart';
import 'nutrient_chart.dart';

class FoodCard extends StatefulWidget {
  final Food food;

  const FoodCard({super.key, required this.food});

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final nutrients = {
      'Calories': widget.food.getNutrientValue('Energy') ?? 0,
      'Protein': widget.food.getNutrientValue('Protein') ?? 0,
      'Carbs': widget.food.getNutrientValue('Carbohydrate') ?? 0,
      'Fat': widget.food.getNutrientValue('Total lipid (fat)') ?? 0,
    };

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.food.description,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${nutrients['Calories']?.toStringAsFixed(0)} kcal',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (widget.food.brandOwner != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.food.brandOwner!,
                      style: TextStyle(color: Colors.blue[700], fontSize: 12),
                    ),
                  ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.blue,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.food.ingredients != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ingredients:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.food.ingredients!,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  const Text(
                    'Nutritional Values (per 100g):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  NutrientChart(nutrients: nutrients),
                  const SizedBox(height: 16),
                  _buildNutrientTable(nutrients),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutrientTable(Map<String, double> nutrients) {
    return Table(
      columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
      children: [
        _buildTableRow('Nutrient', 'Value', isHeader: true),
        ...nutrients.entries.map(
          (e) => _buildTableRow(
            e.key,
            '${e.value.toStringAsFixed(1)} ${_getUnit(e.key)}',
          ),
        ),
      ],
    );
  }

  TableRow _buildTableRow(String label, String value, {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(color: isHeader ? Colors.grey[100] : null),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: isHeader ? Colors.black : Colors.blue[700],
            ),
          ),
        ),
      ],
    );
  }

  String _getUnit(String nutrient) {
    switch (nutrient) {
      case 'Calories':
        return 'kcal';
      case 'Protein':
      case 'Carbs':
      case 'Fat':
        return 'g';
      default:
        return '';
    }
  }
}
