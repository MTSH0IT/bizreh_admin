import 'package:flutter/material.dart';

class LoadingMultiSelectDropdownFormField2<T> extends StatelessWidget {
  final bool isLoading;
  final List<DropdownMenuItem<T>> items;
  final List<T> values;
  final ValueChanged<List<T>> onChanged;
  final String labelText;
  final String hintText;
  final bool enableSearch;
  final String searchHintText;

  const LoadingMultiSelectDropdownFormField2({
    super.key,
    required this.isLoading,
    required this.items,
    required this.values,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    this.enableSearch = false,
    this.searchHintText = 'Search...',
  });

  String _itemText(DropdownMenuItem<T> item) {
    final child = item.child;
    if (child is Text) {
      final data = child.data;
      if (data != null) return data;
      final span = child.textSpan;
      if (span != null) return span.toPlainText();
    }
    return item.value?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final selectedLabels = items
        .where((e) => e.value != null && values.contains(e.value as T))
        .map(_itemText)
        .where((e) => e.trim().isNotEmpty)
        .toList();

    return InkWell(
      onTap: isLoading
          ? null
          : () async {
              final selected = await showDialog<List<T>>(
                context: context,
                barrierDismissible: false,
                builder: (ctx) {
                  final temp = values.toList();
                  final TextEditingController searchController =
                      TextEditingController();
                  return StatefulBuilder(
                    builder: (ctx, setState) {
                      final q = searchController.text.trim().toLowerCase();
                      final filteredItems = !enableSearch || q.isEmpty
                          ? items
                          : items.where((item) {
                              final label = _itemText(item).toLowerCase();
                              return label.contains(q);
                            }).toList();

                      return AlertDialog(
                        title: Text(labelText),
                        content: SizedBox(
                          width: 520,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (enableSearch)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: TextField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      hintText: searchHintText,
                                      prefixIcon: const Icon(Icons.search),
                                      border: const OutlineInputBorder(),
                                      isDense: true,
                                    ),
                                    onChanged: (_) => setState(() {}),
                                  ),
                                ),
                              Flexible(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filteredItems.length,
                                  itemBuilder: (_, i) {
                                    final item = filteredItems[i];
                                    final v = item.value;
                                    if (v == null) {
                                      return const SizedBox.shrink();
                                    }
                                    final checked = temp.contains(v);
                                    return CheckboxListTile(
                                      value: checked,
                                      title: item.child,
                                      onChanged: (val) {
                                        setState(() {
                                          if (val == true) {
                                            if (!temp.contains(v)) temp.add(v);
                                          } else {
                                            temp.remove(v);
                                          }
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(null),
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(ctx).pop(temp),
                            child: const Text('Apply'),
                          ),
                        ],
                      );
                    },
                  );
                },
              );

              if (selected != null) {
                onChanged(selected);
              }
            },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          border: const OutlineInputBorder(),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                isLoading
                    ? 'Loading...'
                    : selectedLabels.isEmpty
                    ? hintText
                    : selectedLabels.join(', '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
