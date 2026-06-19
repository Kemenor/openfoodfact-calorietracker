import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format.dart';
import '../../data/db/database.dart';
import '../../domain/enums.dart';
import '../../providers.dart';

/// Reusable food search: instant local cache results as you type, plus a
/// 600 ms-debounced online OFF search (never per keystroke). Calls [onPick]
/// when a food is tapped. Used both to log into a day and to add recipe
/// ingredients.
class FoodSearchList extends ConsumerStatefulWidget {
  final ValueChanged<Food> onPick;
  final VoidCallback? onCreateCustom;
  const FoodSearchList({super.key, required this.onPick, this.onCreateCustom});

  @override
  ConsumerState<FoodSearchList> createState() => _FoodSearchListState();
}

class _FoodSearchListState extends ConsumerState<FoodSearchList> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';
  List<Food> _local = const [];
  List<Food> _online = const [];
  bool _searchingOnline = false;
  int _seq = 0;

  @override
  void initState() {
    super.initState();
    _runLocal('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() => _query = value);
    _runLocal(value);
    _debounce?.cancel();
    if (value.trim().length >= 2) {
      _debounce = Timer(const Duration(milliseconds: 600), _runOnline);
    } else {
      setState(() => _online = const []);
    }
  }

  Future<void> _runLocal(String value) async {
    final results = await ref.read(foodRepositoryProvider).searchLocal(value);
    if (mounted) setState(() => _local = results);
  }

  Future<void> _runOnline() async {
    final value = _query.trim();
    if (value.length < 2) return;
    final seq = ++_seq;
    setState(() => _searchingOnline = true);
    try {
      final results =
          await ref.read(foodRepositoryProvider).searchOnline(value);
      if (mounted && seq == _seq) setState(() => _online = results);
    } catch (_) {
      // network/rate-limit issues are non-fatal; local results remain.
    } finally {
      if (mounted && seq == _seq) setState(() => _searchingOnline = false);
      _runLocal(_query);
    }
  }

  List<Food> get _merged {
    final seen = <int>{};
    final out = <Food>[];
    for (final f in [..._local, ..._online]) {
      if (seen.add(f.id)) out.add(f);
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final results = _merged;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _controller,
            autofocus: true,
            onChanged: _onChanged,
            decoration: InputDecoration(
              hintText: 'Search foods…',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchingOnline
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2)),
                    )
                  : (_query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            _onChanged('');
                          },
                        )
                      : null),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        if (_query.isEmpty && results.isNotEmpty)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
              child: Text('Recently used',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      )),
            ),
          ),
        Expanded(
          child: results.isEmpty
              ? _EmptyState(query: _query, onCreate: widget.onCreateCustom)
              : ListView.separated(
                  itemCount: results.length + (widget.onCreateCustom != null ? 1 : 0),
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    if (i == results.length) {
                      return ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('Create custom food'),
                        onTap: widget.onCreateCustom,
                      );
                    }
                    return _FoodTile(
                        food: results[i], onTap: () => widget.onPick(results[i]));
                  },
                ),
        ),
      ],
    );
  }
}

class _FoodTile extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;
  const _FoodTile({required this.food, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final parts = <String>[
      if (food.brand != null && food.brand!.isNotEmpty) food.brand!,
      switch (food.source) {
        FoodSource.openFoodFacts => 'Open Food Facts',
        FoodSource.usda => 'USDA',
        FoodSource.custom => 'Custom',
        FoodSource.userContributed => 'Added by you',
      },
    ];
    return ListTile(
      title: Text(food.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(parts.join(' · ')),
      trailing: Text('${kcalStr(food.kcal100)} kcal\n/100 g',
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.bodySmall),
      onTap: onTap,
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  final VoidCallback? onCreate;
  const _EmptyState({required this.query, required this.onCreate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.no_food_outlined,
              size: 48, color: Theme.of(context).disabledColor),
          const SizedBox(height: 12),
          Text(
            query.isEmpty
                ? 'Search for a food, scan a barcode,\nor create your own.'
                : 'No matches for "$query".',
            textAlign: TextAlign.center,
          ),
          if (onCreate != null) ...[
            const SizedBox(height: 12),
            FilledButton.tonalIcon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: const Text('Create custom food'),
            ),
          ],
        ],
      ),
    );
  }
}
