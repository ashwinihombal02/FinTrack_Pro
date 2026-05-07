import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/language_provider.dart';
import '../../core/services/haptic_service.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/custom_textfield.dart';
import '../../domain/usecases/update_transaction.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../core/theme/theme_provider.dart';
import '../widgets/donut_chart.dart';

class DashboardScreen extends StatefulWidget {
  final DeleteTransaction deleteTransaction;
  final UpdateTransaction updateTransaction;

  const DashboardScreen({
    super.key,
    required this.deleteTransaction,
    required this.updateTransaction,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  bool flipped = false;

  List<TransactionEntity> transactions = [];

  double totalExpense = 0;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration:
      const Duration(seconds: 1),
    );

    animation = Tween<double>(
      begin: 0,
      end: totalExpense,
    ).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    controller.forward();
  }

  void updateAnimation() {
    animation = Tween<double>(
      begin: animation.value,
      end: totalExpense,
    ).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    controller.forward(from: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void openAddTransactionSheet() {
    final amountController = TextEditingController();
    final categoryController = TextEditingController();
    final noteController = TextEditingController();

    DateTime selectedDate = DateTime.now();
    String? receiptPath;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add Transaction',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  // ================= STEP 1: AMOUNT =================
                  CustomTextField(
                    controller: amountController,
                    hint: 'Enter Amount',
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  // ================= STEP 2: CATEGORY =================
                  CustomTextField(
                    controller: categoryController,
                    hint: 'Enter Category',
                  ),

                  const SizedBox(height: 16),

                  // ================= STEP 3: DATE PICKER =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date: ${selectedDate.toLocal().toString().split(' ')[0]}",
                      ),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                            initialDate: selectedDate,
                          );

                          if (picked != null) {
                            setModalState(() {
                              selectedDate = picked;
                            });
                          }
                        },
                        child: const Text("Select Date"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ================= STEP 4: RECEIPT CAMERA =================
                  CustomButton(
                    text: receiptPath == null
                        ? "Capture Receipt"
                        : "Receipt Added ✔",
                    onTap: () async {
                      // NOTE: replace with image_picker later
                      setModalState(() {
                        receiptPath = "dummy_path.jpg";
                      });

                      HapticService.lightImpact();
                    },
                  ),

                  const SizedBox(height: 20),

                  // ================= STEP 5: SAVE =================
                  CustomButton(
                    text: 'Save Transaction',
                    onTap: () {
                      final amount =
                          double.tryParse(amountController.text) ?? 0;

                      final category = categoryController.text;

                      if (!Validators.validateAmount(amount) ||
                          !Validators.validateText(category)) {
                        return;
                      }

                      HapticService.lightImpact();

                      setState(() {
                        transactions.add(
                          TransactionEntity(
                            id: DateTime.now().millisecondsSinceEpoch, // TEMP FIX if local-only
                            amount: amount,
                            category: category,
                            type: 'expense',
                            date: selectedDate,
                            note: noteController.text,
                            receiptPath: receiptPath,
                            recurring: false,
                            recurringType: null,
                          ),
                        );

                        totalExpense = transactions.fold(
                          0.0,
                              (sum, e) => sum + e.amount,
                        );

                        updateAnimation();
                      });

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  // ================= EDIT =================
  void openEditTransactionSheet(TransactionEntity tx) {
    final amountController =
    TextEditingController(text: tx.amount.toString());
    final categoryController =
    TextEditingController(text: tx.category);
    final noteController =
    TextEditingController(text: tx.note ?? "");

    DateTime selectedDate = tx.date;
    String? receiptPath = tx.receiptPath;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text(
                    "Edit Transaction",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  CustomTextField(
                    controller: amountController,
                    hint: 'Amount',
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 12),

                  CustomTextField(
                    controller: categoryController,
                    hint: 'Category',
                  ),

                  const SizedBox(height: 12),

                  // DATE EDIT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date: ${selectedDate.toLocal().toString().split(' ')[0]}",
                      ),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                            initialDate: selectedDate,
                          );

                          if (picked != null) {
                            setModalState(() => selectedDate = picked);
                          }
                        },
                        child: const Text("Change Date"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // RECEIPT EDIT
                  CustomButton(
                    text: receiptPath == null
                        ? "Add Receipt"
                        : "Change Receipt ✔",
                    onTap: () {
                      setModalState(() {
                        receiptPath = "updated_receipt.jpg";
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  CustomButton(
                    text: "Update Transaction",
                    onTap: () {
                      final updated = tx.copyWith(
                        amount: double.tryParse(amountController.text) ?? 0,
                        category: categoryController.text,
                        date: selectedDate,
                        note: noteController.text,
                        receiptPath: receiptPath,
                      );

                      setState(() {
                        final index =
                        transactions.indexWhere((e) => e.id == tx.id);

                        if (index != -1) {
                          setState(() {
                            transactions = transactions.map((t) {
                              return t.id == tx.id ? updated : t;
                            }).toList();
                          });
                        }

                        totalExpense =
                            transactions.fold(0, (s, e) => s + e.amount);

                        updateAnimation();
                      });

                      widget.updateTransaction(updated);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
  // ================= DELETE =================
  void deleteTx(TransactionEntity tx) {
    setState(() {
      transactions.removeWhere((e) => e.id == tx.id);
      totalExpense = transactions.fold(0, (s, e) => s + e.amount);
      updateAnimation();
    });

    if (tx.id != null) {
      widget.deleteTransaction(tx.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FinTrack Pro'),

        actions: [
          // 🌍 LANGUAGE BUTTON
          Consumer(
            builder: (context, ref, _) {
              final locale = ref.watch(languageProvider);

              return PopupMenuButton<String>(
                icon: const Icon(Icons.language),

                // show current selection (important UX fix)
                initialValue: locale.languageCode,

                onSelected: (value) {
                  final newLocale = Locale(value);

                  ref.read(languageProvider.notifier).state = newLocale;
                },

                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'en', child: Text("English")),
                  PopupMenuItem(value: 'hi', child: Text("Hindi")),
                  PopupMenuItem(value: 'kn', child: Text("Kannada")),
                ],
              );
            },
          ),

          // 🌙 THEME BUTTON
          Consumer(
            builder: (context, ref, _) {
              final themeMode = ref.watch(themeProvider);

              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  ref.read(themeProvider.notifier).state =
                  themeMode == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark;
                },
              );
            },
          ),
        ],
      ),

      floatingActionButton:
      FloatingActionButton(
        onPressed:
        openAddTransactionSheet,
        child: const Icon(
          Icons.add,
        ),
      ),

      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(
            const Duration(seconds: 1),
          );
        },
        child: ListView(
          padding:
          const EdgeInsets.all(
            16,
          ),
          children: [
            GestureDetector(
              onTap: () {
                HapticService.lightImpact();

                setState(() {
                  flipped = !flipped;
                });
              },
              child: Transform(
                alignment:
                Alignment.center,
                transform:
                Matrix4.identity()
                  ..setEntry(
                    3,
                    2,
                    0.001,
                  )
                  ..rotateY(
                    flipped
                        ? 0.1
                        : 0,
                  ),
                child: Container(
                  padding:
                  const EdgeInsets.all(
                    24,
                  ),
                  decoration:
                  BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(
                      24,
                    ),
                    gradient:
                    const LinearGradient(
                      colors: [
                        Colors.deepPurple,
                        Colors.blue,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      const Text(
                        'Total Expense',
                        style: TextStyle(
                          color:
                          Colors.white,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(
                        height: 12,
                      ),

                      Text(
                        CurrencyFormatter.format(
                          animation.value,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        '${transactions.length} Transactions',
                        style:
                        const TextStyle(
                          color:
                          Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            Container(
              height: 260,
              decoration:
              BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(
                  20,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black
                        .withOpacity(
                      0.05,
                    ),
                  ),
                ],
              ),
              child:
              transactions.isEmpty
                  ? const Center(
                child: Text(
                  'No Analytics Yet',
                ),
              )
                  : Padding(
                padding:
                const EdgeInsets.all(
                  20,
                ),
                child:
                DonutChart(
                  values:
                  transactions
                      .map(
                        (
                        e,
                        ) =>
                    e.amount,
                  )
                      .toList(),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            transactions.isEmpty
                ? const Center(
              child: Padding(
                padding:
                EdgeInsets.all(
                  20,
                ),
                child: Text(
                  'No Transactions Added',
                ),
              ),
            )
                : Column(
              children:
              transactions.map(
                    (tx) {
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.wallet),
                          ),

                          title: Text(tx.category),

                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tx.type),

                              const SizedBox(height: 4),

                              // DATE
                              Text(
                                "Date: ${tx.date.toLocal().toString().split(' ')[0]}",
                                style: const TextStyle(fontSize: 12),
                              ),

                              const SizedBox(height: 4),

                              // RECEIPT
                              tx.receiptPath != null
                                  ? Row(
                                children: const [
                                  Icon(Icons.receipt, size: 14, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text("Receipt added",
                                      style: TextStyle(fontSize: 12)),
                                ],
                              )
                                  : const Text(
                                "No receipt",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(CurrencyFormatter.format(tx.amount)),

                              // ✏️ EDIT
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  openEditTransactionSheet(tx);
                                },
                              ),

                              // 🗑 DELETE
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    transactions.removeWhere((t) => t.id == tx.id);
                                    totalExpense = transactions.fold(
                                      0.0,
                                          (sum, e) => sum + e.amount,
                                    );
                                    updateAnimation();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                },
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }
}