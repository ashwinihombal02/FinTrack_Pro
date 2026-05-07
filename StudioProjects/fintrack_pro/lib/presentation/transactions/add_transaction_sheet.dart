import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/transaction_model.dart';
import '../providers/providers.dart';

class AddTransactionSheet
    extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  ConsumerState<AddTransactionSheet>
  createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState
    extends ConsumerState<AddTransactionSheet> {
  final amountController =
  TextEditingController();

  final noteController =
  TextEditingController();

  String category = 'Food';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom:
        MediaQuery.of(context)
            .viewInsets
            .bottom +
            20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Transaction',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: amountController,
              keyboardType:
              TextInputType.number,
              decoration:
              const InputDecoration(
                labelText: 'Amount',
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField(
              value: category,
              items: const [
                DropdownMenuItem(
                  value: 'Food',
                  child: Text('Food'),
                ),
                DropdownMenuItem(
                  value: 'Travel',
                  child: Text('Travel'),
                ),
                DropdownMenuItem(
                  value: 'Shopping',
                  child: Text('Shopping'),
                ),
              ],
              onChanged: (v) {
                category = v!;
              },
            ),

            const SizedBox(height: 16),

            TextField(
              controller: noteController,
              decoration:
              const InputDecoration(
                labelText: 'Notes',
                border:
                OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  final model =
                  TransactionModel(
                    amount: double.parse(
                      amountController.text,
                    ),
                    category: category,
                    type: 'expense',
                    date: DateTime.now(),
                    note:
                    noteController.text,
                  );

                  Navigator.pop(context);

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                child:
                const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}