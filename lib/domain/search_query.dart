import 'dart:collection';

/// Common-name → USDA-name aliases. USDA uses formal "Noun, qualifier" names
/// (e.g. "Peppers, sweet, green, raw"), so natural searches miss them. We
/// rewrite the query before tokenizing. Keys are matched as substrings, so put
/// multi-word keys before any that could overlap.
const Map<String, String> kSearchSynonyms = {
  'bell peppers': 'peppers sweet',
  'bell pepper': 'peppers sweet',
  'cherry tomatoes': 'tomatoes red ripe',
  'cherry tomato': 'tomatoes red ripe',
  'spring onion': 'onions spring',
  'spring onions': 'onions spring',
  'green onion': 'onions spring',
  'green onions': 'onions spring',
  'scallion': 'onions spring',
  'scallions': 'onions spring',
  'aubergine': 'eggplant',
  'courgette': 'zucchini',
  'rocket': 'arugula',
  'coriander': 'cilantro',
  'chickpea': 'chickpeas',
  'garbanzo': 'chickpeas',
  'garbanzos': 'chickpeas',
  'prawns': 'shrimp',
  'prawn': 'shrimp',
  'mince': 'ground',
  'aubergines': 'eggplant',
};

/// Lower-case, apply synonyms, split into alphanumeric tokens.
List<String> searchTokens(String raw) {
  var q = raw.toLowerCase().trim();
  for (final entry in kSearchSynonyms.entries) {
    if (q.contains(entry.key)) q = q.replaceAll(entry.key, entry.value);
  }
  // Dedupe while preserving order (synonyms can introduce repeats).
  return LinkedHashSet<String>.from(
    q.split(RegExp(r'[^a-z0-9]+')).where((t) => t.isNotEmpty),
  ).toList();
}
