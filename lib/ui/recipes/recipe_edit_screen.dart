import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../data/db/database.dart';
import '../../domain/nutrition.dart';
import '../../domain/recipe_share.dart';
import '../../providers.dart';
import '../food/food_picker_screen.dart';
import '../food/log_food_sheet.dart';

/// Create a recipe: name, servings, and a list of ingredients (food + grams).
class RecipeEditScreen extends ConsumerStatefulWidget {
  const RecipeEditScreen({super.key});

  @override
  ConsumerState<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _RecipeEditScreenState extends ConsumerState<RecipeEditScreen> {
  final _name = TextEditingController();
  final _servings = TextEditingController(text: '2');
  final List<RecipeShareItem> _items = [];

  @override
  void dispose() {
    _name.dispose();
    _servings.dispose();
    super.dispose();
  }

  Nutrition get _total => Nutrition.sum(_items.map((i) => i.nutrition));

  Future<void> _addIngredient() async {
    // Same components as the add-food flow: shared picker (search/scan/custom)
    // + the amount sheet (unit selector, quick-picks, serving).
    final food = await Navigator.of(context).push<Food>(
      MaterialPageRoute(
          builder: (_) => const FoodPickerScreen(title: 'Add ingredient')),
    );
    if (food == null || !mounted) return;
    final grams = await showAmountSheet(context, food: food);
    if (grams == null || !mounted) return;
    setState(() {
      _items.add(RecipeShareItem(
        name: food.name,
        grams: grams,
        kcal100: food.kcal100,
        protein100: food.protein100,
        carb100: food.carb100,
        fat100: food.fat100,
      ));
    });
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final servings = double.tryParse(_servings.text.replaceAll(',', '.')) ?? 1;
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Give the recipe a name.')));
      return;
    }
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Add at least one ingredient.')));
      return;
    }
    await ref
        .read(recipeRepositoryProvider)
        .create(name: name, servings: servings, items: _items);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final total = _total;
    return Scaffold(
      appBar: AppBar(
        title: const Text('New recipe'),
        actions: [TextButton(onPressed: _save, child: const Text('Save'))],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
                labelText: 'Recipe name', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _servings,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
            decoration: const InputDecoration(
              labelText: 'Servings (portions this makes)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Ingredients', style: Theme.of(context).textTheme.titleMedium),
              const Spacer(),
              Text('${kcalStr(total.kcal)} kcal total',
                  style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < _items.length; i++)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(_items[i].name,
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text('${gramsStr(_items[i].grams)} g · '
                  '${kcalStr(_items[i].nutrition.kcal)} kcal'),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => setState(() => _items.removeAt(i)),
              ),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _addIngredient,
            icon: const Icon(Icons.add),
            label: const Text('Add ingredient'),
          ),
        ],
      ),
    );
  }
}
