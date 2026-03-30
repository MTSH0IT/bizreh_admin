import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class LoadingDropdownFormField2<T> extends StatefulWidget {
  final bool isLoading;
  final List<DropdownMenuItem<T>> items;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final String labelText;
  final String hintText;
  final bool enableSearch;
  final String searchHintText;
  final double? menuItemHeight;
  final String Function(DropdownMenuItem<T> item)? selectedItemTextBuilder;

  const LoadingDropdownFormField2({
    super.key,
    required this.isLoading,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.labelText,
    required this.hintText,
    this.enableSearch = false,
    this.searchHintText = 'Search...',
    this.menuItemHeight,
    this.selectedItemTextBuilder,
  });

  @override
  State<LoadingDropdownFormField2<T>> createState() =>
      _LoadingDropdownFormField2State<T>();
}

class _LoadingDropdownFormField2State<T>
    extends State<LoadingDropdownFormField2<T>> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
    final effectiveValue =
        widget.value != null && widget.items.any((e) => e.value == widget.value)
        ? widget.value
        : null;

    final DropdownSearchData<T>? dropdownSearchData = widget.enableSearch
        ? DropdownSearchData<T>(
            searchController: _searchController,
            searchInnerWidgetHeight: 56,
            searchInnerWidget: Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: widget.searchHintText,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            searchMatchFn: (DropdownMenuItem<T> item, String searchValue) {
              final text = _itemText(item);
              return text.toLowerCase().contains(searchValue.toLowerCase());
            },
          )
        : null;

    return DropdownButtonFormField2<T>(
      value: effectiveValue,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: widget.labelText,
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: const OutlineInputBorder(),
      ),
      hint: widget.isLoading ? const Text('Loading...') : Text(widget.hintText),
      items: widget.items,
      selectedItemBuilder: widget.selectedItemTextBuilder == null
          ? null
          : (context) => widget.items.map((item) {
              final text = widget.selectedItemTextBuilder!(item);
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
      onChanged: widget.isLoading ? null : widget.onChanged,
      dropdownSearchData: dropdownSearchData,
      menuItemStyleData: MenuItemStyleData(
        height: widget.menuItemHeight ?? kMinInteractiveDimension,
      ),
    );
  }
}
