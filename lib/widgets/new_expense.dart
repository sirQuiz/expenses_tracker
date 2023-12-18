import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
class NewExpense extends StatefulWidget {
  const NewExpense({
    super.key,
    required this.onAddExpense,
  });

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpense();
  }
}

class _NewExpense extends State<NewExpense> {
  final _enteredTitle  = TextEditingController();
  final _expenseNumber = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now       = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    // final lastDate  = DateTime(now.year + 1, now.month, now.day);

    var pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectedDate = pickedDate;
    });
  }


  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_expenseNumber.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if(_enteredTitle.text.trim().isEmpty || amountIsInvalid || _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Some input has invalid data. Please, make sure that all fields have valid data.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(Expense(
      title: _enteredTitle.text,
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
    ));

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _enteredTitle.dispose();
    _expenseNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        48,
        16,
        16,
      ),
      child: Column(
        children: [
          TextField(
            controller: _enteredTitle,
            maxLength: 50,
            // keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _expenseNumber,
                  maxLength: 50,
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    label: Text('Expense Number'),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'No date picked'
                          : formatter.format(_selectedDate!),
                    ),
                    IconButton(
                      onPressed: _presentDatePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values.map(
                  (category) =>
                    DropdownMenuItem(
                      value: category,
                      child: Text(category.name.toUpperCase()),
                  ),
                ).toList(),
                onChanged: (value) {
                  if(value == null) {
                    return;
                  }

                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _submitExpenseData,
                child: const Text('Save Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
