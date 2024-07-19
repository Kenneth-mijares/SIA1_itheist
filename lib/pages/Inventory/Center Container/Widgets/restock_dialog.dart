import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RestockDialog extends StatefulWidget {
  final String productId;
  final Function(int quantityAdded, int distributionTime) onRestock;

  const RestockDialog({super.key, required this.productId, required this.onRestock});

  @override
  State<RestockDialog> createState() => _RestockDialogState();
}

class _RestockDialogState extends State<RestockDialog> {
  final TextEditingController _quantityAddedController = TextEditingController();
  final TextEditingController _distributionTimeController = TextEditingController();

  void _restock() {
    final int quantityAdded = int.parse(_quantityAddedController.text);
    final int distributionTime = int.parse(_distributionTimeController.text);

    widget.onRestock(quantityAdded, distributionTime);

    // Clear the text fields
    _quantityAddedController.clear();
    _distributionTimeController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Restock Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _quantityAddedController,
            decoration: const InputDecoration(labelText: 'Quantity Added'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
          TextField(
            controller: _distributionTimeController,
            decoration: const InputDecoration(labelText: 'Distribution Time (days)'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _restock();
            Navigator.pop(context);
          },
          child: const Text('Restock'),
        ),
      ],
    );
  }
}
